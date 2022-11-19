use anyhow::{Context, Error, Result};
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
    let parsers_dir = PathBuf::from(parsers_dir);
    let theme = Theme::default();
    let mut loader = Loader::new_from_dir(parsers_dir).map_err(Error::to_formatted_string)?;
    loader.configure_highlights(&theme.highlight_names);
    loader
        .language_configuration_from_scope(scope)
        .and_then(LanguageConfigurationAdapter::highlight_config)
        .and_then(|config| {
            let default_css_style = String::new();
            let css_attribute_callback = get_css_styles(&theme, &default_css_style);
            HighlighterAdapter::new(&loader, config)
                .highlight(code)
                .and_then(|highlights| render_html(highlights, &css_attribute_callback))
        })
        .map_err(Error::to_formatted_string)
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
            .map(|(language, config)| LanguageConfigurationAdapter {
                scope,
                language,
                config,
            })
            .with_context(|| format!("{NO_LANGUAGE_ERROR_MSG} '{scope}'"))
    }
}

struct LanguageConfigurationAdapter<'a> {
    scope: &'a str,
    language: Language,
    config: &'a LanguageConfiguration<'a>,
}

impl<'a> LanguageConfigurationAdapter<'a> {
    fn highlight_config(self) -> Result<&'a HighlightConfiguration> {
        self.config
            .highlight_config(self.language)
            .transpose()
            .with_context(|| format!("{NO_HIGHLIGHT_ERROR_MSG} '{}'", self.scope))
            .flatten_()
    }
}

struct HighlightsAdapter<'a, T: Iterator<Item = Result<HighlightEvent, TSError>>> {
    code: &'a str,
    highlights: T,
}

struct HighlighterAdapter<'a> {
    loader: &'a Loader,
    config: &'a HighlightConfiguration,
    highlighter: Highlighter,
}

impl<'a> HighlighterAdapter<'a> {
    fn new(loader: &'a Loader, config: &'a HighlightConfiguration) -> Self {
        Self {
            loader,
            config,
            highlighter: Highlighter::new(),
        }
    }

    fn highlight(
        &'a mut self,
        code: &'a str,
    ) -> Result<HighlightsAdapter<'a, impl Iterator<Item = Result<HighlightEvent, TSError>> + 'a>>
    {
        let Self {
            loader,
            config,
            highlighter,
        } = self;
        highlighter
            .highlight(config, code.as_bytes(), None, |s| {
                loader.highlight_config_for_injection_string(s)
            })
            .map(|highlights| HighlightsAdapter { code, highlights })
            .map_err(Into::into)
    }
}

fn render_html<'a, F: Fn(Highlight) -> &'a [u8]>(
    highlights: HighlightsAdapter<'a, impl Iterator<Item = Result<HighlightEvent, TSError>> + 'a>,
    css_attribute_callback: &F,
) -> Result<String> {
    let HighlightsAdapter { code, highlights } = highlights;
    let mut renderer = HtmlRenderer::new();
    renderer.render(highlights, code.as_bytes(), css_attribute_callback)?;
    // Remove erroneously appended newline
    if renderer.html.ends_with(&[b'\n']) && !code.ends_with('\n') {
        renderer.html.pop();
    }
    Ok(renderer.lines().collect())
}

fn get_css_styles<'a>(
    theme: &'a Theme,
    default_css_style: &'a String,
) -> Box<dyn Fn(Highlight) -> &'a [u8] + 'a> {
    Box::new(|highlight| {
        theme
            .styles
            .get(highlight.0)
            .and_then(|style| style.css.as_ref())
            .unwrap_or(default_css_style)
            .as_bytes()
    })
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
