import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;

class Shared.VerticalCenteredList extends Shared.CenteredList
{
	var EntriesA: Array;
	var SelectedEntry: Object;
	var bRepositionEntries: Boolean;
	var dispatchEvent: Function;
	var iSelectedIndex: Number;
	var moveListDown;
	var moveListUp;

	function VerticalCenteredList()
	{
		super();
		bRepositionEntries = false;
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.PAGE_DOWN) {
				moveListDown();
				bHandledInput = true;
			} else if (details.navEquivalent == NavigationCode.PAGE_UP) {
				moveListUp();
				bHandledInput = true;
			} else if (details.navEquivalent == NavigationCode.ENTER && iSelectedIndex != -1) {
				dispatchEvent({type: "itemPress", index: iSelectedIndex, entry: EntriesA[iSelectedIndex]});
				bHandledInput = true;
			}
		}
		return bHandledInput;
	}

	function SetEntry(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		if (aEntryObject.text == undefined) 
			aEntryClip.textField.SetText(" ");
		else if (aEntryObject.count > 1) 
			aEntryClip.textField.SetText(aEntryObject.text + " (" + aEntryObject.count + ")");
		else 
			aEntryClip.textField.SetText(aEntryObject.text);
			
		if (aEntryObject == SelectedEntry) {
			aEntryClip.EquipLeftIcon_mc._visible = true;
			aEntryClip.EquipRightIcon_mc._visible = true;
			return;
		}
		aEntryClip.EquipLeftIcon_mc._visible = false;
		aEntryClip.EquipRightIcon_mc._visible = false;
	}

}
