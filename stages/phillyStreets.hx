import objects.BGSprite;
import shaders.RuntimePostEffectShader;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxBasePoint;
import backend.CoolUtil;
import psychlua.ModchartSprite;
import psychlua.LuaUtils;
var scrollingSky;
var car1, car2, traffic;
var propDark;
var canEnabled = false;
var spraycanAtlas;
var explodeEz;
var explode;
function onCreate(){
	
	
	var bg = new FlxSprite(-500, -1000).makeGraphic(1,1,0xFF8E9191);
	bg.scale.set(4000, 3000);
	bg.scrollFactor.set();
	bg.updateHitbox();
	insert(members.indexOf(gfGroup),bg);
	
	scrollingSky = new FlxBackdrop(Paths.image("stages/phillyStreets/phillyStreets/phillySkybox"));
	insert(members.indexOf(gfGroup),scrollingSky);
	
	scrollingSky.setPosition(-650, -375);
	scrollingSky.scrollFactor.set(0.1, 0.1);
	scrollingSky.scale.set(0.65, 0.65);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillySkyline", -545, -273, 0.2, 0.2);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillyForegroundCity", 1865, 220, 0.3, 0.3);
	bg.angle = 5;
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillyConstruction", 1800, 364, 0.7, 1);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillyHighwayLights", 122, 201, 0.8, 0.8);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillyHighwayLights_lightmap", 122, 201, 0.8, 0.8);
	bg.blend = 0;
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillyHighway", -23, 105, 0.8, 0.8);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillySmog", -6, 305, 0.8, 1);
	insert(members.indexOf(gfGroup),bg);
	
	car1 = new BGSprite("stages/phillyStreets/phillyStreets/phillyCars", 1200, 818, 0.9, 1,["car1","car2","car3","car4"]);
	insert(members.indexOf(gfGroup),car1);
	
	car2 = new BGSprite("stages/phillyStreets/phillyStreets/phillyCars", 1200, 818, 0.9, 1,["car1","car2","car3","car4"]);
	car2.flipX=true;
	insert(members.indexOf(gfGroup),car2);
	
	traffic = new BGSprite("stages/phillyStreets/phillyStreets/phillyTraffic", 1840, 608, 0.9, 1,["redtogreen","greentored"]);
	insert(members.indexOf(gfGroup),traffic);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillyTraffic_lightmap", 1840, 608, 0.9, 1);
	bg.blend = 0;
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/phillyForeground", 88, 317);
	insert(members.indexOf(gfGroup),bg);
	
	
	propDark = new FlxSprite(-500, -1000).makeGraphic(1,1,0xFF000000);
	propDark.scale.set(5000, 5000);
	propDark.updateHitbox();
	propDark.alpha = 0;
	insert(members.indexOf(gfGroup),propDark);
	
	
	spraycanAtlas = new ModchartSprite(910, 495);
	LuaUtils.loadFrames(spraycanAtlas, "stages/phillyStreets/spraycanAtlas", "tex");
	
	spraycanAtlas.anim.addBySymbolIndices("start", "Can with Labels", CoolUtil.numberArray(18), 24, false);
	spraycanAtlas.anim.addBySymbolIndices("hit", "Can with Labels", CoolUtil.numberArray(25,19), 24, false);
	spraycanAtlas.anim.addBySymbolIndices("shot", "Can with Labels", CoolUtil.numberArray(42,26), 24, false);
	spraycanAtlas.visible = false;
	
	add(spraycanAtlas);
	
	explode = new FlxSprite(1060, 245);
	explode.frames = Paths.getSparrowAtlas("stages/phillyStreets/SpraypaintExplosion");
	explode.animation.addByPrefix("idle", "Explosion 1 movie0", 24, false);
	explode.animation.play("idle");
	explode.visible = false;
	explode.animation.finishCallback = (name) -> {
		explode.visible = false;
	};
	add(explode);
	
	explodeEZ = new FlxSprite(1660 , 395);
	explodeEZ.frames = Paths.getSparrowAtlas("stages/phillyStreets/spraypaintExplosionEZ");
	explodeEZ.animation.addByPrefix("idle", "explosion round 1 short0", 24, false);
	explodeEZ.animation.play("idle");
	explodeEZ.visible = false;
	add(explodeEZ);
	explodeEZ.animation.finishCallback = (name) -> { explodeEZ.visible = false;
	};
	
	spraycanAtlas.anim.finishCallback = finishCanAnimation;
	spraycanAtlas.anim.onFrameChange.add(onCanFrame);

	
	var bg = new BGSprite("stages/phillyStreets/SpraycanPile", 920, 1045);
	add(bg);
}
var rainShader;
var rainShaderStartIntensity = 0;
var rainShaderEndIntensity = 0;
function onCreatePost(){
	rainShader = new RuntimePostEffectShader(Paths.getTextFromFile("shaders/rain.frag"));
	rainShader.setFloatArray("uRainColor", [0.4,0.501960784, 0.8]);
	rainShader.setFloat("uScale", FlxG.height / 200);
	rainShader.setFloat('uPuddleScaleY', 0);
	
	rainShader.setFloat("uTime", 0);
	
	if (ClientPrefs.data.shaders) FlxG.camera.filters = [new ShaderFilter(rainShader)];
	switch(game.curSong){
		case "darnell":
			rainShaderStartIntensity = 0;
			rainShaderEndIntensity = 0.1;
		case "lit-up":
			rainShaderStartIntensity = 0.1;
			rainShaderEndIntensity = 0.2;
		case "2hot":
			rainShaderStartIntensity = 0.2;
			rainShaderEndIntensity = 0.4;
		default:
			rainShaderStartIntensity = 0.2;
			rainShaderEndIntensity = 0.2;
	}
}
var uTime = 0;
function onUpdatePost(elap){
	rainShader.setFloat("uIntensity", FlxMath.lerp(rainShaderStartIntensity, rainShaderEndIntensity, game.songPercent));
	scrollingSky.x -= elap * 22;
	uTime += elap;
	rainShader.setFloat("uTime", uTime);
	rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
}
var lightsStop:Bool = false;
var lastChange:Int = 0;
var changeInterval:Int = 8;
var carWaiting:Bool = false;
var carInterruptable:Bool = true;
var car2Interruptable:Bool = true;
function changeLights(beat:Int) {
	lastChange = beat;
	lightsStop = !lightsStop;
	if (lightsStop) {
		traffic.animation.play('greentored');
		changeInterval = 20;
	} else {
		traffic.animation.play('redtogreen');
		changeInterval = 30;
		if (carWaiting == true) finishCarLights(car1);
	}
}
function resetCar(left:Bool, right:Bool) {
	if (left) {
		carWaiting = false;
		carInterruptable = true;
		FlxTween.cancelTweensOf(car1);
		car1.x = 1200;
		car1.y = 818;
		car1.angle = 0;
	}
	if (right) {
		car2Interruptable = true;
		FlxTween.cancelTweensOf(car2);
		car2.x = 1200;
		car2.y = 818;
		car2.angle = 0;
	}
}
function finishCarLights(sprite) {
	carWaiting = false;
	var duration:Float = FlxG.random.float(1.8, 3);
	var rotations:Array<Int> = [-5, 18];
	var offset:Array<Float> = [306.6, 168.3];
	var startdelay:Float = FlxG.random.float(0.2, 1.2);
	
	var path = [FlxBasePoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15), FlxBasePoint.get(2400 - offset[0], 980 - offset[1] - 50), FlxBasePoint.get(3102 - offset[0], 1187 - offset[1] + 40)];

	FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.sineIn, startDelay: startdelay});
	FlxTween.quadPath(sprite, path, duration, true, {ease: FlxEase.sineIn,startDelay: startdelay,onComplete: function(_){
			carInterruptable = true;
		}
	});
}
function driveCarLights(sprite) {
	carInterruptable = false;
	FlxTween.cancelTweensOf(sprite);
	var variant:Int = FlxG.random.int(1, 4);
	sprite.animation.play('car' + variant);
	var extraOffset = [0, 0];
	var duration:Float = 2;
	switch (variant) {
		case 1:
			duration = FlxG.random.float(1, 1.7);
		case 2:
			extraOffset = [20, -15];
			duration = FlxG.random.float(0.9, 1.5);
		case 3:
			extraOffset = [30, 50];
			duration = FlxG.random.float(1.5, 2.5);
		case 4:
			extraOffset = [10, 60];
			duration = FlxG.random.float(1.5, 2.5);
	}
	var rotations:Array<Int> = [-7, -5];
	var offset:Array<Float> = [306.6, 168.3];
	sprite.offset.set(extraOffset[0], extraOffset[1]);
	var path = [FlxBasePoint.get(1500 - offset[0] - 20,1049 - offset[1] - 20), FlxBasePoint.get(1770 - offset[0] - 80, 994 - offset[1] + 10), FlxBasePoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15)];
	FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.cubeOut});
	FlxTween.quadPath(sprite, path, duration, true, {ease: FlxEase.cubeOut,onComplete: function(_){
		carWaiting = true;
		if (lightsStop == false) finishCarLights(car1);}
	});
}
function driveCar(sprite) {
	carInterruptable = false;
	FlxTween.cancelTweensOf(sprite);
	var variant:Int = FlxG.random.int(1, 4);
	sprite.animation.play('car' + variant);
	var extraOffset = [0, 0];
	var duration:Float = 2;
	switch (variant) {
		case 1:
			duration = FlxG.random.float(1, 1.7);
		case 2:
			extraOffset = [20, -15];
			duration = FlxG.random.float(0.6, 1.2);
		case 3:
			extraOffset = [30, 50];
			duration = FlxG.random.float(1.5, 2.5);
		case 4:
			extraOffset = [10, 60];
			duration = FlxG.random.float(1.5, 2.5);
	}
	var offset:Array<Float> = [306.6, 168.3];
	sprite.offset.set(extraOffset[0], extraOffset[1]);
	var rotations:Array<Int> = [-8, 18];
	var path = [FlxBasePoint.get(1570 - offset[0], 1049 - offset[1] - 30), FlxBasePoint.get(2400 - offset[0], 980 - offset[1] - 50), FlxBasePoint.get(3102 - offset[0], 1187 - offset[1] + 40)];
	FlxTween.angle(sprite, rotations[0], rotations[1], duration, null);
	FlxTween.quadPath(sprite, path, duration, true, {onComplete: function(_) {
			carInterruptable = true;
		}
	});
}
function driveCarBack(sprite) {
	car2Interruptable = false;
	FlxTween.cancelTweensOf(sprite);
	var variant:Int = FlxG.random.int(1, 4);
	sprite.animation.play('car' + variant);
	var extraOffset = [0, 0];
	var duration:Float = 2;
	switch (variant) {
		case 1:
			duration = FlxG.random.float(1, 1.7);
		case 2:
			extraOffset = [20, -15];
			duration = FlxG.random.float(0.6, 1.2);
		case 3:
			extraOffset = [30, 50];
			duration = FlxG.random.float(1.5, 2.5);
		case 4:
			extraOffset = [10, 60];
			duration = FlxG.random.float(1.5, 2.5);
	}
	var offset:Array<Float> = [306.6, 168.3];
	sprite.offset.set(extraOffset[0], extraOffset[1]);
	var rotations:Array<Int> = [18, -8];
	var path = [FlxBasePoint.get(3102 - offset[0], 1127 - offset[1] + 60), FlxBasePoint.get(2400 - offset[0], 980 - offset[1] - 30), FlxBasePoint.get(1570 - offset[0], 1049 - offset[1] - 10)];
	FlxTween.angle(sprite, rotations[0], rotations[1], duration, null);
	FlxTween.quadPath(sprite, path, duration, true, {onComplete: function(_) {
			car2Interruptable = true;
		}
	});
}
function onSongRestart() {
	lastChange = 0;
}
function onBeatHit() {
	if (FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && carInterruptable == true)
	{
		if (lightsStop == false) {
			driveCar(car1);
		} else {
			driveCarLights(car1);
		}
	}
	if (FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && car2Interruptable == true && lightsStop == false) driveCarBack(car2);
	if (curBeat == (lastChange + changeInterval)) changeLights(curBeat);
}
function finishCanAnimation(name){
	if (!canEnabled) return;
	switch(name){
		case "start":
			spraycanAtlas.anim.play("hit");
		case "hit":
			spraycanAtlas.visible = false;
			explodeEZ.visible = true;
			explodeEZ.animation.play("idle",true);
			game.health -= 0.7;
			boyfriend.playAnim("hitCan",boyfriend.specialAnim=true);
		case "shot":
			spraycanAtlas.visible = false;
	}
}
function onCanFrame(name, frameNumber, frameIndex) {
	if (frameNumber == 3 && name == "shot") {
		explode.visible = true;
		explode.animation.play("idle",true);
	}
}
var canShootCan = false;
function goodNoteHit(note){
	switch(note.noteType){
		case "weekend-1-cockgun":
			canShootCan = true;
			boyfriend.playAnim("reload");
			boyfriend.specialAnim=true;
			FlxG.sound.play(Paths.sound("phillyStreets/Gun_Prep"));
		case "weekend-1-firegun":
			if (canShootCan){
				shootCan();
				
			}
			canShootCan = false;
	}
}
function startCan(){
	spraycanAtlas.anim.play("start",true);
	spraycanAtlas.visible = true;
	canEnabled = true;
}
function shootCan(){
	spraycanAtlas.anim.play("shot",true);
	FlxG.sound.play(Paths.sound("phillyStreets/shot" + FlxG.random.int(1, 4)));
	boyfriend.playAnim("shoot");
	boyfriend.specialAnim=true;
	propDark.alpha = 0.3;
	FlxTween.tween(propDark, {alpha: 0}, 1.4, {startDelay: 1/24});
}
function opponentNoteHit(note){
	switch(note.noteType){
		case "weekend-1-lightcan":
			dad.playAnim("lightcan");
			dad.specialAnim=true;
			
		case "weekend-1-kickcan":
			dad.playAnim("kickcan");
			dad.specialAnim=true;
			startCan();
		case "weekend-1-kneecan":
			dad.playAnim("kneecan");
			dad.specialAnim=true;
	}
}