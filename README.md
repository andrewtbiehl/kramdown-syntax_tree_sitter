***:construction: This project is in early initial development and is not yet
functional. :construction:***

# Kramdown Tree-sitter Highlighter

***Syntax highlight code with [Tree-sitter](https://tree-sitter.github.io/tree-sitter)
via [Kramdown](https://kramdown.gettalong.org).***

This is a syntax highlighter plugin for [Kramdown](https://kramdown.gettalong.org) that
leverages
[Tree-sitter's native syntax highlighter](https://tree-sitter.github.io/tree-sitter/syntax-highlighting)
to highlight code blocks (and spans) when rendering HTML.

## Requirements and compatibility

This plugin is built for [Kramdown](https://kramdown.gettalong.org) and hence requires a
compatible [Ruby](https://www.ruby-lang.org) installation to function. It is officially
compatible with the following environments:

- **Ruby**: 2.7, 3.0, 3.1
- **Platforms**: MacOS, Linux

## Installation

For projects using [Bundler](https://bundler.io) for dependency management, run the
following command to both install the gem and add it to the Gemfile:

```shell
bundle add kramdown-syntax_tree_sitter --github andrewtbiehl/kramdown-syntax_tree_sitter
```

Otherwise, download this project's repository and then run the following command from
within it to build and install the gem:

```shell
gem build && gem install kramdown-syntax_tree_sitter
```

## Usage

```ruby
require 'kramdown'
require 'kramdown/syntax_tree_sitter'

Kramdown::Document.new(text, syntax_highlighter: :'tree-sitter').to_html
```

Please note that this project is in early initial development; the behavior of this
plugin is incomplete and subject to change significantly.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release
a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter.

## License

This project is released under the MIT License.

The text for this license can be found in [the project's LICENSE.txt file](LICENSE.txt).
