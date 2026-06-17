function goodNoteHit(n)
	if (n.noteType == "Cheer"){
		boyfriend.playAnim("Cheer");
		boyfriend.specialAnim = true;
	}
function opponentNoteHit(n)
	if (n.noteType == "Cheer") {
		dad.playAnim("Cheer");
		dad.specialAnim = true;
	}