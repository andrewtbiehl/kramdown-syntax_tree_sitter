# frozen_string_literal: true

require_relative "lib/kramdown/syntax_tree_sitter/version"

Gem::Specification.new do |spec|
  spec.name = "kramdown-syntax_tree_sitter"
  spec.version = Kramdown::SyntaxTreeSitter::VERSION
  spec.authors = ["Andrew T. Biehl"]

  spec.summary = "Syntax highlight code with Tree-Sitter in Kramdown."

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"

end
