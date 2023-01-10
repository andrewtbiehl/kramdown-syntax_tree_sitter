# frozen_string_literal: true

require 'kramdown'
require 'kramdown/syntax_tree_sitter'
require 'minitest/autorun'

PYTHON_STANDARD_MARKDOWN = <<~MARKDOWN
  ~~~python
  print('Hello, World!')
  ~~~
MARKDOWN

PYTHON_TREE_SITTER_MARKDOWN = <<~MARKDOWN
  ~~~source.python
  print('Hello, World!')
  ~~~
MARKDOWN

PYTHON_TREE_SITTER_ESCAPE_CHARACTER_MARKDOWN = <<~MARKDOWN
  ~~~source.python
  print("The newline character ('\\n') is an important control character.")
  ~~~
MARKDOWN

HTML_TREE_SITTER_MARKDOWN = <<~MARKDOWN
  ~~~text.html.basic
  <strong>The ampersand ('&amp;') should be HTML escaped.</strong>
  ~~~
MARKDOWN

PYTHON_TREE_SITTER_INLINE_MARKDOWN = <<~MARKDOWN
  The code `print('Hello, World!')`{: class="language-source.python" } is valid Python.
MARKDOWN

BAD_SYNTAX_PYTHON_TREE_SITTER_MARKDOWN = <<~MARKDOWN
  ~~~source.python
  print('Hello, World!''"))
  ~~~
MARKDOWN

NO_LANGUAGE_TREE_SITTER_MARKDOWN = <<~MARKDOWN
  ~~~
  <strong>The ampersand ('&amp;') should be HTML escaped.</strong>
  ~~~
MARKDOWN

NO_LANGUAGE_TREE_SITTER_INLINE_MARKDOWN = <<~MARKDOWN
  The code `<strong>The ampersand ('&amp;') should be HTML escaped.</strong>` is not \
  highlighted.
MARKDOWN

PYTHON_NO_HIGHLIGHT_HTML = <<~HTML
  <pre><code class="language-python">print('Hello, World!')
  </code></pre>
HTML

PYTHON_ROUGE_HTML = <<~HTML
  <div class="language-python highlighter-rouge"><div class="highlight">\
  <pre class="highlight"><code><span class="k">print</span><span class="p">(</span>\
  <span class="s">'Hello, World!'</span><span class="p">)</span>
  </code></pre></div></div>
HTML

PYTHON_TREE_SITTER_HTML = <<~HTML
  <div class="language-source.python highlighter-tree-sitter"><pre><code>\
  <span style='font-weight: bold;color: #005fd7'>print</span>(\
  <span style='color: #008700'>&#39;Hello, World!&#39;</span>)
  </code></pre></div>
HTML

PYTHON_TREE_SITTER_INLINE_CSS_HTML = <<~HTML
  <div class="language-source.python highlighter-tree-sitter"><pre><code>\
  <span style='font-weight: bold;color: #005fd7'>print</span>(\
  <span style='color: #008700'>&quot;The newline character \
  (&#39;<span>\\n</span>&#39;) is an important control character.&quot;</span>)
  </code></pre></div>
HTML

PYTHON_TREE_SITTER_CSS_CLASS_HTML = <<~HTML
  <div class="language-source.python highlighter-tree-sitter"><pre><code>\
  <span class='ts-function-builtin'>print</span>(\
  <span class='ts-string'>&quot;The newline character \
  (&#39;<span class='ts-escape'>\\n</span>&#39;) is an important control \
  character.&quot;</span>)
  </code></pre></div>
HTML

PYTHON_TREE_SITTER_INLINE_HTML = <<~HTML
  <p>The code <code class="language-source.python highlighter-tree-sitter">\
  <span style='font-weight: bold;color: #005fd7'>print</span>(\
  <span style='color: #008700'>&#39;Hello, World!&#39;</span>)\
  </code> is valid Python.</p>
HTML

HTML_TREE_SITTER_HTML = <<~HTML
  <div class="language-text.html.basic highlighter-tree-sitter"><pre><code>\
  <span style='color: #4e4e4e'>&lt;</span><span style='color: #000087'>strong</span>\
  <span style='color: #4e4e4e'>&gt;</span>The ampersand (&#39;&amp;amp;&#39;) should \
  be HTML escaped.<span style='color: #4e4e4e'>&lt;/</span>\
  <span style='color: #000087'>strong</span><span style='color: #4e4e4e'>&gt;</span>
  </code></pre></div>
HTML

BAD_SYNTAX_PYTHON_TREE_SITTER_HTML = <<~HTML
  <div class="language-source.python highlighter-tree-sitter"><pre><code>\
  <span style='font-weight: bold;color: #005fd7'>print</span>(\
  <span style='color: #008700'>&#39;Hello, World!&#39;</span>&#39;&quot;))
  </code></pre></div>
HTML

NO_LANGUAGE_TREE_SITTER_HTML = <<~HTML
  <pre><code>&lt;strong&gt;The ampersand ('&amp;amp;') should be HTML \
  escaped.&lt;/strong&gt;
  </code></pre>
HTML

NO_LANGUAGE_TREE_SITTER_INLINE_HTML = <<~HTML
  <p>The code <code>&lt;strong&gt;The ampersand ('&amp;amp;') should be HTML \
  escaped.&lt;/strong&gt;</code> is not highlighted.</p>
HTML

PYTHON_TREE_SITTER_ROUGE_IDENTIFIER_HTML = <<~HTML
  <div class="language-python highlighter-tree-sitter"><pre><code>\
  <span style='font-weight: bold;color: #005fd7'>print</span>(\
  <span style='color: #008700'>&#39;Hello, World!&#39;</span>)
  </code></pre></div>
HTML

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
  class TestSyntaxHighlighting < Minitest::Test
    def test_that_tree_sitter_has_a_version_number
      refute_nil Converter::SyntaxHighlighter::TreeSitter::VERSION
    end

    def test_that_it_can_use_no_highlighting
      actual = convert_to_html PYTHON_STANDARD_MARKDOWN, nil

      assert_equal PYTHON_NO_HIGHLIGHT_HTML, actual
    end

    def test_that_it_can_use_rouge_highlighting
      actual = convert_to_html PYTHON_STANDARD_MARKDOWN, :rouge

      assert_equal PYTHON_ROUGE_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_highlighting
      actual = convert_to_html(
        PYTHON_TREE_SITTER_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal PYTHON_TREE_SITTER_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_inline_css_highlighting
      actual = convert_to_html(
        PYTHON_TREE_SITTER_ESCAPE_CHARACTER_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH, css_classes: false }
      )

      assert_equal PYTHON_TREE_SITTER_INLINE_CSS_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_css_class_highlighting
      actual = convert_to_html(
        PYTHON_TREE_SITTER_ESCAPE_CHARACTER_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH, css_classes: true }
      )

      assert_equal PYTHON_TREE_SITTER_CSS_CLASS_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_inline_highlighting
      actual = convert_to_html(
        PYTHON_TREE_SITTER_INLINE_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal PYTHON_TREE_SITTER_INLINE_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_html_escaped_highlighting
      actual = convert_to_html(
        HTML_TREE_SITTER_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal HTML_TREE_SITTER_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_highlighting_on_bad_syntax
      actual = convert_to_html(
        BAD_SYNTAX_PYTHON_TREE_SITTER_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal BAD_SYNTAX_PYTHON_TREE_SITTER_HTML, actual
    end

    def test_that_it_can_use_no_highlighting_with_tree_sitter_enabled
      actual = convert_to_html(
        NO_LANGUAGE_TREE_SITTER_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal NO_LANGUAGE_TREE_SITTER_HTML, actual
    end

    def test_that_it_can_use_no_inline_highlighting_with_tree_sitter_enabled
      actual = convert_to_html(
        NO_LANGUAGE_TREE_SITTER_INLINE_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal NO_LANGUAGE_TREE_SITTER_INLINE_HTML, actual
    end

    def test_that_it_fails_gracefully_if_unable_to_locate_tree_sitter_parsers_directory
      actual = assert_raises Exception do
        convert_to_html(
          PYTHON_TREE_SITTER_MARKDOWN,
          :'tree-sitter',
          { tree_sitter_parsers_dir: FAKE_PARSERS_PATH }
        )
      end

      assert_instance_of RuntimeError, actual
      assert_equal PYTHON_MISSING_LANGUAGE_PARSER_MSG, actual.message
    end

    def test_that_it_can_use_tree_sitter_highlighting_with_rouge_identifiers
      actual = convert_to_html(
        PYTHON_STANDARD_MARKDOWN,
        :'tree-sitter',
        { tree_sitter_parsers_dir: REAL_PARSERS_PATH }
      )

      assert_equal PYTHON_TREE_SITTER_ROUGE_IDENTIFIER_HTML, actual
    end
  end
end
