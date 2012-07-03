import gfx.io.GameDelegate;

class BarterMenu extends ItemMenu
{
	/* API */
	var bPCControlsReady: Boolean = true;
	
	/* Stage Elements */
	var BottomBar_mc: MovieClip;
	var InventoryLists_mc: MovieClip;
	var ItemCard_mc: MovieClip;
	
	var PlayerInfoObj: Object;
	
	var fBuyMult: Number;
	var fSellMult: Number;
	var iConfirmAmount: Number;
	var iPlayerGold: Number;
	var iSelectedCategory: Number;
	var iVendorGold: Number;
	
	function BarterMenu()
	{
		super();
		fBuyMult = 1;
		fSellMult = 1;
		iVendorGold = 0;
		iPlayerGold = 0;
		iConfirmAmount = 0;
	}
	
	function InitExtensions(): Void
	{
		super.InitExtensions();
		GameDelegate.addCallBack("SetBarterMultipliers", this, "SetBarterMultipliers");
		ItemCard_mc.addEventListener("messageConfirm", this, "onTransactionConfirm");
		ItemCard_mc.addEventListener("sliderChange", this, "onQuantitySliderChange");
		BottomBar_mc.SetButtonArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}, 1);
		BottomBar_mc.Button1.addEventListener("click", this, "onExitButtonPress");
		BottomBar_mc.Button1.disabled = false;
	}
	
	function onExitButtonPress(): Void
	{
		GameDelegate.call("CloseMenu", []);
	}
	
	function SetBarterMultipliers(afBuyMult: Number, afSellMult: Number): Void
	{
		fBuyMult = afBuyMult;
		fSellMult = afSellMult;
		BottomBar_mc.SetButtonsText("", "$Exit");
	}
	
	function onShowItemsList(event: Object): Void
	{
		iSelectedCategory = InventoryLists_mc.CategoriesList.selectedIndex;
		if (IsViewingVendorItems()) {
			BottomBar_mc.SetButtonsText("$Buy", "$Exit");
		} else {
			BottomBar_mc.SetButtonsText("$Sell", "$Exit");
		}
		super.onShowItemsList(event);
	}
	
	function onHideItemsList(event: Object): Void
	{
		super.onHideItemsList(event);
		BottomBar_mc.SetButtonsText("", "$Exit");
	}
	
	function IsViewingVendorItems(): Boolean
	{
		var dividerIndex = InventoryLists_mc.CategoriesList.dividerIndex;
		return dividerIndex != undefined && iSelectedCategory < dividerIndex;
	}
	
	function onQuantityMenuSelect(event: Object): Void
	{
		var iItemValue = event.amount * ItemCard_mc.itemInfo.value;
		if (iItemValue > iVendorGold && !IsViewingVendorItems()) {
			iConfirmAmount = event.amount;
			GameDelegate.call("GetRawDealWarningString", [iItemValue], this, "ShowRawDealWarning");
			return;
		}
		doTransaction(event.amount);
	}
	
	function ShowRawDealWarning(strWarning: String): Void
	{
		ItemCard_mc.ShowConfirmMessage(strWarning);
	}
	
	function onTransactionConfirm(): Void
	{
		doTransaction(iConfirmAmount);
		iConfirmAmount = 0;
	}
	
	function doTransaction(aiAmount: Number): Void
	{
		GameDelegate.call("ItemSelect", [aiAmount, ItemCard_mc.itemInfo.value, IsViewingVendorItems()]);
	}
	
	function UpdateItemCardInfo(aUpdateObj: Object): Void
	{
		if (IsViewingVendorItems()) {
			aUpdateObj.value = aUpdateObj.value * fBuyMult;
			aUpdateObj.value = Math.max(aUpdateObj.value, 1);
		} else {
			aUpdateObj.value = aUpdateObj.value * fSellMult;
		}
		aUpdateObj.value = Math.floor(aUpdateObj.value + 0.5);
		ItemCard_mc.itemInfo = aUpdateObj;
		BottomBar_mc.SetBarterPerItemInfo(aUpdateObj, PlayerInfoObj);
	}
	
	function UpdatePlayerInfo(aiPlayerGold: Number, aiVendorGold: Number, astrVendorName: String, aUpdateObj: Object): Void
	{
		iVendorGold = aiVendorGold;
		iPlayerGold = aiPlayerGold;
		BottomBar_mc.SetBarterInfo(aiPlayerGold, aiVendorGold, undefined, astrVendorName);
		PlayerInfoObj = aUpdateObj;
	}
	
	function onQuantitySliderChange(event: Object): Void
	{
		var iCombinedValue = ItemCard_mc.itemInfo.value * event.value;
		if (IsViewingVendorItems()) {
			iCombinedValue = iCombinedValue * -1;
		}
		BottomBar_mc.SetBarterInfo(iPlayerGold, iVendorGold, iCombinedValue);
	}
	
	function onItemCardSubMenuAction(event: Object): Void
	{
		super.onItemCardSubMenuAction(event);
		GameDelegate.call("QuantitySliderOpen", [event.opening]);
		if (event.menu == "quantity") {
			if (event.opening) {
				onQuantitySliderChange({value: ItemCard_mc.itemInfo.count});
				return;
			}
			BottomBar_mc.SetBarterInfo(iPlayerGold, iVendorGold);
		}
	}
	
}
