require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |task|
  task.libs << 'lib' << 'spec'
  task.pattern = 'spec/bitcourier/**/*_spec.rb'
  task.verbose = true
end
