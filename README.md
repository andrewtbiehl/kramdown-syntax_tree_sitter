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
- **Rust**: 1.61, 1.62, 1.63, 1.64, 1.65
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

For the following example to function, the
[Tree-sitter Python parser library](https://github.com/tree-sitter/tree-sitter-python)
must be present inside a directory called `tree_sitter_parsers`, which in turn must be
located in the home directory. See the subsequent
['Tree-sitter parsers'](#tree-sitter-parsers) section for more information.

```ruby
require 'kramdown'
require 'kramdown/syntax_tree_sitter'

text = <<~MARKDOWN
  ~~~source.python
  print('Hello, World!')
  ~~~
MARKDOWN

Kramdown::Document.new(text, syntax_highlighter: :'tree-sitter').to_html
```

### Tree-sitter parsers

Tree-sitter relies on external parser libraries to understand each language grammar.
Thus, in order to syntax highlight a given language using this plugin, that language's
Tree-sitter parser library must be installed to the correct directory on your machine.
This directory is set as `~/tree_sitter_parsers` by default but is also configurable
(see the ['Configuration'](#configuration) section for details).

For most such parser libraries, installation simply amounts to downloading the
repository into the configured Tree-sitter parsers directory.

A partial list of languages for which Tree-sitter parser libraries have been developed
can be found on
[the official Tree-sitter website](https://tree-sitter.github.io/tree-sitter/#available-parsers).

### Language identifiers

Tree-sitter uses a string-based identifier called a 'scope' to identify each language.
For example, the scope string for Python is 'source.python', whereas for HTML it is
'text.html.basic'. Currently, this plugin follows this same convention, so a given code
block will only be correctly highlighted if the language identifier provided for that
code block is its language's corresponding Tree-sitter scope string. This is illustrated
by the code block used in the [Quickstart](#quickstart) example.

### Configuration

This Kramdown plugin currently supports the following options when provided as sub-keys
of the Kramdown option `syntax_highlighter_opts`:

| Key | Description | Default value |
| :-- | :-- | :-- |
| `tree_sitter_parsers_dir` | The path to the Tree-sitter language parsers directory. | `~/tree_sitter_parsers` |

## Contributing

This project is not currently open for contributions, but will be as soon as the initial
MVP version is released.

### Development

To set up a compatible local development environment, please first refer to the
['Requirements and Compatibility'](#requirements-and-compatibility) section of this
document.

This project also depends on Git submodules to run some of its tests. Accordingly, make
sure to initialize recursive submodules when cloning the project for development
purposes, for example with the following command:

```shell
git clone --recurse-submodules https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter.git
```

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

### Disclaimer

Neither this plugin nor its author are affiliated with Tree-sitter or Kramdown in any
way. For any information particular to
[Tree-sitter](https://tree-sitter.github.io/tree-sitter) or
[Kramdown](https://kramdown.gettalong.org), please refer to their respective
documentation directly.

## License

This project is released under the MIT License.

The text for this license can be found in [the project's LICENSE.txt file](LICENSE.txt).
