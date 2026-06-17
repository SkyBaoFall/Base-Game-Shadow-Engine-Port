import objects.BGSprite;

var spotlightBG;
var spotlight;
var smoke = [];
function onCreate() {
	spotlightBG = new FlxSprite(-300, -500).makeGraphic(1,1,0xFF000000);
	spotlightBG.scale.set(2000, 2000);
	spotlightBG.updateHitbox();
	game.add(spotlightBG);
	
	spotlight = new BGSprite("stages/mainStage/spotlight", 700, -100);
	spotlight.blend = 0;
	game.add(spotlight);
	spotlight.alpha = spotlightBG.alpha = 0;
}
function onEvent(n,v1){
	if (n == "Dadbattle Spotlight") {
		spotlight.alpha = spotlightBG.alpha = 0.3;
		if (v1 == "dad"){
			spotlight.setPosition(50, -100);
		} else if (v1 == "bf"){
			spotlight.setPosition(700, -100);
		} else spotlight.alpha = spotlightBG.alpha = 0;
	}
}