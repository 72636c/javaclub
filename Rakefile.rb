require "./app"
require "rspec/core/rake_task"
require "sinatra/activerecord/rake"

task :default => :spec

RSpec::Core::RakeTask.new
