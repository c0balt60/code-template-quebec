Write-Host "Sync mode: src" -ForegroundColor Cyan

Start-Process -FilePath rojo.exe `
    -ArgumentList @(
    "sourcemap",
    ".\default.project.json",
    "-o",
    ".\sourcemap.json",
    "--watch"
)`
    -NoNewWindow

Start-Process -FilePath darklua.exe `
    -ArgumentList @(
    "process",
    "--config",
    "./.darklua.json",
    "--watch",
    "./src",
    "./out"
)`
    -NoNewWindow

Start-Process -FilePath rojo.exe `
    -ArgumentList @(
    "serve",
    ".\out.project.json"
)`
    -NoNewWindow
