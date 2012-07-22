import gfx.events.EventDispatcher;
import gfx.io.GameDelegate;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.managers.FocusHandler;
import Shared.GlobalFunc;

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
		_CategoriesList = CategoriesListHolder.List_mc;
		_ItemsList = ItemsListHolder.List_mc;
		EventDispatcher.initialize(this);
		gotoAndStop("NoPanels");
		GameDelegate.addCallBack("SetCategoriesList", this, "SetCategoriesList");
		GameDelegate.addCallBack("InvalidateListData", this, "InvalidateListData");
		strHideItemsCode = NavigationCode.LEFT;
		strShowItemsCode = NavigationCode.RIGHT;
	}

	function onLoad(): Void
	{
		_CategoriesList.addEventListener("itemPress", this, "onCategoriesItemPress");
		_CategoriesList.addEventListener("listPress", this, "onCategoriesListPress");
		_CategoriesList.addEventListener("listMovedUp", this, "onCategoriesListMoveUp");
		_CategoriesList.addEventListener("listMovedDown", this, "onCategoriesListMoveDown");
		_CategoriesList.addEventListener("selectionChange", this, "onCategoriesListMouseSelectionChange");
		_CategoriesList.numTopHalfEntries = 7;
		_CategoriesList.filterer.itemFilter = 1;
		_ItemsList.maxTextLength = 35;
		_ItemsList.disableInput = true;
		_ItemsList.addEventListener("listMovedUp", this, "onItemsListMoveUp");
		_ItemsList.addEventListener("listMovedDown", this, "onItemsListMoveDown");
		_ItemsList.addEventListener("selectionChange", this, "onItemsListMouseSelectionChange");
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		iPlatform = aiPlatform;
		_CategoriesList.SetPlatform(aiPlatform, abPS3Switch);
		_ItemsList.SetPlatform(aiPlatform, abPS3Switch);
		if (iPlatform == 0) {
			CategoriesListHolder.ListBackground.gotoAndStop("Mouse");
			ItemsListHolder.ListBackground.gotoAndStop("Mouse");
			return;
		}
		CategoriesListHolder.ListBackground.gotoAndStop("Gamepad");
		ItemsListHolder.ListBackground.gotoAndStop("Gamepad");
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (iCurrentState == InventoryLists.ONE_PANEL || iCurrentState == InventoryLists.TWO_PANELS) {
			if (GlobalFunc.IsKeyPressed(details)) {
				if (details.navEquivalent == strHideItemsCode && iCurrentState == InventoryLists.TWO_PANELS) {
					HideItemsList();
					bHandledInput = true;
				} else if (details.navEquivalent == strShowItemsCode && iCurrentState == InventoryLists.ONE_PANEL) {
					ShowItemsList();
					bHandledInput = true;
				}
			}
			if (!bHandledInput)
				bHandledInput = pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		return bHandledInput;
	}

	function get CategoriesList(): MovieClip
	{
		return _CategoriesList;
	}

	function get ItemsList(): MovieClip
	{
		return _ItemsList;
	}

	function get currentState(): Number
	{
		return iCurrentState;
	}

	function set currentState(aiNewState: Number): Void
	{
		switch(aiNewState) {
			case InventoryLists.NO_PANELS:
				iCurrentState = aiNewState;
				break;
			case InventoryLists.ONE_PANEL:
				iCurrentState = aiNewState;
				FocusHandler.instance.setFocus(_CategoriesList, 0);
				break;
			case InventoryLists.TWO_PANELS:
				iCurrentState = aiNewState;
				FocusHandler.instance.setFocus(_ItemsList, 0);
				break;
		}
	}

	function RestoreCategoryIndex(): Void
	{
		_CategoriesList.selectedIndex = iCurrCategoryIndex;
	}

	function ShowCategoriesList(abPlayBladeSound: Boolean): Void
	{
		iCurrentState = InventoryLists.TRANSITIONING_TO_ONE_PANEL;
		dispatchEvent({type: "categoryChange", index: _CategoriesList.selectedIndex});
		gotoAndPlay("Panel1Show");
		if (abPlayBladeSound != false) 
			GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
	}

	function HideCategoriesList(): Void
	{
		iCurrentState = InventoryLists.TRANSITIONING_TO_NO_PANELS;
		gotoAndPlay("Panel1Hide");
		GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
	}

	function ShowItemsList(abPlayBladeSound: Boolean, abPlayAnim: Boolean): Void
	{
		if (abPlayAnim != false) 
			iCurrentState = InventoryLists.TRANSITIONING_TO_TWO_PANELS;
		if (_CategoriesList.selectedEntry != undefined) {
			iCurrCategoryIndex = _CategoriesList.selectedIndex;
			_ItemsList.filterer.itemFilter = _CategoriesList.selectedEntry.flag;
			_ItemsList.RestoreScrollPosition(_CategoriesList.selectedEntry.savedItemIndex, true);
		}
		_ItemsList.UpdateList();
		dispatchEvent({type: "showItemsList", index: _ItemsList.selectedIndex});
		if (abPlayAnim != false) 
			gotoAndPlay("Panel2Show");
		if (abPlayBladeSound != false) 
			GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
		_ItemsList.disableInput = false;
	}

	function HideItemsList(): Void
	{
		iCurrentState = InventoryLists.TRANSITIONING_TO_ONE_PANEL;
		dispatchEvent({type: "hideItemsList", index: _ItemsList.selectedIndex});
		_ItemsList.selectedIndex = -1;
		gotoAndPlay("Panel2Hide");
		GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
		_ItemsList.disableInput = true;
	}

	function onCategoriesItemPress(): Void
	{
		if (iCurrentState == InventoryLists.ONE_PANEL)
			ShowItemsList();
		else if (iCurrentState == InventoryLists.TWO_PANELS) 
			ShowItemsList(true, false);
	}

	function onCategoriesListPress(): Void
	{
		if (iCurrentState == InventoryLists.TWO_PANELS && !_ItemsList.disableSelection && !_ItemsList.disableInput) {
			HideItemsList();
			_CategoriesList.UpdateList();
		}
	}

	function onCategoriesListMoveUp(event: Object): Void
	{
		doCategorySelectionChange(event);
		if (event.scrollChanged == true) 
			_CategoriesList._parent.gotoAndPlay("moveUp");
	}

	function onCategoriesListMoveDown(event: Object): Void
	{
		doCategorySelectionChange(event);
		if (event.scrollChanged == true) 
			_CategoriesList._parent.gotoAndPlay("moveDown");
	}

	function onCategoriesListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0) 
			doCategorySelectionChange(event);
	}

	function onItemsListMoveUp(event: Object): Void
	{
		doItemsSelectionChange(event);
		if (event.scrollChanged == true) 
			_ItemsList._parent.gotoAndPlay("moveUp");
	}

	function onItemsListMoveDown(event: Object): Void
	{
		doItemsSelectionChange(event);
		if (event.scrollChanged == true) 
			_ItemsList._parent.gotoAndPlay("moveDown");
	}

	function onItemsListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0) 
			doItemsSelectionChange(event);
	}

	function doCategorySelectionChange(event: Object): Void
	{
		dispatchEvent({type: "categoryChange", index: event.index});
		if (event.index != -1) 
			GameDelegate.call("PlaySound", ["UIMenuFocus"]);
	}

	function doItemsSelectionChange(event: Object): Void
	{
		_CategoriesList.selectedEntry.savedItemIndex = _ItemsList.scrollPosition;
		dispatchEvent({type: "itemHighlightChange", index: event.index});
		if (event.index != -1) 
			GameDelegate.call("PlaySound", ["UIMenuFocus"]);
	}

	function SetCategoriesList(): Void
	{
		var iTextOffset: Number = 0;
		var iFlagOffset: Number = 1;
		var iDontHideOffset: Number = 2;
		var iNumObjKeys: Number = 3;
		_CategoriesList.entryList.splice(0, _CategoriesList.entryList.length);
		
		for (var i: Number = 0; i < arguments.length; i += iNumObjKeys) {
			var ItemObj: Object = {text: arguments[i + iTextOffset], flag: arguments[i + iFlagOffset], bDontHide: arguments[i + iDontHideOffset], savedItemIndex: 0, filterFlag: arguments[i + iDontHideOffset] == true ? 1 : 0};
			if (ItemObj.flag == 0) 
				ItemObj.divider = true;
			_CategoriesList.entryList.push(ItemObj);
		}
		
		_CategoriesList.InvalidateData();
		_ItemsList.filterer.itemFilter = _CategoriesList.selectedEntry.flag;
	}

	function InvalidateListData(): Void
	{
		var centredEntry: Object = _CategoriesList.centeredEntry;
		var iselectedEntryFlag: Number = _CategoriesList.selectedEntry.flag;
		
		for (var i: Number = 0; i < _CategoriesList.entryList.length; i++)
			_CategoriesList.entryList[i].filterFlag = _CategoriesList.entryList[i].bDontHide ? 1 : 0;
			
		_ItemsList.InvalidateData();
		
		for (var i: Number = 0; i < _ItemsList.entryList.length; i++) {
			var iCurrentEntryFilterFlag: Number = _ItemsList.entryList[i].filterFlag;
			for (var j: Number = 0; j < _CategoriesList.entryList.length; j++)
				if (_CategoriesList.entryList[j].filterFlag == 0)
					if (_ItemsList.entryList[i].filterFlag & _CategoriesList.entryList[j].flag)
						_CategoriesList.entryList[j].filterFlag = 1;
		}
		
		_CategoriesList.onFilterChange();
		
		var iScrollPosition: Number = 0;
		for (var i: Number = 0; i < _CategoriesList.entryList.length; i++) {
			if (_CategoriesList.entryList[i].filterFlag == 1) {
				if (centredEntry.flag == _CategoriesList.entryList[i].flag) 
					_CategoriesList.RestoreScrollPosition(iScrollPosition, false);
				++iScrollPosition;
			}
		}
		
		_CategoriesList.UpdateList();
		if (_CategoriesList.centeredEntry == undefined) 
			_CategoriesList.scrollPosition = _CategoriesList.scrollPosition - 1;
		if (iselectedEntryFlag != _CategoriesList.selectedEntry.flag) {
			_ItemsList.filterer.itemFilter = _CategoriesList.selectedEntry.flag;
			_ItemsList.UpdateList();
			dispatchEvent({type: "categoryChange", index: _CategoriesList.selectedIndex});
		}
		if (iCurrentState != InventoryLists.TWO_PANELS && iCurrentState != InventoryLists.TRANSITIONING_TO_TWO_PANELS) {
			_ItemsList.selectedIndex = -1;
			return;
		}
		if (iCurrentState == InventoryLists.TWO_PANELS) {
			dispatchEvent({type: "itemHighlightChange", index: _ItemsList.selectedIndex});
			return;
		}
		dispatchEvent({type: "showItemsList", index: _ItemsList.selectedIndex});
	}
}
