# Cookbook Name:: smartos
# Recipe:: default
#
# Copyright 2013, ModCloth, Inc.
# Licensed MIT

include_recipe "smartos::link_awk"
include_recipe "smartos::link_grep"
include_recipe "smartos::link_sudo"
include_recipe "smartos::ohai_plugins"
