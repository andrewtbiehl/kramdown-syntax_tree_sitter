# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'rubygems/commands/uninstall_command'

CONSOLE_HELP = <<~TEXT
  Kramdown and kramdown/syntax_tree_sitter imported.

  Try running the following code snippet from the console:

  example_text = <<~MARKDOWN
    ~~~python
    print('Hello, World!')
    ~~~
  MARKDOWN

  puts Kramdown::Document.new(example_text, syntax_highlighter: :'tree-sitter').to_html
TEXT
GEM_SPECIFICATION = Gem::Specification.load Dir.glob('*.gemspec').first
SMOKE_TEST_EXECUTABLE_FILE = File.expand_path 'smoke_test.rb'

RuboCop::RakeTask.new

Rake::TestTask.new(:test) do |task_|
  task_.libs << 'test'
  task_.pattern = 'test/**/test_*.rb'
  # Used to silence noisy warnings for some dependencies
  task_.warning = false
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

desc('Start an interactive prompt for experimentation with the gem')
task :console do
  require 'bundler/setup'
  require 'irb'
  require 'kramdown'
  require 'kramdown/syntax_tree_sitter'

  puts CONSOLE_HELP
  ARGV.clear
  IRB.start(__FILE__)
end
