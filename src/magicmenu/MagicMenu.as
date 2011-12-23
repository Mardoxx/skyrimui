dynamic class MagicMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
	var BottomBar_mc;
	var ExitMenuRect;
	var InventoryLists_mc;
	var ItemCard_mc;
	var ItemsListInputCatcher;
	var MagicButtonArt;
	var RestoreCategoryRect;
	var SaveIndices;
	var ShouldProcessItemsListInput;
	var ToggleMenuFade;
	var bFadedIn;
	var bMenuClosing;
	var iHideButtonFlag;

	function MagicMenu()
	{
		super();
		this.bMenuClosing = false;
		this.iHideButtonFlag = 0;
	}

	function InitExtensions()
	{
		super.InitExtensions();
		gfx.io.GameDelegate.addCallBack("DragonSoulSpent", this, "DragonSoulSpent");
		gfx.io.GameDelegate.addCallBack("AttemptEquip", this, "AttemptEquip");
		this.BottomBar_mc.UpdatePerItemInfo({type: InventoryDefines.ICT_SPELL_DEFAULT});
		this.MagicButtonArt = [{PCArt: "M1M2", XBoxArt: "360_LTRT", PS3Art: "PS3_LBRB"}, {PCArt: "F", XBoxArt: "360_Y", PS3Art: "PS3_Y"}, {PCArt: "R", XBoxArt: "360_X", PS3Art: "PS3_X"}, {PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}];
		this.BottomBar_mc.SetButtonsArt(this.MagicButtonArt);
	}

	function PositionElements()
	{
		super.PositionElements();
		MovieClip(this.InventoryLists_mc).Lock("R");
		this.InventoryLists_mc._x = this.InventoryLists_mc._x + 20;
		var __reg3 = Stage.visibleRect.x + Stage.safeRect.x;
		this.ItemCard_mc._parent._x = (__reg3 + this.InventoryLists_mc._x - this.InventoryLists_mc._width) / 2 - this.ItemCard_mc._parent._width / 2 + 25;
		MovieClip(this.ExitMenuRect).Lock("TR");
		this.ExitMenuRect._y = this.ExitMenuRect._y - Stage.safeRect.y;
		this.RestoreCategoryRect._x = this.ExitMenuRect._x - this.InventoryLists_mc.CategoriesList._parent._width;
		MovieClip(this.ItemsListInputCatcher).Lock("L");
		this.ItemsListInputCatcher._x = this.ItemsListInputCatcher._x - Stage.safeRect.x;
		this.ItemsListInputCatcher._width = this.RestoreCategoryRect._x - Stage.visibleRect.x + 10;
	}

	function handleInput(details, pathToFocus)
	{
		if (this.bFadedIn && !pathToFocus[0].handleInput(details, pathToFocus.slice(1))) 
		{
			if (Shared.GlobalFunc.IsKeyPressed(details)) 
			{
				if (this.InventoryLists_mc.currentState == InventoryLists.ONE_PANEL && details.navEquivalent == gfx.ui.NavigationCode.RIGHT) 
				{
					this.StartMenuFade();
					gfx.io.GameDelegate.call("ShowTweenMenu", []);
				}
				else if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
				{
					this.StartMenuFade();
					gfx.io.GameDelegate.call("CloseTweenMenu", []);
				}
			}
		}
		return true;
	}

	function onExitMenuRectClick()
	{
		this.StartMenuFade();
		gfx.io.GameDelegate.call("ShowTweenMenu", []);
	}

	function StartMenuFade()
	{
		this.InventoryLists_mc.HideCategoriesList();
		this.ToggleMenuFade();
		this.SaveIndices();
		this.bMenuClosing = true;
	}

	function onFadeCompletion()
	{
		if (this.bMenuClosing) 
		{
			gfx.io.GameDelegate.call("CloseMenu", []);
		}
	}

	function onShowItemsList(event)
	{
		super.onShowItemsList(event);
		if (event.index != -1) 
		{
			this.UpdateButtonText();
		}
	}

	function onItemHighlightChange(event)
	{
		super.onItemHighlightChange(event);
		if (event.index != -1) 
		{
			this.UpdateButtonText();
		}
	}

	function DragonSoulSpent()
	{
		this.ItemCard_mc.itemInfo.soulSpent = true;
		this.UpdateButtonText();
	}

	function get hideButtonFlag()
	{
		return this.iHideButtonFlag;
	}

	function set hideButtonFlag(aiHideFlag)
	{
		this.iHideButtonFlag = aiHideFlag;
	}

	function UpdateButtonText()
	{
		if (this.InventoryLists_mc.ItemsList.selectedEntry != undefined) 
		{
			var __reg3 = (this.InventoryLists_mc.ItemsList.selectedEntry.filterFlag & this.InventoryLists_mc.CategoriesList.entryList[0].flag) == 0 ? "$Favorite" : "$Unfavorite";
			var __reg2 = this.ItemCard_mc.itemInfo.showUnlocked == true ? "$Unlock" : "";
			if ((this.InventoryLists_mc.ItemsList.selectedEntry.filterFlag & this.iHideButtonFlag) != 0) 
			{
				this.BottomBar_mc.HideButtons();
				return;
			}
			this.BottomBar_mc.SetButtonsText("$Equip", __reg3, __reg2);
		}
	}

	function onHideItemsList(event)
	{
		super.onHideItemsList(event);
		this.BottomBar_mc.UpdatePerItemInfo({type: InventoryDefines.ICT_SPELL_DEFAULT});
	}

	function AttemptEquip(aiSlot)
	{
		if (this.ShouldProcessItemsListInput(true)) 
		{
			gfx.io.GameDelegate.call("ItemSelect", [aiSlot]);
		}
	}

	function onItemSelect(event)
	{
		if (event.entry.enabled) 
		{
			if (event.keyboardOrMouse != 0) 
			{
				gfx.io.GameDelegate.call("ItemSelect", []);
			}
			return;
		}
		gfx.io.GameDelegate.call("ShowShoutFail", []);
	}

}
