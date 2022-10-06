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

To set up a compatible local development environment, please first refer to the
['Requirements and Compatibility'](#requirements-and-compatibility) section of this
document.

After checking out the project, run `bin/setup` from within it to install dependencies.
Then run `bundle exec rake --tasks` to list all available Rake tasks. Each task can be
invoked via `bundle exec rake <task name>`. For example, `bundle exec rake test` runs
unit tests and `bundle exec rake smoke_test` installs the gem and runs a smoke test
against it. Also, running `bin/console` starts an interactive prompt that allows for
experimentation with the gem.

This project uses [GitHub Actions](https://github.com/features/actions) workflows to
facilitate continuous integration. The 'Quality Control' workflow runs any time new
commits are pushed to GitHub on any branch. This workflow runs the `rubocop`, `test`,
and `smoke_test` Rake tasks to verify that new changes meet the project's code quality
standards, so it is strongly recommended that these tasks are first run locally against
new changes before such changes are pushed.

## Contributing

This project is not currently open for contributions, but will be as soon as the initial
MVP version is released.

## License

This project is released under the MIT License.

The text for this license can be found in [the project's LICENSE.txt file](LICENSE.txt).
