import funkin.vis.dsp.SpectralAnalyzer;
import psychlua.ModchartSprite;
import psychlua.LuaUtils;
import objects.BGSprite;
import backend.CoolUtil;

var analyzer;
var add = false;
var neneAbot;
var stereoBG;
var visSystem;
var eyeWhites;
var pupil;
function onCreate() {
	neneAbot = new ModchartSprite();
	LuaUtils.loadFrames(neneAbot, "characters/abot/abotSystem", "tex");
	neneAbot.anim.addBySymbol("idle", "Abot System", 24, false);
	visSystem = new FlxSpriteGroup();
	for (i in 0...7){
		var x = [0,59,115,181,235,287,338][i];
		var y = [0,-8,-11.5,-11.9,-11.4,-4.4,3.6][i];
		var newHs = new BGSprite("characters/abot/aBotViz", x, y, 1, 1, ["viz" + (i+1)]);
		visSystem.add(newHs);
	}
	stereoBG = new BGSprite("characters/abot/stereoBG");
	eyeWhites = new FlxSprite().makeGraphic(160,60);
	
	pupil = new ModchartSprite();
	LuaUtils.loadFrames(pupil, "characters/abot/systemEyes", "tex");
	pupil.anim.addBySymbolIndices("left", "a bot eyes lookin", CoolUtil.numberArray(16), 24, false);
	pupil.anim.addBySymbolIndices("right","a bot eyes lookin",CoolUtil.numberArray(32,17),24, false);
}
/*
-- normal 
-- raise knife
-- holding knife
-- throw at pico (I lazy to do)
*/
var levels = [{value:0},{value:0},{value:0},{value:0},{value:0},{value:0},{value:0}];
function onSongStart(){
	initAudioSource();
}
var curTarget = 1;
function onUpdatePost(elapsed) {
	if (!add){
		//easier to use than fucking instance add
		gfGroup.insert(0, neneAbot);
		gfGroup.insert(0, visSystem);
		gfGroup.insert(0, stereoBG);
		gfGroup.insert(0, pupil);
		gfGroup.insert(0, eyeWhites);
		add = true;
	}
	if (game.camFollow.x < (game.gf.getMidpoint().x - 30) && curTarget != 0){
		curTarget = 0;
		pupil.playAnim("left");
	}
	if (game.camFollow.x > (game.gf.getMidpoint().x + 30) && curTarget != 1) {
		curTarget = 1;
		pupil.playAnim("right");
	}
	for (i in [neneAbot,eyeWhites,pupil,stereoBG]) {
		i.shader = game.gf.shader;
		i.color = game.gf.color;
	}
	neneAbot.setPosition(game.gf.x - 80, game.gf.y + 329);
	visSystem.setPosition(neneAbot.x + 207, neneAbot.y + 94);
	eyeWhites.setPosition(neneAbot.x + 40, neneAbot.y + 230);
	pupil.setPosition(neneAbot.x + 50, neneAbot.y + 238);
	stereoBG.setPosition(neneAbot.x + 150, neneAbot.y + 30);
	if (FlxG.sound.music != null && analyzer != null){
		levels = (FlxG.sound.music.volume == 0 || FlxG.sound.mute) ? [{value:0},{value:0},{value:0},{value:0},{value:0},{value:0},{value:0}] : analyzer.getLevels(levels);
	}
	for (i in 0...visSystem.length){
		var vis = visSystem.members[i];
		var visible = levels[i].value > 0;
		var level = Math.round(levels[i].value*6);
		level = Math.abs(level - 6);
		vis.animation.curAnim.curFrame = level;
		vis.visible = visible;
	}
}
function initAudioSource(){
	analyzer = new SpectralAnalyzer(FlxG.sound.music._channel.__audioSource, 7, 0.1, 40);
	analyzer.minDb = -65;
	analyzer.maxDb = -25;
	analyzer.maxFreq = 22000;
	analyzer.minFreq = 10;
	analyzer.fftN = 256;
}
function onBeatHit() neneAbot.playAnim("idle",true);