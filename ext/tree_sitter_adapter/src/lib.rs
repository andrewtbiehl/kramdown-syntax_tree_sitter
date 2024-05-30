use magnus::{exception, function, Error, Ruby};

mod tree_sitter_adapter;

fn pub_highlight(
    code: String,
    parsers_dir: String,
    scope: String,
    css_classes: bool,
) -> Result<String, Error> {
    tree_sitter_adapter::highlight(&code, &parsers_dir, &scope, css_classes)
        .map_err(|message| Error::new(exception::runtime_error(), message))
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    ruby.define_module("TreeSitterAdapter")?
        .define_module_function("highlight", function!(pub_highlight, 4))
}
