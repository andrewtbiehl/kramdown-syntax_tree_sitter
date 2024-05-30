# frozen_string_literal: true

# Even though this project uses Magnus to handle interoperabilty between Ruby and Rust,
# the Ruby support library for Rutie still happens to work very well for initializing
# the internal Rust extension for use by this Ruby library
require 'rutie'

Rutie.new(:tree_sitter_adapter).init(
  'Init_tree_sitter_adapter',
  File.expand_path(File.join(__dir__, '..', 'ext', 'tree_sitter_adapter', 'target'))
)
