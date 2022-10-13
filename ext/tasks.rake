# frozen_string_literal: true

require 'English'

MANIFEST_PATH = File.join __dir__, 'tree_sitter_adapter', 'Cargo.toml'

MISSING_RUST_ERROR_MSG = <<~TEXT
  This gem requires a standard Rust installation to install and function.
  See https://www.rust-lang.org/tools/install for details on installing Rust.
TEXT

namespace :extensions do
  desc 'Build gem extensions in place'
  task build: :'rust:build'
end

namespace :rust do
  task :exists do # rubocop:disable Rake/Desc
    command_exists?('cargo') || abort(MISSING_RUST_ERROR_MSG)
  end

  task build: :exists do # rubocop:disable Rake/Desc
    build_rust_project MANIFEST_PATH
  end
end

def command_exists?(name)
  `which #{name}`
  $CHILD_STATUS.success?
end

def build_rust_project(manifest_path)
  sh "cargo build --release --manifest-path #{manifest_path}"
end
