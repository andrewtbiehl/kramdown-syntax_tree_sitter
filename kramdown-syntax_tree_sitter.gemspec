# frozen_string_literal: true

require_relative 'lib/kramdown/syntax_tree_sitter/version'

Gem::Specification.new do |spec|
  spec.name = 'kramdown-syntax_tree_sitter'
  spec.version = Kramdown::Converter::SyntaxHighlighter::TreeSitter::VERSION
  spec.summary = 'Syntax highlight code with Tree-sitter via Kramdown.'
  spec.author = 'Andrew T. Biehl'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7'
  spec.homepage = 'https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter'

  spec.add_runtime_dependency 'kramdown', '~> 2.0'
  spec.add_runtime_dependency 'rake', '~> 13.0'
  spec.add_runtime_dependency 'rutie', '~> 0.0.4'

  spec.add_development_dependency 'minitest', '= 5.18.0'
  spec.add_development_dependency 'rouge', '= 4.1.0'
  spec.add_development_dependency 'rubocop', '= 1.50.0'
  spec.add_development_dependency 'rubocop-minitest', '= 0.30.0'
  spec.add_development_dependency 'rubocop-rake', '= 0.6.0'

  spec.files = Dir['LICENSE.txt', 'README.md', 'ext/**/*.rs', 'ext/**/Cargo.lock',
                   'ext/**/Cargo.toml', 'ext/tasks.rake', 'lib/**/*.rb']
  spec.extensions = ['ext/Rakefile']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
