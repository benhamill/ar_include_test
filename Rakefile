require 'active_record'
require 'pry'

file 'config' do |t|
  sh 'erb config.yml.erb > config.yml'
end

desc 'Fire up an interactive terminal to play with'
task :console => 'db:connect' do
  Pry.start
end

namespace :db do
  task :connect => 'config' do |t|
    ActiveRecord::Base.establish_connection \
      YAML.load_file 'config.yml'
  end

  task :disconnect do
    ActiveRecord::Base.clear_all_connections!
  end

  desc 'Create the test database'
  task :create do
    sh 'createdb include_test'
  end

  desc 'Drop the test database'
  task :drop => :disconnect do
    sh 'dropdb include_test'
  end

  namespace :migrate do
    desc 'Run the test database migrations'
    task :up => 'db:connect' do
      ActiveRecord::Migrator.up 'migrate'
    end

    desc 'Reverse the test database migrations'
    task :down => 'db:connect' do
      ActiveRecord::Migrator.down 'migrate'
    end
  end
  task :migrate => 'migrate:up'

  desc 'Create and configure the test database'
  task :setup => [ :create, :migrate ]

  desc 'Drop the test tables and database'
  task :teardown => [ 'migrate:down', :drop ]
end
