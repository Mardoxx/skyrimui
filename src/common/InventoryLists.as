dynamic class InventoryLists extends MovieClip
{
	static var NO_PANELS: Number = 0;
	static var ONE_PANEL: Number = 1;
	static var TWO_PANELS: Number = 2;
	static var TRANSITIONING_TO_NO_PANELS: Number = 3;
	static var TRANSITIONING_TO_ONE_PANEL: Number = 4;
	static var TRANSITIONING_TO_TWO_PANELS: Number = 5;
	var CategoriesListHolder;
	var ItemsListHolder;
	var _CategoriesList;
	var _ItemsList;
	var dispatchEvent;
	var gotoAndPlay;
	var gotoAndStop;
	var iCurrCategoryIndex;
	var iCurrentState;
	var iPlatform;
	var strHideItemsCode;
	var strShowItemsCode;

	function InventoryLists()
	{
		super();
		this._CategoriesList = this.CategoriesListHolder.List_mc;
		this._ItemsList = this.ItemsListHolder.List_mc;
		gfx.events.EventDispatcher.initialize(this);
		this.gotoAndStop("NoPanels");
		gfx.io.GameDelegate.addCallBack("SetCategoriesList", this, "SetCategoriesList");
		gfx.io.GameDelegate.addCallBack("InvalidateListData", this, "InvalidateListData");
		this.strHideItemsCode = gfx.ui.NavigationCode.LEFT;
		this.strShowItemsCode = gfx.ui.NavigationCode.RIGHT;
	}

	function onLoad()
	{
		this._CategoriesList.addEventListener("itemPress", this, "onCategoriesItemPress");
		this._CategoriesList.addEventListener("listPress", this, "onCategoriesListPress");
		this._CategoriesList.addEventListener("listMovedUp", this, "onCategoriesListMoveUp");
		this._CategoriesList.addEventListener("listMovedDown", this, "onCategoriesListMoveDown");
		this._CategoriesList.addEventListener("selectionChange", this, "onCategoriesListMouseSelectionChange");
		this._CategoriesList.numTopHalfEntries = 7;
		this._CategoriesList.filterer.itemFilter = 1;
		this._ItemsList.maxTextLength = 35;
		this._ItemsList.disableInput = true;
		this._ItemsList.addEventListener("listMovedUp", this, "onItemsListMoveUp");
		this._ItemsList.addEventListener("listMovedDown", this, "onItemsListMoveDown");
		this._ItemsList.addEventListener("selectionChange", this, "onItemsListMouseSelectionChange");
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		this.iPlatform = aiPlatform;
		this._CategoriesList.SetPlatform(aiPlatform, abPS3Switch);
		this._ItemsList.SetPlatform(aiPlatform, abPS3Switch);
		if (this.iPlatform == 0) 
		{
			this.CategoriesListHolder.ListBackground.gotoAndStop("Mouse");
			this.ItemsListHolder.ListBackground.gotoAndStop("Mouse");
			return;
		}
		this.CategoriesListHolder.ListBackground.gotoAndStop("Gamepad");
		this.ItemsListHolder.ListBackground.gotoAndStop("Gamepad");
	}

	function handleInput(details, pathToFocus)
	{
		var __reg2 = false;
		if (this.iCurrentState == InventoryLists.ONE_PANEL || this.iCurrentState == InventoryLists.TWO_PANELS) 
		{
			if (Shared.GlobalFunc.IsKeyPressed(details)) 
			{
				if (details.navEquivalent == this.strHideItemsCode && this.iCurrentState == InventoryLists.TWO_PANELS) 
				{
					this.HideItemsList();
					__reg2 = true;
				}
				else if (details.navEquivalent == this.strShowItemsCode && this.iCurrentState == InventoryLists.ONE_PANEL) 
				{
					this.ShowItemsList();
					__reg2 = true;
				}
			}
			if (!__reg2) 
			{
				__reg2 = pathToFocus[0].handleInput(details, pathToFocus.slice(1));
			}
		}
		return __reg2;
	}

	function get CategoriesList()
	{
		return this._CategoriesList;
	}

	function get ItemsList()
	{
		return this._ItemsList;
	}

	function get currentState()
	{
		return this.iCurrentState;
	}

	function set currentState(aiNewState)
	{
		if ((__reg0 = aiNewState) === InventoryLists.NO_PANELS) 
		{
			this.iCurrentState = aiNewState;
		}
		else if (__reg0 === InventoryLists.ONE_PANEL) 
		{
			this.iCurrentState = aiNewState;
			gfx.managers.FocusHandler.instance.setFocus(this._CategoriesList, 0);
		}
		else if (__reg0 === InventoryLists.TWO_PANELS) 
		{
			this.iCurrentState = aiNewState;
			gfx.managers.FocusHandler.instance.setFocus(this._ItemsList, 0);
		}
	}

	function RestoreCategoryIndex()
	{
		this._CategoriesList.selectedIndex = this.iCurrCategoryIndex;
	}

	function ShowCategoriesList(abPlayBladeSound)
	{
		this.iCurrentState = InventoryLists.TRANSITIONING_TO_ONE_PANEL;
		this.dispatchEvent({type: "categoryChange", index: this._CategoriesList.selectedIndex});
		this.gotoAndPlay("Panel1Show");
		if (abPlayBladeSound != false) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
		}
	}

	function HideCategoriesList()
	{
		this.iCurrentState = InventoryLists.TRANSITIONING_TO_NO_PANELS;
		this.gotoAndPlay("Panel1Hide");
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
	}

	function ShowItemsList(abPlayBladeSound, abPlayAnim)
	{
		if (abPlayAnim != false) 
		{
			this.iCurrentState = InventoryLists.TRANSITIONING_TO_TWO_PANELS;
		}
		if (this._CategoriesList.selectedEntry != undefined) 
		{
			this.iCurrCategoryIndex = this._CategoriesList.selectedIndex;
			this._ItemsList.filterer.itemFilter = this._CategoriesList.selectedEntry.flag;
			this._ItemsList.RestoreScrollPosition(this._CategoriesList.selectedEntry.savedItemIndex, true);
		}
		this._ItemsList.UpdateList();
		this.dispatchEvent({type: "showItemsList", index: this._ItemsList.selectedIndex});
		if (abPlayAnim != false) 
		{
			this.gotoAndPlay("Panel2Show");
		}
		if (abPlayBladeSound != false) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
		}
		this._ItemsList.disableInput = false;
	}

	function HideItemsList()
	{
		this.iCurrentState = InventoryLists.TRANSITIONING_TO_ONE_PANEL;
		this.dispatchEvent({type: "hideItemsList", index: this._ItemsList.selectedIndex});
		this._ItemsList.selectedIndex = -1;
		this.gotoAndPlay("Panel2Hide");
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
		this._ItemsList.disableInput = true;
	}

	function onCategoriesItemPress()
	{
		if (this.iCurrentState == InventoryLists.ONE_PANEL) 
		{
			this.ShowItemsList();
			return;
		}
		if (this.iCurrentState == InventoryLists.TWO_PANELS) 
		{
			this.ShowItemsList(true, false);
		}
	}

	function onCategoriesListPress()
	{
		if (this.iCurrentState == InventoryLists.TWO_PANELS && !this._ItemsList.disableSelection && !this._ItemsList.disableInput) 
		{
			this.HideItemsList();
			this._CategoriesList.UpdateList();
		}
	}

	function onCategoriesListMoveUp(event)
	{
		this.doCategorySelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._CategoriesList._parent.gotoAndPlay("moveUp");
		}
	}

	function onCategoriesListMoveDown(event)
	{
		this.doCategorySelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._CategoriesList._parent.gotoAndPlay("moveDown");
		}
	}

	function onCategoriesListMouseSelectionChange(event)
	{
		if (event.keyboardOrMouse == 0) 
		{
			this.doCategorySelectionChange(event);
		}
	}

	function onItemsListMoveUp(event)
	{
		this.doItemsSelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._ItemsList._parent.gotoAndPlay("moveUp");
		}
	}

	function onItemsListMoveDown(event)
	{
		this.doItemsSelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._ItemsList._parent.gotoAndPlay("moveDown");
		}
	}

	function onItemsListMouseSelectionChange(event)
	{
		if (event.keyboardOrMouse == 0) 
		{
			this.doItemsSelectionChange(event);
		}
	}

	function doCategorySelectionChange(event)
	{
		this.dispatchEvent({type: "categoryChange", index: event.index});
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		}
	}

	function doItemsSelectionChange(event)
	{
		this._CategoriesList.selectedEntry.savedItemIndex = this._ItemsList.scrollPosition;
		this.dispatchEvent({type: "itemHighlightChange", index: event.index});
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		}
	}

	function SetCategoriesList()
	{
		var __reg12 = 0;
		var __reg13 = 1;
		var __reg5 = 2;
		var __reg11 = 3;
		this._CategoriesList.entryList.splice(0, this._CategoriesList.entryList.length);
		var __reg3 = 0;
		while (__reg3 < arguments.length) 
		{
			var __reg4 = {text: arguments[__reg3 + __reg12], flag: arguments[__reg3 + __reg13], bDontHide: arguments[__reg3 + __reg5], savedItemIndex: 0, filterFlag: arguments[__reg3 + __reg5] == true ? 1 : 0};
			if (__reg4.flag == 0) 
			{
				__reg4.divider = true;
			}
			this._CategoriesList.entryList.push(__reg4);
			__reg3 = __reg3 + __reg11;
		}
		this._CategoriesList.InvalidateData();
		this._ItemsList.filterer.itemFilter = this._CategoriesList.selectedEntry.flag;
	}

	function InvalidateListData()
	{
		var __reg6 = this._CategoriesList.centeredEntry;
		var __reg7 = this._CategoriesList.selectedEntry.flag;
		var __reg3 = 0;
		while (__reg3 < this._CategoriesList.entryList.length) 
		{
			this._CategoriesList.entryList[__reg3].filterFlag = this._CategoriesList.entryList[__reg3].bDontHide ? 1 : 0;
			++__reg3;
		}
		this._ItemsList.InvalidateData();
		__reg3 = 0;
		while (__reg3 < this._ItemsList.entryList.length) 
		{
			var __reg5 = this._ItemsList.entryList[__reg3].filterFlag;
			var __reg2 = 0;
			while (__reg2 < this._CategoriesList.entryList.length) 
			{
				if (this._CategoriesList.entryList[__reg2].filterFlag == 0) 
				{
					if (this._ItemsList.entryList[__reg3].filterFlag & this._CategoriesList.entryList[__reg2].flag) 
					{
						this._CategoriesList.entryList[__reg2].filterFlag = 1;
					}
				}
				++__reg2;
			}
			++__reg3;
		}
		this._CategoriesList.onFilterChange();
		var __reg4 = 0;
		__reg3 = 0;
		while (__reg3 < this._CategoriesList.entryList.length) 
		{
			if (this._CategoriesList.entryList[__reg3].filterFlag == 1) 
			{
				if (__reg6.flag == this._CategoriesList.entryList[__reg3].flag) 
				{
					this._CategoriesList.RestoreScrollPosition(__reg4, false);
				}
				++__reg4;
			}
			++__reg3;
		}
		this._CategoriesList.UpdateList();
		if (this._CategoriesList.centeredEntry == undefined) 
		{
			this._CategoriesList.scrollPosition = this._CategoriesList.scrollPosition - 1;
		}
		if (__reg7 != this._CategoriesList.selectedEntry.flag) 
		{
			this._ItemsList.filterer.itemFilter = this._CategoriesList.selectedEntry.flag;
			this._ItemsList.UpdateList();
			this.dispatchEvent({type: "categoryChange", index: this._CategoriesList.selectedIndex});
		}
		if (this.iCurrentState != InventoryLists.TWO_PANELS && this.iCurrentState != InventoryLists.TRANSITIONING_TO_TWO_PANELS) 
		{
			this._ItemsList.selectedIndex = -1;
			return;
		}
		if (this.iCurrentState == InventoryLists.TWO_PANELS) 
		{
			this.dispatchEvent({type: "itemHighlightChange", index: this._ItemsList.selectedIndex});
			return;
		}
		this.dispatchEvent({type: "showItemsList", index: this._ItemsList.selectedIndex});
	}

}
