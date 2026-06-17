import objects.BGSprite;
var lighBG = [];
function onCreate() {
	var bg = new FlxSprite(-300, -500).makeGraphic(1,1,0xFf242336);
	bg.scale.set(2400, 2000);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/spookyMansion/erect/bgtrees", 200, 50, 0.8, 0.8, ["bgtrees"], true);
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/spookyMansion/erect/bgDark",-560,-220);
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/spookyMansion/erect/bgLight",-560,-220);
	insert(members.indexOf(gfGroup), bg);
	lighBG.push(bg);
	
	var bg = new BGSprite("stages/spookyMansion/erect/stairsDark",966, -225);
	add(bg);
	
	var bg = new BGSprite("stages/spookyMansion/erect/stairsLight",966, -225);
	add(bg);
	lighBG.push(bg);
	
	for (i in lighBG) i.alpha = 0;
	
}
function onCreatePost(){
	for (i in [dad, boyfriend, gf]){
		if (i == null) continue;
		if (Paths.getTextFromFile("characters/" + StringTools.replace(i.curCharacter, "-dark","") + ".json") == null) continue;
		
		var chara = new Character(0,0,StringTools.replace(i.curCharacter, "-dark",""),i.isPlayer);
		i.animation.onFrameChange.add(function(){
			chara.setPosition(i.x - 1, i.y - 2);
			chara.playAnim(i.anim.curAnim.name,true,false,i.anim.curAnim.curFrame);
		});
		chara.alpha = 0.001;
		lighBG.push(chara);
		switch(i){
			case dad: dadGroup.add(chara);
			case boyfriend: boyfriendGroup.add(chara);
			case gf: gfGroup.add(chara);
		}
	}
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
	lightningStrikeBeat = beat;
	lightningStrikeOffset = FlxG.random.int(8, 24);
	boyfriend.animation.play("scared", boyfriend.specialAnim = true);
	for (i in lighBG) i.alpha = 1;
	gf.animation.play("scared", gf.specialAnim = true);
}
function onUpdatePost(elap){
	for (i in lighBG) i.alpha -= elap;
}