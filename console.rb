#!/usr/bin/env ruby
# frozen_string_literal: true

# Starts an interactive prompt for experimentation with the gem
# Requires prior installation to system gems to funtion properly

require 'irb'
require 'kramdown/syntax_tree_sitter'

CONSOLE_HELP = <<~TEXT
  Kramdown and kramdown/syntax_tree_sitter imported.

  Try running the following code snippet from the console:

  example_text = <<~MARKDOWN
    ~~~python
    print('Hello, World!')
    ~~~
  MARKDOWN

  puts Kramdown::Document.new(example_text, syntax_highlighter: :'tree-sitter').to_html
TEXT

puts CONSOLE_HELP
IRB.start(__FILE__)
