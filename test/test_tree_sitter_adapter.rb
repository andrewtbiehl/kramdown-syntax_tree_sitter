# frozen_string_literal: true

require 'minitest/autorun'
require 'tree_sitter_adapter'

class TestTreeSitterAdapter < Minitest::Test
  def test_that_it_reverses_strings
    assert_equal 'selppa', RutieExample.reverse('apples')
  end
end
