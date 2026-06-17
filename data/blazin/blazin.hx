import psychlua.LuaUtils;
var start = false;
function onEndSong(){
	if (start) return;
	game.startVideo("blazinCutscene");
	start = true;
	return LuaUtils.Function_Stop;
}