use anyhow::{Context, Result};
use std::convert;
use std::path::PathBuf;
use tree_sitter::Language;
use tree_sitter_cli::highlight::Theme;
use tree_sitter_highlight::{Error as TSError, HighlightEvent};
use tree_sitter_highlight::{Highlight, HighlightConfiguration, Highlighter, HtmlRenderer};
use tree_sitter_loader::{Config, LanguageConfiguration, Loader};

const LOADER_ERROR_MSG: &str = "Error loading Tree-sitter parsers from directory";
const NO_LANGUAGE_ERROR_MSG: &str = "Error retrieving language configuration for scope";
const NO_HIGHLIGHT_ERROR_MSG: &str = "Error retrieving highlight configuration for scope";

pub fn highlight(code: &str, parsers_dir: &str, scope: &str) -> Result<String, String> {
    highlight_adapter(code, parsers_dir, scope).map_err(|e| format!("{e:#}"))
}

fn highlight_adapter(code: &str, parsers_dir: &str, scope: &str) -> Result<String> {
    let parsers_dir = PathBuf::from(parsers_dir);
    let theme = Theme::default();
    let mut loader = Loader::new_from_dir(parsers_dir)?;
    loader.configure_highlights(&theme.highlight_names);
    let (language, config) = language_and_configuration(&loader, scope)?;
    let config = highlight_config(language, config, scope)?;
    let highlights = highlights(code, &loader, config)?;
    let inline_css_styles = theme
        .styles
        .into_iter()
        .map(|s| s.css)
        .map(Option::unwrap_or_default)
        .collect::<Vec<_>>();
    render_html(highlights, code, &inline_css_styles)
}

trait LoaderExt {
    fn new_from_dir(parser_directory: PathBuf) -> Result<Loader>;
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
}

fn language_and_configuration<'a>(
    loader: &'a Loader,
    scope: &'a str,
) -> Result<(Language, &'a LanguageConfiguration<'a>)> {
    loader
        .language_configuration_for_scope(scope)
        .transpose()
        .context("Language not found")
        .flatten_()
        .with_context(|| format!("{NO_LANGUAGE_ERROR_MSG} '{scope}'"))
}

fn highlight_config<'a>(
    language: Language,
    config: &'a LanguageConfiguration<'a>,
    scope: &'a str,
) -> Result<&'a HighlightConfiguration> {
    config
        .highlight_config(language)
        .transpose()
        .with_context(|| format!("{NO_HIGHLIGHT_ERROR_MSG} '{scope}'"))
        .flatten_()
}

fn highlights(
    code: &str,
    loader: &Loader,
    config: &HighlightConfiguration,
) -> Result<impl Iterator<Item = Result<HighlightEvent, TSError>>> {
    Highlighter::new()
        .highlight(config, code.as_bytes(), None, |s| {
            loader.highlight_config_for_injection_string(s)
        })
        .map(Iterator::collect)
        .map(Vec::into_iter)
        .map_err(Into::into)
}

fn render_html(
    highlights: impl Iterator<Item = Result<HighlightEvent, TSError>>,
    code: &str,
    css_attributes: &[String],
) -> Result<String> {
    let css_attribute_callback = |h: Highlight| {
        css_attributes
            .get(h.0)
            .map(String::as_str)
            .unwrap_or_default()
            .as_bytes()
    };
    let mut renderer = HtmlRenderer::new();
    renderer.render(highlights, code.as_bytes(), &css_attribute_callback)?;
    // Remove erroneously appended newline
    if renderer.html.ends_with(&[b'\n']) && !code.ends_with('\n') {
        renderer.html.pop();
    }
    Ok(renderer.lines().collect())
}

trait ResultExt<T, E> {
    fn flatten_(self) -> Result<T, E>;
}

impl<T, E> ResultExt<T, E> for Result<Result<T, E>, E> {
    fn flatten_(self) -> Result<T, E> {
        self.and_then(convert::identity)
    }
}
