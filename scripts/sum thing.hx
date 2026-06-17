function updateAnimation(character) {
	for (i in character.animationsArray){
		if (i.flipX != null) character.animation.getByName(i.anim).flipX = i.flipX;
		if (i.flipY != null) character.animation.getByName(i.anim).flipX = i.flipY;
	}
}
function onCreatePost(){
	if (ClientPrefs.data.lowQuality) {
		// hell yea
		game.gf = new Character(0, 0, PlayState.SONG.gfVersion);
		game.gf.scrollFactor.set(0.95, 0.95);
		game.gfGroup.add(game.gf);
		game.startCharacterPos(game.gf);
		game.startCharacterScripts(game.gf.curCharacter);
	} 
	game.camZooming = true;
	updateAnimation(dad);
	updateAnimation(boyfriend);
	updateAnimation(gf);
}
function onStepHit(){
	updateAnimation(dad);
	updateAnimation(boyfriend);
	updateAnimation(gf);
}