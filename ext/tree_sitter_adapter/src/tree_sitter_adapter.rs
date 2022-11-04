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

pub fn highlight(code: &str, _parsers_dir: &str) -> Result<String, String> {
    Ok(escape_text_html(code))
}
