use nix::unistd::fork;
use nix::unistd::ForkResult::Child;
use std::process::Command;
pub struct Wc;
impl Wc {
    pub fn wc() {
        for x in std::env::args().skip(1) {
            let pid = unsafe { fork().unwrap() };
            if let Child = pid {
                let output = &Command::new("/bin/wc")
                    .arg("-c")
                    .arg(x)
                    .output()
                    .unwrap()
                    .stdout;
                println!("result : {}", std::str::from_utf8(output).unwrap());
                return;
            }
        }
    }
}
