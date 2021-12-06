use std::{fs::File, io::Result, thread::Thread};

fn main() -> Result<()> {
    let file = File::open("watch.txt")?;
    let metadata = file.metadata()?;
    let modified = metadata.modified()?;
    println!("{:?}", modified);
    Ok(())
}
