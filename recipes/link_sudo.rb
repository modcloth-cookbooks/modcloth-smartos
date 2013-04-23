# Joyent pkgsrc puts stuff in the wrong directory (/opt/local/etc).  
# We're working around this by linking /etc/sudoers to /opt/local/etc/sudoers 
# until they correct this as this is the least destructive way to move forward.
# ln -s /etc/sudoers /opt/local/etc/sudoers

case node['platform']
when 'smartos'
  link "/opt/local/etc/sudoers" do
    to "/etc/sudoers"
    link_type :hard
    only_if { File.exists?("/etc/sudoers") }
  end
end
