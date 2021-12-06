pub struct Zombie;
use nix::unistd::sleep;
use nix::unistd::ForkResult::{Child, Parent};
use nix::unistd::{fork, getpid};
impl Zombie {
    pub fn createZompieProcess() {
        let pid = unsafe { fork().unwrap() };
        match pid {
            Parent { child } => {
                println!("i am goona produce a zombie process!");
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
                println!("i am zombie process pid : {}", getpid());
            }
        }
    }
}
