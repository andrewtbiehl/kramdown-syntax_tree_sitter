# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |task_|
  task_.libs << 'test'
  task_.pattern = 'test/**/test_*.rb'
end

task default: %i[rubocop test]
