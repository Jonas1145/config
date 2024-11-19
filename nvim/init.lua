require("jonas.core")
require("jonas.lazy")


local original_definition = vim.lsp.buf.definition

original_definition = function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
    if result then
      -- Filter out any results from index.d.ts files
      local filtered_result = vim.tbl_filter(function(item)
        return not string.match(item.targetUri or item.uri, "index%.d%.ts$")
      end, result)

      if #filtered_result == 1 then
        -- If there's only one result left, jump directly to it
        vim.lsp.util.jump_to_location(filtered_result[1], "utf-8")
      else
        -- Otherwise, show the filtered results
        vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(filtered_result, "utf-8"))
        vim.api.nvim_command("copen")
      end
    else
      original_definition()
    end
  end)
end

vim.cmd("colorscheme tokyonight")
