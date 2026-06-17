import objects.BGSprite;
import psychlua.ModchartSprite;
import psychlua.LuaUtils;
import flixel.math.FlxAngle;
import backend.Difficulty;


var littank = [];
var tankmonArrau= [];
var tankmonGroup;
var sniper;
var guy;
var animationNotes = [];
function onCreate(){
	var bg = new BGSprite("stages/tankmanBattlefield/erect/bg", -985, -809);
	bg.scale.set(1.15, 1.15);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	sniper = new ModchartSprite(-100, 350);
	LuaUtils.loadFrames(sniper, "stages/tankmanBattlefield/erect/sniper", "tex");
	sniper.anim.addBySymbol("idle", "sniper idle", 24, false);
	sniper.anim.addBySymbol("sip", "sniper sip", 24, false);
	sniper.playAnim("idle");
	sniper.scale.set(1.15, 1.15);
	sniper.updateHitbox();
	insert(members.indexOf(gfGroup), sniper);
	
	guy = new ModchartSprite(1400, 400);
	LuaUtils.loadFrames(guy, "stages/tankmanBattlefield/erect/rando", "tex");
	guy.anim.addBySymbol("idle", "rando", 24, false);
	guy.playAnim("idle");
	guy.scale.set(1.15, 1.15);
	guy.updateHitbox();
	insert(members.indexOf(gfGroup), guy);
	
	var bg = new BGSprite("stages/tankmanBattlefield/erect/bricksGround", 465, 760);
	bg.scale.set(1.15, 1.15);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup) + 1, bg);
	
	tankmonGroup = new FlxSpriteGroup();
	add(tankmonGroup);
}
function onCreatePost(){
	
	for (i in [boyfriend, gf, dad]) if (ClientPrefs.data.shaders) updateCharacterShader(i);
	if (Paths.getTextFromFile("data/" + PlayState.SONG.song + "/picospeaker" + Difficulty.getSongPrefix(null, true) + ".json") == null) return;
	var js = Json.parse(Paths.getTextFromFile("data/" + PlayState.SONG.song + "/picospeaker" + Difficulty.getSongPrefix(null, true)  + ".json"));
	if(js.song.song!=null)js=js.song;
	gf.playAnim("shoot1-loop", gf.skipDance = true);
	for (i in js.notes) {
		for (b in i.sectionNotes) {
			animationNotes.push(b);
		if (FlxG.random.bool(1 / 16 * 100)) littank.push({time: b[0], flip: (b[1] == 2 || b[1] == 3) ? true : false, speed: FlxG.random.float(0.6, 1), end: FlxG.random.float(50, 200)});
		}
	}
}
function onCountdownTick() bopDance();
function onBeatHit() bopDance();
function bopDance(){
	if (curBeat % 2 == 0){
		guy.playAnim("idle", true);
		if (sniper.anim.curAnim.name != "sip" || sniper.anim.curAnim.name == "sip" && sniper.anim.curAnim.finished) sniper.playAnim(FlxG.random.bool(2) ? "sip" : "idle", true);
	}
}
var tankMoving:Bool = false;
var tankAngle:Float = FlxG.random.int(-90, 45);
var tankSpeed:Float = FlxG.random.float(5, 7);
var tankX:Float = 400;
function onUpdate() {
	if (animationNotes.length > 0) {
		if (Conductor.songPosition >= animationNotes[0][0]) {
			gf.playAnim("shoot" + (animationNotes[0][1] + 1), true);
			animationNotes.shift();
		}
	}
	if (tankmonGroup.length > 0){
		for (i in tankmonGroup){
			if (tankmonArrau[i.ID].id == 1) {
				if (i.animation.curAnim.name == "run") {
					if (Conductor.songPosition > tankmonArrau[i.ID].time){ 
						i.animation.play("shot");
						i.offset.y = 200;
						i.offset.x = 300;
					}
					var runFactor = ((Conductor.songPosition - tankmonArrau[i.ID].time) * tankmonArrau[i.ID].speed);
					i.x = i.flipX ? ((FlxG.width * 0.02 - tankmonArrau[i.ID].ending) + runFactor) : ((FlxG.width * 0.74 + tankmonArrau[i.ID].ending) - runFactor);
				}
				if (i.animation.curAnim.name == "shot" && i.animation.curAnim.curFrame >= 10) {
					tankmonArrau[i.ID].id = 0;
					FlxFlicker.flicker(i, 0.3, 1 / 10, true, true, function(_) {
						FlxFlicker.flicker(i, 0.3, 1 / 20, false, true, function(_) {
							i.kill();
						});
					});
				}
			}
		}
	}
	var cutoff:Float = Conductor.songPosition + (1000 * 3);
	if (littank.length == 0) return;
	for (i in littank)
		if (i.time < cutoff) {
			createTank(350 + FlxG.random.int(50, 100), i);
			littank.remove(i);
		}
}
var ID = 0;
function createTank(y,data){
	var yankmon = new BGSprite("stages/tankmanBattlefield/tankmanKilled1", 9999, y, 1, 1, [""]);
	yankmon.animation.addByPrefix('run', 'tankman running', 24, true);
	yankmon.animation.addByPrefix('shot', 'John Shot ' + FlxG.random.int(1, 2), 24, false);
	yankmon.animation.play("run");
	yankmon.offset.set();
	yankmon.scale.set(1.1, 1.1);
	yankmon.flipX = data.flip;
	updateCharacterShader(yankmon);
	yankmon.ID = ID;
	tankmonGroup.add(yankmon);
	ID += 1;
	tankmonArrau.push({id: 1, time: data.time, speed: data.speed, ending: data.end});
}
function updateCharacterShader(char){
	var shader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/dropshadow.frag"));
	
	shader.setFloatArray("dropColor", [0.937254902, 1, 0.278431373]);
	shader.setFloat("brightness", -46);
	shader.setFloat("hue", -38);
	
	shader.setFloat("contrass", -25);
	shader.setFloat("saturation", -20);
	shader.setFloat("AA_STAGES", 2);
	shader.setFloat("dist", 15);
	shader.setFloat("ang", 90 * FlxAngle.TO_RAD);
	shader.setFloat("thr", 0.1);
	shader.setFloat("thr2", 1);
	shader.setFloat("str", 1);
	if (char.isAnimate) char.useRenderTexture = true;
	char.animation.onFrameChange.add(function(){
		shader.setFloatArray("uFrameBounds", [char.frame.uv.left, char.frame.uv.top, char.frame.uv.right, char.frame.uv.bottom]);
		shader.setFloat("angOffset", char.frame.angle * FlxAngle.TO_RAD);
	});
	// I don't want my phone died 
	char.shader = shader;
	switch(char){
		case gf:
			if (char.curCharacter == 'nene-tankmen') { shader.setBitmapData("altMask", Paths.image('stages/tankmanBattlefield/erect/masks/neneTankmen_mask').bitmap);
				shader.setBool("useMask", true);
			}
			if (char.curCharacter == 'gf-tankmen') { shader.setBitmapData("altMask", Paths.image('stages/tankmanBattlefield/erect/masks/gfTankmen_mask').bitmap);
				shader.setBool("useMask", true);
			}
			shader.setFloat("thr2", 0.4);
		case dad:
			shader.setFloat("thr", 0.3);
			shader.setFloat("ang", 25 * FlxAngle.TO_RAD);
			if (char.curCharacter == "tankman-bloody"){
				shader.setBitmapData("altMask", Paths.image('stages/tankmanBattlefield/erect/masks/tankmanCaptainBloody_mask').bitmap);
				shader.setBool("useMask", true);
			}
			
	}
}