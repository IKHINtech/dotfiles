local function is_empty_commit_buffer()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for _, line in ipairs(lines) do
    if line:match("%S") and not line:match("^#") then
      return false
    end
  end

  return true
end

local function normalize_response(response)
  if response == nil then
    return nil
  end

  if type(response) == "string" then
    return response
  end

  if type(response) == "table" then
    return response.content or response.message or response.output or response.answer or response.text
  end

  return tostring(response)
end

local function extract_commit_title(response)
  local text = normalize_response(response)
  if not text or text == "" then
    return nil
  end

  -- buang code fence kalau CopilotChat mengembalikan markdown
  text = text:gsub("^```[%w_-]*\n", "")
  text = text:gsub("\n```%s*$", "")

  text = vim.trim(text)
  if text == "" then
    return nil
  end

  local first = vim.split(text, "\n", { plain = true })[1] or ""
  first = vim.trim(first)

  -- buang quote pembuka/penutup jika ada
  first = first:gsub("^['\"]", ""):gsub("['\"]$", "")

  -- buang bullet / numbering kalau model mengembalikan list
  first = first:gsub("^[-*]%s+", "")
  first = first:gsub("^%d+[.)]%s+", "")

  if first == "" then
    return nil
  end

  return first
end

local function fill_commit_message()
  if not is_empty_commit_buffer() then
    return
  end

  local ok, chat = pcall(require, "CopilotChat")
  if not ok then
    vim.notify("CopilotChat not available", vim.log.levels.WARN)
    return
  end

  local prompt = "Generate a concise conventional commit message from the currently staged git changes. "
    .. "Return only the commit title, one line only, no explanation, no markdown, no code block."

  chat.ask(prompt, {
    headless = true,
    callback = function(response)
      local first = extract_commit_title(response)
      if not first then
        vim.schedule(function()
          vim.notify("Failed to generate commit message", vim.log.levels.WARN)
        end)
        return response
      end

      vim.schedule(function()
        -- isi hanya kalau buffer masih kosong
        if not is_empty_commit_buffer() then
          return
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, { first, "" })
        vim.cmd("normal! gg")
      end)

      return response
    end,
  })
end

vim.defer_fn(fill_commit_message, 300)