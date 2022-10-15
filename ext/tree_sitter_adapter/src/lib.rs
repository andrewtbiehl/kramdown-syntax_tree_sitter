#[macro_use]
extern crate rutie;

use rutie::{Class, Object, RString};

fn reverse(s: &str) -> String {
    s.chars().rev().collect()
}

class!(RutieExample);

methods!(
    RutieExample,
    _rtself,
    fn pub_reverse(raw_text: RString) -> RString {
        let reversed = {
            let text = raw_text.unwrap().to_string();
            reverse(&text)
        };
        RString::new_utf8(&reversed)
    }
);

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_rutie_ruby_example() {
    Class::new("RutieExample", None).define(|class_| {
        class_.def_self("reverse", pub_reverse);
    });
}
