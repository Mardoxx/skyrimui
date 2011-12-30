class ItemMenu extends MovieClip
{
	var BottomBar_mc: MovieClip;
	var ExitMenuRect: MovieClip;
	var InventoryLists_mc: MovieClip;
	var ItemCardFadeHolder_mc: MovieClip;
	var ItemCard_mc: MovieClip;
	var ItemsListInputCatcher: MovieClip;
	var MouseRotationRect: MovieClip;
	var RestoreCategoryRect: MovieClip;
	var bFadedIn: Boolean;
	var iPlatform: Number;

	function ItemMenu()
	{
		super();
		this.InventoryLists_mc = this.InventoryLists_mc;
		this.ItemCard_mc = this.ItemCardFadeHolder_mc.ItemCard_mc;
		this.BottomBar_mc = this.BottomBar_mc;
		this.bFadedIn = true;
		Mouse.addListener(this);
	}

	function InitExtensions(abPlayBladeSound: Boolean): Void
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
		this.RestoreCategoryRect.onRollOver = function ()
		{
			if (this._parent.bFadedIn == true && this._parent.InventoryLists_mc.currentState == InventoryLists.TWO_PANELS) 
			{
				this._parent.InventoryLists_mc.RestoreCategoryIndex();
			}
		}
		this.ExitMenuRect.onMouseDown = function ()
		{
			if (this._parent.bFadedIn == true && Mouse.getTopMostEntity() == this) 
			{
				this._parent.onExitMenuRectClick();
			}
		}
	}

	function PositionElements(): Void
	{
		Shared.GlobalFunc.SetLockFunction();
		MovieClip(this.InventoryLists_mc).Lock("L");
		this.InventoryLists_mc._x = this.InventoryLists_mc._x - 20;
		var iLeftOffset: Number = Stage.visibleRect.x + Stage.safeRect.x;
		var iRightOffset: Number = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		this.BottomBar_mc.PositionElements(iLeftOffset, iRightOffset);
		this.ItemCard_mc._parent._x = (iRightOffset + this.InventoryLists_mc._x + this.InventoryLists_mc._width) / 2 - this.ItemCard_mc._parent._width / 2 - 85;
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

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
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

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
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

	function onMouseWheel(delta: Object): Void
	{
		var topMostEntity: Object = Mouse.getTopMostEntity();
		for (;;) 
		{
			if (!(topMostEntity && topMostEntity != undefined)) 
			{
				return;
			}
			if ((topMostEntity == this.MouseRotationRect && this.ShouldProcessItemsListInput(false)) || (!this.bFadedIn && delta == -1)) 
			{
				gfx.io.GameDelegate.call("ZoomItemModel", [delta]);
			}
			else if (topMostEntity == this.ItemsListInputCatcher && this.ShouldProcessItemsListInput(false)) 
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
			topMostEntity = topMostEntity._parent;
		}
	}

	function onExitMenuRectClick(): Void
	{
		gfx.io.GameDelegate.call("CloseMenu", []);
	}

	function onCategoryChange(event: Object): Void
	{
	}

	function onItemHighlightChange(event: Object): Void
	{
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("UpdateItem3D", [true]);
			gfx.io.GameDelegate.call("RequestItemCardInfo", [], this, "UpdateItemCardInfo");
			return;
		}
		this.onHideItemsList();
	}

	function onShowItemsList(event: Object): Void
	{
		if (event.index != -1) 
		{
			gfx.io.GameDelegate.call("UpdateItem3D", [true]);
			gfx.io.GameDelegate.call("RequestItemCardInfo", [], this, "UpdateItemCardInfo");
			this.ItemCard_mc.FadeInCard();
			this.BottomBar_mc.ShowButtons();
		}
	}

	function onHideItemsList(event: Object): Void
	{
		gfx.io.GameDelegate.call("UpdateItem3D", [false]);
		this.ItemCard_mc.FadeOutCard();
		this.BottomBar_mc.HideButtons();
	}

	function onItemSelect(event: Object): Void
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

	function onQuantityMenuSelect(event: Object): Void
	{
		gfx.io.GameDelegate.call("ItemSelect", [event.amount]);
	}

	function UpdatePlayerInfo(aUpdateObj: Object): Void
	{
		this.BottomBar_mc.UpdatePlayerInfo(aUpdateObj, this.ItemCard_mc.itemInfo);
	}

	function UpdateItemCardInfo(aUpdateObj: Object): Void
	{
		this.ItemCard_mc.itemInfo = aUpdateObj;
		this.BottomBar_mc.UpdatePerItemInfo(aUpdateObj);
	}

	function onItemCardSubMenuAction(event: Object): Void
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

	function ShouldProcessItemsListInput(abCheckIfOverRect: Boolean): Boolean
	{
		var bInTwoPanelsWithItems: Boolean = this.bFadedIn == true && this.InventoryLists_mc.currentState == InventoryLists.TWO_PANELS && this.InventoryLists_mc.ItemsList.numUnfilteredItems > 0 && !this.InventoryLists_mc.ItemsList.disableSelection && !this.InventoryLists_mc.ItemsList.disableInput;
		if (bInTwoPanelsWithItems && this.iPlatform == 0 && abCheckIfOverRect) 
		{
			var topMostEntity: Object = Mouse.getTopMostEntity();
			var bFoundInputRect: Boolean = false;
			while (!bFoundInputRect && topMostEntity && topMostEntity != undefined) 
			{
				if (topMostEntity == this.ItemsListInputCatcher || topMostEntity == this.InventoryLists_mc.ItemsList) 
				{
					bFoundInputRect = true;
				}
				topMostEntity = topMostEntity._parent;
			}
			bInTwoPanelsWithItems = bInTwoPanelsWithItems && bFoundInputRect;
		}
		return bInTwoPanelsWithItems;
	}

	function onMouseRotationStart(): Void
	{
		gfx.io.GameDelegate.call("StartMouseRotation", []);
		this.InventoryLists_mc.CategoriesList.disableSelection = true;
		this.InventoryLists_mc.ItemsList.disableSelection = true;
	}

	function onMouseRotationStop(): Void
	{
		gfx.io.GameDelegate.call("StopMouseRotation", []);
		this.InventoryLists_mc.CategoriesList.disableSelection = false;
		this.InventoryLists_mc.ItemsList.disableSelection = false;
	}

	function onItemsListInputCatcherClick(): Void
	{
		if (this.ShouldProcessItemsListInput(false)) 
		{
			this.onItemSelect({entry: this.InventoryLists_mc.ItemsList.selectedEntry, keyboardOrMouse: 0});
		}
	}

	function onMouseRotationFastClick(): Void
	{
		this.onItemsListInputCatcherClick();
	}

	function ToggleMenuFade(): Void
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

	function SetFadedIn(): Void
	{
		this.bFadedIn = true;
		this.InventoryLists_mc.ItemsList.disableSelection = false;
		this.InventoryLists_mc.ItemsList.disableInput = false;
		this.InventoryLists_mc.CategoriesList.disableSelection = false;
		this.InventoryLists_mc.CategoriesList.disableInput = false;
	}

	function RestoreIndices(): Void
	{
		this.InventoryLists_mc.CategoriesList.RestoreScrollPosition(arguments[0], true);
		var i: Number = 1;
		while (i < arguments.length) 
		{
			this.InventoryLists_mc.CategoriesList.entryList[i - 1].savedItemIndex = arguments[i];
			++i;
		}
		this.InventoryLists_mc.CategoriesList.UpdateList();
	}

	function SaveIndices(): Void
	{
		var Indices: Array = new Array();
		Indices.push(this.InventoryLists_mc.CategoriesList.scrollPosition);
		var i: Number = 0;
		while (i < this.InventoryLists_mc.CategoriesList.entryList.length) 
		{
			Indices.push(this.InventoryLists_mc.CategoriesList.entryList[i].savedItemIndex);
			++i;
		}
		gfx.io.GameDelegate.call("SaveIndices", [Indices]);
	}

}
