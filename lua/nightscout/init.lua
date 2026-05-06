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

function M.setup(opts)
	config = vim.tbl_deep_extend("force", defaults, opts or {})
	if config.url == "" then
		config.url = vim.env.NIGHTSCOUT_URL or ""
	end
	if config.token == "" then
		config.token = vim.env.NIGHTSCOUT_TOKEN or ""
	end
	M.fetch()
	local timer = assert(vim.uv.new_timer())
	timer:start(config.interval * 1000, config.interval * 1000, function()
		vim.schedule(M.fetch)
	end)
end

function M.fetch()
	vim.system(
		{ "curl", "-s", config.url .. "/api/v1/entries/current.json?token=" .. config.token },
		{ text = true },
		function(result)
			local data = vim.json.decode(result.stdout)
			local entry = data[1]
			current = entry
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
