include_recipe 'build-essential'
include_recipe 'ruby_build'


########################################
# Base setup
########################################

%w(postgresql-libs postgresql-devel postgresql-server openssl-devel libyaml-devel libffi-devel
   readline-devel zlib-devel gdbm-devel ncurses-devel
   policycoreutils policycoreutils-python).each do |package_name|
  package package_name do
    action :install
  end
end

ruby_build_ruby "2.1.4" do
  prefix_path '/usr/'
  action :reinstall
  not_if "test $(ruby -v | grep #{"2.1.4"} | wc -l) = 1"
end

gem_package 'bundler' do
  gem_binary '/usr/bin/gem'
  options '--no-ri --no-rdoc'
end

# user_account 'neyaz' do
#   create_group true
#   ssh_keygen false
# end
#

user 'neyaz'

execute "install_gems" do
  command "cd /flashcards && bundle install"
end

execute "migrate" do
  command "cd /flashcards && bundle exec rake db:create && bundle exec rake db:migrate"
end

execute "start_server" do
  command "cd /flashcards && rails -s"
end
