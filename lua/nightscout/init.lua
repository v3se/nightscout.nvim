local M = {}
local config = {}
local current = {}
local defaults = {
	url = "",
	token = "",
	interval = 60,
}

local arrows = {
	Flat = "→",
	SingleUp = "↑",
	DoubleUp = "↑↑",
	SingleDown = "↓",
	DoubleDown = "↓↓",
	FortyFiveUp = "↗",
	FortyFiveDown = "↘",
}

local function notify(msg, level)
	vim.schedule(function()
		vim.notify("nightscout.nvim: " .. msg, level)
	end)
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", defaults, opts or {})
	if config.url == "" then
		config.url = vim.env.NIGHTSCOUT_URL or ""
	end
	if config.token == "" then
		config.token = vim.env.NIGHTSCOUT_TOKEN or ""
	end
	if config.url == "" then
		notify("NIGHTSCOUT_URL is not set", vim.log.levels.ERROR)
		return
	end
	if config.token == "" then
		notify("NIGHTSCOUT_TOKEN is not set", vim.log.levels.ERROR)
		return
	end
	M.fetch()
	local timer = assert(vim.uv.new_timer())
	timer:start(config.interval * 1000, config.interval * 1000, function()
		vim.schedule(M.fetch)
	end)
end

function M.fetch()
	vim.system(
		{ "curl", "-s", "-f", config.url .. "/api/v1/entries/current.json?token=" .. config.token },
		{ text = true },
		function(result)
			if result.code ~= 0 then
				notify("failed to reach Nightscout (check NIGHTSCOUT_URL)", vim.log.levels.WARN)
				return
			end
			local ok, data = pcall(vim.json.decode, result.stdout)
			if not ok or not data or not data[1] then
				notify("unexpected response (check NIGHTSCOUT_TOKEN)", vim.log.levels.WARN)
				return
			end
			current = data[1]
		end
	)
end

function M.get_status()
	if vim.tbl_isempty(current) then
		return "--"
	end
	local mmol = current.sgv * 0.0555
	local arrow = arrows[current.direction] or "?"
	return string.format("%.1f%s", mmol, arrow)
end

return M
