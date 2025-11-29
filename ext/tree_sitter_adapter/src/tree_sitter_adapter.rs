use anyhow::{Context, Result};
use std::collections::HashMap;
use std::convert;
use std::path::PathBuf;
use tree_sitter::Language;
use tree_sitter_cli::highlight::Style;
use tree_sitter_cli::highlight::Theme;
use tree_sitter_highlight::{Error as TSError, HighlightEvent};
use tree_sitter_highlight::{Highlight, HighlightConfiguration, Highlighter, HtmlRenderer};
use tree_sitter_loader::{Config, LanguageConfiguration, Loader};

use std::collections::HashSet;

const LOADER_ERROR_MSG: &str = "Error loading Tree-sitter parsers from directory";
const NO_LANGUAGE_ERROR_MSG: &str = "Error retrieving language configuration for scope";
const NO_HIGHLIGHT_ERROR_MSG: &str = "Error retrieving highlight configuration for scope";

trait ResultExt<T, E> {
    fn flatten_(self) -> Result<T, E>;
}

impl<T, E> ResultExt<T, E> for Result<Result<T, E>, E> {
    fn flatten_(self) -> Result<T, E> {
        self.and_then(convert::identity)
    }
}

fn loader(parser_directory: PathBuf) -> Result<Loader> {
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
            let parser_directory_str = parser_directory.display();
            format!("{LOADER_ERROR_MSG} '{parser_directory_str}'")
        })
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

fn highlight_configuration<'a>(
    language: Language,
    config: &'a LanguageConfiguration<'a>,
    scope: &'a str,
) -> Result<&'a HighlightConfiguration> {
    config
        .highlight_config(language, None)
        .transpose()
        .with_context(|| format!("{NO_HIGHLIGHT_ERROR_MSG} '{scope}'"))
        .flatten_()
}

fn highlights(
    code: &str,
    config: &HighlightConfiguration,
    loader: &Loader,
) -> Result<impl Iterator<Item = Result<HighlightEvent, TSError>>> {
    Highlighter::new()
        .highlight(config, code.as_bytes(), None, |s| {
            loader.highlight_config_for_injection_string(s)
        })
        .map(Iterator::collect)
        .map(Vec::into_iter)
        .map_err(Into::into)
}

fn create_html_attribute_callback<'a>(
    html_attributes: &'a [String],
) -> impl Fn(Highlight, &mut Vec<u8>) + use<'a> {
    |highlight, html| {
        html.extend(
            html_attributes
                .get(highlight.0)
                .map(String::as_str)
                .unwrap_or_default()
                .as_bytes(),
        )
    }
}

fn render_html(
    code: &str,
    highlights: impl Iterator<Item = Result<HighlightEvent, TSError>>,
    html_attributes: &[String],
) -> Result<String> {
    let html_attribute_callback = create_html_attribute_callback(html_attributes);
    let mut renderer = HtmlRenderer::new();
    renderer.render(highlights, code.as_bytes(), &html_attribute_callback)?;
    // Remove erroneously appended newline
    if renderer.html.ends_with(&[b'\n']) && !code.ends_with('\n') {
        renderer.html.pop();
    }
    Ok(renderer.lines().collect())
}

fn highlight_names_for_language(scope: &str, loader: &Loader) -> Result<Vec<String>> {
    let (language, config) = language_and_configuration(loader, scope)?;
    let highlight_config = highlight_configuration(language, config, scope)?;
    Ok(highlight_config
        .names()
        .iter()
        .map(ToString::to_string)
        .collect())
}

fn highlight_names(parser_directory: PathBuf) -> Result<Vec<String>> {
    let loader = loader(parser_directory)?;
    let highlight_names = loader
        .get_all_language_configurations()
        .into_iter()
        .flat_map(|(config, _)| config.scope.clone())
        .flat_map(|scope| highlight_names_for_language(&scope, &loader))
        .flat_map(Vec::into_iter)
        .collect::<HashSet<_>>();
    Ok(highlight_names.into_iter().collect())
}

fn highlight_name_styles() -> HashMap<String, Style> {
    let theme = Theme::default();
    theme
        .highlight_names
        .into_iter()
        .zip(theme.styles)
        .collect()
}

fn inline_css_attributes(highlight_names: &[String]) -> Vec<String> {
    let highlight_name_styles = highlight_name_styles();
    highlight_names
        .iter()
        .map(|n| highlight_name_styles.get(n))
        .map(|o| o.and_then(|style| style.css.as_ref()))
        .map(|o| o.map(|s| "style='".to_string() + s + "'"))
        .map(Option::unwrap_or_default)
        .collect()
}

fn css_class_attributes(highlight_names: &[String]) -> Vec<String> {
    highlight_names
        .iter()
        .map(|s| s.replace('.', "-"))
        .map(|s| format!("class='ts-{s}'"))
        .collect()
}

fn highlight_adapter(
    code: &str,
    parsers_dir: &str,
    scope: &str,
    css_classes: bool,
) -> Result<String> {
    let parsers_dir = PathBuf::from(parsers_dir);
    let mut loader = loader(parsers_dir.clone())?;
    let highlight_names = highlight_names(parsers_dir)?;
    loader.configure_highlights(&highlight_names);
    let (language, config) = language_and_configuration(&loader, scope)?;
    let highlight_config = highlight_configuration(language, config, scope)?;
    let highlights = highlights(code, highlight_config, &loader)?;
    let html_attributes = match css_classes {
        true => css_class_attributes,
        false => inline_css_attributes,
    }(&highlight_names);
    render_html(code, highlights, &html_attributes)
}

pub fn highlight(
    code: &str,
    parsers_dir: &str,
    scope: &str,
    css_classes: bool,
) -> Result<String, String> {
    highlight_adapter(code, parsers_dir, scope, css_classes).map_err(|e| format!("{e:#}"))
}
