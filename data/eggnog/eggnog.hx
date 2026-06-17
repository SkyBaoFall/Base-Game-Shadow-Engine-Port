import psychlua.ModchartSprite;
import psychlua.LuaUtils;
import backend.Difficulty;
var start = false;
function onEndSong() {
	if (start) return;
	// what a peak
	
	var parents = new ModchartSprite(-600, 0);
	LuaUtils.loadFrames(parents, "stages/christmas/parents_shoot_assets", "tex");
	parents.anim.addBySymbol("fuck u", "parents whole scene", 24, false);
	parents.playAnim("fuck u");
	parents.anim.curAnim.paused = true;
	add(parents);
	parents.visible = false;
	
	// Santa clause
	var santa = new ModchartSprite(-1300, 100);
	LuaUtils.loadFrames(santa, "stages/christmas/santa_speaks_assets", "tex");
	santa.anim.addBySymbol("speak", "santa whole scene", 24, false);
	santa.playAnim("speak");
	santa.anim.curAnim.paused = true;
	add(santa);
	santa.visible = false;
	
	// 1 second head start
	new FlxTimer().start(1, function() {
		// who tf nammed this dude
		if(getVar("satan")!=null)getVar("satan").visible=false;
		santa.anim.curAnim.paused = parents.anim.curAnim.paused = false;
		santa.visible = parents.visible = true;
		//dadGroup.visible = false;
		FlxG.sound.play(Paths.sound("christmas/santa_emotion"));
		game.triggerEvent("Focus Camera", "", "-100, 400, 6.53333334, expoOut");
		game.triggerEvent("Zoom Camera", "4.66666667, 0.73", "quadinout");
		new FlxTimer().start(2.8, function() {
			game.triggerEvent("Focus Camera", "", "-250, 400, 21, quartInOut");
			game.triggerEvent("Zoom Camera", "21, 0.79", "quadinout");
			new FlxTimer().start(8.57500, function() {
				FlxG.sound.play(Paths.sound("christmas/santa_shot_n_falls"));
				new FlxTimer().start(1.45500, function() {
					FlxG.camera.shake(0.005, 0.2);
					game.triggerEvent("Focus Camera", "", "-240, 480, 11.666666656, expoOut");
					new FlxTimer().start(2.17, function() {
						camHUD.fade(0xFF000000, 1, false, null, true);
						new FlxTimer().start(1, function() {
							game.endCallback();
						});
					});
				});
			});
		});
	});
	start = true;
	return LuaUtils.Function_Stop;
}