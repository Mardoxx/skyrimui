dynamic class ContainerMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
	static var NULL_HAND: Number = -1;
	static var RIGHT_HAND: Number = 0;
	static var LEFT_HAND: Number = 1;
	var BottomBar_mc;
	var ContainerButtonArt;
	var InventoryButtonArt;
	var InventoryLists_mc;
	var ItemCardFadeHolder_mc;
	var ItemCard_mc;
	var ShouldProcessItemsListInput;
	var bNPCMode;
	var bShowEquipButtonHelp;
	var iEquipHand;
	var iPlatform;
	var iSelectedCategory;

	function ContainerMenu()
	{
		super();
		this.ContainerButtonArt = [{PCArt: "M1M2", XBoxArt: "360_LTRT", PS3Art: "PS3_LBRB"}, {PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"}, {PCArt: "R", XBoxArt: "360_X", PS3Art: "PS3_X"}];
		this.InventoryButtonArt = [{PCArt: "M1M2", XBoxArt: "360_LTRT", PS3Art: "PS3_LBRB"}, {PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"}, {PCArt: "R", XBoxArt: "360_X", PS3Art: "PS3_X"}, {PCArt: "F", XBoxArt: "360_Y", PS3Art: "PS3_Y"}];
		this.bNPCMode = false;
		this.bShowEquipButtonHelp = true;
		this.iEquipHand = undefined;
	}

	function InitExtensions()
	{
		super.InitExtensions(false);
		gfx.io.GameDelegate.addCallBack("AttemptEquip", this, "AttemptEquip");
		gfx.io.GameDelegate.addCallBack("XButtonPress", this, "onXButtonPress");
		this.ItemCardFadeHolder_mc.StealTextInstance._visible = false;
		this.updateButtons();
	}

	function ShowItemsList()
	{
		this.InventoryLists_mc.ShowItemsList(false);
	}

	function handleInput(details, pathToFocus)
	{
		super.handleInput(details, pathToFocus);
		if (this.ShouldProcessItemsListInput(false)) 
		{
			if (this.iPlatform == 0 && details.code == 16) 
			{
				this.bShowEquipButtonHelp = details.value != "keyUp";
				this.updateButtons();
			}
		}
		return true;
	}

	function onXButtonPress()
	{
		if (this.isViewingContainer() && !this.bNPCMode) 
		{
			gfx.io.GameDelegate.call("TakeAllItems", []);
			return;
		}
		if (this.isViewingContainer()) 
		{
			return;
		}
		this.StartItemTransfer();
	}

	function UpdateItemCardInfo(aUpdateObj)
	{
		super.UpdateItemCardInfo(aUpdateObj);
		this.updateButtons();
		if (aUpdateObj.pickpocketChance != undefined) 
		{
			this.ItemCardFadeHolder_mc.StealTextInstance._visible = true;
			this.ItemCardFadeHolder_mc.StealTextInstance.PercentTextInstance.html = true;
			this.ItemCardFadeHolder_mc.StealTextInstance.PercentTextInstance.htmlText = "<font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + aUpdateObj.pickpocketChance + "%</font>" + (this.isViewingContainer() ? _root.TranslationBass.ToStealTextInstance.text : _root.TranslationBass.ToPlaceTextInstance.text);
			return;
		}
		this.ItemCardFadeHolder_mc.StealTextInstance._visible = false;
	}

	function onShowItemsList(event)
	{
		this.iSelectedCategory = this.InventoryLists_mc.CategoriesList.selectedIndex;
		this.updateButtons();
		super.onShowItemsList(event);
	}

	function onHideItemsList(event)
	{
		super.onHideItemsList(event);
		this.BottomBar_mc.UpdatePerItemInfo({type: InventoryDefines.ICT_NONE});
		this.updateButtons();
	}

	function updateButtons()
	{
		this.BottomBar_mc.SetButtonsArt(this.isViewingContainer() ? this.ContainerButtonArt : this.InventoryButtonArt);
		if (this.InventoryLists_mc.currentState != InventoryLists.TRANSITIONING_TO_TWO_PANELS && this.InventoryLists_mc.currentState != InventoryLists.TWO_PANELS) 
		{
			this.BottomBar_mc.SetButtonText("", 0);
			this.BottomBar_mc.SetButtonText("", 1);
			this.BottomBar_mc.SetButtonText("", 2);
			this.BottomBar_mc.SetButtonText("", 3);
			return;
		}
		this.updateEquipButtonText();
		if (this.isViewingContainer()) 
		{
			this.BottomBar_mc.SetButtonText("$Take", 1);
		}
		else 
		{
			this.BottomBar_mc.SetButtonText(this.bShowEquipButtonHelp ? "" : InventoryDefines.GetEquipText(this.ItemCard_mc.itemInfo.type), 1);
		}
		if (this.isViewingContainer()) 
		{
			if (this.bNPCMode) 
			{
				this.BottomBar_mc.SetButtonText("", 2);
			}
			else if (this.isViewingContainer()) 
			{
				this.BottomBar_mc.SetButtonText("$Take All", 2);
			}
		}
		else if (this.bNPCMode) 
		{
			this.BottomBar_mc.SetButtonText("$Give", 2);
		}
		else 
		{
			this.BottomBar_mc.SetButtonText("$Store", 2);
		}
		this.updateFavoriteText();
	}

	function onMouseRotationFastClick(aiMouseButton)
	{
		gfx.io.GameDelegate.call("CheckForMouseEquip", [aiMouseButton], this, "AttemptEquip");
	}

	function updateEquipButtonText()
	{
		this.BottomBar_mc.SetButtonText(this.bShowEquipButtonHelp ? InventoryDefines.GetEquipText(this.ItemCard_mc.itemInfo.type) : "", 0);
	}

	function updateFavoriteText()
	{
		if (!this.isViewingContainer()) 
		{
			this.BottomBar_mc.SetButtonText(this.ItemCard_mc.itemInfo.favorite ? "$Unfavorite" : "$Favorite", 3);
			return;
		}
		this.BottomBar_mc.SetButtonText("", 3);
	}

	function isViewingContainer()
	{
		var __reg2 = this.InventoryLists_mc.CategoriesList.dividerIndex;
		return __reg2 != undefined && this.iSelectedCategory < __reg2;
	}

	function onQuantityMenuSelect(event)
	{
		if (this.iEquipHand != undefined) 
		{
			gfx.io.GameDelegate.call("EquipItem", [this.iEquipHand, event.amount]);
			this.iEquipHand = undefined;
			return;
		}
		if (this.InventoryLists_mc.ItemsList.selectedEntry.enabled) 
		{
			gfx.io.GameDelegate.call("ItemTransfer", [event.amount, this.isViewingContainer()]);
			return;
		}
		gfx.io.GameDelegate.call("DisabledItemSelect", []);
	}

	function AttemptEquip(aiSlot, abCheckOverList)
	{
		var __reg2 = abCheckOverList == undefined ? true : abCheckOverList;
		if (this.ShouldProcessItemsListInput(__reg2)) 
		{
			if (this.iPlatform == 0) 
			{
				if (!this.isViewingContainer() || this.bShowEquipButtonHelp) 
				{
					this.StartItemEquip(aiSlot);
				}
				else 
				{
					this.StartItemTransfer();
				}
				return;
			}
			this.StartItemEquip(aiSlot);
		}
	}

	function onItemSelect(event)
	{
		if (event.keyboardOrMouse != 0) 
		{
			if (!this.isViewingContainer()) 
			{
				this.StartItemEquip(ContainerMenu.NULL_HAND);
				return;
			}
			this.StartItemTransfer();
		}
	}

	function StartItemTransfer()
	{
		if (this.ItemCard_mc.itemInfo.weight == 0 && this.isViewingContainer()) 
		{
			this.onQuantityMenuSelect({amount: this.InventoryLists_mc.ItemsList.selectedEntry.count});
			return;
		}
		if (this.InventoryLists_mc.ItemsList.selectedEntry.count <= InventoryDefines.QUANTITY_MENU_COUNT_LIMIT) 
		{
			this.onQuantityMenuSelect({amount: 1});
			return;
		}
		this.ItemCard_mc.ShowQuantityMenu(this.InventoryLists_mc.ItemsList.selectedEntry.count);
	}

	function StartItemEquip(aiEquipHand)
	{
		if (this.isViewingContainer()) 
		{
			this.iEquipHand = aiEquipHand;
			this.StartItemTransfer();
			return;
		}
		gfx.io.GameDelegate.call("EquipItem", [aiEquipHand]);
	}

	function onItemCardSubMenuAction(event)
	{
		super.onItemCardSubMenuAction(event);
		if (event.menu == "quantity") 
		{
			gfx.io.GameDelegate.call("QuantitySliderOpen", [event.opening]);
		}
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		super.SetPlatform(aiPlatform, abPS3Switch);
		this.iPlatform = aiPlatform;
		this.bShowEquipButtonHelp = aiPlatform != 0;
		this.updateButtons();
	}

}
