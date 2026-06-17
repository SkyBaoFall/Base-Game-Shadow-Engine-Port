import psychlua.ModchartSprite;
import psychlua.LuaUtils;
var bg;
function onCreate() {
	bg = new ModchartSprite(-395, -505);
	LuaUtils.loadFrames(bg, "stages/spookyMansion/halloween_bg", "tex");
	bg.anim.addBySymbol("light", "halloweem bg lightning strike", 24, false);
	bg.anim.play("light", true, false, 34);
	insert(members.indexOf(gfGroup), bg);
}
var lightningStrikeBeat:Int = 0;
var lightningStrikeOffset:Int = 8;
function onSongRestart() {
	lightningStrikeBeat = 0;
}
function onBeatHit(){
	if (curBeat == 4&&PlayState.SONG.song == "spookeez") doLightningStrike(false, curBeat);
	if (FlxG.random.bool(10) && curBeat > (lightningStrikeBeat + lightningStrikeOffset)) doLightningStrike(true, curBeat);
}
function doLightningStrike(playSound, beat) {
	if (playSound) {
		FlxG.sound.play(Paths.sound("spookyMansion/thunder_" + FlxG.random.int(8, 24)));
	}
	bg.anim.play("light");
	lightningStrikeBeat = beat;
	lightningStrikeOffset = FlxG.random.int(8, 24);
	boyfriend.animation.play("scared", boyfriend.specialAnim = true);
	gf.animation.play("scared", gf.specialAnim = true);
}