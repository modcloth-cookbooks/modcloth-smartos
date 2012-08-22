case node['platform']
when 'smartos'
  directory "/etc/haproxy" do
    owner "root"
    group "root"
    mode "0644"
    action :create
  end
end