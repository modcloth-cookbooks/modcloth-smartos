template "#{node['ohai']['plugin_path']}/cpu.rb" do
  source "plugins/cpu.rb.erb"
  owner "root"
  group "root"
  mode 0755
end

include_recipe "ohai"
