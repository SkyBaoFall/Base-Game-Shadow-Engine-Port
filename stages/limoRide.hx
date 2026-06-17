import objects.BGSprite;
var car;
var henchmen; 
function onCreate(){
	var bg = new BGSprite("stages/limo/limoSunset", -120, -50, 0.1, 0.1);
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/limo/bgLimo", -200, 480, 0.4, 0.4, ["background limo pink"], true);
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
	
	var bg = new BGSprite("stages/limo/limoDrive", -128, 528, 1, 1, ["Limo stage"], true);
	insert(members.indexOf(gfGroup) + 1, bg);
	
	car = new BGSprite("stages/limo/fastCar", -12600, 160);
	add(car);
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
}
function onCountdownTick(t) for (i in henchmen) i.animation.play(t % 2 == 0 ? "right" : "left");