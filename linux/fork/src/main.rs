mod daemon;
mod exit;
mod fork;
mod orphan;
mod wait;
mod wc;
mod zombie;
fn main() {
    wc::Wc::wc();
}
