import objects.BGSprite;
import flixel.addons.display.FlxBackdrop;
import shaders.AdjustColorShader;

var car;
var star;
var mist1,mist2,mist3,mist4,mist5;
var colorShader;
var henchmen; 
function onCreate(){
	var bg = new BGSprite("stages/limo/erect/limoSunset", -120, -50, 0.1, 0.1);
	insert(members.indexOf(gfGroup), bg);
	
		
	star = new BGSprite("stages/limo/erect/shooting star", 200, 0, 0.12, 0.12, ["shooting star"]);
	insert(members.indexOf(gfGroup), star);
	star.blend = 0;
	
	mist5 = new FlxBackdrop(Paths.image('stages/limo/erect/mistMid'), 0x01);
	mist5.setPosition(-650, -400);
	mist5.scrollFactor.set(0.2, 0.2);
	mist5.blend = 0;
	mist5.color = 0xFFE7A480;
	mist5.alpha = 1;
	mist5.velocity.x = 100;
	mist5.scale.set(1.5, 1.5);
	insert(members.indexOf(gfGroup), mist5);

	
	var bg = new BGSprite("stages/limo/erect/bgLimo", -200, 480, 0.4, 0.4, ["background limo blue"], true);
	insert(members.indexOf(gfGroup), bg);
	
	henchmen = new FlxSpriteGroup(100,100);
	henchmen.scrollFactor.set(0.4,0.4);
	for (i in 0...5){
		var sprite = new BGSprite("stages/limo/henchmen", 300 * i, 0, 0.4, 0.4, ["hench"]);
		sprite.animation.addByIndices("left","hench dancing",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],"",24,false);
		sprite.animation.addByIndices("right", "hench dancing", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],"",24, false);
		henchmen.add(sprite);
	}
	insert(members.indexOf(gfGroup), henchmen);
	
	mist4 = new FlxBackdrop(Paths.image('stages/limo/erect/mistBack'), 0x01);
	mist4.setPosition(-650, -380);
	mist4.scrollFactor.set(0.6, 0.6);
	mist4.blend = 0;
	mist4.color = 0xFF9c77c7;
	mist4.alpha = 1;
	mist4.velocity.x = 700;
	mist4.scale.set(1.5, 1.5);
	insert(members.indexOf(gfGroup), mist4);
	
	mist3 = new FlxBackdrop(Paths.image('stages/limo/erect/mistMid'), 0x01);
	mist3.setPosition(-650, -100);
	mist3.scrollFactor.set(0.8, 0.8);
	mist3.blend = 0;
	mist3.color = 0xFFa7d9be;
	mist3.alpha = 0.5;
	mist3.velocity.x = 900;
	mist3.scale.set(1.5, 1.5);
	insert(members.indexOf(gfGroup), mist3);

	
	var bg = new BGSprite("stages/limo/erect/limoDrive", -128, 528, 1, 1, ["Limo stage"], true);
	insert(members.indexOf(gfGroup) + 1, bg);
	
	mist1 = new FlxBackdrop(Paths.image('stages/limo/erect/mistMid'), 0x01);
	mist1.setPosition(-650, -100);
	mist1.scrollFactor.set(1.1, 1.1);
	mist1.blend = 0;
	mist1.color = 0xFFc6bfde;
	mist1.alpha = 0.4;
	mist1.velocity.x = 1700;
	mist1.scale.set(1.3, 1.3);
	add(mist1);
	
	mist2 = new FlxBackdrop(Paths.image('stages/limo/erect/mistBack'), 0x01);
	mist2.setPosition(-650, -100);
	mist2.scrollFactor.set(1.2, 1.2);
	mist2.blend = 0;
	mist2.color = 0xFF6a4da1;
	mist2.alpha = 1;
	mist2.velocity.x = 2100;
	add(mist2);
	
	car = new BGSprite("stages/limo/fastCar", -12600, 160);
	add(car);
	if (ClientPrefs.data.lowQuality){
		for (i in [mist1,mist2,mist3,mist4,mist5]) remove(i);
	}
}
var shootingStarBeat:Int = 0;
var shootingStarOffset:Int = 2;
var _timer = 0;
function onCreatePost(){
	colorShader = new AdjustColorShader();
	colorShader.hue = -30;
	colorShader.saturation = -20;
	colorShader.contrast = 0;
	colorShader.brightness = -30;
	if (!ClientPrefs.data.shaders) return;
	for (i in henchmen) i.shader = colorShader;
	for(i in[dad,boyfriend,gf])i.shader=colorShader;
}
function onUpdate(elapsed) {
	_timer += elapsed;
	mist1.y = 100 + (Math.sin(_timer) * 200);
	mist2.y = 0 + (Math.sin(_timer * 0.8) * 100);
	mist3.y = -20 + (Math.sin(_timer * 0.5) * 200);
	mist4.y = -180 + (Math.sin(_timer * 0.4) * 300);
	mist5.y = -450 + (Math.sin(_timer * 0.2) * 150);
}
function doShootingStar(beat:Int) {
	star.x = FlxG.random.int(50, 900);
	star.y = FlxG.random.int(-10, 20);
	star.flipX = FlxG.random.bool(50);
	star.dance();

	shootingStarBeat = beat;
	shootingStarOffset = FlxG.random.int(4, 8);
}
var car_can_pass = true;
function carGoInto300Kilometer(){
	FlxG.sound.play(Paths.sound("limo/carPass" + FlxG.random.int(0, 1)));
	car.x = -12600;
	car.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
	car_can_pass = false;
	new FlxTimer().start(2, function() {
		car_can_pass = true;
		car.velocity.x = 0;
	});
}
function onBeatHit() {
	if (FlxG.random.bool(10) && car_can_pass) carGoInto300Kilometer();
	for (i in henchmen) i.animation.play(curBeat % 2 == 0 ? "right" : "left");
	if (FlxG.random.bool(10) && curBeat > (shootingStarBeat + shootingStarOffset)) doShootingStar(curBeat);
}
function onCountdownTick(t) for (i in henchmen) i.animation.play(t % 2 == 0 ? "right" : "left");