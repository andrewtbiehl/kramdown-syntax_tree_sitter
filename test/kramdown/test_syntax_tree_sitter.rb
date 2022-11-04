# frozen_string_literal: true

require 'kramdown'
require 'kramdown/syntax_tree_sitter'
require 'minitest/autorun'

PYTHON_MARKDOWN = <<~MARKDOWN
  ~~~python
  print('Hello, World!')
  ~~~
MARKDOWN

HTML_MARKDOWN = <<~MARKDOWN
  ~~~html
  <strong>The ampersand ('&amp;') should be HTML escaped.</strong>
  ~~~
MARKDOWN

PYTHON_INLINE_MARKDOWN = <<~MARKDOWN
  The code `print('Hello, World!')`{: .language-python} is valid Python.
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
  <div class="language-python highlighter-tree-sitter"><pre><code>print('Hello, World!')
  </code></pre></div>
HTML

PYTHON_TREE_SITTER_INLINE_HTML = <<~HTML
  <p>The code <code class="language-python highlighter-tree-sitter">\
  print('Hello, World!')</code> is valid Python.</p>
HTML

HTML_TREE_SITTER_HTML = <<~HTML
  <div class="language-html highlighter-tree-sitter"><pre><code>\
  &lt;strong&gt;The ampersand ('&amp;amp;') should be HTML escaped.&lt;/strong&gt;
  </code></pre></div>
HTML

# Helper function for invoking Kramdown to render Markdown into HTML using a
# specific syntax highlighter.
def convert_to_html(markdown, highlighter)
  Kramdown::Document.new(markdown, syntax_highlighter: highlighter).to_html
end

module Kramdown
  class TestSyntaxHighlighting < Minitest::Test
    def test_that_tree_sitter_has_a_version_number
      refute_nil Converter::SyntaxHighlighter::TreeSitter::VERSION
    end

    def test_that_it_can_use_no_highlighting
      actual = convert_to_html PYTHON_MARKDOWN, nil

      assert_equal PYTHON_NO_HIGHLIGHT_HTML, actual
    end

    def test_that_it_can_use_rouge_highlighting
      actual = convert_to_html PYTHON_MARKDOWN, :rouge

      assert_equal PYTHON_ROUGE_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_highlighting
      actual = convert_to_html PYTHON_MARKDOWN, :'tree-sitter'

      assert_equal PYTHON_TREE_SITTER_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_inline_highlighting
      actual = convert_to_html PYTHON_INLINE_MARKDOWN, :'tree-sitter'

      assert_equal PYTHON_TREE_SITTER_INLINE_HTML, actual
    end

    def test_that_it_can_use_tree_sitter_html_escaped_highlighting
      actual = convert_to_html HTML_MARKDOWN, :'tree-sitter'

      assert_equal HTML_TREE_SITTER_HTML, actual
    end
  end
end
