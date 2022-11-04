***:construction: This project is in early initial development and is not yet
functional. :construction:***

# Kramdown Tree-sitter Highlighter

***Syntax highlight code with [Tree-sitter](https://tree-sitter.github.io/tree-sitter)
via [Kramdown](https://kramdown.gettalong.org).***

This is a syntax highlighter plugin for [Kramdown](https://kramdown.gettalong.org) that
leverages
[Tree-sitter's native syntax highlighter](https://tree-sitter.github.io/tree-sitter/syntax-highlighting)
to highlight code blocks (and spans) when rendering HTML.

## Getting started

### Requirements and compatibility

This plugin is built for [Kramdown](https://kramdown.gettalong.org) and hence requires a
compatible [Ruby](https://www.ruby-lang.org) installation to function. It is also
essentially an adapter for the
[Tree-sitter highlight library](https://crates.io/crates/tree-sitter-highlight) and
hence also requires a compatible [Rust](https://www.rust-lang.org) installation to
function. It is officially compatible with the following environments:

- **Ruby**: 2.7, 3.0, 3.1
- **Rust**: 1.60, 1.61, 1.62, 1.63, 1.64
- **Platforms**: MacOS, Linux

### Installation

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

Please note that this project is in early initial development; the behavior of this
plugin is incomplete and subject to change significantly.

### Quickstart

```ruby
require 'kramdown'
require 'kramdown/syntax_tree_sitter'

Kramdown::Document.new(text, syntax_highlighter: :'tree-sitter').to_html
```

### Configuration

This Kramdown plugin does not currently support any configuration options.

## Contributing

This project is not currently open for contributions, but will be as soon as the initial
MVP version is released.

### Development

To set up a compatible local development environment, please first refer to the
['Requirements and Compatibility'](#requirements-and-compatibility) section of this
document.

After checking out the project, run `bundle install` from within it to install
dependencies. Then run `bundle exec rake --tasks` to list all available Rake tasks. Each
task can be invoked via `bundle exec rake <task name>`. For example,
`bundle exec rake test` runs unit tests and `bundle exec rake smoke_test` installs the
gem and runs a smoke test against it.

This project uses [GitHub Actions](https://github.com/features/actions) workflows to
facilitate continuous integration. The 'Quality Control' workflow runs any time new
commits are pushed to GitHub on any branch. This workflow runs the `rubocop`, `test`,
and `smoke_test` Rake tasks to verify that new changes meet the project's code quality
standards, so it is strongly recommended that these tasks are first run locally against
new changes before such changes are pushed.

## About

[Tree-sitter](https://tree-sitter.github.io/tree-sitter) is a modern, general-purpose
parsing library that outclasses many existing tools at the task of syntax highlighting.
This plugin adapts Tree-sitter's native highlighter for
[Kramdown](https://kramdown.gettalong.org), so that Tree-sitter's superior highlighting
capabilities can be easily leveraged in the context of rendering Markdown.

The basic functionality of this plugin was originally presented as a blog post:
*["Syntax highlight your Jekyll site with Tree-sitter!"](https://andrewtbiehl.com/blog/jekyll-tree-sitter)*.
This article explains the original use case and inspiration for the project, walks
through its implementation, and even provides some fun examples of syntax highlighting
with Tree-sitter.

## License

This project is released under the MIT License.

The text for this license can be found in [the project's LICENSE.txt file](LICENSE.txt).
