use libc::_exit;
use libc::atexit;
use libc::exit;
pub struct Exit;

impl Exit {
    extern "C" fn on_exit() {
        println!("on exit, i am called!");
    }
    pub fn my_exit() {
        println!("i am gonna exit!");
        print!("yes!");
        unsafe { atexit(Self::on_exit) };
        unsafe { exit(0) };
    }
    pub fn my__exit() {
        println!("i am gonna _exit!");
        print!("yes!");
        unsafe { atexit(Self::on_exit) };
        unsafe { _exit(0) };
    }
}
