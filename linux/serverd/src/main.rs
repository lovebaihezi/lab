use actix_web::{post, App, HttpServer, Responder};
use serde_json::json;

mod tools;

#[post("/os/cpu_info")]
async fn os_cpu_info() -> impl Responder {
    ""
}

#[get("/")]
async fn index() -> impl Responder {
    
}

// use MVC model to build
// use easiest to run it at first
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(move || App::new().service(os_cpu_info))
        .bind(("0.0.0.0", 80))?
        .run()
        .await
}
