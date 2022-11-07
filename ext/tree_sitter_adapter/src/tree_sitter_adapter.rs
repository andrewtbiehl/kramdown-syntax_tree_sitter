use anyhow::{Context, Error, Result};
use std::convert;
use std::path::PathBuf;
use tree_sitter::Language;
use tree_sitter_loader::{Config, LanguageConfiguration, Loader};

const LOADER_ERROR_MSG: &str = "Error loading Tree-sitter parsers from directory";
const NO_LANGUAGE_ERROR_MSG: &str = "Error retrieving language configuration for scope";

// Escape a single character for HTML text.
//
// Not intended for use on other HTML content, such as attribute content.
fn html_text_escape(c: char) -> String {
    match c {
        '&' => "&amp;".to_string(),
        '<' => "&lt;".to_string(),
        '>' => "&gt;".to_string(),
        _ => c.to_string(),
    }
}

// Escapes HTML text content.
//
// Not intended for use on other HTML content, such as attribute content.
fn escape_text_html(text: &str) -> String {
    text.chars().map(html_text_escape).collect()
}

pub fn highlight(code: &str, parsers_dir: &str, scope: &str) -> Result<String, String> {
    let parsers_dir = PathBuf::from(parsers_dir);
    Loader::new_from_dir(parsers_dir)
        .map_err(Error::to_formatted_string)?
        .language_configuration_from_scope(scope)
        .err()
        .map(Error::to_formatted_string)
        .err_or_else(|| escape_text_html(code))
}

trait LoaderExt {
    fn new_from_dir(parser_directory: PathBuf) -> Result<Loader>;

    fn language_configuration_from_scope<'a>(
        &'a self,
        scope: &'a str,
    ) -> Result<LanguageConfigurationAdapter<'a>>;
}

impl LoaderExt for Loader {
    fn new_from_dir(parser_directory: PathBuf) -> Result<Loader> {
        Loader::new()
            .and_then(|mut loader| {
                let config = {
                    let parser_directory = parser_directory.clone();
                    let parser_directories = vec![parser_directory];
                    Config { parser_directories }
                };
                loader.find_all_languages(&config)?;
                Ok(loader)
            })
            .with_context(|| {
                let parser_directory_string = parser_directory.display();
                format!("{LOADER_ERROR_MSG} '{parser_directory_string}'")
            })
    }

    fn language_configuration_from_scope<'a>(
        &'a self,
        scope: &'a str,
    ) -> Result<LanguageConfigurationAdapter<'a>> {
        self.language_configuration_for_scope(scope)
            .transpose()
            .context("Language not found")
            .flatten_()
            .map(|(language, config)| LanguageConfigurationAdapter { language, config })
            .with_context(|| format!("{NO_LANGUAGE_ERROR_MSG} '{scope}'"))
    }
}

#[allow(dead_code)]
struct LanguageConfigurationAdapter<'a> {
    language: Language,
    config: &'a LanguageConfiguration<'a>,
}

trait OptionExt<E> {
    fn err_or_else<T, F: FnOnce() -> T>(self, ok: F) -> Result<T, E>;
}

impl<E> OptionExt<E> for Option<E> {
    fn err_or_else<T, F: FnOnce() -> T>(self, ok: F) -> Result<T, E> {
        match self {
            None => Ok(ok()),
            Some(e) => Err(e),
        }
    }
}

trait ResultExt<T, E> {
    fn flatten_(self) -> Result<T, E>;
}

impl<T, E> ResultExt<T, E> for Result<Result<T, E>, E> {
    fn flatten_(self) -> Result<T, E> {
        self.and_then(convert::identity)
    }
}

trait ErrorExt {
    fn to_formatted_string(self) -> String;
}

impl ErrorExt for Error {
    fn to_formatted_string(self) -> String {
        format!("{self:#}")
    }
}
