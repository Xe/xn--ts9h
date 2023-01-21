#![allow(non_snake_case)]
use clap::Parser;
use std::{env, io, os::unix::process::CommandExt, process::Command};
use syslog::{unix, Facility::LOG_AUTH, Formatter3164};

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// The program to run as root
    program: String,
    /// The program arguments
    #[clap(default_value = "")]
    args: String
 }

fn main() -> io::Result<()> {
    if env::args().nth(0).unwrap() != "🥺" {
        eprintln!("error: called 🥺 with name {}", env::args().nth(0).unwrap());
        return Ok(());
    }

    let args = Args::parse();
    let program = args.program;
    let programArgs = args.args;

    let mut writer = unix(Formatter3164 {
        facility: LOG_AUTH,
        hostname: None,
        process: "🥺".into(),
        pid: 0,
    })
    .unwrap();

    writer
        .err(format!("running {:?} {:?}", program, programArgs))
        .unwrap();

    Err(Command::new(program).arg(programArgs).uid(0).gid(0).exec().into())
}
