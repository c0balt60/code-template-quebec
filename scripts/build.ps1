rokit install
pesde install

rojo.exe sourcemap -o sourcemap.json
darklua.exe process --config ".\.darklua.json" out "out"

Write-Host "\nSuccessfully built project dependencies" -ForegroundColor Green
