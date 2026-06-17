import states.FreeplayState;
import sys.io.File;
import sys.FileSystem;
import backend.Mods;
import object.Alphabet;
import backend.WeekData;
import backend.MusicBeatState;
import states.MainMenuState;
import backend.Funkin;
import flixel.util.FlxStringUtil;
import flixel.text.FlxTextBorderStyle;
// useless
var allowDifficulty = ["Easy", "Normal", "Hard", "Erect", "Nightmare"];
var iconArray = [];
var songs = [];
// list useer for 
var grpSongs = [];
var bg;
var grpSongList;
var iconSongList;
var replace = StringTools.replace;
var start = StringTools.startsWith;
var end = StringTools.endsWith;
var trim = StringTools.trim;
var curChoose = 0;
var curDifficulty = 1;
var pad;
var currentMods = Mods.currentModDirectory;
function onCreate(){
	bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
	add(bg);
	bg.screenCenter();
	reloadWeek();
	Mods.currentModDirectory = currentMods;
	reloadSongList();
	Mods.currentModDirectory = currentMods;
	#if android
		MusicBeatState.addTouchPad("LEFT_FULL","A_B_C_X_Y_Z");
	#end
}
function reloadWeek(){
	WeekData.reloadWeekFiles(false);
	songs = [];
	for (i in 2...WeekData.weeksList.length) {
		if (weekIsLocked(WeekData.weeksList[i])) continue;
		var leWeek = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
		// folder
		WeekData.setDirectoryFromWeek(leWeek);
		for (song in leWeek.songs) {
			var colors:Array<Int> = song[2];
			if(colors==null||colors.length<3)colors=[146,113,253];
			var icon = song[1];
			icon = icon.toLowerCase();
			icon = replace(icon, "-pixel", "");
			icon = replace(icon, "pixel", "");
			Mods.currentModDirectory = Mods.currentModDirectory == "" ? currentMods : Mods.currentModDirectory;
			var difficultyList = [];
			for (b in 0...allowDifficulty.length) {
				var diff = allowDifficulty[b] == "Normal" ? "" : ("-" + allowDifficulty[b]);
				var path = "data/" + Paths.formatToSongPath(song[0]) + "/" + Paths.formatToSongPath(song[0]);
				if (Paths.getTextFromFile(path + diff + ".json") != null) {
					difficultyList.push(allowDifficulty[b]);
				}
			}
			if (difficultyList.length == 0) continue;
			songs.push({songName: song[0], icon: icon, folder: Mods.currentModDirectory, color: FlxColor.fromRGB(colors[0], colors[1], colors[2]), difficulty: difficultyList});
		}
	}
}
function reloadSongList(){
	for (i in 0...songs.length) {
		if (!allowDifficulty.contains(songs[i].difficulty[curDifficulty])) continue;
		var name = FlxStringUtil.toTitleCase(replace(songs[i].songName, "-", " "));
		var songText = new FlxText(90, 320, 0, name);
	//	songText.ID = i;
		songText.setFormat(Paths.font("Tardling-Solid.ttf"), 60, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songText.borderSize = 6;
		add(songText);
		grpSongs.push([songs[i].songName, songText, songs[i].difficulty]);

		//songText.snapToPosition();
		Mods.currentModDirectory = songs[i].folder;
		var icon;
		var isFreeplay = false;
		if (!FileSystem.exists(Paths.modFolders("images/icons/freeplay/" + songs[i].icon + "pixel.png"))) {
			icon = new HealthIcon(songs[i].icon);
		} else {
			isFreeplay = true;
			icon = new FlxSprite().loadGraphic(Paths.image("icons/freeplay/" + songs[i].icon + "pixel"));
			if (FileSystem.exists(Paths.modFolders("images/icons/freeplay/" + songs[i].icon + "pixel.xml"))){
				icon.frames = Paths.getSparrowAtlas("icons/freeplay/" + songs[i].icon + "pixel");
				icon.animation.addByPrefix("idle", "idle", 12);
				icon.animation.addByPrefix("enter", "confirm0", 12, false);
				icon.animation.addByPrefix("loop", "confirm-hold", 12);
				icon.animation.play("idle");
				icon.animation.finishCallback = (name) -> icon.animation.play("loop");
			}
			icon.setGraphicSize(icon.frameWidth * 3);
			icon.updateHitbox();
			icon.antialiasing = false;
		}
		iconArray.push([icon, isFreeplay]);
		add(icon);
	}
}
function weekIsLocked(name:String) {
	var leWeek:WeekData = WeekData.weeksLoaded.get(name);
	return (!leWeek.startUnlocked
		&& leWeek.weekBefore.length > 0
		&& (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
}
var lerpSelected = 0;
function onUpdatePost(elapsed){
	if (controls.UI_LEFT_P || buildTarget == "android" && MusicBeatState.touchPad.buttonLeft.justPressed) {
		chnageDifficulty(-1);
	}
	if (controls.UI_UP_P || buildTarget == "android" && MusicBeatState.touchPad.buttonUp.justPressed) {
		changeSelection(-1);
	}
	if (controls.UI_DOWN_P || buildTarget == "android" && MusicBeatState.touchPad.buttonDown.justPressed) {
		changeSelection(1);
	}
	if (controls.UI_RIGHT_P || buildTarget == "android" && MusicBeatState.touchPad.buttonRight.justPressed) {
		chnageDifficulty(1);
	}
	if (controls.BACK || buildTarget == "android" && MusicBeatState.touchPad.buttonB.justPressed) {
		Funkin.switchState(MainMenuState);
	}
	if (controls.ACCEPT || buildTarget == "android" && MusicBeatState.touchPad.buttonA.justPressed){
		onConfirm();
	}
	
	lerpSelected = FlxMath.lerp(curChoose, lerpSelected, Math.exp(-elapsed * 9.6));
	// yes a tracker
	var index = -1;
	for (i in 0...grpSongs.length){
		index += 1;
		grpSongs[i][1].x = FlxMath.lerp((640 - grpSongs[i][1].width/2) + 120 * FlxMath.fastSin(i - curChoose), grpSongs[i][1].x, Math.exp(-elapsed * 9.6));
		grpSongs[i][1].y = (index - lerpSelected) * 1.3 * 120 + 300;
		
	}
	for (i in 0...iconArray.length){
		iconArray[i][0].setPosition(grpSongs[i][1].x + grpSongs[i][1].width + 12, grpSongs[i][1].y - 30);
		if (iconArray[i][1]) {
			iconArray[i][0].setPosition(grpSongs[i][1].x - iconArray[i][0].frameWidth * iconArray[i][0].scale.x, grpSongs[i][1].y + grpSongs[i][1].height/2 - iconArray[i][0].height/2);
		}
	}
}
function snapToPosition(){
	for (i in 0...grpSongs.length){
		index += 1;
		grpSongs[i][1].x = (640 - grpSongs[i][1].width/2) + 120 * FlxMath.fastSin(i - curChoose);
		grpSongs[i][1].y = (index - curChoose) * 1.3 * 120 + 300;
	}
}
function changeSelection(id) {
	curChoose = FlxMath.wrap(curChoose + id, 0, grpSongs.length - 1);
	for (i in 0...grpSongs.length) {
		grpSongs[i][1].alpha = curChoose == i ? 1 : 0.6;
		iconArray[i][0].alpha=curChoose == i ? 1:0.6;
	}
	
	Mods.currentModDirectory = currentMods;
	FlxG.sound.play(Paths.sound("freeplay/select"), 0.4);
}

function chnageDifficulty(id){
	var start = allowDifficulty.indexOf(grpSongs[curChoose][2][0]);
	var length = allowDifficulty.lastIndexOf(grpSongs[curChoose][2][grpSongs[curChoose][2].length - 1]);
	curDifficulty = FlxMath.wrap(curDifficulty + id, start, length);
	var choose = grpSongs[curChoose][0];
	while(grpSongs.length > 0){
		var array = grpSongs.shift();
		remove(array[1]);
		array[1].destroy();
	}
	while(iconArray.length > 0){
		var array = iconArray.shift();
		remove(array[0]);
		array[0].destroy();
	}
	reloadSongList();
	snapToPosition();
	for (i in 0...grpSongs.length){
		if (curDifficulty > 2) grpSongs[i][1].text += " Erect";
		if (grpSongs[i][0] != choose) continue;
		curChoose = i;
		changeSelection(0);
	}
}
function onConfirm(){
	if (iconArray[curChoose][1] && iconArray[curChoose][0].animation != null){
		iconArray[curChoose][0].animation.play("enter");
	}
	Mods.currentModDirectory = currentMods;
	FlxG.sound.play(Paths.sound("freeplay/confirm"), 0.4);
}