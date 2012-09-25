case node['platform']
when 'smartos'
  # Tune up the tcp/ip stack
  cookbook_file "/etc/inittab" do
    source "inittab" 
    owner "root"
    group "root"
    mode "0744"
    action :create
  end
end
