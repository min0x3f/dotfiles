local M = {}
local jobs = {}

local function source()
	local filename = vim.api.nvim_buf_get_name(0)
	if filename == "" or vim.fn.filereadable(filename) ~= 1 then
		vim.notify("Save the Typst file first", vim.log.levels.WARN)
		return
	end
	return filename
end

function M.watch()
	local filename = source()
	if not filename then
		return
	end
	if jobs[filename] then
		vim.notify("Typst is already watching this file")
		return
	end
	local job = vim.fn.jobstart({ "typst", "watch", filename }, {
		cwd = vim.fn.fnamemodify(filename, ":h"),
		-- jobstart's default lifetime stops the watcher when Neovim exits.
		on_stderr = function(_, data)
			for _, line in ipairs(data) do
				if line:match("^error:") then
					vim.schedule(function()
						vim.notify("Typst: " .. line, vim.log.levels.ERROR)
					end)
				end
			end
		end,
		on_exit = function(_, code)
			jobs[filename] = nil
			if code ~= 0 and code ~= 143 then
				vim.schedule(function()
					vim.notify("Typst watcher exited with code " .. code, vim.log.levels.WARN)
				end)
			end
		end,
	})
	if job <= 0 then
		vim.notify("Could not start typst watch", vim.log.levels.ERROR)
		return
	end
	jobs[filename] = job
	vim.notify("Watching " .. vim.fn.fnamemodify(filename, ":t") .. "; save to update the PDF")
end

function M.stop()
	local filename = vim.api.nvim_buf_get_name(0)
	if jobs[filename] then
		vim.fn.jobstop(jobs[filename])
	else
		vim.notify("No Typst watcher for this file")
	end
end

function M.open()
	local filename = source()
	if not filename then
		return
	end
	local pdf = vim.fn.fnamemodify(filename, ":r") .. ".pdf"
	if vim.fn.filereadable(pdf) ~= 1 then
		vim.notify("PDF not found; use :TypstWatch and fix any compilation errors first", vim.log.levels.WARN)
		return
	end
	vim.system({ "open", "-a", "Skim", pdf }, {}, function(result)
		if result.code ~= 0 then
			vim.schedule(function()
				vim.notify("Could not open Skim: " .. result.stderr, vim.log.levels.ERROR)
			end)
		end
	end)
end

return M
