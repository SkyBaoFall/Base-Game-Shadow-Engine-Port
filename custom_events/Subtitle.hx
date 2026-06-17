import flixel.text.FlxTextBorderStyle;

var lyricsTexy;
function onCreate(){
	lyricsTexy = new FlxText(0, 500, FlxG.width);
	lyricsTexy.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	lyricsTexy.borderSize = 2;
	lyricsTexy.cameras = [camOther];
	lyricsTexy.screenCenter(0x01);
	add(lyricsTexy);
}
function onEvent(n,v1,v2){
	if (n == "Subtitle") {
		lyricsTexy.text = v1;
		if (v2 != "" && Std.parseFloat(v2) != null) {
			new FlxTimer().start(Std.parseFloat(v2), function(){
				lyricsTexy.text = "";
			});
		}
	}
}