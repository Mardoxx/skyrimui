dynamic class InventoryScrollingList extends Shared.CenteredScrollingList
{
	var iMaxTextLength;

	function InventoryScrollingList()
	{
		super();
	}

	function SetEntryText(aEntryClip, aEntryObject)
	{
		var __reg5 = ["None", "Equipped", "LeftEquip", "RightEquip", "LeftAndRightEquip"];
		if (aEntryObject.text != undefined) 
		{
			var __reg3 = aEntryObject.text;
			if (aEntryObject.soulLVL != undefined) 
			{
				__reg3 = __reg3 + " (" + aEntryObject.soulLVL + ")";
			}
			if (aEntryObject.count > 1) 
			{
				__reg3 = __reg3 + " (" + aEntryObject.count.toString() + ")";
			}
			if (__reg3.length > this.iMaxTextLength) 
			{
				__reg3 = __reg3.substr(0, this.iMaxTextLength - 3) + "...";
			}
			if (aEntryObject.bestInClass == true) 
			{
				__reg3 = __reg3 + "<img src=\'BestIcon.png\' vspace=\'2\'>";
			}
			aEntryClip.textField.textAutoSize = "shrink";
			aEntryClip.textField.SetText(__reg3, true);
			if (aEntryObject.negativeEffect == true || aEntryObject.isStealing == true) 
			{
				aEntryClip.textField.textColor = aEntryObject.enabled == false ? 8388608 : 16711680;
			}
			else 
			{
				aEntryClip.textField.textColor = aEntryObject.enabled == false ? 5000268 : 16777215;
			}
		}
		if (aEntryObject != undefined && aEntryObject.equipState != undefined) 
		{
			aEntryClip.EquipIcon.gotoAndStop(__reg5[aEntryObject.equipState]);
		}
		else 
		{
			aEntryClip.EquipIcon.gotoAndStop("None");
		}
		if (aEntryObject.favorite == true && (aEntryObject.equipState == 0 || aEntryObject.equipState == 1)) 
		{
			aEntryClip.EquipIcon.FavoriteIconInstance.gotoAndStop("On");
			return;
		}
		aEntryClip.EquipIcon.FavoriteIconInstance.gotoAndStop("Off");
	}

}
