#
# Cookbook Name:: logrotate
# Provider:: rotation
#
# Copyright 2009, Scott M. Likens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "logrotate"

path = new_resource.path.respond_to?(:each) ? new_resource.path : new_resource.path.split
perms = new_resource.permissions ? new_resource.permissions : "644 root adm"

action :create do
  template "/etc/logrotate.d/#{new_resource.name}" do
    source new_resource.template
    cookbook new_resource.cookbook
    mode 0440
    owner "root"
    group "root"
    backup false
    variables(
      :path => new_resource.path,
      :create => new_resource.permissions,
      :frequency => new_resource.frequency,
      :rotate => new_resource.rotate
    )
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  execute "rm /etc/logrotate.d/#{new_resource.name}" do
    only_if FileTest.exists?("/etc/logrotate.d/#{new_resource.name}")
    command "rm /etc/logrotate.d/#{new_resource.name}"
    new_resource.updated_by_last_action(true)
  end
end
