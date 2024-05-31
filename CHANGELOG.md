# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
<!-- For new features -->

- Added testing support for Ruby version 3.3.
- Added testing support for Rust version 1.75, 1.76, 1.77, and 1.78.
- Added testing support for MacOS version 13 (Ventura).

### Changed
<!-- For changes in existing functionality -->

- Updated the Tree-sitter scope for HTML that the Rouge identifier for HTML maps to.
- Replaced the Rust dependency [Rutie](https://github.com/danielpclark/rutie), used for
  establishing Ruby bindings for Rust, with
  [Magnus](https://github.com/matsadler/magnus). No known behavior changes were
  introduced as part of this implementation change.
- Bumped the Rust dependency '[Anyhow](https://crates.io/crates/anyhow)' from version
  1.0.71 to 1.0.86.
- Bumped the Rust dependency '[Tree-sitter](https://crates.io/crates/tree-sitter)' from
  version 0.20.10 to 0.22.6.
- Bumped the Rust dependency
  '[Tree-sitter CLI](https://crates.io/crates/tree-sitter-cli)' from version 0.20.8 to
  0.22.6.
- Bumped the Rust dependency
  '[Tree-sitter Highlight](https://crates.io/crates/tree-sitter-highlight)' from version
  0.20.1 to 0.22.6.
- Bumped the Rust dependency
  '[Tree-sitter Loader](https://crates.io/crates/tree-sitter-loader)' from version
  0.20.0 to 0.22.6.

### Deprecated
<!-- For soon-to-be removed features -->

### Removed
<!-- For now removed features -->

- Removed testing support for Rust version 1.66, 1.67, 1.68, and 1.69.
- Removed testing support for MacOS version 11 (Big Sur).

### Fixed
<!-- For any bug fixes -->

### Security
<!-- In case of vulnerabilities -->

## [0.5.0] - 2023-05-18

### Added

- Added testing support for Rust version 1.69.

### Changed

- Moved all development dependency declarations from the gem specification file to the
  Gemfile.

### Removed

- Removed testing support for Rust version 1.65.

### Fixed

- Fixed a bug in which the tool failed to highlight languages embedded in other
  languages.

## [0.4.0] - 2023-04-15

### Added

- Added testing support for Rust version 1.67 and 1.68.

### Changed

- Refactored the project's test suite. No behavior changes were introduced as part of
  this refactor.
- Bumped the Rust dependency '[Anyhow](https://crates.io/crates/anyhow)' from version
  1.0.68 to 1.0.70.
- Updated all test suite dependency version declarations to be fixed at the 'patch'
  level.
- Bumped the Rust dependency '[Tree-sitter](https://crates.io/crates/tree-sitter)' from
  version 0.20.9 to 0.20.10.
- Bumped the Rust dependency
  '[Tree-sitter CLI](https://crates.io/crates/tree-sitter-cli)' from version 0.20.7 to
  0.20.8.

### Removed

- Removed support for Rust version 1.62, 1.63, and 1.64.

### Fixed

- Updated a test to work with the test suite dependencies.

## [0.3.0] - 2023-01-11

### Added

- Added testing support for Rust version 1.66.
- Added testing support for Ruby version 3.2.
- Added support for Rouge language identifiers.

### Changed

- Bumped the Rust dependency '[Anyhow](https://crates.io/crates/anyhow)' from version
  1.0.66 to 1.0.68.

### Removed

- Removed testing support for Rust version 1.61.

## [0.2.0] - 2022-12-07

### Added

- Added the option to highlight code via CSS classes instead of via inline CSS.

### Changed

- Improved the error message for missing highlight configuration errors.
- Significantly refactored the internal Rust implementation. No known behavior changes
  were introduced as part of this refactor.

## [0.1.0] - 2022-11-11

### Added

- This is a syntax highlighter plugin for Kramdown that leverages Tree-sitter's native
  syntax highlighter to highlight code blocks (and spans) when rendering HTML.

[unreleased]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/releases/tag/v0.1.0
