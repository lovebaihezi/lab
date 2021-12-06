pub struct Orphan;
use nix::unistd::sleep;
use nix::unistd::ForkResult::{Child, Parent};
use nix::unistd::{fork, getpid};
use std::process::exit;
impl Orphan {
    pub fn createOrphanProcess() {
        let pid = unsafe { fork().unwrap() };
        match pid {
            Parent { child } => {
                println!("i am goona produce a orphan process!");
                exit(1);
            }
            Child => {
                sleep(2);
                let ps_output = &std::process::Command::new("ps")
                    .arg("a")
                    .output()
                    .unwrap()
                    .stdout;
                let pstree_output = &std::process::Command::new("pstree")
                    .output()
                    .unwrap()
                    .stdout;
                println!("{}", std::str::from_utf8(ps_output).unwrap());
                println!("{}", std::str::from_utf8(pstree_output).unwrap());
                println!("i am orphan process pid : {}", getpid());
            }
        }
    }
}
