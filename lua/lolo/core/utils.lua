local M = {}

function M.trim_whitespace()
	-- Check if the file type is markdown, if so, do not trim whitespace
	if vim.bo.filetype == "markdown" then
		return
	end
	-- Use Vim's substitution command to remove trailing whitespace
	vim.cmd([[ %s/\s\+$//e ]])
end

-- Create an autocommand that triggers the function before saving files
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = M.trim_whitespace,
})

return M
