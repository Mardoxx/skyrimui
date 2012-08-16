import gfx.io.GameDelegate;
import Shared.GlobalFunc;

class GiftMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
	var BottomBar_mc: MovieClip;
	var GiftLabel_mc: MovieClip;
	var InventoryLists_mc: MovieClip;
	var bGivingGifts: Boolean;

	function GiftMenu()
	{
		super();
		bGivingGifts = true;
	}

	function InitExtensions(): Void
	{
		super.InitExtensions();
		GameDelegate.addCallBack("SetMenuInfo", this, "SetMenuInfo");
		BottomBar_mc.SetButtonArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}, 1);
		GiftLabel_mc = InventoryLists_mc.CategoriesList._parent.CategoryLabel;
		GlobalFunc.SetLockFunction();
		GiftLabel_mc.Lock("T");
	}

	function ShowItemsList(): Void
	{
		InventoryLists_mc.ShowItemsList(false);
	}

	function UpdatePlayerInfo(aiFavorPoints: Number): Void
	{
		BottomBar_mc.SetGiftInfo(aiFavorPoints);
	}

	function SetMenuInfo(abGivingGifts: Boolean, abUseFavorPoints: Boolean): Void
	{
		bGivingGifts = abGivingGifts;
		if (abGivingGifts) {
			GiftLabel_mc.textField.SetText("$GIVE GIFT");
		} else {
			GiftLabel_mc.textField.SetText("$TAKE GIFT");
		}
		if (abUseFavorPoints) {
			return;
		}
		BottomBar_mc.HidePlayerInfo();
	}

	function onShowItemsList(event: Object): Void
	{
		if (bGivingGifts) {
			BottomBar_mc.SetButtonsText("$Give", "$Exit");
		} else {
			BottomBar_mc.SetButtonsText("$Take", "$Exit");
		}
		super.onShowItemsList(event);
	}

	function onHideItemsList(event: Object): Void
	{
		super.onHideItemsList(event);
		BottomBar_mc.SetButtonsText("", "$Exit");
	}
	
	function onItemCardSubMenuAction(event: Object): Void
	{
		super.onItemCardSubMenuAction(event);
		GameDelegate.call("QuantitySliderOpen", [event.opening]);
	}

}
