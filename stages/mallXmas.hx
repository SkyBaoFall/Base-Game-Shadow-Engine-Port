import objects.BGSprite;

var bopperShit;
function onCreate() {
	var bg = new BGSprite("stages/christmas/bgWalls", -726, -566, 0.2, 0.2);
	bg.scale.set(0.8, 0.8);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var upper = new BGSprite("stages/christmas/upperBop", -396, -98, 0.28, 0.28, ["Upper Crowd Bob"]);
	upper.scale.set(0.85, 0.85);
	upper.updateHitbox();
	insert(members.indexOf(gfGroup), upper);
	
	var bg = new BGSprite("stages/christmas/bgEscalator", -1100, -540, 0.3, 0.3);
	bg.scale.set(0.9, 0.9);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/christmas/christmasTree", 370, -250, 0.4, 0.4);
	insert(members.indexOf(gfGroup), bg);
	
	var botom = new BGSprite("stages/christmas/bottomBop", -300, 120,0.9,0.9,["Bottom Level Boppers"]);
	botom.scale.set(0.9, 0.9);
	botom.updateHitbox();
	insert(members.indexOf(gfGroup), botom);
	
	
	var bg = new BGSprite("stages/christmas/fgSnow", -1350, 680);
	bg.scale.set(1.1, 1);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new FlxSprite(-1500, 800).makeGraphic(1,1,0xFFF3F4F5);
	bg.scale.set(5700, 3000);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	santa = new BGSprite("stages/christmas/santa", -840, 100, 1, 1, ["santa idle in fear"]);
	santa.updateHitbox();
	add(santa);
	setVar("satan", santa);
	bopperShit = () -> {
		botom.dance(true);
		upper.dance(true);
		santa.dance(true);
	};
	
	bopperShit();
}
function onBeatHit(){
	bopperShit();
}
function onCountdownTick(){
	bopperShit();
}