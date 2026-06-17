import objects.BGSprite;
import shaders.RuntimePostEffectShader;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxBasePoint;
var scrollingSky;
var light, lightning, forego, sky;
function onCreate(){
	scrollingSky = new FlxBackdrop(Paths.image("stages/phillyStreets/phillyBlazin/skyBlur"));
	insert(members.indexOf(gfGroup),scrollingSky);
	scrollingSky.setPosition(-600,-175);
	scrollingSky.scrollFactor.set();
	scrollingSky.scale.set(1.75,1.75);
	
	sky = new BGSprite("stages/phillyStreets/phillyBlazin/skyBlur", -600, -175, 0,0);
	sky.scale.set(1.75,1.75);
	sky.updateHitbox();
	sky.blend = 0;
	sky.alpha = 0;
	insert(members.indexOf(gfGroup),sky);
	
	lightning = new BGSprite("stages/phillyStreets/phillyBlazin/lightning", 50, 0, 1,1, ["lightning"]);
	lightning.visible = false;
	lightning.scale.set(1.75,1.75);
	lightning.updateHitbox();
	insert(members.indexOf(gfGroup),lightning);
	
	var bg = new BGSprite("stages/phillyStreets/phillyBlazin/streetBlur", -600, -175, 0,0);
	bg.scale.set(1.75,1.75);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup),bg);
	
	forego = new BGSprite("stages/phillyStreets/phillyBlazin/streetBlur", -600, -175, 0,0);
	forego.scale.set(1.75,1.75);
	forego.updateHitbox();
	forego.blend = 9;
	insert(members.indexOf(gfGroup),forego);
	forego.alpha = 0;
	
	light = new FlxSprite(-600, -175).makeGraphic(1,1);
	light.scale.set(2500, 2000);
	light.updateHitbox();
	light.blend = 0;
	light.scrollFactor.set();
	light.alpha = 0.001;
	insert(members.indexOf(gfGroup),light);
	
	
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
	rainShader.setFloat("uIntensity", 0.5);
	if (ClientPrefs.data.shaders) FlxG.camera.filters = [new ShaderFilter(rainShader)];
	boyfriend.color = dad.color = 0xFFDEDEDE;
	gf.color = 0xFF888888;
	boyfriend.skipDance = dad.skipDance = true;
}
var uTime = 0;
var rainTimeScale = 0;
var lightningTimer = 3;
function onUpdatePost(elap){
	scrollingSky.x -= elap * 35;
	uTime += elap + rainTimeScale;
	rainTimeScale = smoothLerpPrecision(rainTimeScale, 0.02, elap, 1.535);
	rainShader.setFloat("uTime", uTime);
	rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
	game.triggerEvent("Camera Follow Pos", game.gf.getMidpoint().x, game.gf.getMidpoint().y - 50);
	lightningTimer -= FlxG.elapsed;
	if (lightningTimer <= 0)
	{
		applyLightning();
		lightningTimer = FlxG.random.float(7, 15);
	}
	for (i in opponentStrums)i.x -= 999;
	for (i in 0...playerStrums.length){
		var stru = playerStrums.members[i];
		var startX = FlxG.width/2 - Note.swagWidth*(playerStrums.length/2);
		stru.x = startX + Note.swagWidth * i;
	}
}
function onSongRestart(){
	playIdleAnim(boyfriend);
	playIdleAnim(dad);
	rainTimeScale = 0;
}
function applyLightning(){
	var LIGHTNING_FULL_DURATION = 1.5;
	var LIGHTNING_FADE_DURATION = 0.3;
	sky.alpha = 0.7;
	FlxTween.tween(sky, {alpha: 0.0}, LIGHTNING_FULL_DURATION);
	forego.alpha = 0.64;
	FlxTween.tween(forego, {alpha: 0.0}, LIGHTNING_FULL_DURATION);
	
	light.alpha = 0.3;
	FlxTween.tween(light, {alpha: 0.0}, LIGHTNING_FADE_DURATION);

	lightning.visible = true;
	lightning.dance();

	if (FlxG.random.bool(65))
		lightning.x = FlxG.random.int(-250, 280);
	else
		lightning.x = FlxG.random.int(780, 900);

	FlxTween.color(boyfriend, LIGHTNING_FADE_DURATION, 0xFF606060, 0xFFDEDEDE);
	FlxTween.color(dad, LIGHTNING_FADE_DURATION, 0xFF606060, 0xFFDEDEDE);

	FlxTween.color(gf, LIGHTNING_FADE_DURATION, 0xFF606060, 0xFF888888);
	FlxG.sound.play(Paths.sound("phillyStreets/Lightning" + FlxG.random.int(1,3)));
}
function smoothLerpPrecision(base:Float, target:Float, deltaTime:Float, duration:Float, precision:Float = 1 / 100) {
	if (deltaTime == 0) return base;
	if (base == target) return target;
	return FlxMath.lerp(target, base, Math.pow(precision, deltaTime / duration));
}
function goodNoteHitPre(note){
	rainTimeScale+=0.7;
	noteHit(note);
}
function opponentNoteHitPre(note){
	rainTimeScale+=0.7;
	noteHit(note);
}
var cantUppercut = false;
function noteHit(note){
	FlxG.camera.shake(0.002, 0.1);
	if (wasNoteHitPoorly(note.rating) && isPlayerLowHealth() && FlxG.random.bool(30)) {
		playUppercutPrepAnim(dad);
		return;
	}

	if (cantUppercut) {
		playPunchHighAnim(dad);
		playHitHighAnim(boyfriend);
		return;
	}
	moveToBack();
	switch (note.noteType) {
		case "weekend-1-punchlow":
			playHitLowAnim(dad);
			playPunchLowAnim(boyfriend);
		case "weekend-1-punchlowblocked":
			playBlockAnim(dad);
			playPunchLowAnim(boyfriend);
		case "weekend-1-punchlowdodged":
			playDodgeAnim(dad);
			playPunchLowAnim(boyfriend);
		case "weekend-1-punchlowspin":
			playSpinAnim(dad);
			playPunchLowAnim(boyfriend);
		case "weekend-1-punchhigh":
			playHitHighAnim(dad);
			playPunchHighAnim(boyfriend);
		case "weekend-1-punchhighblocked":
			playBlockAnim(dad);
			playPunchHighAnim(boyfriend);
		case "weekend-1-punchhighdodged":
			playDodgeAnim(dad);
			playPunchHighAnim(boyfriend);
		case "weekend-1-punchhighspin":
			playSpinAnim(dad);
			playPunchHighAnim(boyfriend);
		case "weekend-1-blockhigh":
			playPunchHighAnim(dad);
			playBlockAnim(boyfriend);
			moveToFront();
		case "weekend-1-blocklow":
			playPunchLowAnim(dad);
			playBlockAnim(boyfriend);
			moveToFront();
		case "weekend-1-blockspin":
			playPunchHighAnim(dad);
			playBlockAnim(boyfriend);
			moveToFront();
		case "weekend-1-dodgehigh":
			playPunchHighAnim(dad);
			playDodgeAnim(boyfriend);
			moveToFront();
		case "weekend-1-dodgelow":
			playPunchLowAnim(dad);
			playDodgeAnim(boyfriend);
			moveToFront();
		case "weekend-1-dodgespin":
			playPunchHighAnim(dad);
			playDodgeAnim(boyfriend);
			moveToFront();
		case "weekend-1-hithigh":
			playPunchHighAnim(dad);
			playHitHighAnim(boyfriend);
			moveToFront();
		case "weekend-1-hitlow":
			playPunchLowAnim(dad);
			playHitLowAnim(boyfriend);
			moveToFront();
		case "weekend-1-hitspin":
			playPunchHighAnim(dad);
			playHitSpinAnim(boyfriend);
			moveToFront();
		case "weekend-1-picouppercutprep":
			playUppercutPrepAnim(boyfriend);
		case "weekend-1-picouppercut":
			playUppercutHitAnim(dad);
			playUppercutAnim(boyfriend);
		case "weekend-1-darnelluppercutprep":
			playUppercutPrepAnim(dad);
		case "weekend-1-darnelluppercut":
			playUppercutAnim(dad);
			playUppercutHitAnim(boyfriend);
			moveToFront();
		case "weekend-1-idle":
			playIdleAnim(dad);
			playIdleAnim(boyfriend);
		case "weekend-1-fakeout":
			playCringeAnim(dad);
			playFakeoutAnim(boyfriend);
		case "weekend-1-taunt":
			playPissedConditionalAnim(dad);
		case "weekend-1-tauntforce":
			playPissedAnim(dad);
			playTauntAnim(boyfriend);
		case "weekend-1-reversefakeout":
			playFakeoutAnim(dad);
			playIdleAnim(boyfriend);
	}
	cantUppercut = false;
}
function noteMiss(note) {
	if (dad.anim.curAnim.name == 'uppercutPrep') {
		playUppercutAnim(dad);
		return;
	}
	if (willMissBeLethal()) {
		playPunchLowAnim(boyfriend);
		return;
	}
	if (cantUppercut) {
		playPunchHighAnim(dad);
		playHitHighAnim(boyfriend);
		return;
	}
	moveToBack();
	switch(note.noteType) {
		case "weekend-1-punchlow":
			playHitLowAnim(boyfriend);
			playPunchLowAnim(dad);
		case "weekend-1-punchlowblocked":
			playHitLowAnim(boyfriend);
			playPunchLowAnim(dad);
		case "weekend-1-punchlowdodged":
			playHitLowAnim(boyfriend);
			playPunchLowAnim(dad);
		case "weekend-1-punchlowspin":
			playSpinAnim(boyfriend);
			playPunchLowAnim(dad);
		case "weekend-1-punchhigh":
			playHitHighAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-punchhighblocked":
			playHitHighAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-punchhighdodged":
			playHitHighAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-punchhighspin":
			playHitSpinAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-blockhigh":
			playHitHighAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-blocklow":
			playHitLowAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-blockspin":
			playHitSpinAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-dodgehigh":
			playHitHighAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-dodgelow":
			playHitLowAnim(boyfriend);
			playPunchLowAnim(dad);
		case "weekend-1-dodgespin":
			playHitSpinAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-hithigh":
			playHitHighAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-hitlow":
			playHitLowAnim(boyfriend);
			playPunchLowAnim(dad);
		case "weekend-1-hitspin":
			playHitSpinAnim(boyfriend);
			playPunchHighAnim(dad);
		case "weekend-1-picouppercutprep":
			playPunchHighAnim(boyfriend);
			playHitHighAnim(dad);
			cantUppercut = true;
		case "weekend-1-picouppercut":
			playUppercutHitAnim(boyfriend);
			playDodgeAnim(dad);
		case "weekend-1-darnelluppercutprep":
			playUppercutPrepAnim(dad);
		case "weekend-1-darnelluppercut":
			playUppercutAnim(dad);
			playUppercutHitAnim(boyfriend);
		case "weekend-1-idle":
			playIdleAnim(dad);
			playIdleAnim(boyfriend);
		case "weekend-1-fakeout":
			playCringeAnim(dad);
			playHitHighAnim(boyfriend);
		case "weekend-1-taunt":
			playPissedConditionalAnim(dad);
		case "weekend-1-tauntforce":
			playPissedAnim(dad);
			playTauntAnim(boyfriend);
		case "weekend-1-reversefakeout":
			playIdleAnim(dad);
			playIdleAnim(boyfriend);
	}
	cantUppercut = false;
}
function noteMissPress() {
	if (willMissBeLethal())
		playPunchLowAnim();
	else {
		var shouldDodge = FlxG.random.bool();
		if (shouldDodge)
			playDodgeAnim();
		else
			playBlockAnim();
	}
}
var alternate:Bool = false;
function doAlternate() {
	alternate = !alternate;
	return alternate ? '1' : '2';
}
function playBlockAnim(char) {
	char.playAnim('block', true);
	FlxG.camera.shake(0.002, 0.1);
}
function playCringeAnim(char) {
	char.playAnim('cringe', true);
}
function playDodgeAnim(char) {
	char.playAnim('dodge', true);
}
function playIdleAnim(char) {
	char.playAnim('idle');
}
function playFakeoutAnim(char) {
	char.playAnim('fakeout', true);
}
function playPissedConditionalAnim(char) {
	if (char.anim.curAnim.name == "cringe") {
		playPissedAnim(dad);
		playTauntAnim(boyfriend);
	} else {
		playIdleAnim(dad);
		playIdleAnim(boyfriend);
	}
}
function playPissedAnim(char) {
	char.playAnim('pissed', true);
}
function playUppercutPrepAnim(char) {
	char.playAnim('uppercutPrep', true);
}
function playUppercutAnim(char) {
	char.playAnim('uppercut', true);
}
function playUppercutHitAnim(char) {
	char.playAnim('uppercutHit', true);
}
function playHitHighAnim(char) {
	char.playAnim('hitHigh', true);
	FlxG.camera.shake(0.0025, 0.15);
}
function playHitLowAnim(char) {
	char.playAnim('hitLow', true);
	FlxG.camera.shake(0.0025, 0.15);
}
function playPunchHighAnim(char) {
	char.playAnim('punchHigh' + doAlternate(), true);
}
function playTauntAnim(char) {
	char.playAnim('taunt', true);
}
function playPunchLowAnim(char) {
	char.playAnim('punchLow' + doAlternate(), true);
}
function playSpinAnim(char) {
	char.playAnim('hitSpin', true);
	FlxG.camera.shake(0.0025, 0.15);
}
function willMissBeLethal() {
	return game.health <= 0.0 && !game.practiceMode;
}
function wasNoteHitPoorly(rating) {
	return (rating == "bad" || rating == "shit");
}
function isPlayerLowHealth() {
	return game.health <= 0.3 * 2;
}
function moveToBack() {
	var dadPos = FlxG.state.members.indexOf(dadGroup);
	var bfPos = FlxG.state.members.indexOf(boyfriendGroup);
	if (dadPos < bfPos) return;
	FlxG.state.members[bfPos] = dadGroup;
	FlxG.state.members[dadPos] = boyfriendGroup;
}
function moveToFront() {
	var dadPos = FlxG.state.members.indexOf(dadGroup);
	var bfPos = FlxG.state.members.indexOf(boyfriendGroup);
	if (dadPos > bfPos) return;

	FlxG.state.members[bfPos] = dadGroup;
	FlxG.state.members[dadPos] = boyfriendGroup;
}