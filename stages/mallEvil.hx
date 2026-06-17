import objects.BGSprite;
function onCreate(){
	var bg = new FlxSprite(-500, -1000).makeGraphic(1, 1, 0xFF23062D);
	bg.scale.set(2400, 2000);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/christmas/evilBG", -400, -500, 0.2, 0.2);
	bg.scale.set(0.8, 0.8);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/christmas/evilTree", 300, -300, 0.2, 0.2);
	insert(members.indexOf(gfGroup), bg);
	
	var bg = new BGSprite("stages/christmas/evilSnow", -500, 700);
	insert(members.indexOf(gfGroup), bg);
}