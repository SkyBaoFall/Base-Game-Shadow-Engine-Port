import objects.BGSprite;
import flixel.math.FlxAngle;
import haxe.Json;
import flixel.effects.FlxFlicker;
import backend.Difficulty;
var tankmonGroup;
var tankmonArrau = [];
var tankRolling;
var bopDance;
function onCreate(){
	var bg = new FlxSprite(-500, -1000).makeGraphic(1,1, 0xFFE3A26D);
	bg.scale.set(2400, 2000);
	bg.scrollFactor.set();
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/tankSky", -1000, -400, 0, 0);
	bg.scale.set(3000, 1);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/tankClouds", 0,0, 0.4, 0.4);
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/mountains2", -500, -35, 0.2, 0.2);
	bg.scale.set(1.2,1.2);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/tankBuildings", -260, -35, 0.3, 0.3);
	bg.scale.set(1.2,1.2);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/cityruins2", -200, 150, 0.35, 0.35);
	bg.scale.set(1.1,1.1);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/smokeLeft", -380,-40, 0.4, 0.4, ["SmokeBlurLeft"], true);
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/smokeRight", 1050,-35, 0.4, 0.4, ["SmokeRight"], true);
	insert(members.indexOf(gfGroup), bg);
	
	var watcher = new BGSprite("stages/tankmanBattlefield/tankWatchtower", -35, 110, 0.5, 0.5, ["watchtower gradient color"]);
	watcher.scale.set(0.85,0.85);
	watcher.updateHitbox();
	insert(members.indexOf(gfGroup), watcher);
	
	tankRolling = new BGSprite("stages/tankmanBattlefield/tankRolling", 300,300, 0.5, 0.5, ["BG tank w lighting"], true);
	insert(members.indexOf(gfGroup), tankRolling);
	
	var bg = new BGSprite("stages/tankmanBattlefield/tankGround", -420,-150);
	bg.scale.set(1.15, 1.15);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/tankmanBattlefield/bricksGround", -420,-150);
	bg.scale.set(1.15, 1.15);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup) + 1, bg);
	
	tankmonGroup = new FlxSpriteGroup();
	insert(members.indexOf(gfGroup), tankmonGroup);
	
	var tank0 = new BGSprite("stages/tankmanBattlefield/tank0", -500, 650, 1.7, 1.5, ["fg tankhead far right instance 1"]);
	add(tank0);
	
	var tank2 = new BGSprite("stages/tankmanBattlefield/tank2", 360, 980, 1.5, 1.5, ["foreground man 3 instance 1"]);
	add(tank2);
	
	var tank5 = new BGSprite("stages/tankmanBattlefield/tank5", 1550, 700, 1.5, 1.5, ["fg tankhead far right instance 1"]);
	add(tank5);
	
	var tank4 = new BGSprite("stages/tankmanBattlefield/tank4", 1200, 900, 1.5, 1.5, ["fg tankman bobbin 3 instance 1"]);
	add(tank4);
	
	var tank3 = new BGSprite("stages/tankmanBattlefield/tank3", 1050, 1240, 3.5, 2.5, ["fg tankhead 4 instance 1"]);
	add(tank3);
	
	var tank1 = new BGSprite("stages/tankmanBattlefield/tank1", -300, 750, 2, 0.2, ["fg tankhead 5 instance 1"]);
	add(tank1);
	
	bopDance = function() {
		tank0.dance(true);
		tank1.dance(true);
		tank2.dance(true);
		tank4.dance(true);
		tank3.dance(true);
		tank5.dance(true);
		watcher.dance(true);
	}
	moveTank();
	bopDance();
}
var animationNotes = [];
var littank = [];
function onBeatHit() bopDance();
function onCountdownTick() bopDance();
function onCreatePost(){
	if (Paths.getTextFromFile("data/" + PlayState.SONG.song + "/picospeaker" + Difficulty.getSongPrefix(null, true)  + ".json") == null) return;
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
var tankMoving:Bool = false;
var tankAngle:Float = FlxG.random.int(-90, 45);
var tankSpeed:Float = FlxG.random.float(5, 7);
var tankX:Float = 400;
function onUpdate() {
	moveTank();
	updateShooting();
}
function updateShooting(){
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
			createTank(200 + FlxG.random.int(50, 100), i);
			littank.remove(i);
		}
}
function moveTank(){
	var daAngleOffset:Float = 1;
	tankAngle += FlxG.elapsed * tankSpeed;
	tankRolling.angle = tankAngle - 90 + 15;
	tankRolling.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
	tankRolling.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
}
var ID = 0;
function createTank(y,data){
	var yankmon = new BGSprite("stages/tankmanBattlefield/tankmanKilled1", 9999, y, 1, 1, [""]);
	yankmon.animation.addByPrefix('run', 'tankman running', 24, true);
	yankmon.animation.addByPrefix('shot', 'John Shot ' + FlxG.random.int(1, 2), 24, false);
	yankmon.animation.play("run");
	yankmon.offset.set();
	yankmon.flipX = data.flip;
	yankmon.ID = ID;
	tankmonGroup.add(yankmon);
	ID += 1;
	tankmonArrau.push({id: 1, time: data.time, speed: data.speed, ending: data.end});
}