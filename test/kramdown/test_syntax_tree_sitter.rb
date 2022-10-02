# frozen_string_literal: true

require 'test_helper'

module Kramdown
  class TestSyntaxTreeSitter < Minitest::Test
    def test_that_tree_sitter_has_a_version_number
      refute_nil ::Kramdown::Converter::SyntaxHighlighter::TreeSitter::VERSION
    end
  end
end
