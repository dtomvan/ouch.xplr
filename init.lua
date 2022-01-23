---@diagnostic disable: undefined-field
local function fnargs_to_target(fnargs)
	local selected = fnargs.focused_node
	if next(fnargs.selection) == nil then
		if selected == nil then
			return { { LogError = "Could not find the selected node." } }
		else
			selected = '"' .. selected.absolute_path .. '"'
		end
	else
		selected = ""
		for _, entry in ipairs(fnargs.selection) do
			selected = selected .. " " .. '"' .. entry.absolute_path .. '"'
		end
	end
	return selected
end

local function ouch_compress(from, comp_type, target)
	if from == nil then
		return { "PopMode", "PopMode", { LogError = "Please specify something to compress!" } }
	end
	if target == nil or target == "." then
		for match in from:gmatch("%g+") do
			target = match
			break
		end
	end
	local ext = nil
	if comp_type ~= nil then
		ext = "." .. comp_type
	else
		ext = ""
	end
	return {
		{
			BashExec = "ouch c " .. from .. ' "' .. target .. ext .. '"' .. ";" .. [===[
            read -p "[press enter to continue]"
            ]===],
		},
		"ExplorePwdAsync",
		"PopMode",
		"PopMode",
	}
end

local function ouch_compress_target(args)
	local input_buffer = args.input_buffer
	if input_buffer == nil or input_buffer == "" then
		return { { LogError = "No such target." } }
	end
	local from = fnargs_to_target(args)
	if type(from) ~= "string" then
		return from
	end
	return ouch_compress(from, nil, input_buffer)
end

local function ouch_decompress(args)
	local target = args.input_buffer
	if target == nil or target == "" or type(target) ~= "string" then
		target = "."
	end
	local from = fnargs_to_target(args)

	return {
		{
			BashExec = "ouch d " .. from .. " --dir " .. '"' .. target .. '"' .. ";" .. [===[
            read -p "[press enter to continue]"
            ]===],
		},
		"ExplorePwdAsync",
		"PopMode",
	}
end

local ouch_mode = {
	name = "ouch",
	key_bindings = {
		on_key = {
			["c"] = {
				help = "compress",
				messages = {
					"PopMode",
					{ SwitchModeCustom = "ouch compress to" },
				},
			},
			["d"] = {
				help = "decompress",
				messages = {
					"PopMode",
					{ SwitchModeCustom = "ouch decompress to" },
				},
			},
			esc = {
				help = "cancel",
				messages = {
					"PopMode",
				},
			},
			["ctrl-c"] = {
				help = "terminate",
				messages = { "Terminate" },
			},
		},
	},
}

local ouch_compress_mode = {
	name = "ouch compress to",
	key_bindings = {
		on_key = {
			["."] = {
				help = "to PWD",
				messages = {
					{ SwitchModeCustom = "ouch compress pwd type" },
				},
			},
			["t"] = {
				help = "to target",
				messages = {
					{ SwitchModeCustom = "ouch compress to target" },
					{ SetInputBuffer = "" },
				},
			},
			esc = {
				help = "cancel",
				messages = {
					"PopMode",
				},
			},
			["ctrl-c"] = {
				help = "terminate",
				messages = { "Terminate" },
			},
		},
	},
}
ouch_compress_mode.key_bindings.on_key.enter = ouch_compress_mode.key_bindings.on_key["."]

local ouch_compress_pwd_type_mode = {
	name = "ouch compress pwd type",
	key_bindings = {
		on_key = {
			["g"] = {
				help = "tgz",
				messages = {
					{ CallLua = "custom.ouch_compress_pwd_gz" },
				},
			},
			["b"] = {
				help = "tbz2",
				messages = {
					{ CallLua = "custom.ouch_compress_pwd_bz2" },
				},
			},
			["B"] = {
				help = "tbz",
				messages = {
					{ CallLua = "custom.ouch_compress_pwd_bz" },
				},
			},
			["x"] = {
				help = "txz",
				messages = {
					{ CallLua = "custom.ouch_compress_pwd_xz" },
				},
			},
			["l"] = {
				help = "tlz",
				messages = {
					{ CallLua = "custom.ouch_compress_pwd_lz" },
				},
			},
			["m"] = {
				help = "tlzma",
				messages = {
					{ CallLua = "custom.ouch_compress_pwd_lzma" },
				},
			},
			["z"] = {
				help = "tzst",
				messages = {
					{ CallLua = "custom.ouch_compress_pwd_zst" },
				},
			},
			esc = {
				help = "cancel",
				messages = {
					"PopMode",
				},
			},
			["ctrl-c"] = {
				help = "terminate",
				messages = { "Terminate" },
			},
		},
	},
}

