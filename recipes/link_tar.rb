# Cookbook Name:: smartos
# Recipe:: link_tar
#
# Copyright 2013, ModCloth, Inc.
# Licensed MIT

case node['platform']
when 'smartos'
  link "/opt/local/bin/tar" do
    to "/opt/local/gnu/bin/tar"
    only_if { File.exists?("/opt/local/gnu/bin/tar") }
  end
end
