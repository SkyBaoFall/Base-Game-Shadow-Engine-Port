import objects.BGSprite;

var spotlightBG;
var spotlight;
var smoke = [];
function onCreate() {
	spotlightBG = new FlxSprite(-300, -500).makeGraphic(1,1,0xFF000000);
	spotlightBG.scale.set(2000, 2000);
	spotlightBG.updateHitbox();
	game.add(spotlightBG);
	
	spotlight = new BGSprite("stages/mainStage/spotlight", 700, -50);
	spotlight.blend = 0;
	game.add(spotlight);
	spotlight.alpha = spotlightBG.alpha = 0;
}
function onEvent(n,v1){
	if (n == "Dadbattle Spotlight") {
		spotlight.alpha = spotlightBG.alpha = 0.3;
		spotlight.alpha += 0.2;
		if (v1 == "dad"){
			spotlight.setPosition(-190, -50);
		} else if (v1 == "bf") spotlight.setPosition(690, -50);
		else spotlight.alpha = spotlightBG.alpha = 0;
	}
}