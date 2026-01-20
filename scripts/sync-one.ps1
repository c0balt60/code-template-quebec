rokit install
pesde install

rojo.exe serve default.project.json
rojo.exe sourcemap default.project.json -o sourcemap.json --watch
darklua.exe process --config .darklua.json --watch src/
