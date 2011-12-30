dynamic class FavoritesMenu extends MovieClip
{
	var bPCControlsReady: Boolean = true;
	var ItemList;
	var LeftPanel;
	var List_mc;
	var _parent;
	var gotoAndPlay;

	function FavoritesMenu()
	{
		super();
		this.ItemList = this.List_mc;
	}

	function InitExtensions()
	{
		Shared.GlobalFunc.SetLockFunction();
		this._parent.Lock("BL");
		gfx.io.GameDelegate.addCallBack("PopulateItems", this, "populateItemList");
		gfx.io.GameDelegate.addCallBack("SetSelectedItem", this, "setSelectedItem");
		gfx.io.GameDelegate.addCallBack("StartFadeOut", this, "startFadeOut");
		this.ItemList.addEventListener("listMovedUp", this, "onListMoveUp");
		this.ItemList.addEventListener("listMovedDown", this, "onListMoveDown");
		this.ItemList.addEventListener("itemPress", this, "onItemSelect");
		gfx.managers.FocusHandler.instance.setFocus(this.ItemList, 0);
		this._parent.gotoAndPlay("startFadeIn");
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		if (!pathToFocus[0].handleInput(details, pathToFocus.slice(1))) 
		{
			if (Shared.GlobalFunc.IsKeyPressed(details) && details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				this.startFadeOut();
			}
		}
		return true;
	}

	function get selectedIndex()
	{
		return this.ItemList.selectedEntry.index;
	}

	function get itemList()
	{
		return this.ItemList;
	}

	function setSelectedItem(aiIndex)
	{
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.ItemList.entryList.length) 
			{
				return;
			}
			if (this.ItemList.entryList[__reg2].index == aiIndex) 
			{
				this.ItemList.selectedIndex = __reg2;
				this.ItemList.RestoreScrollPosition(__reg2);
				this.ItemList.UpdateList();
				return;
			}
			++__reg2;
		}
	}

	function onListMoveUp(event)
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) 
		{
			this.gotoAndPlay("moveUp");
		}
	}

	function onListMoveDown(event)
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) 
		{
			this.gotoAndPlay("moveDown");
		}
	}

	function onItemSelect(event)
	{
		if (event.keyboardOrMouse != 0) 
		{
			gfx.io.GameDelegate.call("ItemSelect", []);
		}
	}

	function startFadeOut()
	{
		this._parent.gotoAndPlay("startFadeOut");
	}

	function onFadeOutCompletion()
	{
		gfx.io.GameDelegate.call("FadeDone", [this.selectedIndex]);
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean)
	{
		this.ItemList.SetPlatform(aiPlatform, abPS3Switch);
		this.LeftPanel._x = aiPlatform == 0 ? -90 : -78.2;
		this.LeftPanel.gotoAndStop(aiPlatform == 0 ? "Mouse" : "Gamepad");
	}

}
