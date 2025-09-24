--- Automatically reopen the files and windows you had open.
return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Downloads" },
    })
  end,
}
