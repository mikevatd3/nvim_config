local project_dir = vim.fn.expand("~/2_responsibilities/emails")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if not bufname:find(project_dir, 1, true) then
      return
    end

    vim.api.nvim_buf_create_user_command(args.buf, "GmailDraft", function()
      if vim.bo[args.buf].modified then
        vim.cmd("write")
      end

      vim.notify("Creating Gmail draft...", vim.log.levels.INFO)

      vim.system(
        { "uv", "run", "--directory", project_dir, "main.py", bufname },
        { text = true },
        function(obj)
          vim.schedule(function()
            if obj.code == 0 then
              vim.notify(vim.trim(obj.stdout), vim.log.levels.INFO, { title = "Gmail draft" })
            else
              local msg = obj.stderr ~= "" and obj.stderr or obj.stdout
              vim.notify(vim.trim(msg), vim.log.levels.ERROR, { title = "Gmail draft failed" })
            end
          end)
        end
      )
    end, {})

    vim.keymap.set("n", "<leader>gd", "<cmd>GmailDraft<cr>", {
      buffer = args.buf,
      desc = "Create Gmail draft from this file",
    })
  end,
})
