#
# Cookbook Name:: vsphere_perl_sdk
# Recipe:: default
#
# Copyright 2014, Biola University 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# update the apt cache before the package installs below
if node['platform_family'] == 'debian'
  include_recipe 'apt::default'
end

# Pull in ark for the package deployment
include_recipe 'ark::default'
# 'Expect' support
chef_gem 'greenletters'

# Install pre-reqs
if node['platform_family'] == 'debian'
  %w{ libarchive-zip-perl libcrypt-ssleay-perl libclass-methodmaker-perl libdata-dump-perl libsoap-lite-perl perl-doc libssl-dev libuuid-perl liburi-perl libxml-libxml-perl }.each do |p|
    package p do
      action :install
    end
  end
end

# Proceed w/ the install if running on a 64bit node and EULA has been accepted
if (node['kernel']['machine'] == "x86_64") && (not File.exists?("/usr/bin/vmware-uninstall-vSphere-CLI.pl")) && node['vsphere']['perlsdk_x64_url'] && node['vsphere']['perlsdk_x64_checksum'] && node['vsphere']['perlsdk_eula_accepted']
  
  ark node['vsphere']['perlsdk_x64_url'].split('/').last.split('.tar.gz').first do
    url node['vsphere']['perlsdk_x64_url']
    checksum node['vsphere']['perlsdk_x64_checksum']
    path Chef::Config['file_cache_path']
    #strip_components 0
    action :put
  end
  
  ruby_block "install vsphere sdk & cli" do
    block do
      require 'greenletters'
      installer = Greenletters::Process.new("#{Chef::Config['file_cache_path']}/#{node['vsphere']['perlsdk_x64_url'].split('/').last.split('.tar.gz').first}/vmware-install.pl -d", :timeout => 300, :transcript => $stdout)
      installer.start!
      installer.wait_for(:output, /Press enter to display it\./i)
      installer << "\n"
      sleep 1
      installer << "q"
      installer.wait_for(:output, /Do you accept\? \(yes\/no\) /i)
      installer << "yes\n"
      installer.wait_for(:exit)
    end
  end
  
else
  log 'Skipping install - already installed or requirements not met'
end
