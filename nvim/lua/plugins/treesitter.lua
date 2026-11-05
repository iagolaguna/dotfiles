-- nvim-treesitter `main` branch: it only installs parsers. Highlighting and
-- indentation are enabled per buffer by the FileType autocmd below.
local ensure_installed = {
	"bash",
	"css",
	"diff",
	"graphql",
	"html",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
}

local function attach(buf, lang)
	if not vim.api.nvim_buf_is_valid(buf) or not pcall(vim.treesitter.start, buf, lang) then
		return
	end
	vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.install(ensure_installed)

		local available = {}
		for _, lang in ipairs(ts.get_available()) do
			available[lang] = true
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
			callback = function(event)
				local lang = vim.treesitter.language.get_lang(event.match)
				if not lang or not available[lang] then
					return
				end
				if vim.list_contains(ts.get_installed(), lang) then
					attach(event.buf, lang)
				else
					-- Same behaviour as the old `auto_install = true`.
					ts.install(lang):await(function()
						vim.schedule(function()
							attach(event.buf, lang)
						end)
					end)
				end
			end,
		})
	end,
}
