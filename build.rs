use std::process::Command;
use std::env;
use std::path::Path;

fn main() {
    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();
    
    // Windows resources
    if target_os == "windows" {
        let mut res = winres::WindowsResource::new();
        res.set("ProductName", "Nuke");
        res.set("FileDescription", "Nuke Desktop Application");
        res.set("CompanyName", "AnarchByte");
        res.set("LegalCopyright", "Copyright (c) 2026 AnarchByte");
        if Path::new("app-icon.ico").exists() {
            res.set_icon("app-icon.ico");
        }
        res.compile().unwrap();
    }

    // Nuxt build
    let ui_dir = Path::new("ui");
    if ui_dir.exists() {
        // Ensure the default output directory exists so include_dir! doesn't fail during initial analysis
        std::fs::create_dir_all("ui/.output/public").ok();

        println!("cargo:rerun-if-changed=ui/app.vue");
        println!("cargo:rerun-if-changed=ui/nuxt.config.ts");
        println!("cargo:rerun-if-changed=ui/package.json");

        let npm_cmd = if target_os == "windows" { "npm.cmd" } else { "npm" };

        // Only run npm install if node_modules doesn't exist
        if !ui_dir.join("node_modules").exists() {
            let status = Command::new(npm_cmd)
                .args(&["install"])
                .current_dir(ui_dir)
                .status()
                .expect("Failed to run npm install");
            if !status.success() {
                panic!("npm install failed");
            }
        }

        let status = Command::new(npm_cmd)
            .args(&["run", "generate"])
            .current_dir(ui_dir)
            .status()
            .expect("Failed to run npm run generate");
        
        if !status.success() {
            panic!("npm run generate failed");
        }
    }
}
