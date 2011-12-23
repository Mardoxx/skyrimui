dynamic class BarterMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
	var BottomBar_mc;
	var InventoryLists_mc;
	var ItemCard_mc;
	var PlayerInfoObj;
	var fBuyMult;
	var fSellMult;
	var iConfirmAmount;
	var iPlayerGold;
	var iSelectedCategory;
	var iVendorGold;

	function BarterMenu()
	{
		super();
		this.fBuyMult = 1;
		this.fSellMult = 1;
		this.iVendorGold = 0;
		this.iPlayerGold = 0;
		this.iConfirmAmount = 0;
	}

	function InitExtensions()
	{
		super.InitExtensions();
		gfx.io.GameDelegate.addCallBack("SetBarterMultipliers", this, "SetBarterMultipliers");
		this.ItemCard_mc.addEventListener("messageConfirm", this, "onTransactionConfirm");
		this.ItemCard_mc.addEventListener("sliderChange", this, "onQuantitySliderChange");
		this.BottomBar_mc.SetButtonArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}, 1);
		this.BottomBar_mc.Button1.addEventListener("click", this, "onExitButtonPress");
		this.BottomBar_mc.Button1.disabled = false;
	}

	function onExitButtonPress()
	{
		gfx.io.GameDelegate.call("CloseMenu", []);
	}

	function SetBarterMultipliers(afBuyMult, afSellMult)
	{
		this.fBuyMult = afBuyMult;
		this.fSellMult = afSellMult;
		this.BottomBar_mc.SetButtonsText("", "$Exit");
	}

	function onShowItemsList(event)
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

	function onHideItemsList(event)
	{
		super.onHideItemsList(event);
		this.BottomBar_mc.SetButtonsText("", "$Exit");
	}

	function IsViewingVendorItems()
	{
		var __reg2 = this.InventoryLists_mc.CategoriesList.dividerIndex;
		return __reg2 != undefined && this.iSelectedCategory < __reg2;
	}

	function onQuantityMenuSelect(event)
	{
		var __reg2 = event.amount * this.ItemCard_mc.itemInfo.value;
		if (__reg2 > this.iVendorGold && !this.IsViewingVendorItems()) 
		{
			this.iConfirmAmount = event.amount;
			gfx.io.GameDelegate.call("GetRawDealWarningString", [__reg2], this, "ShowRawDealWarning");
			return;
		}
		this.doTransaction(event.amount);
	}

	function ShowRawDealWarning(strWarning)
	{
		this.ItemCard_mc.ShowConfirmMessage(strWarning);
	}

	function onTransactionConfirm()
	{
		this.doTransaction(this.iConfirmAmount);
		this.iConfirmAmount = 0;
	}

	function doTransaction(aiAmount)
	{
		gfx.io.GameDelegate.call("ItemSelect", [aiAmount, this.ItemCard_mc.itemInfo.value, this.IsViewingVendorItems()]);
	}

	function UpdateItemCardInfo(aUpdateObj)
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

	function UpdatePlayerInfo(aiPlayerGold, aiVendorGold, astrVendorName, aUpdateObj)
	{
		this.iVendorGold = aiVendorGold;
		this.iPlayerGold = aiPlayerGold;
		this.BottomBar_mc.SetBarterInfo(aiPlayerGold, aiVendorGold, undefined, astrVendorName);
		this.PlayerInfoObj = aUpdateObj;
	}

	function onQuantitySliderChange(event)
	{
		var __reg2 = this.ItemCard_mc.itemInfo.value * event.value;
		if (this.IsViewingVendorItems()) 
		{
			__reg2 = __reg2 * -1;
		}
		this.BottomBar_mc.SetBarterInfo(this.iPlayerGold, this.iVendorGold, __reg2);
	}

	function onItemCardSubMenuAction(event)
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
