# frozen_string_literal: true

require 'kramdown'
require 'kramdown/syntax_tree_sitter'
require 'minitest/autorun'

TEST_FILES_DIRECTORY_PATH = File.join __dir__, '..', 'test_files'

# Helper function for reading test input data from a file
def read_test_file(filename)
  full_path = File.join TEST_FILES_DIRECTORY_PATH, filename
  File.read full_path
end

TEST_DATA =
  {
    PYTHON_STANDARD_MARKDOWN: 'python_standard.md',
    PYTHON_TREE_SITTER_MARKDOWN: 'python_tree_sitter.md',
    PYTHON_TREE_SITTER_ESCAPE_CHARACTER_MARKDOWN:
      'python_tree_sitter_escape_character.md',
    HTML_TREE_SITTER_MARKDOWN: 'html_tree_sitter.md',
    PYTHON_TREE_SITTER_INLINE_MARKDOWN: 'python_tree_sitter_inline.md',
    BAD_SYNTAX_PYTHON_TREE_SITTER_MARKDOWN: 'bad_syntax_python_tree_sitter.md',
    NO_LANGUAGE_TREE_SITTER_MARKDOWN: 'no_language_tree_sitter.md',
    NO_LANGUAGE_TREE_SITTER_INLINE_MARKDOWN: 'no_language_tree_sitter_inline.md',
    PYTHON_NO_HIGHLIGHT_HTML: 'python_no_highlight.html',
    PYTHON_ROUGE_HTML: 'python_rouge.html',
    PYTHON_TREE_SITTER_HTML: 'python_tree_sitter.html',
    PYTHON_TREE_SITTER_INLINE_CSS_HTML: 'python_tree_sitter_inline_css.html',
    PYTHON_TREE_SITTER_CSS_CLASS_HTML: 'python_tree_sitter_css_class.html',
    PYTHON_TREE_SITTER_INLINE_HTML: 'python_tree_sitter_inline.html',
    HTML_TREE_SITTER_HTML: 'html_tree_sitter.html',
    BAD_SYNTAX_PYTHON_TREE_SITTER_HTML: 'bad_syntax_python_tree_sitter.html',
    NO_LANGUAGE_TREE_SITTER_HTML: 'no_language_tree_sitter.html',
    NO_LANGUAGE_TREE_SITTER_INLINE_HTML: 'no_language_tree_sitter_inline.html',
    PYTHON_TREE_SITTER_ROUGE_IDENTIFIER_HTML: 'python_tree_sitter_rouge_identifier.html'
  }
  .transform_values(&method(:read_test_file))
  .freeze

PYTHON_MISSING_LANGUAGE_PARSER_MSG = 'Error retrieving language configuration for ' \
                                     "scope 'source.python': Language not found"

TEST_DIR_PATH = File.expand_path File.join(__dir__, '..')
REAL_PARSERS_PATH = File.join TEST_DIR_PATH, 'tree_sitter_parsers'
FAKE_PARSERS_PATH = File.join TEST_DIR_PATH, 'tree_sitter_parsers_fake'

# Helper function for invoking Kramdown to render Markdown into HTML using a
# specific syntax highlighter.
def convert_to_html(markdown, highlighter, highlighter_opts = {})
  Kramdown::Document.new(
    markdown,
    syntax_highlighter: highlighter,
    syntax_highlighter_opts: highlighter_opts
  ).to_html
end

module Kramdown
  class TestSyntaxHighlighting < Minitest::Test # rubocop:disable Metrics/ClassLength
    def test_that_tree_sitter_has_a_version_number
      refute_nil Converter::SyntaxHighlighter::TreeSitter::VERSION
    end

    def test_that_it_can_use_no_highlighting
      actual = convert_to_html TEST_DATA.fetch(:PYTHON_STANDARD_MARKDOWN), nil

      assert_equal TEST_DATA.fetch(:PYTHON_NO_HIGHLIGHT_HTML), actual
    end

    def test_that_it_can_use_rouge_highlighting
      actual = convert_to_html TEST_DATA.fetch(:PYTHON_STANDARD_MARKDOWN), :rouge

      assert_equal TEST_DATA.fetch(:PYTHON_ROUGE_HTML), actual
    end

    def test_that_it_can_use_tree_sitter_highlighting
      actual = convert_to_html(
        TEST_DATA.fetch(:PYTHON_TREE_SITTER_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal TEST_DATA.fetch(:PYTHON_TREE_SITTER_HTML), actual
    end

    def test_that_it_can_use_tree_sitter_inline_css_highlighting
      actual = convert_to_html(
        TEST_DATA.fetch(:PYTHON_TREE_SITTER_ESCAPE_CHARACTER_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH, css_classes: false }
      )

      assert_equal TEST_DATA.fetch(:PYTHON_TREE_SITTER_INLINE_CSS_HTML), actual
    end

    def test_that_it_can_use_tree_sitter_css_class_highlighting
      actual = convert_to_html(
        TEST_DATA.fetch(:PYTHON_TREE_SITTER_ESCAPE_CHARACTER_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH, css_classes: true }
      )

      assert_equal TEST_DATA.fetch(:PYTHON_TREE_SITTER_CSS_CLASS_HTML), actual
    end

    def test_that_it_can_use_tree_sitter_inline_highlighting
      actual = convert_to_html(
        TEST_DATA.fetch(:PYTHON_TREE_SITTER_INLINE_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal TEST_DATA.fetch(:PYTHON_TREE_SITTER_INLINE_HTML), actual
    end

    def test_that_it_can_use_tree_sitter_html_escaped_highlighting
      actual = convert_to_html(
        TEST_DATA.fetch(:HTML_TREE_SITTER_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal TEST_DATA.fetch(:HTML_TREE_SITTER_HTML), actual
    end

    def test_that_it_can_use_tree_sitter_highlighting_on_bad_syntax
      actual = convert_to_html(
        TEST_DATA.fetch(:BAD_SYNTAX_PYTHON_TREE_SITTER_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal TEST_DATA.fetch(:BAD_SYNTAX_PYTHON_TREE_SITTER_HTML), actual
    end

    def test_that_it_can_use_no_highlighting_with_tree_sitter_enabled
      actual = convert_to_html(
        TEST_DATA.fetch(:NO_LANGUAGE_TREE_SITTER_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal TEST_DATA.fetch(:NO_LANGUAGE_TREE_SITTER_HTML), actual
    end

    def test_that_it_can_use_no_inline_highlighting_with_tree_sitter_enabled
      actual = convert_to_html(
        TEST_DATA.fetch(:NO_LANGUAGE_TREE_SITTER_INLINE_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal TEST_DATA.fetch(:NO_LANGUAGE_TREE_SITTER_INLINE_HTML), actual
    end

    def test_that_it_fails_gracefully_if_unable_to_locate_tree_sitter_parsers_directory
      actual = assert_raises Exception do
        convert_to_html(
          TEST_DATA.fetch(:PYTHON_TREE_SITTER_MARKDOWN),
          :'tree-sitter',
          { tree_sitter_parsers_dir: FAKE_PARSERS_PATH }
        )
      end

      assert_instance_of RuntimeError, actual
      assert_equal PYTHON_MISSING_LANGUAGE_PARSER_MSG, actual.message
    end

    def test_that_it_can_use_tree_sitter_highlighting_with_rouge_identifiers
      actual = convert_to_html(
        TEST_DATA.fetch(:PYTHON_STANDARD_MARKDOWN),
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal TEST_DATA.fetch(:PYTHON_TREE_SITTER_ROUGE_IDENTIFIER_HTML), actual
    end
  end
end
