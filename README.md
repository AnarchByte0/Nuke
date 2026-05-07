# Nuke 🚀

A modern, cross-platform desktop application built with **Rust**, **Nuxt 3**, and **Wry**.

![Nuke Banner](https://via.placeholder.com/800x200?text=Nuke+Desktop+Application)

## ✨ Features

- **Blazing Fast Backend:** Powered by Rust and the Wry/Tao webview stack.
- **Modern Frontend:** Nuxt 3 (Vue 3) with SPA static generation.
- **Embedded UI:** The entire frontend is compiled into a single binary.
- **Self-Updating:** Built-in update mechanism via `axoupdater` and GitHub Releases.
- **Professional Packaging:** Supports MSI, EXE (NSIS), and modern MSIX installers.

## 🛠 Tech Stack

- **Backend:** [Rust](https://www.rust-lang.org/)
- **Frontend:** [Nuxt 3](https://nuxt.com/)
- **Webview:** [Wry](https://github.com/tauri-apps/wry)
- **Packaging:** [cargo-dist](https://opensource.axodotdev.com/cargo-dist/) & MSIX

## 🚀 Getting Started

### Prerequisites

- [Rust](https://rustup.rs/) (latest stable)
- [Node.js](https://nodejs.org/) (v18+)
- [Windows SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/) (for MSIX signing)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AnarchByte/Nuke.git
   cd Nuke
   ```

2. **Run in Development Mode:**
   ```bash
   cargo run
   ```
   *This will automatically install UI dependencies and generate the frontend.*

3. **Build Release Binary:**
   ```bash
   cargo build --release
   ```

## 📦 Packaging & Installers

### Modern MSIX (Recommended)
To build a signed MSIX package locally:
```powershell
.\Build-MSIX.ps1
```
*Note: You may need to install the `NukeDev.pfx` certificate to Trusted Root Authorities for local testing.*

### Traditional Installers (MSI/EXE)
Using `cargo-dist`:
```bash
cargo dist build
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Built with ❤️ by [AnarchByte](https://github.com/AnarchByte)
