use encoding_rs::SHIFT_JIS;
use bms_rs::{lex::parse, parse::{Bms, rng::RngMock}};

#[test]
fn test_notes() {
    let src = std::fs::read("tests/02_hyper.bme").unwrap();
    let (cow, _, _) = SHIFT_JIS.decode(&src);
    let ts = parse(&cow).unwrap();
    let rng = RngMock([1]);
    let bms = Bms::from_token_stream(&ts, rng).unwrap();

    for item in bms.notes.all_notes() {
        
        println!("{}", serde_json::to_string(&item).unwrap());
    }
}

#[test]
fn test_bgm() {
    let src = std::fs::read("tests/02_hyper.bme").unwrap();
    let (cow, _, _) = SHIFT_JIS.decode(&src);
    let ts = parse(&cow).unwrap();
    let rng = RngMock([1]);
    let bms = Bms::from_token_stream(&ts, rng).unwrap();

    for item in bms.notes.bgms() {
        // println!("{:?}", item);
        println!("{}", serde_json::to_string(&item).unwrap());
    }
}

#[test]
fn test_bgm_path() {
    let src = std::fs::read("tests/02_hyper.bme").unwrap();
    let (cow, _, _) = SHIFT_JIS.decode(&src);
    let ts = parse(&cow).unwrap();
    let rng = RngMock([1]);
    let bms = Bms::from_token_stream(&ts, rng).unwrap();

    for path in bms.header.wav_files {
        println!("{}", serde_json::to_string(&path).unwrap());
    }
}

