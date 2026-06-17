table.toString = function(array)
   -- string variable
   text = ""

   -- iterate the array
   for i = 1, #array do
      -- concatenate the values to the string
      text = text.. (#text > 0 and "," or "") .. tostring(array[i])
   end
   -- return string representation
   return text
end
function onSongStart()
	luaDebugMode = true
	local path = ""
	if (difficultyName:lower() == "erect") then path = "-erect" end
	local json = callMethodFromClass("haxe.Json", "parse", {getTextFromFile("data/songs/"..songPath.."/".. songPath.."-chart"..path..".json")})
	-- mostly for focus camera and zoom camera
	table.sort(json.events, function(a,b) return a.t < b.t end)
	local events = {}
	for i, c in ipairs(json.events) do
		local value = c.v
		local name = c.e
		local value1 = ""
		local value2 = ""
		if name == "sserafimKick" then
			if value.final==nil then value.final=false end
			name = "Sserafim Kick"
			value1 = value.final
		end
		if name == "sserafimSing" then
			name = "Sserafim Sing"
			if value.singing == nil then value.singing = {false, false, false, false, false, false} end
			local sing = ""
			for d,a in ipairs(value.singing) do
				local si = ""
				if d > 1 then si = "," end
				sing = sing..si..tostring(a)
			end
			value1 = sing
		end
		if name == "sserafimShow" then
			name = "Sserafim Show"
			if value.visible == nil then value.visible = {false, false, false, false, false, false} end
			local sing = ""
			for d,a in ipairs(value.visible) do
				local si = ""
				if d > 1 then si = "," end
				sing = sing..si..tostring(a)
			end
			value1 = sing
		end
		if name == "sserafimPulseLights" then
			name = "Sserafim Pulse Lights"
			if value.colors == nil then value.colors = {"0xFFFFFFFF"} end
			if value.enabled == nil then value.enabled = false end
			if value.durations == nil then value.durations = {1} end
			if value.intensities == nil then value.intensities = {0.5} end

			local color = ""
			local durations = ""
			local intensities = ""
			for d,a in ipairs(value.colors) do
				local si = ""
				if d > 1 then si = "," end
				color = color..si..a
			end
			for d,a in ipairs(value.durations) do
				local si = ""
				if d > 1 then si = "," end
				durations = durations..si..a
			end
			for d,a in ipairs(value.intensities) do
				local si = ""
				if d > 1 then si = "," end
				intensities = intensities..si..a
			end
			color = color:gsub("0xFF", "")
			value1=color.."|"..tostring(value.enabled)
			
			value2 = durations.."|"..intensities
		end
		if name == "sserafimDark" then
			name = "Sserafim Dark"
			if value.duration == nil then value.duration = 1 end
			if value.amount == nil then value.amount = 1 end
			value1 = value.amount
			value2 = value.duration
		end
		if name == "sserafimLights" then
			name = "Sserafim Lights"
			if value.duration == nil then value.duration = 1 end
			if value.amount == nil then value.amount = 1 end
			value1 = value.amount
			value2 = value.duration
		end
		if name == "sserafimFlash" then
			if value.duration == nil then value.duration = 1 end
			name = "Sserafim Flash"
			value1 = value.duration
		end
		if name == "sserafimCover" then
			if value.visible == nil then value.visible = false end
			name = "Sserafim Cover"
			value1 = value.visible
		end
		if name == "sserafimBeautiful" then
			name = "Sserafim Beautiful"
			if value.beautiful == nil then value.beautiful = false end
			value1 = value.beautiful
		end
		if name == "sserafimEnd" then
			name = "Sserafim End"
		end
		if name == "FocusCamera" then
			if type(value) ~= "table" then value = {char = value} end
			if value.char == nil then value.char = 0 end
			if value.x == nil then value.x = 0 end
			if value.y == nil then value.y = 0 end
			if value.duration == nil then value.duration = 4 end
			if value.ease == nil then value.ease = "CLASSIC" end
			if value.easeDir==nil then value.easeDir=""end
			
			if value.ease == "CLASSIC" or value.ease == "INSTANT" or value.ease == "linear" then 
				value.easeDir = "" 
			end
			value.x = tonumber(value.x)
			value.y = tonumber(value.y)
			value.char = tonumber(value.char)
			value.duration = tonumber(value.duration)
			name = "Focus Camera"
			value1 = value.char == 0 and "bf" or value.char == 2 and "gf" or value.char == 1 and "dad" or ""
			value2 = value.x..","..value.y..","..value.duration..","..allowEase(value.ease..""..value.easeDir)
		end
		if name == "ZoomCamera" then
			if value.duration == nil then value.duration = 4 end
			if value.zoom==nil then value.zoom=1 end
			if value.ease == nil then value.ease = "classic" end
			if value.easeDir==nil then value.easeDir=""end
			if value.mode==nil then value.mode="absolute"end
			name = "Zoom Camera"
			value.ease = value.ease:lower()
			if value.ease == "classic" or value.ease == "instant" or value.ease == "linear" then value.easeDir = "" end
			value.zoom = tonumber(value.zoom)
			value.duration = tonumber(value.duration)
			value1 = value.duration..","..(value.zoom * (value.mode == "stage" and getProperty("defaultCamZoom") or 1))
			value2 = allowEase(value.ease..""..value.easeDir)
		end
		if name == "SetHealthIcon" then
			if value.id == nil then value.id="dad"end
			if value.char==nil then value.char=0 end
			-- remember mistake with focus camera
			value.char = tonumber(value.char)
			value1 = value.char == 1 and "dad" or "bf"
			value2 = value.id
		end
		if name == "PlayAnimation" then
			name = "Play Animation"
			if value.target == nil then value.target = dad end
			if value.anim==nil then value.anim="idle"end
			value2 = value.target
			value1 = value.anim
		end
		if name == "SetCameraBop" then
			if value.intensity == nil then value.intensity = 1 end
			if value.rate == nil then value.rate = 4 end
			name = "Set Camera Bopping"
			value.rate = tonumber(value.rate)
			value.intensity =tonumber(value.intensity)
			value1 = value.rate
			value2 = value.intensity
		end
		table.insert(events, {c.t, {{name, tostring(value1), tostring(value2)}}})
	end
--	debugPrint({events = events})
	saveFile("Vslice ChartConvert/data/"..songPath.."/events"..path..".json", callMethodFromClass("haxe.Json", "stringify", {{events = events}}))
	debugPrint("fuck u")
end
function allowEase(esse)
	esse = esse:lower()
	if esse=="instant"then return "INSTANT"end
	if esse=="linear"then return"linear"end
	if esse=="quadin"then return"quadin"end
	if esse=="quadout"then return"quadout"end
	if esse=="quadinout"then return"quadinout"end
	if esse=="cubein"then return"cubein"end
	if esse=="cubeout"then return"cubeout"end
	if esse=="cubeinout"then return"cubeinout"end
	if esse=="quartin"then return"quartin"end
	if esse=="quartout"then return"quartout"end
	if esse=="quartinout"then return"quartinout"end
	if esse=="quintin"then return"quintin"end
	if esse=="quintout"then return"quintout"end
	if esse=="quintinout"then return"quintinout"end
	if esse=="smoothstepin"then return"smoothstepin"end
	if esse=="smoothstepout"then return"smoothstepout"end
	if esse=="smoothstepinout"then return"smoothstepinout"end
	if esse=="smootherstepin"then return"smootherstepin"end
	if esse=="smootherstepout"then return"smootherstepout"end
	if esse=="smootherstepinout"then return"smootherstepinout"end
	if esse=="sinein"then return"sinein"end
	if esse=="sineout"then return"sineout"end
	if esse=="sineinout"then return"sineout"end
	if esse=="bouncein"then return"bouncein"end
	if esse=="bounceout"then return"bounceout"end
	if esse=="bounceinout"then return"bounceinout"end
	if esse=="circin"then return"circin"end
	if esse=="circout"then return"circout"end
	if esse=="circinout"then return"circinout"end
	if esse=="expoin"then return"expoin"end
	if esse=="expoout"then return"expoout"end
	if esse=="expoinout"then return"expoinout"end
	if esse=="backin"then return"backin"end
	if esse=="backout"then return"backout"end
	if esse=="backinout"then return"backinout"end
	if esse=="elasticin"then return"elasticin"end
	if esse=="elasticout"then return"elasticout"end
	if esse=="elasticinout"then return"elasticinout"end
	return "CLASSIC"
end
function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end