# Cookbook Name:: smartos
# Recipe:: ohai_plugins
#
# Copyright 2013, ModCloth, Inc.
# Licensed MIT
#
# O HAI! I NEED TEH CPU AND TEH MEMORY STATZ!

include_recipe "ohai"

template "#{node['ohai']['plugin_path']}/cpu.rb" do
  source "plugins/cpu.rb.erb"
  owner "root"
  group "root"
  mode 0755
end

template "#{node['ohai']['plugin_path']}/memory.rb" do
  source "plugins/memory.rb.erb"
  owner "root"
  group "root"
  mode 0755
end
