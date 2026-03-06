-- Disable Plugin
if true then
  return {}
end

return {
  "johnpmitsch/vai.nvim",
  config = function()
    require("vai").setup()
  end,
}
