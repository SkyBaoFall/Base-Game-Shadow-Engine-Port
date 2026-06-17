import flixel.addons.text.FlxTypeText;
import flixel.addons.display.FlxBackdrop;
import backend.Difficulty;
import haxe.Json;
import flixel.text.FlxTextBorderStyle;
import psychlua.ModchartSprite;
import psychlua.LuaUtils;
var swagDialogue;
var fadeTime = {
	alpha: 1,
	bg: 1,
	music: 1,
	end: 1
};
var endType = "fade";
var boxArray = [];
var charArray = [];
var dialogueList = null;
var bgGraphic;
var hasMusic = false;
function importCharacter(name) {
	if (Paths.getTextFromFile("images/dialogueCharacter/" + name + ".json") == null) return;
	var c = new Character(0, 0, "bf-pixel");
	var json = Json.parse(Paths.getTextFromFile("images/dialogueCharacter/" + name + ".json"));
	c.loadCharacterFile(json);
	c.cameras = [camOther];
	add(c);
	c.x = 640 + c.positionArray[0];
	c.y = 360 + c.positionArray[1];
	c.alpha = 0;
	charArray.push({name: name, sprite: c,json:json});
}
function importBox(name) {
	if (Paths.getTextFromFile("images/dialogueCharacter/box/" + name + ".json") == null) return;
	var c = new Character(0, 0, "bf-pixel");
	var json = Json.parse(Paths.getTextFromFile("images/dialogueCharacter/box/" + name + ".json"));
	c.loadCharacterFile(json);
	c.cameras = [camOther];
	add(c);
	c.x = 640 + c.positionArray[0];
	c.y = 360 + c.positionArray[1];
	c.alpha = 0;
	boxArray.push({name: name, sprite: c,json:json});
}
function startConversation() {
	new FlxTimer().start(1, function()startDialogue());
	loadFile();
}
function startDialogue() {
	game.camHUD.visible = false;
	FlxTween.tween(bgGraphic, {
		alpha: fadeTime.alpha
	}, fadeTime.bg);
	if (hasMusic) {
		FlxG.sound.music.play();
		FlxG.sound.music.fadeOut(fadeTime.music, 1);
	}
	nextDialogue();
	game.callOnScripts("onDialogueStart");
}
function loadFile() {
	var file = Paths.getTextFromFile("data/" + PlayState.SONG.song + "/dialogue" + Difficulty.getSongPrefix(null, true) + ".json");
	if (file == null) return;
	var boxed = [];
	var character = [];
	file = Json.parse(file);

	fadeTime.bg = file.backdrop.fadeTime;
	fadeTime.music = file.music.fadeTime;
	fadeTime.outro = file.outro.fadeTime;
	bgGraphic = new FlxBackdrop();
	switch (file.backdrop.type) {
		case "solid":
			bgGraphic.makeGraphic(1280, 720);
		default:
			bgGraphic.loadGraphic(Paths.image(file.backdrop.asset));
	}
	var color = file.backdrop.color;
	color = StringTools.replace(color, "0x", "");
	color = StringTools.replace(color, "#", "");
	var red = Std.parseInt("0x" + color.substr(2, 2));
	var green = Std.parseInt("0x"+ color.substr(4, 2));
	var blue = Std.parseInt("0x" + color.substr(6, 2));
	var alpha = Std.parseInt("0x" + color.substr(0, 2));
	bgGraphic.color = FlxColor.fromRGB(red, green, blue);
	fadeTime.alpha = alpha/255;
	bgGraphic.cameras = [camOther];
	bgGraphic.alpha = 0;
	add(bgGraphic);
	dialogueList = file.dialogue;
	
	for (i in file.dialogue) {
		if (!character.contains(i.speaker)) {
			character.push(i.speaker);
			importCharacter(i.speaker);
		}
	}
	for (i in file.dialogue){
		if (!boxed.contains(i.box)) {
			boxed.push(i.box);
			importBox(i.box);
		}
	}
	swagDialogue = new FlxTypeText();
	swagDialogue.cameras = [camOther];
	add(swagDialogue);
	if (file.music.asset != ""){
		FlxG.sound.playMusic(Paths.music(file.music.asset), 0, file.music.looped);
		FlxG.sound.music.pause();
		hasMusic = true;
	}
}
var current = 0;
var end = false;
var nextTimer = new FlxTimer();
function onUpdate() {
	if (dialogueList != null) {
		var enter = FlxG.keys.justPressed.ENTER || controls.ACCEPT;
		#if FEATURE_MOBILE_CONTROLS
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				enter = true;
			}
		}
		#end
		if (enter) {
			if (!nextTimer.finished)nextTimer.cancel();
			FlxG.sound.play(Paths.sound('weeb/textboxClick'), 0.8);
			if (dialogueList.length <= 0) {
				dialogueList = null;
				if (hasMusic) FlxG.sound.music.fadeOut(fadeTime.end, 0);
				game.inCutscene = false;
				for (i in boxArray) {
					i.sprite.playAnim("exit");
				}
				remove(swagDialogue);
				FlxTween.tween(bgGraphic, {
					alpha: 0
				}, fadeTime.end, {
					onComplete: () -> {
						remove(bgGraphic);
						for (i in boxArray) remove(i.sprite);
						for (i in charArray) remove(i.sprite);
						
					}});
				new FlxTimer().start(fadeTime.end + 0.2,
					function() {
						game.startCountdown();
						game.camHUD.visible = true;
					});
				game.callOnScripts("onDialogueEnd");
				return;
			}
			for (i in boxArray) {
				i.sprite.playAnim("click");
			}
			nextTimer.start(0.1, function() nextDialogue());
		}
	}
}
function nextDialogue() {
	var dialogue = dialogueList.shift();
	var text = "";
	var index = 0;
	for (i in dialogue.text) {
		if (index != 0) text += "\n";
		text += i;
		index += 1;
	}
	swagDialogue.resetText(text);
	for (i in charArray) {
		i.sprite.alpha = 0;
		if (i.name == dialogue.speaker) {
			i.sprite.alpha = 1;
			i.sprite.playAnim(dialogue.speakerAnimation);
		}
	}
	for (i in boxArray) {
		i.sprite.alpha = 0;
		i.sprite.anim.onFinish.removeAll();
		if (i.name == dialogue.box) {
			i.sprite.alpha = 1;
			i.sprite.playAnim(dialogue.boxAnimation);
			updateText(i.json.text);
			i.sprite.anim.onFinish.addOnce(function(animName) {
				if (swagDialogue != null)
					swagDialogue.start(0.04, true);
			});
			swagDialogue.completeCallback = () -> i.sprite.playAnim("wait");
		}
	}
	game.callOnScripts("onNextDialogue",
		[current]);
	current += 1;
}
function updateText(file){
	if (file.offsets == null) file.offsets = [0,0];
	if (file.width == null) file.width = 0;
	swagDialogue.setPosition(file.offsets[0], file.offsets[1]);
	swagDialogue.fieldWidth = file.width;
	var font = "Arial";
	if (file.fontFamily != null) font = file.fontFamily;
	else if (file.font != null) font = Paths.font(file.font);
	swagDialogue.setFormat(font, 32, FlxColor.fromString(file.color != null ? file.color : "#ffffff"), "left", FlxTextBorderStyle.SHADOW, FlxColor.fromString(file.shadowColor != null ? file.shadowColor : "#000000"));
	swagDialogue.borderSize = file.shadowWidth != null ? file.shadowWidth : 1;
	var soundList = [];
	if (file.sounds.length > 0 && file.sounds != null)
		for(i in file.sounds)
			soundList.push(FlxG.sound.load(Paths.sound(i)));
	swagDialogue.sounds = soundList;
	return;
}