# Kramdown Tree-sitter Highlighter

[![Build status](https://img.shields.io/github/actions/workflow/status/andrewtbiehl/kramdown-syntax_tree_sitter/quality-control.yml?branch=main&style=flat-square&logo=github)](https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/actions/workflows/quality-control.yml)
[![RubyGems page](https://img.shields.io/gem/v/kramdown-syntax_tree_sitter?style=flat-square&color=blue&logo=rubygems&logoColor=white)](https://rubygems.org/gems/kramdown-syntax_tree_sitter)

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

- **Ruby**: 2.7, 3.0, 3.1, 3.2
- **Rust**: 1.67, 1.68, 1.69, 1.70, 1.71
- **Platforms**: MacOS, Linux

### Installation

For projects using [Bundler](https://bundler.io) for dependency management, run the
following command to both install the gem and add it to the Gemfile:

```shell
bundle add kramdown-syntax_tree_sitter
```

Otherwise, install the gem via the following command:

```shell
gem install kramdown-syntax_tree_sitter
```

## Usage

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
  ~~~python
  print('Hello, World!')
  ~~~
MARKDOWN

Kramdown::Document.new(text, syntax_highlighter: :'tree-sitter').to_html
```

### General usage

To successfully highlight input text via Kramdown with this plugin enabled, make sure
that every language referenced has a corresponding Tree-sitter parser library installed.
See the subsequent ['Language identifiers'](#language-identifiers) and
['Tree-sitter parsers'](#tree-sitter-parsers) sections for more information.

### Usage with Jekyll

This plugin can be used with the popular static site generator
[Jekyll](https://jekyllrb.com). Jekyll projects using Kramdown for Markdown rendering
(the default setting for Jekyll), can enable this plugin by installing the gem (most
likely via Bundler, as described in the ['Installation'](#installation) section) and
then adding the following lines to the Jekyll project's configuration file
(`_config.yml`):

```yaml
plugins:
  - kramdown/syntax_tree_sitter
  # Other Jekyll plugins...
kramdown:
  syntax_highlighter: tree-sitter
  # Other Kramdown options...
```

Note that this plugin's general usage prerequisites (described in the previous
['General usage'](#general-usage) section) still apply when using this plugin with
Jekyll.

Also, there are multiple ways to render highlighted code blocks with Jekyll, as
illustrated in the following table:

<table>
<tr>
<th>Method name</th>
<th>Example</th>
<th>Supported by this plugin</th>
</tr>
<tr>
<td>Fenced code block</td>
<td>

---
````
```python
print('Hello, World!')
```

or

~~~python
print('Hello, World!')
~~~
````
---

</td>
<td>:white_check_mark:</td>
</tr>
<tr>
<td>Indented code block</td>
<td>

---
```
    print('Hello, World!')
{: class="language-python" }
```
---

</td>
<td>:white_check_mark:</td>
</tr>
<tr>
<td>Liquid highlight tag</td>
<td>

---
```
{% highlight python %}
print('Hello, World!')
{% endhighlight %}
```
---

</td>
<td>:x:</td>
</tr>
</table>

Since Jekyll does not defer to Kramdown to render Liquid highlight tags, this plugin
does not support highlighting code using that method. Therefore, ***code blocks must be
represented in either fenced or indented notation*** in order to be rendered via this
plugin.

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

For most popular languages, this plugin recognizes the same language identifiers as used
by the popular highlighter [Rouge](https://github.com/rouge-ruby/rouge). For example,
both 'python' and 'py' may be used to identify a code block written in Python. For the
complete list of Rouge language identifiers recognized by this plugin, see
[`lib/kramdown/syntax_tree_sitter/languages.rb`](https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/blob/main/lib/kramdown/syntax_tree_sitter/languages.rb).

This plugin also automatically supports the language identifier format used by
Tree-sitter, known as as the 'scope' name. For example, the scope name for Python is
'source.python', whereas for HTML it is 'text.html.basic'.

For any identifiers currently supported by Rouge but not by this plugin, feel free to
open an issue or pull request on GitHub to have them included.

### CSS styling

Code highlights can be rendered either via inline CSS styles or via CSS classes, which
are applied to each token in the parsed code.

To use CSS classes for highlighting, set the `css_classes` Kramdown syntax-highlighting
option to `true`. Otherwise, the plugin will apply highlights via inline CSS styles.

The inline CSS styles are derived from Tree-sitter's built-in default highlighting
theme, repeated here for convenience:

| Token name | CSS style |
| :-- | :-- |
| attribute | `color: #af0000; font-style: italic;` |
| comment | `color: #8a8a8a; font-style: italic;` |
| constant | `color: #875f00;` |
| function | `color: o#005fd7;` |
| function.builtin | `color: #005fd7; font-weight: bold;` |
| keyword | `color: #5f00d7;` |
| operator | `color: #4e4e4e; font-weight: bold;` |
| property | `color: #af0000;` |
| string | `color: #008700;` |
| string.special | `color: #008787;` |
| tag | `color: #000087;` |
| type | `color: #005f5f;` |
| type.builtin | `color: #005f5f; font-weight: bold;` |
| variable.builtin | `font-weight: bold;` |
| variable.parameter | `text-decoration: underline;` |
| constant.builtin, number | `color: #875f00; font-weight: bold;` |
| constructor, module | `color: #af8700;` |
| punctuation.bracket, punctuation.delimiter | `color: #4e4e4e;` |

Any and all token types not represented in this default theme are consequently not
highlighted when using the inline CSS styles option.

The CSS class names are derived directly from Tree-sitter token names by replacing all
full stops ('.') with dashes ('-') and adding the prefix 'ts-'. For example, the CSS
class for 'function.builtin' tokens is 'ts-function-builtin'. The use of CSS classes
allows for customization of highlighting styles, including the ability to highlight more
token types than with the default inline CSS method. Of course, this also requires that
an externally created CSS stylesheet defining the style for each token type is provided
whenever the Kramdown-generated HTML is rendered.

### Configuration

This Kramdown plugin currently supports the following options when provided as sub-keys
of the Kramdown option `syntax_highlighter_opts`:

| Key | Description | Type | Default value |
| :-- | :-- | :-- | :-- |
| `tree_sitter_parsers_dir` | The path to the Tree-sitter language parsers directory. | String | `~/tree_sitter_parsers` |
| `css_classes` | Whether to use CSS classes for highlights. | Boolean | `false` |

## Contributing

Contributions are welcome!

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

The 'Unreleased' section of the changelog should also be updated accordingly whenever
significant changes are introduced.

#### Release process

1. Determine the new version number based on the changes being introduced. This project
   follows the [Semantic Versioning](https://semver.org/spec/v2.0.0.html) versioning
   standard.

1. Make a commit to the trunk branch with the following changes:

   - Update the project's version number (located in
     [`lib/kramdown/syntax_tree_sitter/version.rb`](https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/blob/main/lib/kramdown/syntax_tree_sitter/version.rb)).

   - Update the project's changelog
     ([`CHANGELOG.md`](https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/blob/main/CHANGELOG.md))
     with documentation for the new
     version by modifying the current 'Unreleased' section accordingly.

   - Add a copy of the following release template to the top of the changelog and update
     the 'Unreleased' section link to restart the process for the next release.

     ```markdown
     ## [Unreleased]

     ### Added
     <!-- For new features -->

     ### Changed
     <!-- For changes in existing functionality -->

     ### Deprecated
     <!-- For soon-to-be removed features -->

     ### Removed
     <!-- For now removed features -->

     ### Fixed
     <!-- For any bug fixes -->

     ### Security
     <!-- In case of vulnerabilities -->
     ```

1. [Draft and publish a new GitHub release](https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/releases/new)
   with a new trunk branch tag and title corresponding to the new version number and a
   description copied over from the changelog. This will trigger the 'Gem Publication'
   GitHub Actions workflow, which will push the new version to
   [RubyGems.org](https://rubygems.org).

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
