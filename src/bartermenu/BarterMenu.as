class BarterMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
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
		this.fBuyMult = 1;
		this.fSellMult = 1;
		this.iVendorGold = 0;
		this.iPlayerGold = 0;
		this.iConfirmAmount = 0;
	}

	function InitExtensions(): Void
	{
		super.InitExtensions();
		gfx.io.GameDelegate.addCallBack("SetBarterMultipliers", this, "SetBarterMultipliers");
		this.ItemCard_mc.addEventListener("messageConfirm", this, "onTransactionConfirm");
		this.ItemCard_mc.addEventListener("sliderChange", this, "onQuantitySliderChange");
		this.BottomBar_mc.SetButtonArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}, 1);
		this.BottomBar_mc.Button1.addEventListener("click", this, "onExitButtonPress");
		this.BottomBar_mc.Button1.disabled = false;
	}

	function onExitButtonPress(): Void
	{
		gfx.io.GameDelegate.call("CloseMenu", []);
	}

	function SetBarterMultipliers(afBuyMult: Number, afSellMult: Number): Void
	{
		this.fBuyMult = afBuyMult;
		this.fSellMult = afSellMult;
		this.BottomBar_mc.SetButtonsText("", "$Exit");
	}

	function onShowItemsList(event: Object): Void
	{
		this.iSelectedCategory = this.InventoryLists_mc.CategoriesList.selectedIndex;
		if (this.IsViewingVendorItems()) 
		{
			this.BottomBar_mc.SetButtonsText("$Buy", "$Exit");
		}
		else 
		{
			this.BottomBar_mc.SetButtonsText("$Sell", "$Exit");
		}
		super.onShowItemsList(event);
	}

	function onHideItemsList(event: Object): Void
	{
		super.onHideItemsList(event);
		this.BottomBar_mc.SetButtonsText("", "$Exit");
	}

	function IsViewingVendorItems(): Boolean
	{
		var dividerIndex = this.InventoryLists_mc.CategoriesList.dividerIndex;
		return dividerIndex != undefined && this.iSelectedCategory < dividerIndex;
	}

	function onQuantityMenuSelect(event: Object): Void
	{
		var iItemValue = event.amount * this.ItemCard_mc.itemInfo.value;
		if (iItemValue > this.iVendorGold && !this.IsViewingVendorItems()) 
		{
			this.iConfirmAmount = event.amount;
			gfx.io.GameDelegate.call("GetRawDealWarningString", [iItemValue], this, "ShowRawDealWarning");
			return;
		}
		this.doTransaction(event.amount);
	}

	function ShowRawDealWarning(strWarning: String): Void
	{
		this.ItemCard_mc.ShowConfirmMessage(strWarning);
	}

	function onTransactionConfirm(): Void
	{
		this.doTransaction(this.iConfirmAmount);
		this.iConfirmAmount = 0;
	}

	function doTransaction(aiAmount: Number): Void
	{
		gfx.io.GameDelegate.call("ItemSelect", [aiAmount, this.ItemCard_mc.itemInfo.value, this.IsViewingVendorItems()]);
	}

	function UpdateItemCardInfo(aUpdateObj: Object): Void
	{
		if (this.IsViewingVendorItems()) 
		{
			aUpdateObj.value = aUpdateObj.value * this.fBuyMult;
			aUpdateObj.value = Math.max(aUpdateObj.value, 1);
		}
		else 
		{
			aUpdateObj.value = aUpdateObj.value * this.fSellMult;
		}
		aUpdateObj.value = Math.floor(aUpdateObj.value + 0.5);
		this.ItemCard_mc.itemInfo = aUpdateObj;
		this.BottomBar_mc.SetBarterPerItemInfo(aUpdateObj, this.PlayerInfoObj);
	}

	function UpdatePlayerInfo(aiPlayerGold: Number, aiVendorGold: Number, astrVendorName: String, aUpdateObj: Object): Void
	{
		this.iVendorGold = aiVendorGold;
		this.iPlayerGold = aiPlayerGold;
		this.BottomBar_mc.SetBarterInfo(aiPlayerGold, aiVendorGold, undefined, astrVendorName);
		this.PlayerInfoObj = aUpdateObj;
	}

	function onQuantitySliderChange(event: Object): Void
	{
		var iCombinedValue = this.ItemCard_mc.itemInfo.value * event.value;
		if (this.IsViewingVendorItems()) 
		{
			iCombinedValue = iCombinedValue * -1;
		}
		this.BottomBar_mc.SetBarterInfo(this.iPlayerGold, this.iVendorGold, iCombinedValue);
	}

	function onItemCardSubMenuAction(event: Object): Void
	{
		super.onItemCardSubMenuAction(event);
		if (event.menu == "quantity") 
		{
			if (event.opening) 
			{
				this.onQuantitySliderChange({value: this.ItemCard_mc.itemInfo.count});
				return;
			}
			this.BottomBar_mc.SetBarterInfo(this.iPlayerGold, this.iVendorGold);
		}
	}

}
