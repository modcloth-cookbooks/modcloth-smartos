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
          Chef::Log.debug("XXXXXXXXX #{@new_resource.package_name} new resource name")
					Chef::Log.debug("#{@new_resource} loading current resource")
					@current_resource = Chef::Resource::Package.new(@new_resource.name)
					@current_resource.package_name(@new_resource.package_name)
					@current_resource.version(nil)
					Chef::Log.debug("XXXXXXX #{@new_resource.package_name} new  resource")
          ss = check_package_state(@new_resource.package_name)
          Chef::Log.debug("XXXXXXX #{@current_resource.version} current version")
					@current_resource # modified by check_package_state
				end
				
				def check_package_state(name)
					Chef::Log.debug("#{@new_resource} XXXXXXXX checking package #{name}")
					# XXX
					version = nil
					#Check if is already installed
					info = shell_out!("pkg_info -E \"#{name}*\"", :env => nil, :returns => [0,1])
					
					if info.stdout
						version = info.stdout[/^#{@new_resource.package_name}-(.+)/, 1]
          end
          Chef::Log.debug("#{version.class} XXXXXXXX checking version")
					if !version
						@current_resource.version(nil)
						Chef::Log.debug("#{version.class} XXXXXXX it will try to install it")
						
					else
						@current_resource.version(version)
					end
        end

        def candidate_version
          return @candidate_version if @candidate_version
          status = IO.popen(" pkgin search #{@new_resource.package_name}") do |ver|
            ver.each_line do |line|
              case line
              when /^#{@new_resource.package_name}-(\d+.\d+.\d+.*$)/
                @candidate_version = $1
                @new_resource.version($1)
                Chef::Log.debug("#{@new_resource} #{status.inspect} XXXXXXXsetting install candidate version to #{@candidate_version}")
              end
            end
          end
           Chef::Log.debug( "XXXXXXX#{$?}")
          # unless $? == 0
          #              raise Chef::Exceptions::Package, "pkginfo -l -d #{@new_resource.source} - #{status.inspect}!"
          #           end
          @candidate_version
        end


        def install_package(name, version)
					Chef::Log.debug("#{@new_resource} XXXXXX installing package #{name}-#{version}")
					package = "#{name}-#{version}"
          out = shell_out!("pkgin -y install #{package}", :env => nil)
        end

				def upgrade_package(name, version)
					Chef::Log.debug("#{@new_resource} XXXXXXX upgrading package #{name}-#{version}")
					install_package(name, version)
				end

				def remove_package(name, version)
					Chef::Log.debug("#{@new_resource} XXXXX removing package #{name}-#{version}")
					package = "#{name}-#{version}"
          out = shell_out!("pkgin -y remove #{package}", :env => nil)
				end

      end
    end
  end
end