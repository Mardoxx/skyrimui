dynamic class FavoritesCenteredList extends Shared.CenteredScrollingList
{
	var EntriesA;
	var iNumTopHalfEntries;
	var iPlatform;
	var moveSelectionDown;
	var moveSelectionUp;

	function FavoritesCenteredList()
	{
		super();
	}

	function SetEntryText(aEntryClip, aEntryObject)
	{
		var __reg6 = ["None", "Equipped", "LeftEquip", "RightEquip", "LeftAndRightEquip"];
		if (aEntryObject.text == undefined) 
		{
			aEntryClip.textField.SetText(" ");
		}
		else 
		{
			if (aEntryObject.hotkey != undefined && aEntryObject.hotkey != -1) 
			{
				aEntryClip.textField.SetText(aEntryObject.hotkey + 1 + ". " + aEntryObject.text);
			}
			else 
			{
				aEntryClip.textField.SetText(aEntryObject.text);
			}
			var __reg4 = 35;
			if (aEntryClip.textField.text.length > __reg4) 
			{
				aEntryClip.textField.SetText(aEntryClip.textField.text.substr(0, __reg4 - 3) + "...");
			}
		}
		aEntryClip.textField.textAutoSize = "shrink";
		if (aEntryObject == undefined) 
		{
			aEntryClip.EquipIcon.gotoAndStop("None");
		}
		else 
		{
			aEntryClip.EquipIcon.gotoAndStop(__reg6[aEntryObject.equipState]);
		}
		if (this.iPlatform == 0) 
		{
			aEntryClip._alpha = aEntryObject == this.selectedEntry ? 100 : 60;
			return;
		}
		var __reg5 = 8;
		if (aEntryClip.clipIndex < this.iNumTopHalfEntries) 
		{
			aEntryClip._alpha = 60 - __reg5 * (this.iNumTopHalfEntries - aEntryClip.clipIndex);
			return;
		}
		if (aEntryClip.clipIndex > this.iNumTopHalfEntries) 
		{
			aEntryClip._alpha = 60 - __reg5 * (aEntryClip.clipIndex - this.iNumTopHalfEntries);
			return;
		}
		aEntryClip._alpha = 100;
	}

	function InvalidateData()
	{
		this.EntriesA.sort(this.doABCSort);
		super.InvalidateData();
	}

	function doABCSort(aObj1, aObj2)
	{
		if (aObj1.text < aObj2.text) 
		{
			return -1;
		}
		if (aObj1.text > aObj2.text) 
		{
			return 1;
		}
		return 0;
	}

	function onMouseWheel(delta)
	{
		if (delta == 1) 
		{
			this.moveSelectionUp();
			return;
		}
		if (delta == -1) 
		{
			this.moveSelectionDown();
		}
	}

}
