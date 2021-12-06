use nix::unistd::ForkResult::{Child, Parent};
use nix::unistd::{fork, getpid};
use nix::{sys::wait::wait, unistd::sleep};

pub struct Fork;
impl Fork {
    pub fn question1() {
        let pid = unsafe { fork().unwrap() };
        match pid {
            Parent { child } => {
                for i in 0..5 {
                    println!(
                        "Parent Process : index : {} pid : {} child pid : {} ",
                        i,
                        getpid(),
                        child
                    )
                }
            }
            Child => {
                let _result = wait();
                for i in 0..5 {
                    println!("Child Process : index : {} pid : {:?} ", i, getpid())
                }
            }
        };
    }
    pub fn question2() {
        let pid = unsafe { fork().unwrap() };
        match pid {
            Parent { child } => {
                let _result = wait().unwrap();
                for i in 0..5 {
                    println!(
                        "Parent Process : index : {} pid : {} child pid : {} ",
                        i,
                        getpid(),
                        child
                    )
                }
            }
            Child => {
                for i in 0..5 {
                    println!("Child Process : index : {} pid : {:?} ", i, getpid())
                }
            }
        };
    }
    pub fn question3() {
        let pid = unsafe { fork().unwrap() };
        match pid {
            Parent { child } => {
                for i in 1..6 {
                    println!("Parent Process : index : {} child  pid : {} ", i, child);
                    sleep(i);
                }
            }
            Child => {
                for i in 1..6 {
                    println!("Child  Process : index : {} parent pid : {} ", i, getpid());
                    sleep(i);
                }
            }
        };
    }
}
