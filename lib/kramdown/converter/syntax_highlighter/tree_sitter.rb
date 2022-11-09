# frozen_string_literal: true

require 'kramdown'
require 'tree_sitter_adapter'

module Kramdown
  module Converter # rubocop:disable Style/Documentation
    module SyntaxHighlighter
      # This highlighter is not yet fully configured to highlight code.
      #
      # Currently it merely escapes the code so that it can be safely inserted into HTML
      # text.
      module TreeSitter
        DEFAULT_PARSERS_DIR = '~/tree_sitter_parsers'

        def self.call(converter, raw_text, language, type, _)
          return nil unless language

          parsers_dir = get_option(converter, :tree_sitter_parsers_dir)
                        .then { _1 || DEFAULT_PARSERS_DIR }
                        .then { File.expand_path _1 }
          rendered_text = TreeSitterAdapter.highlight raw_text, parsers_dir, language
          # Code blocks are additionally wrapped in HTML code tags
          type == :block ? "<pre><code>#{rendered_text}</code></pre>" : rendered_text
        end

        def self.get_option(converter, name)
          converter.options[:syntax_highlighter_opts][name]
        end
      end
    end

    add_syntax_highlighter(:'tree-sitter', SyntaxHighlighter::TreeSitter)
  end
end
