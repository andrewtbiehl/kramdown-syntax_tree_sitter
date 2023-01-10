# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
<!-- For new features -->

- Added testing support for Rust version 1.66.
- Added testing support for Ruby version 3.2.
- Added support for Rouge language identifiers.

### Changed
<!-- For changes in existing functionality -->

- Bumped the Rust dependency '[Anyhow](https://crates.io/crates/anyhow)' from version
  1.0.66 to 1.0.68.

### Deprecated
<!-- For soon-to-be removed features -->

### Removed
<!-- For now removed features -->

- Removed testing support for Rust version 1.61.

### Fixed
<!-- For any bug fixes -->

### Security
<!-- In case of vulnerabilities -->

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

[unreleased]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/andrewtbiehl/kramdown-syntax_tree_sitter/releases/tag/v0.1.0
