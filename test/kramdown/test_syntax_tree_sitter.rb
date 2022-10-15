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
  <div class=\"language-html highlighter-tree-sitter\"><pre><code>\
  &lt;strong&gt;The ampersand ('&amp;amp;') should be HTML escaped.&lt;/strong&gt;
  </code></pre></div>
HTML

MARKDOWN_HIGHLIGHTER_HTML_COMBINATIONS = [
  [PYTHON_MARKDOWN, nil, PYTHON_NO_HIGHLIGHT_HTML],
  [PYTHON_MARKDOWN, :rouge, PYTHON_ROUGE_HTML],
  [PYTHON_MARKDOWN, :'tree-sitter', PYTHON_TREE_SITTER_HTML]
].freeze

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

    MARKDOWN_HIGHLIGHTER_HTML_COMBINATIONS.each do |markdown, highlighter, expected|
      highlighter_name = highlighter.nil? ? 'no' : highlighter
      define_method "test_that_it_can_use_#{highlighter_name}_highlighting" do
        actual = convert_to_html markdown, highlighter
        assert_equal actual, expected
      end
    end

    def test_that_it_can_use_tree_sitter_inline_highlighting
      actual = convert_to_html PYTHON_INLINE_MARKDOWN, :'tree-sitter'
      assert_equal actual, PYTHON_TREE_SITTER_INLINE_HTML
    end

    def test_that_it_can_use_tree_sitter_html_escaped_highlighting
      actual = convert_to_html HTML_MARKDOWN, :'tree-sitter'
      assert_equal actual, HTML_TREE_SITTER_HTML
    end
  end
end
