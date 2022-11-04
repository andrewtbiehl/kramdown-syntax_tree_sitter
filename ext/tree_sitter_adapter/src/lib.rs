#[macro_use]
extern crate rutie;

use rutie::{Class, Object, RString};

mod tree_sitter_adapter;

class!(TreeSitterAdapter);

methods!(
    TreeSitterAdapter,
    _rtself,
    fn pub_highlight(raw_code: RString, raw_parsers_dir: RString) -> RString {
        RString::new_utf8(&tree_sitter_adapter::highlight(
            &raw_code.unwrap().to_string(),
            &raw_parsers_dir.unwrap().to_string(),
        ))
    }
);

#[no_mangle]
pub extern "C" fn Init_tree_sitter_adapter() {
    Class::new("TreeSitterAdapter", None).define(|class_| {
        class_.def_self("highlight", pub_highlight);
    });
}
