# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

CONSOLE_EXECUTABLE_FILE = File.expand_path 'console.rb'
GEM_SPECIFICATION = Gem::Specification.load Dir.glob('*.gemspec').first
SMOKE_TEST_EXECUTABLE_FILE = File.expand_path 'smoke_test.rb'

Rake::Task[:install].clear_actions
Rake::Task[:'install:local'].clear
RuboCop::RakeTask.new

task default: %i[rubocop test]

task :install do # rubocop:disable Rake/Desc
  install_gem Dir.glob('pkg/*.gem').first
end

Rake::TestTask.new(:test) do |task_|
  task_.pattern = 'test/**/test_*.rb'
  # Used to silence noisy warnings for some dependencies
  task_.warning = false
end

desc 'Run a smoke test'
task smoke_test: :install do
  expected = GEM_SPECIFICATION.version.to_s
  actual = Bundler.with_unbundled_env { `#{SMOKE_TEST_EXECUTABLE_FILE}` }
  if actual == expected
    puts 'Smoke test passed!'
  else
    abort "Smoke test failed: expected '#{expected}' but got '#{actual}'."
  end
end

desc 'Attempt to uninstall the gem from system gems'
task :uninstall do
  uninstall_gem GEM_SPECIFICATION.name
rescue Gem::InstallError => e
  puts e
end

desc [
  'Start an interactive prompt for experimentation with the gem (requires prior',
  'installation)'
].join(' ')
task :console do
  Bundler.unbundled_exec CONSOLE_EXECUTABLE_FILE
end

def install_gem(name)
  Bundler.unbundled_system "gem install #{name}"
end

def uninstall_gem(name)
  Bundler.unbundled_system "gem uninstall #{name}"
end
