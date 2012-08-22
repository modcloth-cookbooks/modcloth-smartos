case node['platform']
when 'smartos'
  link "/opt/local/etc/haproxy.cfg" do
    to "/etc/haproxy/haproxy.cfg"
    only_if { File.exists?("/etc/haproxy/haproxy.cfg") }
  end
end