local ouch_compress_target_mode = {
	name = "ouch compress to target",
	help = nil,
	extra_help = nil,
	key_bindings = {
		on_key = {
			backspace = {
				help = "remove last character",
				messages = { "RemoveInputBufferLastCharacter" },
			},
			["ctrl-c"] = {
				help = "terminate",
				messages = { "Terminate" },
			},
			["ctrl-u"] = {
				help = "remove line",
				messages = {
					{ SetInputBuffer = "" },
				},
			},
			["ctrl-w"] = {
				help = "remove last word",
				messages = { "RemoveInputBufferLastWord" },
			},
			enter = {
				help = "perform compression",
				messages = {
					{ CallLua = "custom.ouch_compress_target" },
				},
			},
			esc = {
				help = "cancel",
				messages = {
					"PopMode",
				},
			},
		},
		on_alphabet = nil,
		on_number = nil,
		on_special_character = nil,
		default = {
			help = nil,
			messages = { "BufferInputFromKey" },
		},
	},
}

local ouch_decompress_mode = {
	name = "ouch decompress to",
	key_bindings = {
		on_key = {
			["."] = {
				help = "to PWD",
				messages = {
					{ CallLua = "custom.ouch_decompress" },
				},
			},
			["t"] = {
				help = "to target",
				messages = {
					"PopMode",
					{ SwitchModeCustom = "ouch decompress to target" },
					{ SetInputBuffer = "" },
				},
			},
			esc = {
				help = "cancel",
				messages = {
					"PopMode",
				},
			},
			["ctrl-c"] = {
				help = "terminate",
				messages = { "Terminate" },
			},
		},
	},
}
ouch_decompress_mode.key_bindings.on_key.enter = ouch_decompress_mode.key_bindings.on_key["."]

local ouch_decompress_target_mode = {
	name = "ouch decompress to target",
	help = nil,
	extra_help = nil,
	key_bindings = {
		on_key = {
			backspace = {
				help = "remove last character",
				messages = { "RemoveInputBufferLastCharacter" },
			},
			["ctrl-c"] = {
				help = "terminate",
				messages = { "Terminate" },
			},
			["ctrl-u"] = {
				help = "remove line",
				messages = {
					{ SetInputBuffer = "" },
				},
			},
			["ctrl-w"] = {
				help = "remove last word",
				messages = { "RemoveInputBufferLastWord" },
			},
			enter = {
				help = "perform compression",
				messages = {
					{ CallLua = "custom.ouch_decompress" },
				},
			},
			esc = {
				help = "cancel",
				messages = {
					"PopMode",
				},
			},
		},
		on_alphabet = nil,
		on_number = nil,
		on_special_character = nil,
		default = {
			help = nil,
			messages = { "BufferInputFromKey" },
		},
	},
}

local function setup(args)
	---@diagnostic disable-next-line: undefined-global
	local xplr = xplr

	if args == nil then
		args = {}
	end
	if args.key == nil then
		args.key = "o"
	end
	if args.mode == nil then
		args.mode = "action"
	end

	xplr.config.modes.custom.ouch = ouch_mode
	xplr.config.modes.custom["ouch compress to"] = ouch_compress_mode
	xplr.config.modes.custom["ouch compress pwd type"] = ouch_compress_pwd_type_mode
	xplr.config.modes.custom["ouch compress to target"] = ouch_compress_target_mode
	xplr.fn.custom.ouch_compress_target = ouch_compress_target

	xplr.config.modes.custom["ouch decompress to"] = ouch_decompress_mode
	xplr.config.modes.custom["ouch decompress to target"] = ouch_decompress_target_mode
	xplr.fn.custom.ouch_decompress = ouch_decompress

	local functions = {
		"gz",
		"bz2",
		"bz",
		"xz",
		"lz",
		"lzma",
		"zst",
	}
	for _, v in ipairs(functions) do
		xplr.fn.custom["ouch_compress_pwd_" .. v] = function(fnargs)
			local selected = fnargs_to_target(fnargs)
			if type(selected) ~= "string" then
				return selected
			end
			local file_count = 0
			for _ in selected:gmatch(" ") do
				file_count = file_count + 1
			end
			local format = v
			if file_count > 1 then
				format = "tar." .. v
			end
			return ouch_compress(selected, format, ".")
		end
	end
	xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
		help = "ouch",
		messages = {
			"PopMode",
			{ SwitchModeCustom = "ouch" },
		},
	}
end

return { setup = setup }
