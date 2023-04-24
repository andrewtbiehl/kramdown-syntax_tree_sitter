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
  spec.description = <<~TEXT.chomp
    This is a syntax highlighter plugin for Kramdown that leverages Tree-sitter's \
    native syntax highlighter to highlight code blocks (and spans) when rendering HTML.

    Tree-sitter is a modern, general-purpose parsing library that outclasses many \
    existing tools at the task of syntax highlighting. This plugin adapts \
    Tree-sitter's native highlighter for Kramdown, so that Tree-sitter's superior \
    highlighting capabilities can be easily leveraged in the context of rendering \
    Markdown.
  TEXT
  spec.requirements = <<~TEXT.chomp
    This plugin is essentially an adapter for the Tree-sitter highlight library and \
    hence requires a compatible Rust installation to function. It is officially \
    compatible with the following environments:

    - Rust: 1.66, 1.67, 1.68, 1.69
    - Platforms: MacOS, Linux
  TEXT

  spec.add_runtime_dependency 'kramdown', '~> 2.0'
  spec.add_runtime_dependency 'rake', '~> 13.0'
  spec.add_runtime_dependency 'rutie', '~> 0.0.4'

  spec.add_development_dependency 'minitest', '= 5.18.0'
  spec.add_development_dependency 'rouge', '= 4.1.0'
  spec.add_development_dependency 'rubocop', '= 1.50.2'
  spec.add_development_dependency 'rubocop-minitest', '= 0.30.0'
  spec.add_development_dependency 'rubocop-rake', '= 0.6.0'

  spec.files = Dir['LICENSE.txt', 'README.md', 'ext/**/*.rs', 'ext/**/Cargo.lock',
                   'ext/**/Cargo.toml', 'ext/tasks.rake', 'lib/**/*.rb']
  spec.extensions = ['ext/Rakefile']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
