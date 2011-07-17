require 'bundler'
Bundler::GemHelper.install_tasks

require 'rubygems'
require 'rake/testtask'
#require 'rdoc/task'

task :default => :test

desc 'Test the gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end