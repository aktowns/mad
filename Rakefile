require "bundler/gem_tasks"
require 'rubocop/rake_task'
require 'cane/rake_task'
require 'rspec/core/rake_task'
require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['--embed-mixins', '--private', '--protected', '--hide-void-return']
  t.stats_options = ['--list-undoc']
end

Cane::RakeTask.new
RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)
