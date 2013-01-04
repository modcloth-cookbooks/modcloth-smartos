#
# Authors:: Trevor O (trevoro@joyent.com)
#           Bryan McLellan (btm@loftninjas.org)
#           Matthew Landauer (matthew@openaustralia.org)
# Copyright:: Copyright (c) 2009 Bryan McLellan, Matthew Landauer
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Notes
#
#  * Supports installing using a local package name
#  * Otherwise reverts to installing from the pkgsrc repositories URL

require 'chef/provider/package'
require 'chef/mixin/shell_out'
require 'chef/resource/package'
require 'chef/mixin/get_source_from_package'

class Chef
  class Provider
    class Package
      class SmartOS < Chef::Provider::Package
        include Chef::Mixin::ShellOut
        attr_accessor :is_virtual_package

        def load_current_resource
          Chef::Log.debug("#{@new_resource} loading current resource")
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
          @current_resource.package_name(@new_resource.package_name)
          @current_resource.version(nil)
          check_package_state(@new_resource.package_name)
          @current_resource # modified by check_package_state
        end
        
        def check_package_state(name)
          Chef::Log.debug("#{@new_resource} checking package #{name}")
          # XXX
          version = nil
          info = shell_out!("pkg_info -E \"#{name}*\"", :env => nil, :returns => [0,1])
          
          if info.stdout
            version = info.stdout[/^#{@new_resource.package_name}-(.+)/, 1]
          end

          if !version
            @current_resource.version(nil)            
          else
            @current_resource.version(version)
          end
        end

        def candidate_version
          return @candidate_version if @candidate_version
          status = IO.popen(" pkgin search #{@new_resource.package_name}") do |ver|
            vers = []
            ver.each_line do |line|
              case line
              # when /^#{@new_resource.package_name}[.+]?-(.+?-?\d+.{1,}*$)/
              # weird case for gtk2+ /^gtk2\+-([^ ]*)/
              # this might work best for versions? /^#{@new_resource.package_name}-([^ ]*)/
              when /^#{@new_resource.package_name}-(\d+.{1,}*$)/
                vers << $1.to_s.split(' ').first
                @candidate_version = vers.sort.last
                @new_resource.version(vers.sort.last)                
              end
            end
            Chef::Log.info("#{@new_resource.package_name} versions available [#{vers}]")
          end          
          Chef::Log.info("Installing #{@new_resource.package_name} #{@candidate_version} ")
          @candidate_version 
        end

        def install_package(name, version)
          
          package = "#{name}-#{version}"
          Chef::Log.info("#{@new_resource} pkgin -y install #{package}")
          out = shell_out!( "pkgin -y install #{package.split(' ').first}", :env => nil)
        end

        def upgrade_package(name, version)
          Chef::Log.debug("#{@new_resource} upgrading package #{name}-#{version}")
          install_package(name, version)
        end

        def remove_package(name, version)
          Chef::Log.debug("#{@new_resource} removing package #{name}-#{version}")
          package = "#{name}-#{version}"
          out = shell_out!("pkgin -y remove #{package}", :env => nil)
        end
      end
    end
  end
end

require 'pathname'
require 'chef/provider/user/useradd'

class Chef
  class Provider
    class User 
      class Smartos < Chef::Provider::User::Useradd
        
        def check_lock
          status = popen4("passwd -s #{@new_resource.username}") do |pid, stdin, stdout, stderr|
            status_line = stdout.gets.split(' ')
            case status_line[1]
            when /^P/
              @locked = false
            when /^N/
              @locked = false
            when /^L/
              @locked = true
            end
          end

          unless status.exitstatus == 0
            raise_lock_error = false
            # we can get an exit code of 1 even when it's successful on rhel/centos (redhat bug 578534)
            if status.exitstatus == 1 && ['redhat', 'centos'].include?(node[:platform])
              passwd_version_status = popen4('rpm -q passwd') do |pid, stdin, stdout, stderr|
                passwd_version = stdout.gets.chomp

                unless passwd_version == 'passwd-0.73-1'
                  raise_lock_error = true
                end
              end
            else
              raise_lock_error = true
            end

            raise Chef::Exceptions::User, "Cannot determine if #{@new_resource} is locked!" if raise_lock_error
          end

          @locked
        end
        
        def lock_user
          run_command(:command => "usermod -L #{@new_resource.username}")
        end
        
        def unlock_user
          run_command(:command => "passwd -u #{@new_resource.username}")
        end

        def useradd_options
          opts = ''
          opts << " -m" if updating_home? && managing_home_dir?
          # opts << " -r" if @new_resource.system
          opts
        end

      end
    end
  end
end
