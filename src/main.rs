use include_dir::{include_dir, Dir};
use tao::{
    event::{Event, StartCause, WindowEvent},
    event_loop::{ControlFlow, EventLoop},
    window::WindowBuilder,
};
use wry::WebViewBuilder;
use mime_guess::from_path;
use std::borrow::Cow;
use axoupdater::AxoUpdater;

static PROJECT_DIR: Dir<'_> = include_dir!("$CARGO_MANIFEST_DIR/ui/.output/public");

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 1. Updater integration (GitHub releases via cargo-dist)
    tokio::spawn(async move {
        // We use a simple check; in a real app, you might want more complex error handling
        let mut updater = AxoUpdater::new_for("Nuke");
        if updater.load_receipt().is_ok() {
            if let Ok(needed) = updater.is_update_needed().await {
                if needed {
                    println!("A new version is available!");
                }
            }
        }
    });

    // 2. Event Loop and Window setup
    let event_loop = EventLoop::new();
    let window = WindowBuilder::new()
        .with_title("Nuke")
        .build(&event_loop)?;

    // 3. Custom Protocol to serve embedded files
    let _webview = WebViewBuilder::new()
        .with_custom_protocol("nuke".into(), move |_id, request| {
            let path = request.uri().path();
            let path = if path == "/" || path.is_empty() {
                "index.html"
            } else {
                path.trim_start_matches('/')
            };

            if let Some(file) = PROJECT_DIR.get_file(path) {
                let mime = from_path(path).first_or_octet_stream().to_string();
                wry::http::Response::builder()
                    .header("Content-Type", mime)
                    .body(Cow::from(file.contents().to_vec()))
                    .unwrap()
            } else {
                wry::http::Response::builder()
                    .status(wry::http::StatusCode::NOT_FOUND)
                    .body(Cow::from(vec![]))
                    .unwrap()
            }
        })
        .with_url("nuke://localhost/")
        .build(&window)?;

    // 4. Run the event loop
    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;

        match event {
            Event::NewEvents(StartCause::Init) => println!("Nuke application started!"),
            Event::WindowEvent {
                event: WindowEvent::CloseRequested,
                ..
            } => *control_flow = ControlFlow::Exit,
            _ => (),
        }
    });
}
