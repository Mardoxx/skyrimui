class InventoryScrollingList extends Shared.CenteredScrollingList
{
	function InventoryScrollingList()
	{
		super();
	}

	function SetEntryText(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		var equippedStates: Array = ["None", "Equipped", "LeftEquip", "RightEquip", "LeftAndRightEquip"];
		if (aEntryObject.text != undefined) {
			var strEntryObjectText: String = aEntryObject.text;
			if (aEntryObject.soulLVL != undefined) 
				strEntryObjectText = strEntryObjectText + " (" + aEntryObject.soulLVL + ")";
			if (aEntryObject.count > 1) 
				strEntryObjectText = strEntryObjectText + " (" + aEntryObject.count.toString() + ")";
			if (strEntryObjectText.length > iMaxTextLength) 
				strEntryObjectText = strEntryObjectText.substr(0, iMaxTextLength - 3) + "...";
			if (aEntryObject.bestInClass == true) 
				strEntryObjectText = strEntryObjectText + "<img src=\'BestIcon.png\' vspace=\'2\'>";
			aEntryClip.textField.textAutoSize = "shrink";
			aEntryClip.textField.SetText(strEntryObjectText, true);
			if (aEntryObject.negativeEffect == true || aEntryObject.isStealing == true) 
				aEntryClip.textField.textColor = aEntryObject.enabled == false ? 0x800000 : 0xFF0000;
			else
				aEntryClip.textField.textColor = aEntryObject.enabled == false ? 0x4C4C4C : 0xFFFFFF;
		}
		if (aEntryObject != undefined && aEntryObject.equipState != undefined) 
			aEntryClip.EquipIcon.gotoAndStop(equippedStates[aEntryObject.equipState]);
		else
			aEntryClip.EquipIcon.gotoAndStop("None");
		if (aEntryObject.favorite == true && (aEntryObject.equipState == 0 || aEntryObject.equipState == 1)) 
			aEntryClip.EquipIcon.FavoriteIconInstance.gotoAndStop("On");
		else
			aEntryClip.EquipIcon.FavoriteIconInstance.gotoAndStop("Off");
	}
}
