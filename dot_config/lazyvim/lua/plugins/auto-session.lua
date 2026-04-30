--- Automatically reopen the files and windows you had open.
return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      auto_session_suppress_dirs = { "~/", "~/Downloads" },
      -- log_level = "debug",
    })
  end,
}
