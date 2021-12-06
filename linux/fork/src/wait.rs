use libc::exit;
use libc::signal;
use libc::umask;
use nix::unistd::ForkResult::{Child, Parent};
use nix::unistd::{fork, getpid};
use nix::{sys::wait::wait, unistd::sleep};
pub struct Wait;
impl Wait {
    pub fn wait() {
        let pid = unsafe { fork().unwrap() };
        match pid {
            Parent { child } => {
                let mut x: i32 = 0;
                let p = unsafe { libc::wait(&mut x) };
                println!("stats : {} pid : {} ", x as u32, p);
            }
            Child => {
                unsafe { libc::exit(1) };
            }
        }
    }
}
