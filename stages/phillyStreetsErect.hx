import objects.BGSprite;
import shaders.RuntimePostEffectShader;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxBasePoint;
import shaders.AdjustColorShader;
var scrollingSky;
var car1, car2, traffic;
var mist0,mist1,mist2,mist3,mist4,mist5;
var paper;
function onCreate(){
	
	
	var bg = new FlxSprite(-500, -1000).makeGraphic(1,1,0xFF8E9191);
	bg.scale.set(4000, 3000);
	bg.scrollFactor.set();
	bg.updateHitbox();
	insert(members.indexOf(gfGroup),bg);
	
	scrollingSky = new FlxBackdrop(Paths.image("stages/phillyStreets/phillyStreets/erect/phillySkybox"));
	insert(members.indexOf(gfGroup),scrollingSky);
	
	scrollingSky.setPosition(-650, -375);
	scrollingSky.scrollFactor.set(0.1, 0.1);
	scrollingSky.scale.set(0.65, 0.65);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillySkyline", -545, -273, 0.2, 0.2);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyForegroundCity", 1865, 220, 0.3, 0.3);
	bg.angle = 5;
	insert(members.indexOf(gfGroup),bg);
	
	mist5 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist5.setPosition(-650, -100);
	mist5.scrollFactor.set(0.5, 0.5);
	insert(members.indexOf(gfGroup),mist5);
	mist5.blend = 0;
	mist5.color = 0xFF5c5c5c;
	mist5.alpha = 1;
	mist5.velocity.x = 20;
	mist5.scale.set(1.1, 1.1);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyConstruction", 1800, 364, 0.7, 1);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyHighwayLights", 122, 201, 0.8, 0.8);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyHighwayLights_lightmap", 122, 201, 0.8, 0.8);
	bg.blend = 0;
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyHighway", -23, 105, 0.8, 0.8);
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillySmog", -6, 305, 0.8, 1);
	insert(members.indexOf(gfGroup),bg);
	
	car1 = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyCars", 1200, 818, 0.9, 1,["car1","car2","car3","car4"]);
	insert(members.indexOf(gfGroup),car1);
	
	car2 = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyCars", 1200, 818, 0.9, 1,["car1","car2","car3","car4"]);
	car2.flipX=true;
	insert(members.indexOf(gfGroup),car2);
	
	
	mist4 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistBack'), 0x01);
	mist4.setPosition(-650, -100);
	mist4.scrollFactor.set(0.8, 0.8);
	insert(members.indexOf(gfGroup),mist4);
	mist4.blend = 0;
	mist4.color = 0xFF5c5c5c;
	mist4.alpha = 1;
	mist4.velocity.x = 40;
	mist4.scale.set(0.7, 0.7);
	
	traffic = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyTraffic", 1840, 608, 0.9, 1,["redtogreen","greentored"]);
	insert(members.indexOf(gfGroup),traffic);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyTraffic_lightmap", 1840, 608, 0.9, 1);
	bg.blend = 0;
	insert(members.indexOf(gfGroup),bg);
	
	var bg = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyForeground", 88, 317);
	insert(members.indexOf(gfGroup),bg);
	
	mist3 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist3.setPosition(-650, -100);
	mist3.scrollFactor.set(0.95, 0.95);
	insert(members.indexOf(gfGroup),mist3);
	mist3.blend = 0;
	mist3.color = 0xFF5c5c5c;
	mist3.alpha = 0.5;
	mist3.velocity.x = -50;
	mist3.scale.set(0.8, 0.8);
	
	
	mist0 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist0.setPosition(-650, -100);
	mist0.scrollFactor.set(1.2, 1.2);
	add(mist0);
	mist0.blend = 0;
	mist0.color = 0xFF5c5c5c;
	mist0.alpha = 0.6;
	mist0.velocity.x = 172;
	
	mist1 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist1.setPosition(-650, -100);
	mist1.scrollFactor.set(1.1, 1.1);
	add(mist1);
	mist1.blend = 0;
	mist1.color = 0xFF5c5c5c;
	mist1.alpha = 0.6;
	mist1.velocity.x = 150;
	
	mist2 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistBack'), 0x01);
	mist2.setPosition(-650, -100);
	mist2.scrollFactor.set(1.2, 1.2);
	add(mist2);
	mist2.blend = 0;
	mist2.color = 0xFF5c5c5c;
	mist2.alpha = 0.8;
	mist2.velocity.x = -80;
	
	paper = new BGSprite("stages/pillyStreets/phillyStreets/erect/paper", 350, 608,1.1,1.1,["Paper Blowing instance 1"]);
	add(paper);
	
	paper.alpha = 0.001;
	
	if (ClientPrefs.data.lowQuality){
		for (i in [mist0,mist1,mist2,mist3,mist4,mist5]) remove(i);
	}

}
function onCreatePost() {
	var colorShader = new AdjustColorShader();
	colorShader.hue = -5;
	colorShader.saturation = -40;
	colorShader.contrast = -25;
	colorShader.brightness = -20;
	if (ClientPrefs.data.shaders) for (i in [dad, boyfriend, gf]) i.shader = colorShader;
}
var _timer:Float = 0;
function onUpdate(elap){
	_timer += elap;
	mist0.y = 660 + (Math.sin(_timer * 0.35) * 70);
	mist1.y = 500 + (Math.sin(_timer * 0.3) * 80);
	mist2.y = 540 + (Math.sin(_timer * 0.4) * 60);
	mist3.y = 230 + (Math.sin(_timer * 0.3) * 70);
	mist4.y = 170 + (Math.sin(_timer * 0.35) * 50);
	mist5.y = -80 + (Math.sin(_timer * 0.08) * 100);
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
var paperInterruptable = true;
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
	if (FlxG.random.bool(8) && paperInterruptable) {
	paper.alpha = 1;
	paper.dance();
	paper.y = 608 + FlxG.random.float(-150,150);
	paperInterruptable = false;
	new FlxTimer().start(2, function() {
		paperInterruptable = true;
		paper.alpha = 0;
	 	});
	}
}