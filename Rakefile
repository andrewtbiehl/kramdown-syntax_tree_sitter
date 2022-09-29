# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'rubygems/commands/uninstall_command'

GEM_SPECIFICATION = Gem::Specification.load Dir.glob('*.gemspec').first
SMOKE_TEST_EXECUTABLE_FILE = File.expand_path 'bin/smoke_test'

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |task_|
  task_.libs << 'test'
  task_.pattern = 'test/**/test_*.rb'
end

task default: %i[rubocop test]

desc('Run a smoke test')
task smoke_test: :install do
  expected = GEM_SPECIFICATION.version.to_s
  actual = `#{SMOKE_TEST_EXECUTABLE_FILE}`
  if actual == expected
    puts 'Smoke test passed!'
  else
    abort "Smoke test failed: expected '#{expected}' but got '#{actual}'."
  end
end

desc('Attempt to uninstall the gem from system gems')
task :uninstall do
  uninstall_gem GEM_SPECIFICATION.name
rescue Gem::InstallError => e
  puts e
end

def uninstall_gem(name)
  command = Gem::Commands::UninstallCommand.new
  command.handle_options ['--ignore-dependencies', name]
  command.execute
end
