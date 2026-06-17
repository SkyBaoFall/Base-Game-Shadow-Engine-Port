import objects.BGSprite;
import psychlua.ModchartSprite;
import psychlua.LuaUtils;
import shaders.AdjustColorShader;

var bopperShit;
function onCreate() {
	var shader = new AdjustColorShader();
	shader.hue = 15;
    shader.brightness = 20;
	var bg = new BGSprite("stages/christmas/erect/bgWalls", -726, -566, 0.2, 0.2);
	bg.scale.set(0.8, 0.8);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var upper = new BGSprite("stages/christmas/erect/upperBop", -374, -98, 0.28, 0.28, ["upperBop"]);
	upper.scale.set(0.85, 0.85);
	upper.updateHitbox();
	insert(members.indexOf(gfGroup), upper);
	
	var bg = new BGSprite("stages/christmas/erect/bgEscalator", -1100, -540, 0.3, 0.3);
	bg.scale.set(0.9, 0.9);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/christmas/erect/christmasTree", 370, -250, 0.4, 0.4);
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/christmas/erect/white", -1000, 100, 0.85, 0.85);
	bg.scale.set(0.9, 0.9);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var botom = new ModchartSprite(-300, -170);
	LuaUtils.loadFrames(botom, "stages/christmas/erect/bottomBop", "tex");
	botom.anim.addBySymbol("idle", "BOPPERS_EXPORT", 24, false);
	botom.applyStageMatrix = true;
	botom.scrollFactor.set(0.9, 0.9);
	botom.scale.set(0.9, 0.9);
	botom.updateHitbox();
	if (ClientPrefs.data.shaders) botom.shader = shader;
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
	// for cutscene
	setVar("satan", santa);
	bopperShit = () -> {
		botom.animation.play("idle", true);
		upper.dance(true);
		santa.dance(true);
	};
	
	bopperShit();
}
function onCreatePost(){
	if (!ClientPrefs.data.shaders) return;
	for (i in [boyfriend, dad, gf, santa]){
		var sh = new AdjustColorShader();
		sh.hue = 5;
		sh.saturation = 20;
		i.shader = sh;
	}
}
function onBeatHit(){
	bopperShit();
}
function onCountdownTick(){
	bopperShit();
}