# frozen_string_literal: true

require_relative "lib/kramdown/syntax_tree_sitter/version"

Gem::Specification.new do |spec|
  spec.name = "kramdown-syntax_tree_sitter"
  spec.version = Kramdown::SyntaxTreeSitter::VERSION
  spec.authors = ["Andrew T. Biehl"]

  spec.summary = "Syntax highlight code with Tree-Sitter in Kramdown."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
