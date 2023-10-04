use bms_rs::{
    lex::parse,
    parse::{header::Header, Bms},
    parse::{notes::Notes, rng::RngMock},
};
use encoding_rs::SHIFT_JIS;
use godot::{
    builtin::{self, *},
    engine::Node,
    prelude::*,
};
use serde_json;

struct ParserExtension;

#[gdextension]
unsafe impl ExtensionLibrary for ParserExtension {}

#[derive(GodotClass)]
#[class(base=Node)]
struct BMSParser {
    #[base]
    parser: Base<Node>,

    bms: Option<Bms>
}

#[godot_api]
impl NodeVirtual for BMSParser {
    fn init(node: Base<Node>) -> Self {
        Self {
            parser: node,
            bms: None
        }
    }
}

#[godot_api]
impl BMSParser {
    #[func]
    fn parse_bms(&mut self, path: GodotString) {
        let src = std::fs::read(path.to_string()).expect("Must be parse");
        let (cow, _, _) = SHIFT_JIS.decode(&src);
        let token_stream = parse(&cow).expect("must be parse");
        let rng = RngMock([1]);
        let bms = Bms::from_token_stream(&token_stream, rng).unwrap();
        self.bms = Some(bms);
    }

    #[func]
    fn parse_notes(&mut self) -> godot::builtin::Array<GodotString> {
        let mut godot_bms = builtin::Array::new();
        let bms = self.bms.take().unwrap();
        for item in bms.notes.all_notes() {
            godot_bms.push(GodotString::from(serde_json::to_string(item).unwrap()));
        }
        godot_print!("Parse success");
        return godot_bms;
    }
}
