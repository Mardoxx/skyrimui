class InventoryLists extends MovieClip
{
	static var NO_PANELS: Number = 0;
	static var ONE_PANEL: Number = 1;
	static var TWO_PANELS: Number = 2;
	static var TRANSITIONING_TO_NO_PANELS: Number = 3;
	static var TRANSITIONING_TO_ONE_PANEL: Number = 4;
	static var TRANSITIONING_TO_TWO_PANELS: Number = 5;
	var CategoriesListHolder: MovieClip;
	var ItemsListHolder: MovieClip;
	var _CategoriesList: MovieClip;
	var _ItemsList: MovieClip;
	var dispatchEvent: Function;
	var iCurrCategoryIndex: Number;
	var iCurrentState: Number;
	var iPlatform: Number;
	var strHideItemsCode: String;
	var strShowItemsCode: String;

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

	function onLoad(): Void
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

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
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

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (this.iCurrentState == InventoryLists.ONE_PANEL || this.iCurrentState == InventoryLists.TWO_PANELS) 
		{
			if (Shared.GlobalFunc.IsKeyPressed(details)) 
			{
				if (details.navEquivalent == this.strHideItemsCode && this.iCurrentState == InventoryLists.TWO_PANELS) 
				{
					this.HideItemsList();
					bHandledInput = true;
				}
				else if (details.navEquivalent == this.strShowItemsCode && this.iCurrentState == InventoryLists.ONE_PANEL) 
				{
					this.ShowItemsList();
					bHandledInput = true;
				}
			}
			if (!bHandledInput) 
			{
				bHandledInput = pathToFocus[0].handleInput(details, pathToFocus.slice(1));
			}
		}
		return bHandledInput;
	}

	function get CategoriesList(): MovieClip
	{
		return this._CategoriesList;
	}

	function get ItemsList(): MovieClip
	{
		return this._ItemsList;
	}

	function get currentState(): Number
	{
		return this.iCurrentState;
	}

	function set currentState(aiNewState: Number): Void
	{
		if (aiNewState === InventoryLists.NO_PANELS) 
		{
			this.iCurrentState = aiNewState;
		}
		else if (aiNewState === InventoryLists.ONE_PANEL) 
		{
			this.iCurrentState = aiNewState;
			gfx.managers.FocusHandler.instance.setFocus(this._CategoriesList, 0);
		}
		else if (aiNewState === InventoryLists.TWO_PANELS) 
		{
			this.iCurrentState = aiNewState;
			gfx.managers.FocusHandler.instance.setFocus(this._ItemsList, 0);
		}
	}

	function RestoreCategoryIndex(): Void
	{
		this._CategoriesList.selectedIndex = this.iCurrCategoryIndex;
	}

	function ShowCategoriesList(abPlayBladeSound: Boolean): Void
	{
		this.iCurrentState = InventoryLists.TRANSITIONING_TO_ONE_PANEL;
		this.dispatchEvent({type: "categoryChange", index: this._CategoriesList.selectedIndex});
		this.gotoAndPlay("Panel1Show");
		if (abPlayBladeSound != false) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
		}
	}

	function HideCategoriesList(): Void
	{
		this.iCurrentState = InventoryLists.TRANSITIONING_TO_NO_PANELS;
		this.gotoAndPlay("Panel1Hide");
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
	}

	function ShowItemsList(abPlayBladeSound: Boolean, abPlayAnim: Boolean): Void
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

	function HideItemsList(): Void
	{
		this.iCurrentState = InventoryLists.TRANSITIONING_TO_ONE_PANEL;
		this.dispatchEvent({type: "hideItemsList", index: this._ItemsList.selectedIndex});
		this._ItemsList.selectedIndex = -1;
		this.gotoAndPlay("Panel2Hide");
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
		this._ItemsList.disableInput = true;
	}

	function onCategoriesItemPress(): Void
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

	function onCategoriesListPress(): Void
	{
		if (this.iCurrentState == InventoryLists.TWO_PANELS && !this._ItemsList.disableSelection && !this._ItemsList.disableInput) 
		{
			this.HideItemsList();
			this._CategoriesList.UpdateList();
		}
	}

	function onCategoriesListMoveUp(event: Object): Void
	{
		this.doCategorySelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._CategoriesList._parent.gotoAndPlay("moveUp");
		}
	}

	function onCategoriesListMoveDown(event: Object): Void
	{
		this.doCategorySelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._CategoriesList._parent.gotoAndPlay("moveDown");
		}
	}

	function onCategoriesListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0) 
		{
			this.doCategorySelectionChange(event);
		}
	}

	function onItemsListMoveUp(event: Object): Void
	{
		this.doItemsSelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._ItemsList._parent.gotoAndPlay("moveUp");
		}
	}

	function onItemsListMoveDown(event: Object): Void
	{
		this.doItemsSelectionChange(event);
		if (event.scrollChanged == true) 
		{
			this._ItemsList._parent.gotoAndPlay("moveDown");
		}
	}

	function onItemsListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0) 
		{
			this.doItemsSelectionChange(event);
		}
	}

	function doCategorySelectionChange(event: Object): Void
	{
		this.dispatchEvent({type: "categoryChange", index: event.index});
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		}
	}

	function doItemsSelectionChange(event: Object): Void
	{
		this._CategoriesList.selectedEntry.savedItemIndex = this._ItemsList.scrollPosition;
		this.dispatchEvent({type: "itemHighlightChange", index: event.index});
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		}
	}

	function SetCategoriesList(): Void
	{
		var iTextOffset: Number = 0;
		var iFlagOffset: Number = 1;
		var iDontHideOffset: Number = 2;
		var iNumObjKeys: Number = 3;
		this._CategoriesList.entryList.splice(0, this._CategoriesList.entryList.length);
		var i: Number = 0;
		while (i < arguments.length) 
		{
			var ItemObj: Object = {text: arguments[i + iTextOffset], flag: arguments[i + iFlagOffset], bDontHide: arguments[i + iDontHideOffset], savedItemIndex: 0, filterFlag: arguments[i + iDontHideOffset] == true ? 1 : 0};
			if (ItemObj.flag == 0) 
			{
				ItemObj.divider = true;
			}
			this._CategoriesList.entryList.push(ItemObj);
			i = i + iNumObjKeys;
		}
		this._CategoriesList.InvalidateData();
		this._ItemsList.filterer.itemFilter = this._CategoriesList.selectedEntry.flag;
	}

	function InvalidateListData(): Void
	{
		var centredEntry: Object = this._CategoriesList.centeredEntry;
		var iselectedEntryFlag: Number = this._CategoriesList.selectedEntry.flag;
		var i: Number = 0;
		while (i < this._CategoriesList.entryList.length) 
		{
			this._CategoriesList.entryList[i].filterFlag = this._CategoriesList.entryList[i].bDontHide ? 1 : 0;
			++i;
		}
		this._ItemsList.InvalidateData();
		i = 0;
		while (i < this._ItemsList.entryList.length) 
		{
			var iCurrentEntryFilterFlag: Number = this._ItemsList.entryList[i].filterFlag;
			var j: Number = 0;
			while (j < this._CategoriesList.entryList.length) 
			{
				if (this._CategoriesList.entryList[j].filterFlag == 0) 
				{
					if (this._ItemsList.entryList[i].filterFlag & this._CategoriesList.entryList[j].flag) 
					{
						this._CategoriesList.entryList[j].filterFlag = 1;
					}
				}
				++j;
			}
			++i;
		}
		this._CategoriesList.onFilterChange();
		var j: Number = 0;
		i = 0;
		while (i < this._CategoriesList.entryList.length) 
		{
			if (this._CategoriesList.entryList[i].filterFlag == 1) 
			{
				if (centredEntry.flag == this._CategoriesList.entryList[i].flag) 
				{
					this._CategoriesList.RestoreScrollPosition(j, false);
				}
				++j;
			}
			++i;
		}
		this._CategoriesList.UpdateList();
		if (this._CategoriesList.centeredEntry == undefined) 
		{
			this._CategoriesList.scrollPosition = this._CategoriesList.scrollPosition - 1;
		}
		if (iselectedEntryFlag != this._CategoriesList.selectedEntry.flag) 
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
