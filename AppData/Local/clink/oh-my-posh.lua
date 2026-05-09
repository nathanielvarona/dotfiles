-- Oh-My-Posh for Windows Command Prompt (cmd.exe)

local home = os.getenv("USERPROFILE")
load(io.popen("oh-my-posh init cmd --config " .. home .. "/.config/oh-my-posh/zen.omp.toml"):read("*a"))()
