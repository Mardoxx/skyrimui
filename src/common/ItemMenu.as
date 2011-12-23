dynamic class ItemMenu extends MovieClip
{
	var BottomBar_mc;
	var ExitMenuRect;
	var InventoryLists_mc;
	var ItemCardFadeHolder_mc;
	var ItemCard_mc;
	var ItemsListInputCatcher;
	var MouseRotationRect;
	var RestoreCategoryRect;
	var _parent;
	var bFadedIn;
	var iPlatform;

	function ItemMenu()
	{
		super();
		this.InventoryLists_mc = this.InventoryLists_mc;
		this.ItemCard_mc = this.ItemCardFadeHolder_mc.ItemCard_mc;
		this.BottomBar_mc = this.BottomBar_mc;
		this.bFadedIn = true;
		Mouse.addListener(this);
	}

	function InitExtensions(abPlayBladeSound)
	{
		gfx.io.GameDelegate.addCallBack("UpdatePlayerInfo", this, "UpdatePlayerInfo");
		gfx.io.GameDelegate.addCallBack("UpdateItemCardInfo", this, "UpdateItemCardInfo");
		gfx.io.GameDelegate.addCallBack("ToggleMenuFade", this, "ToggleMenuFade");
		gfx.io.GameDelegate.addCallBack("RestoreIndices", this, "RestoreIndices");
		this.InventoryLists_mc.addEventListener("categoryChange", this, "onCategoryChange");
		this.InventoryLists_mc.addEventListener("itemHighlightChange", this, "onItemHighlightChange");
		this.InventoryLists_mc.addEventListener("showItemsList", this, "onShowItemsList");
		this.InventoryLists_mc.addEventListener("hideItemsList", this, "onHideItemsList");
		this.InventoryLists_mc.ItemsList.addEventListener("itemPress", this, "onItemSelect");
		this.ItemCard_mc.addEventListener("quantitySelect", this, "onQuantityMenuSelect");
		this.ItemCard_mc.addEventListener("subMenuAction", this, "onItemCardSubMenuAction");
		this.PositionElements();
		this.InventoryLists_mc.ShowCategoriesList(abPlayBladeSound);
		this.ItemCard_mc._visible = false;
		this.BottomBar_mc.HideButtons();
		this.ItemsListInputCatcher.onMouseDown = function ()
		{
			if (this._parent.bFadedIn == true && Mouse.getTopMostEntity() == this) 
			{
				this._parent.onItemsListInputCatcherClick();
			}
		}
		;
		this.RestoreCategoryRect.onRollOver = function ()
		{
			if (this._parent.bFadedIn == true && this._parent.InventoryLists_mc.currentState == InventoryLists.TWO_PANELS) 
			{
				this._parent.InventoryLists_mc.RestoreCategoryIndex();
			}
		}
		;
		this.ExitMenuRect.onMouseDown = function ()
		{
			if (this._parent.bFadedIn == true && Mouse.getTopMostEntity() == this) 
			{
				this._parent.onExitMenuRectClick();
			}
		}
		;
	}

	function PositionElements()
	{
		Shared.GlobalFunc.SetLockFunction();
		MovieClip(this.InventoryLists_mc).Lock("L");
		this.InventoryLists_mc._x = this.InventoryLists_mc._x - 20;
		var __reg4 = Stage.visibleRect.x + Stage.safeRect.x;
		var __reg3 = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		this.BottomBar_mc.PositionElements(__reg4, __reg3);
		this.ItemCard_mc._parent._x = (__reg3 + this.InventoryLists_mc._x + this.InventoryLists_mc._width) / 2 - this.ItemCard_mc._parent._width / 2 - 85;
		MovieClip(this.ExitMenuRect).Lock("TL");
		this.ExitMenuRect._x = this.ExitMenuRect._x - Stage.safeRect.x;
		this.ExitMenuRect._y = this.ExitMenuRect._y - Stage.safeRect.y;
		this.RestoreCategoryRect._x = this.ExitMenuRect._x + this.InventoryLists_mc.CategoriesList._parent._width;
		this.ItemsListInputCatcher._x = this.RestoreCategoryRect._x + this.RestoreCategoryRect._width;
		this.ItemsListInputCatcher._width = _root._width - this.ItemsListInputCatcher._x;
		if (this.MouseRotationRect != undefined) 
		{
			MovieClip(this.MouseRotationRect).Lock("T");
			this.MouseRotationRect._x = this.ItemCard_mc._parent._x;
			this.MouseRotationRect._width = this.ItemCard_mc._parent._width;
			this.MouseRotationRect._height = 0.55 * Stage.visibleRect.height;
		}
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		this.iPlatform = aiPlatform;
		this.InventoryLists_mc.SetPlatform(aiPlatform, abPS3Switch);
		this.ItemCard_mc.SetPlatform(aiPlatform, abPS3Switch);
		this.BottomBar_mc.SetPlatform(aiPlatform, abPS3Switch);
	}

	function GetInventoryItemList()
	{
		return this.InventoryLists_mc.ItemsList;
	}

	function handleInput(details, pathToFocus)
	{
		if (this.bFadedIn) 
		{
			if (!pathToFocus[0].handleInput(details, pathToFocus.slice(1))) 
			{
				if (Shared.GlobalFunc.IsKeyPressed(details) && details.navEquivalent == gfx.ui.NavigationCode.TAB) 
				{
					gfx.io.GameDelegate.call("CloseMenu", []);
				}
			}
		}
		return true;
	}

	function onMouseWheel(delta)
	{
		var __reg2 = Mouse.getTopMostEntity();
		for (;;) 
		{
			if (!(__reg2 && __reg2 != undefined)) 
			{
				return;
			}
			if ((__reg2 == this.MouseRotationRect && this.ShouldProcessItemsListInput(false)) || (!this.bFadedIn && delta == -1)) 
			{
				gfx.io.GameDelegate.call("ZoomItemModel", [delta]);
			}
			else if (__reg2 == this.ItemsListInputCatcher && this.ShouldProcessItemsListInput(false)) 
			{
				if (delta == 1) 
				{
					this.InventoryLists_mc.ItemsList.moveSelectionUp();
				}
				else if (delta == -1) 
				{
					this.InventoryLists_mc.ItemsList.moveSelectionDown();
				}
			}
			__reg2 = __reg2._parent;
		}
	}

	function onExitMenuRectClick()
	{
		gfx.io.GameDelegate.call("CloseMenu", []);
	}

	function onCategoryChange(event)
	{
	}

	function onItemHighlightChange(event)
	{
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("UpdateItem3D", [true]);
			gfx.io.GameDelegate.call("RequestItemCardInfo", [], this, "UpdateItemCardInfo");
			return;
		}
		this.onHideItemsList();
	}

	function onShowItemsList(event)
	{
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("UpdateItem3D", [true]);
			gfx.io.GameDelegate.call("RequestItemCardInfo", [], this, "UpdateItemCardInfo");
			this.ItemCard_mc.FadeInCard();
			this.BottomBar_mc.ShowButtons();
		}
	}

	function onHideItemsList(event)
	{
		gfx.io.GameDelegate.call("UpdateItem3D", [false]);
		this.ItemCard_mc.FadeOutCard();
		this.BottomBar_mc.HideButtons();
	}

	function onItemSelect(event)
	{
		if (event.entry.enabled) 
		{
			if (event.entry.count > InventoryDefines.QUANTITY_MENU_COUNT_LIMIT) 
			{
				this.ItemCard_mc.ShowQuantityMenu(event.entry.count);
			}
			else 
			{
				this.onQuantityMenuSelect({amount: 1});
			}
			return;
		}
		gfx.io.GameDelegate.call("DisabledItemSelect", []);
	}

	function onQuantityMenuSelect(event)
	{
		gfx.io.GameDelegate.call("ItemSelect", [event.amount]);
	}

	function UpdatePlayerInfo(aUpdateObj)
	{
		this.BottomBar_mc.UpdatePlayerInfo(aUpdateObj, this.ItemCard_mc.itemInfo);
	}

	function UpdateItemCardInfo(aUpdateObj)
	{
		this.ItemCard_mc.itemInfo = aUpdateObj;
		this.BottomBar_mc.UpdatePerItemInfo(aUpdateObj);
	}

	function onItemCardSubMenuAction(event)
	{
		if (event.opening == true) 
		{
			this.InventoryLists_mc.ItemsList.disableSelection = true;
			this.InventoryLists_mc.ItemsList.disableInput = true;
			this.InventoryLists_mc.CategoriesList.disableSelection = true;
			this.InventoryLists_mc.CategoriesList.disableInput = true;
			return;
		}
		if (event.opening == false) 
		{
			this.InventoryLists_mc.ItemsList.disableSelection = false;
			this.InventoryLists_mc.ItemsList.disableInput = false;
			this.InventoryLists_mc.CategoriesList.disableSelection = false;
			this.InventoryLists_mc.CategoriesList.disableInput = false;
		}
	}

	function ShouldProcessItemsListInput(abCheckIfOverRect)
	{
		var __reg4 = this.bFadedIn == true && this.InventoryLists_mc.currentState == InventoryLists.TWO_PANELS && this.InventoryLists_mc.ItemsList.numUnfilteredItems > 0 && !this.InventoryLists_mc.ItemsList.disableSelection && !this.InventoryLists_mc.ItemsList.disableInput;
		if (__reg4 && this.iPlatform == 0 && abCheckIfOverRect) 
		{
			var __reg2 = Mouse.getTopMostEntity();
			var __reg3 = false;
			while (!__reg3 && __reg2 && __reg2 != undefined) 
			{
				if (__reg2 == this.ItemsListInputCatcher || __reg2 == this.InventoryLists_mc.ItemsList) 
				{
					__reg3 = true;
				}
				__reg2 = __reg2._parent;
			}
			__reg4 = __reg4 && __reg3;
		}
		return __reg4;
	}

	function onMouseRotationStart()
	{
		gfx.io.GameDelegate.call("StartMouseRotation", []);
		this.InventoryLists_mc.CategoriesList.disableSelection = true;
		this.InventoryLists_mc.ItemsList.disableSelection = true;
	}

	function onMouseRotationStop()
	{
		gfx.io.GameDelegate.call("StopMouseRotation", []);
		this.InventoryLists_mc.CategoriesList.disableSelection = false;
		this.InventoryLists_mc.ItemsList.disableSelection = false;
	}

	function onItemsListInputCatcherClick()
	{
		if (this.ShouldProcessItemsListInput(false)) 
		{
			this.onItemSelect({entry: this.InventoryLists_mc.ItemsList.selectedEntry, keyboardOrMouse: 0});
		}
	}

	function onMouseRotationFastClick()
	{
		this.onItemsListInputCatcherClick();
	}

	function ToggleMenuFade()
	{
		if (this.bFadedIn) 
		{
			this._parent.gotoAndPlay("fadeOut");
			this.bFadedIn = false;
			this.InventoryLists_mc.ItemsList.disableSelection = true;
			this.InventoryLists_mc.ItemsList.disableInput = true;
			this.InventoryLists_mc.CategoriesList.disableSelection = true;
			this.InventoryLists_mc.CategoriesList.disableInput = true;
			return;
		}
		this._parent.gotoAndPlay("fadeIn");
	}

	function SetFadedIn()
	{
		this.bFadedIn = true;
		this.InventoryLists_mc.ItemsList.disableSelection = false;
		this.InventoryLists_mc.ItemsList.disableInput = false;
		this.InventoryLists_mc.CategoriesList.disableSelection = false;
		this.InventoryLists_mc.CategoriesList.disableInput = false;
	}

	function RestoreIndices()
	{
		this.InventoryLists_mc.CategoriesList.RestoreScrollPosition(arguments[0], true);
		var __reg3 = 1;
		while (__reg3 < arguments.length) 
		{
			this.InventoryLists_mc.CategoriesList.entryList[__reg3 - 1].savedItemIndex = arguments[__reg3];
			++__reg3;
		}
		this.InventoryLists_mc.CategoriesList.UpdateList();
	}

	function SaveIndices()
	{
		var __reg3 = new Array();
		__reg3.push(this.InventoryLists_mc.CategoriesList.scrollPosition);
		var __reg2 = 0;
		while (__reg2 < this.InventoryLists_mc.CategoriesList.entryList.length) 
		{
			__reg3.push(this.InventoryLists_mc.CategoriesList.entryList[__reg2].savedItemIndex);
			++__reg2;
		}
		gfx.io.GameDelegate.call("SaveIndices", [__reg3]);
	}

}
