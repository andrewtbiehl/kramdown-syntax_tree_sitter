# frozen_string_literal: true

require 'kramdown'
require 'test_helper'

PYTHON_MARKDOWN = <<~MARKDOWN
  ~~~python
  print('Hello, World!')
  ~~~
MARKDOWN

PYTHON_NO_HIGHLIGHT_HTML = <<~HTML
  <pre><code class="language-python">print('Hello, World!')
  </code></pre>
HTML

PYTHON_ROUGE_HTML = <<~HTML
  <div class="language-python highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">print</span><span class="p">(</span><span class="s">'Hello, World!'</span><span class="p">)</span>
  </code></pre></div></div>
HTML

MARKDOWN_HIGHLIGHTER_HTML_COMBINATIONS = [
  [PYTHON_MARKDOWN, nil, PYTHON_NO_HIGHLIGHT_HTML],
  [PYTHON_MARKDOWN, :rouge, PYTHON_ROUGE_HTML]
].freeze

module Kramdown
  class TestSyntaxHighlighting < Minitest::Test
    def test_that_tree_sitter_has_a_version_number
      refute_nil Converter::SyntaxHighlighter::TreeSitter::VERSION
    end

    MARKDOWN_HIGHLIGHTER_HTML_COMBINATIONS.each do |markdown, highlighter, expected|
      highlighter_name = highlighter.nil? ? 'no' : highlighter
      define_method "test_that_it_can_use_#{highlighter_name}_highlighting" do
        actual = Document.new(markdown, syntax_highlighter: highlighter).to_html
        assert_equal actual, expected
      end
    end
  end
end
