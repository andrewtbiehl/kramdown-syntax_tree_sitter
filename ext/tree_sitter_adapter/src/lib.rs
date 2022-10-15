#[macro_use]
extern crate rutie;

use rutie::{Class, Object, RString};

fn reverse(s: &str) -> String {
    s.chars().rev().collect()
}

class!(TreeSitterAdapter);

methods!(
    TreeSitterAdapter,
    _rtself,
    fn pub_reverse(raw_text: RString) -> RString {
        RString::new_utf8(&reverse(&raw_text.unwrap().to_string()))
    }
);

#[no_mangle]
pub extern "C" fn Init_tree_sitter_adapter() {
    Class::new("TreeSitterAdapter", None).define(|class_| {
        class_.def_self("reverse", pub_reverse);
    });
}
