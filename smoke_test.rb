#!/usr/bin/env ruby
# frozen_string_literal: true

# A very simple smoke test, invoked by the Rake smoke_test task
# Verifies that the gem has been installed successfully and can run successfully

require 'kramdown/syntax_tree_sitter'

print Kramdown::Converter::SyntaxHighlighter::TreeSitter::VERSION
