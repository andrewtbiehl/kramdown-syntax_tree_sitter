#[macro_use]
extern crate rutie;

use rutie::{Class, Object, RString};

// Escapes HTML text content.
//
// Not intended for use on other HTML content, such as attribute content.
fn escape_text_html(text: &str) -> String {
    let mut escaped_text = String::new();
    for c in text.chars() {
        match c {
            '&' => escaped_text.push_str("&amp;"),
            '<' => escaped_text.push_str("&lt;"),
            '>' => escaped_text.push_str("&gt;"),
            _ => escaped_text.push(c),
        }
    }
    escaped_text
}

fn highlight(code: &str) -> String {
    escape_text_html(code)
}

class!(TreeSitterAdapter);

methods!(
    TreeSitterAdapter,
    _rtself,
    fn pub_highlight(raw_code: RString) -> RString {
        RString::new_utf8(&highlight(&raw_code.unwrap().to_string()))
    }
);

#[no_mangle]
pub extern "C" fn Init_tree_sitter_adapter() {
    Class::new("TreeSitterAdapter", None).define(|class_| {
        class_.def_self("highlight", pub_highlight);
    });
}
