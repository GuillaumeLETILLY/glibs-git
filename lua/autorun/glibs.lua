--@ Global configuration
local CONFIG = {
	FilesToLoad = {
		{file = "modules/server/sql.lua", realm = "server"},
		{file = "modules/client/responsive.lua", realm = "client"},
		{file = "modules/client/materials.lua", realm = "client"},
		{file = "modules/client/draw.lua", realm = "client"},
		{file = "modules/client/panel.lua", realm = "client"},
		{file = "modules/client/anims.lua", realm = "client"},
	},
	Prefix = "[ Golem - Libs ]",
	Debug = true
}

--@ Debug print function with prefix
local function DebugPrint(message)
	if CONFIG.Debug then
		print(CONFIG.Prefix .. " > " .. message)
	end
end

--@ Load individual file based on realm
local function LoadFile(fileData)
	local realm = fileData.realm:lower()
	local filePath = fileData.file
	
	if realm == "shared" then
		if SERVER then
			AddCSLuaFile(filePath)
			include(filePath)
			DebugPrint("[SHARED-SV] Loaded & Added: " .. filePath)
		else
			include(filePath)
			DebugPrint("[SHARED-CL] Loaded: " .. filePath)
		end
	elseif realm == "server" and SERVER then
		if not file.Exists(fileData.file, "LUA") then return end
		include(filePath)
		DebugPrint("[SERVER] Loaded: " .. filePath)
	elseif realm == "client" then
		if SERVER then
			AddCSLuaFile(filePath)
			DebugPrint("[CLIENT-SV] Added: " .. filePath)
		else
			if not file.Exists(fileData.file, "LUA") then return end
			include(filePath)
			DebugPrint("[CLIENT-CL] Loaded: " .. filePath)
		end
	end
end

--@ Main function to load all files
local function LoadFiles()
	DebugPrint("Starting files loading...")
	for _, fileData in ipairs(CONFIG.FilesToLoad) do
		if SERVER or (not SERVER and fileData.realm ~= "server") then
			local success, err = pcall(LoadFile, fileData)
			if not success then
				ErrorNoHalt(CONFIG.Prefix .. " ERROR while loading " .. fileData.file .. ": " .. err .. "\n")
			end
		end
	end
	DebugPrint("Loading complete!")
end

--@ Initialize loading process
LoadFiles()