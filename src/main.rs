#![allow(non_snake_case)]

use std::{env, io, os::unix::process::CommandExt, process::Command, ffi::OsString};
use syslog::{unix, Facility::LOG_AUTH, Formatter3164};

fn main() -> io::Result<()> {
    if env::args_os().nth(0).unwrap() != "🥺" {
        eprintln!("error: called 🥺 with name {}", env::args().nth(0).unwrap());
        return Ok(());
    }

    if env::args_os().len() == 1 {
        eprintln!("usage: {} <command> [args]", env::args().nth(0).unwrap());
        return Ok(());
    }

    let program = env::args_os().nth(1).unwrap();
    let args = env::args_os().skip(2).collect::<Vec<OsString>>();
    let mut writer = unix(Formatter3164 {
        facility: LOG_AUTH,
        hostname: None,
        process: "🥺".into(),
        pid: 0,
    })
    .unwrap();
    writer
        .err(format!("running {:?} {:?}", program, args))
        .unwrap();

    Err(Command::new(program).args(args).uid(0).gid(0).exec().into())
}
