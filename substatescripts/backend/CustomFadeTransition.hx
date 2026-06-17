import sys.io.File;
import sys.FileSystem;
import haxe.Json;

var grpStickers = [];
var newCamera;
var allow = false;
var it_here = false;
function onCreatePost() {
	var stickers = Json.parse(Paths.getTextFromFile("stickers/standard-bf.json"));
	var xPos = -100;
	var yPos = -100;
	var array = {stickerList: []};
	if (isTransIn) {
		if (!FileSystem.exists(Paths.modFolders("transition.json"))) return;
		var json = Json.parse(Paths.getTextFromFile("transition.json"));
		if (json.stickerList.length == 0 || json.stickerList == null) return;
		json.stickerList.sort(function(a,b) return a.index - b.index);
		for (i in json.stickerList){
			var image = i.sprite;
			var sticky = new FlxSprite(i.x,i.y).loadGraphic(Paths.image(i.sprite));
			sticky.angle = i.angle;
			sticky.scale.set(i.scale, i.scale);
			sticky.ID = grpStickers.length;
			array.stickerList.push({x: sticky.x, y: sticky.y, angle: sticky.angle, sprite: image, scale: sticky.scale.x});
			grpStickers.push(sticky);
			add(sticky);
		}
	} else {
		if (FlxG.state != PlayState.instance) return;
		while (xPos <= FlxG.width) {
			var image = stickers.stickers[FlxG.random.int(0, stickers.stickers.length - 1)];
			var sticky = new FlxSprite().loadGraphic(Paths.image(image));
			sticky.alpha = 0.001;
	
			sticky.x = xPos;
			sticky.y = yPos;
			sticky.ID = grpStickers.length;
			xPos += sticky.frameWidth * 0.5;
	
			if (xPos >= FlxG.width) {
				if (yPos <= FlxG.height) {
					xPos = -100;
					yPos += FlxG.random.float(70, 120);
				}
			}
			sticky.scale.x = sticky.scale.y = FlxG.random.float(0.97, 1.02);
			sticky.angle = FlxG.random.int(-60, 70);
			array.stickerList.push({x: sticky.x, y: sticky.y, angle: sticky.angle, sprite: image, scale: sticky.scale.x});
			grpStickers.push(sticky);
			
		}
	}
	var length = grpStickers.length - 1;
	if (length <= 0) return;
	if (!isTransIn) shuffle(grpStickers);
	var index = 0;
	for (i in grpStickers){
		if (!isTransIn) {
			add(i);
			array.stickerList[i.ID].index = index;
		}
		index += 1;
	}
	new FlxTimer().start(0.5, function() {
		var index = 0;
		var a = 0;
		for (i in grpStickers){
			a += 1;
			new FlxTimer().start(0.6/length * a, function(){
				// fuck you
				FlxG.sound.play(Paths.sound("stickersounds/keys/keyClick" + FlxG.random.int(1, 9)));
				i.scale.x = i.scale.y = 1;
				i.alpha = !isTransIn ? 1 : 0;
				var frameTimer:Int = FlxG.random.int(0, 2);
				new FlxTimer().start((1 / 24) * frameTimer, function(){
					i.scale.x = i.scale.y = array.stickerList[i.ID].scale;
					if (index >= length) allow = true;
				});
				index += 1;
			});
		}
	});
	it_here = true;
	checkSave(array);
	
	newCamera = new FlxCamera();
	newCamera.bgColor = false;
	FlxG.cameras.add(newCamera, false);
	for (a in grpStickers) a.cameras = [newCamera];
}
var timer = 0;
function onUpdate(elaps) {
	if (!it_here) return;
	members[0].visible = members[1].visible = false;
	if (allow) timer += elaps;
	if (allow && timer > 0.1) {
		if (isTransIn) FlxG.cameras.remove(newCamera, true);
		members[0].y = 2000; 
		
	}
	else members[0].y = -90;
}
function checkSave(array) {
	if (!isTransIn) {
		File.saveContent(Paths.mods(Mods.currentModDirectory + "/transition.json"), Json.stringify(array, null, "\t"));
	} else {
		if (FileSystem.exists(Paths.modFolders("transition.json")))
			FileSystem.deleteFile(Paths.mods(Mods.currentModDirectory + "/transition.json"));
	}
}
function shuffle(arr:Array) {
	var i = arr.length;
	while (i > 1) {
		i--;
		var j = FlxG.random.int(0, i);
		var temp = arr[i];
		arr[i] = arr[j];
		arr[j] = temp;
	}
}
