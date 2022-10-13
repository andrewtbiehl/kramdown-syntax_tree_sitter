# frozen_string_literal: true

require_relative 'lib/kramdown/syntax_tree_sitter/version'

DEVELOPMENT_DEPENDENCIES = [['minitest', '~> 5.0'],
                            ['rake', '~> 13.0'],
                            ['rouge', '~> 4.0'],
                            ['rubocop', '~> 1.36'],
                            ['rubocop-minitest', '~> 0.22'],
                            ['rubocop-rake', '~> 0.6']].freeze

Gem::Specification.new do |spec|
  spec.name = 'kramdown-syntax_tree_sitter'
  spec.version = Kramdown::Converter::SyntaxHighlighter::TreeSitter::VERSION
  spec.summary = 'Syntax highlight code with Tree-sitter via Kramdown.'
  spec.author = 'Andrew T. Biehl'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7'
  spec.homepage = 'https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter'

  spec.add_runtime_dependency 'kramdown', '~> 2.0'

  DEVELOPMENT_DEPENDENCIES.each { spec.add_development_dependency(*_1) }

  spec.files = Dir['LICENSE.txt', 'README.md', 'ext/tasks.rake', 'lib/**/*.rb']
  spec.extensions = ['ext/Rakefile']
end
