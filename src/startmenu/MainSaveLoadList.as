import gfx.io.GameDelegate;

class MainSaveLoadList extends Shared.BSScrollingList
{

	function MainSaveLoadList()
	{
		super();
	}

	function SetEntry(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		super.SetEntry(aEntryClip, aEntryObject);
		if (aEntryObject.fileNum != undefined) {
			if (aEntryObject.fileNum < 10) {
				aEntryClip.SaveNumber.SetText("00" + aEntryObject.fileNum);
			} else if (aEntryObject.fileNum < 100) {
				aEntryClip.SaveNumber.SetText("0" + aEntryObject.fileNum);
			} else {
				aEntryClip.SaveNumber.SetText(aEntryObject.fileNum);
			}
			return;
		}
		aEntryClip.SaveNumber.SetText(" ");
	}

	function moveSelectionUp(): Void
	{
		super.moveSelectionUp();
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
	}

	function moveSelectionDown(): Void
	{
		super.moveSelectionDown();
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
	}

}
