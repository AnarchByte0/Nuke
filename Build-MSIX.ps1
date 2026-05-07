# Build-MSIX.ps1
# Automates Building, Packing, and Signing of the Nuke MSIX package

$APP_NAME = "Nuke"
$VERSION = "0.1.0"
$TARGET = "x86_64-pc-windows-msvc"
$MSIX_NAME = "${APP_NAME}-${VERSION}-${TARGET}.msix"

# 1. Paths to Windows SDK tools
$SDK_BIN = "C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64"
$MAKEAPPX = Join-Path $SDK_BIN "makeappx.exe"
$SIGNTOOL = Join-Path $SDK_BIN "signtool.exe"

Write-Host "--- Starting MSIX Build for $APP_NAME v$VERSION ---" -ForegroundColor Cyan

# 2. Build the Rust project first
Write-Host "[1/5] Compiling Rust project..." -ForegroundColor Gray
cargo build --release
if ($LASTEXITCODE -ne 0) { Write-Error "Cargo build failed"; exit }

# 3. Prepare Build Directory
Write-Host "[2/5] Preparing packaging directory..." -ForegroundColor Gray
$BUILD_DIR = "msix_build"
if (Test-Path $BUILD_DIR) { Remove-Item -Recurse -Force $BUILD_DIR }
New-Item -ItemType Directory -Path $BUILD_DIR | Out-Null
New-Item -ItemType Directory -Path (Join-Path $BUILD_DIR "Assets") | Out-Null

# Copy Files
copy "target\release\${APP_NAME}.exe" (Join-Path $BUILD_DIR "${APP_NAME}.exe")
copy "msix_assets\AppxManifest.xml" (Join-Path $BUILD_DIR "AppxManifest.xml")

# 4. Generate Placeholder Assets (to avoid validation errors)
Write-Host "[3/5] Generating placeholder assets..." -ForegroundColor Gray
# This is a trick to create empty/minimal valid files if real ones are missing
$Assets = @("StoreLogo.png", "Square150x150Logo.png", "Square44x44Logo.png", "Wide310x150Logo.png", "SplashScreen.png")
foreach ($Asset in $Assets) {
    $Path = Join-Path $BUILD_DIR "Assets\$Asset"
    if (!(Test-Path $Path)) {
        New-Item -ItemType File -Path $Path -Value "fake" | Out-Null
    }
}

# 5. Pack MSIX
Write-Host "[4/5] Packing MSIX: $MSIX_NAME" -ForegroundColor Gray
& $MAKEAPPX pack /d $BUILD_DIR /p $MSIX_NAME /o
if ($LASTEXITCODE -ne 0) { Write-Error "MakeAppx failed"; exit }

# 6. Sign MSIX
Write-Host "[5/5] Signing MSIX with NukeDev.pfx..." -ForegroundColor Gray
if (Test-Path "NukeDev.pfx") {
    & $SIGNTOOL sign /fd SHA256 /a /f "NukeDev.pfx" /p 1234 $MSIX_NAME
    if ($LASTEXITCODE -ne 0) { Write-Error "Signing failed"; exit }
    Write-Host "SUCCESS! Your signed package is ready: $MSIX_NAME" -ForegroundColor Green
} else {
    Write-Host "WARNING: NukeDev.pfx not found. Package created but NOT signed." -ForegroundColor Yellow
}

# Clean up
# Remove-Item -Recurse -Force $BUILD_DIR
