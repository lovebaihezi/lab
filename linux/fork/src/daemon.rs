use std::{fmt::Debug, io::Write};

use libc::chdir;
use libc::exit;
use libc::setsid;
use libc::signal;
use libc::umask;
use nix::unistd::ForkResult::{Child, Parent};
use nix::unistd::{fork, getpid};
use nix::{sys::wait::wait, unistd::sleep};
pub struct Daemon;

impl Daemon {
    pub fn daemon() {
        let pid = unsafe { fork().unwrap() };
        
        match pid {
            Parent { child } => {
                unsafe { exit(0) };
            }
            Child => {
                let id = unsafe { setsid() };
                assert!(id >= 0);
                println!("setsid : {}", id);
                loop {
                    let mut file = &std::fs::File::create("/home/lqxc/myrandom.sys").unwrap();
                        file
                        .write(
                            std::format!(
                                "{} {} {:?}\n",
                                unsafe { libc::rand() }.to_string(),
                                getpid(),
                                std::time::SystemTime::now()
                            )
                            .as_bytes(),
                        )
                        .unwrap();
                    file.sync_data().unwrap();
                    unsafe { libc::sleep(10) };
                }
            }
        };
    }
}
