dynamic class GiftMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
	var BottomBar_mc;
	var GiftLabel_mc;
	var InventoryLists_mc;
	var bGivingGifts;

	function GiftMenu()
	{
		super();
		this.bGivingGifts = true;
	}

	function InitExtensions()
	{
		super.InitExtensions();
		gfx.io.GameDelegate.addCallBack("SetMenuInfo", this, "SetMenuInfo");
		this.BottomBar_mc.SetButtonArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}, 1);
		this.GiftLabel_mc = this.InventoryLists_mc.CategoriesList._parent.CategoryLabel;
		Shared.GlobalFunc.SetLockFunction();
		this.GiftLabel_mc.Lock("T");
	}

	function ShowItemsList()
	{
		this.InventoryLists_mc.ShowItemsList(false);
	}

	function UpdatePlayerInfo(aiFavorPoints)
	{
		this.BottomBar_mc.SetGiftInfo(aiFavorPoints);
	}

	function SetMenuInfo(abGivingGifts, abUseFavorPoints)
	{
		this.bGivingGifts = abGivingGifts;
		if (abGivingGifts) 
		{
			this.GiftLabel_mc.textField.SetText("$GIVE GIFT");
		}
		else 
		{
			this.GiftLabel_mc.textField.SetText("$TAKE GIFT");
		}
		if (abUseFavorPoints) 
		{
			return;
		}
		this.BottomBar_mc.HidePlayerInfo();
	}

	function onShowItemsList(event)
	{
		if (this.bGivingGifts) 
		{
			this.BottomBar_mc.SetButtonsText("$Give", "$Exit");
		}
		else 
		{
			this.BottomBar_mc.SetButtonsText("$Take", "$Exit");
		}
		super.onShowItemsList(event);
	}

	function onHideItemsList(event)
	{
		super.onHideItemsList(event);
		this.BottomBar_mc.SetButtonsText("", "$Exit");
	}
	
	function onItemCardSubMenuAction(event)
	{
		super.onItemCardSubMenuAction(event);
		gfx.io.GameDelegate.call("QuantitySliderOpen", [event.opening]);
	}

}
