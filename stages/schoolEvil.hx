import substates.GameOverSubstate;
import objects.BGSprite;
import shaders.WiggleEffect;
var bgGurl;
var shaderUpdate = [];
function onCreate() {
	GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
	GameOverSubstate.loopSoundName = 'gameOver-pixel';
	GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
	GameOverSubstate.characterName = 'bf-pixel-dead';
	
	
	var backspikes = new BGSprite('stages/weeb/evil/weebBackTrees', -842, -180, 0.5, 0.5);
	insert(members.indexOf(gfGroup), backspikes);
	backspikes.antialiasing = false;

	var school = new BGSprite('stages/weeb/evil/weebSchool', -816, -38, 0.75, 0.75);
	insert(members.indexOf(gfGroup), school);
	school.antialiasing = false;
	
	var street = new BGSprite('stages/weeb/evil/weebStreet', -662, 6);
	insert(members.indexOf(gfGroup), street);
	street.antialiasing = false;
	
	var backspike = new BGSprite('stages/weeb/evil/weebTrees', -662, 6);
	insert(members.indexOf(gfGroup), backspike);
	backspike.antialiasing = false;
	
	bgGurl = new BGSprite("stages/weeb/evil/bgGhouls", -646, 222, 1, 1, ["BG freaks glitch instance 1"]);
	bgGurl.setGraphicSize(Std.int(bgGurl.width * 6));
	bgGurl.updateHitbox();
	insert(members.indexOf(gfGroup), bgGurl);
	bgGurl.antialiasing = bgGurl.visible = false;
	bgGurl.animation.finishCallback = (name) -> bgGurl.visible = false;

	school.setGraphicSize(Std.int(school.width * 6));
	backspike.setGraphicSize(Std.int(backspike.width * 6));
	backspikes.setGraphicSize(Std.int(backspikes.width * 6));
	street.setGraphicSize(Std.int(street.width * 6));

	school.updateHitbox();
	backspike.updateHitbox();
	backspikes.updateHitbox();
	street.updateHitbox();
	for (i in 0...4){
		var obj = [school, backspikes, backspike, street][i];
		var shader = new WiggleEffect();
		shader.waveSpeed = [1.6, 2, 2, 2][i];
		shader.waveFrequency = [1.6, 4, 4, 4][i];
		shader.waveAmplitude = [0.011, 0.017, 0.01, 0.007][i];
		shaderUpdate.push(shader);
		obj.shader = shader.shader;
	}
	game.startHScriptsNamed("stages/props/DialoguePixel");
}
var start = false;
function onStartCountdown() {
	if (!start) {
		game.callOnScripts("startConversation");
		start = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
}
function onUpdatePost(e){
	for (a in shaderUpdate) a.update(e);
}
function onEvent(n){
	if (n == "BG Freak Ghost") {
		bgGurl.visible = true;
		bgGurl.dance(true);
	}
}