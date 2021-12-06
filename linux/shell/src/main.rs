use std::io::{Read, Write};

fn main() -> std::io::Result<()> {
    let stdin = std::io::stdin();
    let stdout = std::io::stdout();
    let stderr = std::io::stderr();
    let mut put_err: std::io::StderrLock = stderr.lock();
    let mut std_in: std::io::StdinLock = stdin.lock();
    let mut std_out: std::io::StdoutLock = stdout.lock();
    let result = std_in.bytes();
    print!("{:#?}", result);
    std_out.write(format!("{}", result.count()).as_bytes())?;
    put_err.write(b"error")?;
    put_err.flush()?;
    Ok(())
}
