
class Chef
  class Provider
    class User
      class Solaris < Chef::Provider::User::Useradd
        def create
          super
          manage_password
          unlock_user
        end

        def check_lock
          lock_check = Mixlib::ShellOut.new("passwd -s #{@new_resource.username}")
          lock_check.run_command

          if lock_check.exitstatus != 0
            raise Chef::Exceptions::User, "Cannot determine if #{@new_resource} is locked!"
          end

          username, status = lock_check.stdout.split(' ')

          status == "LK"
        end

        def lock_user
          unless check_lock
            run_command(:command => "passwd -l #{@new_resource.username}")
          end
        end

        def unlock_user
          if check_lock
            run_command(:command => "passwd -u #{@new_resource.username}")
          end
        end
      end
    end
  end
end
