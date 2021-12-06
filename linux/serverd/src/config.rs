pub mod config {
    pub enum IpAddress {
        V4(u8, u8, u8, u16),
        V6(String, u16),
    }
    pub struct Config {
        ip_address: IpAddress,
    }
}
