function onSongStart()
	luaDebugMode = true
	local path = ""
	if (difficultyName:lower() == "erect") then path = "-erect" end
	local json = callMethodFromClass("haxe.Json", "parse", {getTextFromFile("data/songs/"..songPath.."/"..songPath.."-chart"..path..".json")})
	local meta = callMethodFromClass("haxe.Json", "parse", {getTextFromFile("data/songs/"..songPath.."/"..songPath.."-metadata"..path..".json")})
	local changeBPM = {}
	if #meta.timeChanges > 1 then
		for i = 2, #meta.timeChanges do
			table.insert(changeBPM, {meta.timeChanges[i].t, meta.timeChanges[i].bpm})
		end
	end
	for b = 1, 5 do
		local difficulty = difficultyName:lower() == "erect" and {"erect", "nightmare", "picospeaker"} or {"easy", "", "hard", "picospeaker"}
		difficulty = difficulty[b]
		local note = json.notes
		local difficultyPath = difficultyName:lower() == "erect" and {note.erect, note.nightmare, note.picospeaker} or {note.easy, note.normal, note.hard, note.picospeaker}
		difficultyPath = difficultyPath[b]
		if difficultyPath == nil then return end
		local songSpeed = difficultyName:lower() == "erect" and {json.scrollSpeed.erect, json.scrollSpeed.nightmare, json.scrollSpeed.erect} or {json.scrollSpeed.easy, json.scrollSpeed.normal, json.scrollSpeed.hard, json.scrollSpeed.normal}
		local notes = {}
		table.sort(difficultyPath, function(a,b) return a.t < b.t end)
		for i = 1, #difficultyPath do
			local data = {difficultyPath[i].t, difficultyPath[i].d,difficultyPath[i].l}
			if data[3] == nil then data[3] = 0 end
			if difficultyPath[i].k ~= nil then
				data[4] = difficultyPath[i].k
			end
			table.insert(notes, data)
		end
		if stringStartsWith(meta.playData.stage, "mainStage") then
			meta.playData.stage = meta.playData.stage:gsub("mainStage", "stage")
		end
		local file = {
			song = {
				bpm = meta.timeChanges[1].bpm,
				speed = songSpeed[b],
				song = songPath,
				needsVoices = true,
				player1 = meta.playData.characters.player,
				player2 = meta.playData.characters.opponent,
				gfVersion = meta.playData.characters.girlfriend,
				stage = meta.playData.stage,
				notes = {}
			}
		}
		local crochet = 60 / file.song.bpm * 1000
		local int = 0
		local time = 0
		local lastMustHit = false
		local v = 1
		while time < getPropertyFromClass("flixel.FlxG", "sound.music.length") do
			table.insert(file.song.notes, {sectionNotes = {}, mustHitSection = true})
			if changeBPM[v] ~= nil and time >= changeBPM[v][1] then
				crochet = 60 / changeBPM[v][2] * 1000
				
				file.song.notes[#file.song.notes].changeBPM = true
				file.song.notes[#file.song.notes].bpm = changeBPM[v][2]
				v = v + 1
			end
			
			for i = 1, #notes do
				if notes[i][1] >= ((#file.song.notes - 1) * crochet*4) and notes[i][1] < (#file.song.notes * (crochet*4)) then
					table.insert(file.song.notes[#file.song.notes].sectionNotes, notes[i])
				end
			end
			time += crochet * 4
		end
		file = callMethodFromClass("haxe.Json", "stringify", {file})
		file = string.gsub(file, '"sectionNotes":{}', '"sectionNotes":[]')
		debugPrint("hi")
		saveFile("Vslice ChartConvert/data/"..songPath.."/"..songPath..(difficulty == "" and "" or ("-"..difficulty))..".json", file)
	end
end