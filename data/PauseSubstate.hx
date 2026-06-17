import backend.Song;
import states.StoryMenuState;
import backend.MusicBeatSubstate;
import states.FreeplayState;
import options.OptionsState;
import objects.Alphabet;
import backend.Funkin;
import backend.Difficulty;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import mobile.objects.TouchPad;
import states.editors.ChartingState;
import backend.Song;
import objects.Note;
import flixel.sounds.FlxSound;
import backend.MusicBeatState;
import backend.StageData;

var curSelected = 0;
var menuGroupShit:FlxSpriteGroup;
var grpMenuShit = [];
var menuItems = [
	'Resume',
	'Restart Song',
	'Chart Editor',
	'Options',
	'Exit to menu'
];
var newCamera;
// mobile
var PAD;
function pause(bool){
	FlxG.camera.followLerp = 0;
	game.persistentUpdate = !bool;
	game.persistentDraw = true;
	game.paused = bool;
	FlxTimer.globalManager.forEach(function(tmr) if(!tmr.finished) tmr.active = !bool);
	FlxTween.globalManager.forEach(function(twn) if(!twn.finished) twn.active = !bool);
	if (bool) {
		if (game.videoCutscene != null) state.videoCutscene.pause();
		if (FlxG.sound.music != null) {
			FlxG.sound.music.pause();
			game.vocals.pause();
			if (game.opponentVocals._sound != null)
				game.opponentVocals.pause();
		}
	} else {
		if (FlxG.sound.music != null) {
			if (game.videoCutscene != null) state.videoCutscene.resume();
			FlxG.sound.music.resume();
			game.vocals.resume();
			if (game.opponentVocals._sound != null)
				game.opponentVocals.resume();
		}
	}
}
function onCreate(){
	MusicBeatSubstate.instance.add(menuGroupShit);
	newCamera = new FlxCamera();
	newCamera.bgColor = 0;
	FlxG.cameras.add(newCamera, false);
	MusicBeatSubstate.instance.cameras = [newCamera];
	
	pause(true);
	var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	bg.scale.set(FlxG.width, FlxG.height);
	bg.updateHitbox();
	bg.alpha = 0;
	bg.scrollFactor.set();
	MusicBeatSubstate.instance.add(bg);
	FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
	
	for (i in 0...menuItems.length){
		var item = new Alphabet(90, 320, menuItems[i], true);
		item.isMenuItem = true;
		item.targetY = i;
		item.ID = i;
		MusicBeatSubstate.instance.add(item);
		grpMenuShit.push(item);
	}
	if (buildTarget == "android"){
		PAD = new TouchPad("UP_DOWN", "A");
		PAD.cameras = [newCamera];
		MusicBeatSubstate.instance.add(PAD);
	}
	
	
	
	
	changeSelection(0);
}
function onCloseSubState(){
	
}
var lastBeat = 0;
var lastTime = 0;
var died = false;
function onUpdatePost(){
	if (died) return;
	if (controls.UI_UP_P || buildTarget == "android" && PAD.buttonUp.justPressed && PAD != null) changeSelection(-1);
	if (controls.UI_DOWN_P || buildTarget == "android" && PAD.buttonDown.justPressed && PAD != null) changeSelection(1);
	if (controls.ACCEPT || buildTarget == "android" && PAD.buttonA.justPressed && PAD != null){
		if (PAD != null) PAD.destroy();
		died = true;
		FlxG.cameras.remove(newCamera, true);
		switch(curSelected){
			case 0:
				pause(false);
				
				MusicBeatSubstate.instance.closeSubState();
			case 1: 
				FlxG.sound.music.pause();
				//MusicBeatSubstate.instance.closeSubState();
				
				pause(false);
				for (i in [game.vocals, game.opponentVocals])
					if (i._sound != null) {
						i.volume = 0;
						i.pause();
					}
				// use for fix lastBeat
				game.callOnScripts("onSongRestart");
				setVar("inRestart", true);
				setVar("restartSong", true);
				game.startingSong = false;
				game.canPause = false;
				lastTime = Conductor.songPosition;
				FlxTween.tween(game.timeBar,{alpha:0},1,{ease: FlxEase.circInOut});
				FlxTween.tween(game.timeTxt,{alpha:0},1,{ease: FlxEase.circInOut});
				FlxTween.num(Conductor.songPosition / 1000, (Conductor.crochet / 1000) * -5, 1, {ease: FlxEase.circInOut, onComplete: function() {
					Conductor.bpm=PlayState.SONG.bpm;
					game.generatedMusic = false;
					genat();
					MusicBeatSubstate.instance.closeSubState();
					game.startedCountdown = false;
					game.startingSong = true;
					game.startCountdown();
					Conductor.songPosition = -(Conductor.crochet*5);
					FlxTween.num(-(Conductor.crochet*5)/1000, 0, (Conductor.crochet*5)/1000,{},function(n){
						Conductor.songPosition = n*1000;
					});
					setVar("restartSong", true);
					game.canPause = true;
					setVar("inRestart", false);
					while(game.strumLineNotes.length>8){
						game.strumLineNotes.remove(game.strumLineNotes.members[8], true);
					}
					resetCharacterPosition();
				}}, function(num) {
					FlxG.sound.music.time = num*1000;
					FlxG.sound.music.pause();
					FlxG.sound.music.volume = 0;
					Conductor.songPosition = num*1000;
				});
				
				if (PlayState.storyMode){
					PlayState.campaignScore -= game.songScore;
					PlayState.campaignMisses -= game.songMisses;
				}
				game.health = 1;
				game.combo = 0;
				game.ratingData[0].hits = game.ratingData[1].hits = game.ratingData[2].hits = game.ratingData[3].hits = game.songScore = game.songMisses = game.ratingPercent = game.songHits = game.totalNotesHit = game.totalPlayed = 0;
				
				
				
			case 2: game.openChartEditor();
			case 3:
				OptionsState.onPlayState = true;
				game.paused = true; // For lua
				game.vocals.volume = 0;
				FlxG.switchState(OptionsState);
			case 4: 
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				Funkin.switchState(PlayState.isStoryMode ? StoryMenuState : FreeplayState);
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				PlayState.changedDifficulty = false;
				PlayState.chartingMode = false;
				FlxG.camera.followLerp = 0;
		}
	}
}
function changeSelection(id){
	FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	curSelected = FlxMath.wrap(curSelected+id, 0, grpMenuShit.length-1);
	for (item in grpMenuShit) {
		item.targetY = item.ID - curSelected;
		item.alpha = 0.6;
		if (item.targetY == 0) item.alpha = 1;
	}
}
function genat(){
	var contains = StringTools.contains;
	game.songSpeed = PlayState.SONG.speed;
	game.songSpeedType = ClientPrefs.getGameplaySetting('scrolltype');
	switch (songSpeedType) {
		case "multiplicative":
			game.songSpeed = PlayState.SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed');
		case "constant":
			game.songSpeed = ClientPrefs.getGameplaySetting('scrollspeed');
	}
	var songData = PlayState.SONG;
	// piece of shit
	for (i in game.hscriptArray){
		if (StringTools.startsWith(i.origin,"custom_note")) i.destroy();
	}
	var noteData:Array = [];
	noteData = songData.notes;
	var isDiffErect:Bool = Difficulty.getString().toLowerCase() == "erect" || Difficulty.getString().toLowerCase() == "nightmare";
	var file:String = Paths.getTextFromFile("data/" + songData.song + "/events" + (isDiffErect ? "-erect" : "") + ".json");
	game.eventNotes = [];
	if (file != null){
		var eventsData = Json.parse(file).events;
		for (event in eventsData) // Event Notes
			for (i in 0...event[1].length) {
				var subEvent:EventNote = {
					strumTime: event[0] + ClientPrefs.data.noteOffset,
					event: event[1][i][0],
					value1: event[1][i][1],
					value2: event[1][i][2]
				};
				game.eventNotes.push(subEvent);
			}
	}
	var noteTypes = [];
	final isPsychRelease = songData.format == "psych_v1";
	for (section in noteData) {
		for (notes in section.sectionNotes){
			var strumTime = notes[0];
			if (strumTime > lastTime) continue;
			var noteData = Std.int(notes[1]%4);
			var gottaHitNote = section.mustHitSection;
			if(!isPsychRelease){
				if(notes[1] > 3) gottaHitNote = !section.mustHitSection;
				
			} else {
				gottaHitNote = notes[1] < 4;
			}
			if (game.characterPlayingAsDad) gottaHitNote = !gottaHitNote;
			var oldNote = null;
			if (game.unspawnNotes.length > 0){
				oldNote = game.unspawnNotes[game.unspawnNotes.length - 1];
			}
			
			var note = new Note(strumTime, noteData, oldNote);
			note.sustainLength = notes[2];
			note.mustPress = gottaHitNote;
			note.gfNote = (section.gfSection && (notes[1] < 4));
			note.noteType = notes[3];
			if (!noteTypes.contains(note.noteType)) noteTypes.push(note.noteType);
			note.scrollFactor.set();
			game.unspawnNotes.push(note);
			var sus:Float = note.sustainLength / Conductor.stepCrochet;
			var sus:Int = Math.floor(sus);
			if (sus > 0) {
				for (susNote in 0...sus + 1) {
					oldNote = game.unspawnNotes[game.unspawnNotes.length - 1];
					var noteSussy = new Note(strumTime + (Conductor.stepCrochet * susNote), noteData, oldNote, true);
					noteSussy.mustPress = gottaHitNote;
					noteSussy.gfNote = (section.gfSection && (notes[1] < 4));
					noteSussy.noteType = note.noteType;
					noteSussy.scrollFactor.set();
					noteSussy.parent = note;
					game.unspawnNotes.push(noteSussy);
					note.tail.push(noteSussy);
					noteSussy.correctionOffset = note.height / 2;
					if (!PlayState.isPixelStage) {
						if (oldNote.isSustainNote) {
							oldNote.scale.y *= Note.SUSTAIN_SIZE / oldNote.frameHeight;
							oldNote.scale.y /= game.playbackRate;
							oldNote.updateHitbox();
						}
						if (ClientPrefs.data.downScroll)
							sustainNote.correctionOffset = 0;
					} else if (oldNote.isSustainNote) {
						oldNote.scale.y /= game.playbackRate;
						oldNote.updateHitbox();
					}
				}
			}
		}
	}
	game.unspawnNotes.sort(function(a,b) return a.strumTime - b.strumTime);
	for (event in songData.events) // Event Notes
		for (i in 0...event[1].length)
			for (i in 0...event[1].length) {
				var subEvent:EventNote = {
					strumTime: event[0] + ClientPrefs.data.noteOffset,
					event: event[1][i][0],
					value1: event[1][i][1],
					value2: event[1][i][2]
				};
				game.eventNotes.push(subEvent);
			}
	for (i in noteTypes){
		game.startHScriptsNamed("custom_notetypes/" + i);
	}
	game.generatedMusic = true;
}
function resetCharacterPosition(){
	var stageData = StageData.getStageFile(PlayState.curStage);
	game.defaultCamZoom = stageData.defaultZoom;
	game.boyfriendGroup.setPosition(stageData.boyfriend[0], stageData.boyfriend[1]);
	game.dadGroup.setPosition(stageData.opponent[0], stageData.opponent[1]);
	game.gfGroup.setPosition(stageData.girlfriend[0], stageData.girlfriend[1]);
	if (stageData.camera_speed != null)
		cameraSpeed = stageData.camera_speed;
	game.boyfriendCameraOffset = stageData.camera_boyfriend;
	if (game.boyfriendCameraOffset == null)
		game.boyfriendCameraOffset = [0, 0];
	game.opponentCameraOffset = stageData.camera_opponent;
	if (game.opponentCameraOffset == null)
		game.opponentCameraOffset = [0, 0];
	game.girlfriendCameraOffset = stageData.camera_girlfriend;
	if (game.girlfriendCameraOffset == null)
		game.girlfriendCameraOffset = [0, 0];
}