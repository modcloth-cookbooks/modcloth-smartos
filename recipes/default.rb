#
# Cookbook Name:: smartos
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "smartos::link_awk"
include_recipe "smartos::link_grep"
include_recipe "smartos::link_sudo"
include_recipe "smartos::ohai_plugins"
