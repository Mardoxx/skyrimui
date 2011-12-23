dynamic class Shared.VerticalCenteredList extends Shared.CenteredList
{
	var EntriesA;
	var SelectedEntry;
	var bRepositionEntries;
	var dispatchEvent;
	var iSelectedIndex;
	var moveListDown;
	var moveListUp;

	function VerticalCenteredList()
	{
		super();
		this.bRepositionEntries = false;
	}

	function handleInput(details, pathToFocus)
	{
		var __reg2 = false;
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.PAGE_DOWN) 
			{
				this.moveListDown();
				__reg2 = true;
			}
			else if (details.navEquivalent == gfx.ui.NavigationCode.PAGE_UP) 
			{
				this.moveListUp();
				__reg2 = true;
			}
			else if (details.navEquivalent == gfx.ui.NavigationCode.ENTER && this.iSelectedIndex != -1) 
			{
				this.dispatchEvent({type: "itemPress", index: this.iSelectedIndex, entry: this.EntriesA[this.iSelectedIndex]});
				__reg2 = true;
			}
		}
		return __reg2;
	}

	function SetEntry(aEntryClip, aEntryObject)
	{
		if (aEntryObject.text == undefined) 
		{
			aEntryClip.textField.SetText(" ");
		}
		else if (aEntryObject.count > 1) 
		{
			aEntryClip.textField.SetText(aEntryObject.text + " (" + aEntryObject.count + ")");
		}
		else 
		{
			aEntryClip.textField.SetText(aEntryObject.text);
		}
		if (aEntryObject == this.SelectedEntry) 
		{
			aEntryClip.EquipLeftIcon_mc._visible = true;
			aEntryClip.EquipRightIcon_mc._visible = true;
			return;
		}
		aEntryClip.EquipLeftIcon_mc._visible = false;
		aEntryClip.EquipRightIcon_mc._visible = false;
	}

}
