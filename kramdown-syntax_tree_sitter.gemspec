# frozen_string_literal: true

require_relative 'lib/kramdown/syntax_tree_sitter/version'

Gem::Specification.new do |spec|
  spec.name = 'kramdown-syntax_tree_sitter'
  spec.version = Kramdown::Converter::SyntaxHighlighter::TreeSitter::VERSION
  spec.summary = 'Syntax highlight code with Tree-sitter via Kramdown.'
  spec.author = 'Andrew T. Biehl'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0'
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

    - Rust: 1.76, 1.77, 1.78, 1.79
    - Platforms: MacOS, Linux
  TEXT

  spec.add_dependency 'kramdown', '~> 2.0'
  spec.add_dependency 'rake', '~> 13.0'
  spec.add_dependency 'rutie', '~> 0.0.4'

  spec.files = Dir['LICENSE.txt', 'README.md', 'ext/**/*.rs', 'ext/**/Cargo.lock',
                   'ext/**/Cargo.toml', 'ext/tasks.rake', 'lib/**/*.rb']
  spec.extensions = ['ext/Rakefile']
  spec.metadata = {
    'rubygems_mfa_required' => 'true',
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'documentation_uri' => "#{spec.homepage}/blob/main/README.md",
    'changelog_uri' => "#{spec.homepage}/blob/main/CHANGELOG.md",
    'bug_tracker_uri' => "#{spec.homepage}/issues"
  }
end
