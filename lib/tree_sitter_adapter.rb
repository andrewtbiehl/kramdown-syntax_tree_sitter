# frozen_string_literal: true

require 'rutie'

Rutie.new(:tree_sitter_adapter).init(
  'Init_rutie_ruby_example',
  File.expand_path(File.join(__dir__, '..', 'ext', 'tree_sitter_adapter', 'target'))
)
