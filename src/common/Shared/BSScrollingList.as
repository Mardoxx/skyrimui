dynamic class Shared.BSScrollingList extends MovieClip
{
	static var TEXT_OPTION_NONE: Number = 0;
	static var TEXT_OPTION_SHRINK_TO_FIT: Number = 1;
	static var TEXT_OPTION_MULTILINE: Number = 2;
	var EntriesA;
	var ListScrollbar;
	var ScrollDown;
	var ScrollUp;
	var _parent;
	var bDisableInput;
	var bDisableSelection;
	var bListAnimating;
	var bMouseDrivenNav;
	var border;
	var dispatchEvent;
	var fListHeight;
	var iListItemsShown;
	var iMaxItemsShown;
	var iMaxScrollPosition;
	var iPlatform;
	var iScrollPosition;
	var iScrollbarDrawTimerID;
	var iSelectedIndex;
	var iTextOption;
	var itemIndex;
	var onMousePress;
	var scrollbar;

	function BSScrollingList()
	{
		super();
		this.EntriesA = new Array();
		this.bDisableSelection = false;
		this.bDisableInput = false;
		this.bMouseDrivenNav = false;
		gfx.events.EventDispatcher.initialize(this);
		Mouse.addListener(this);
		this.iSelectedIndex = -1;
		this.iScrollPosition = 0;
		this.iMaxScrollPosition = 0;
		this.iListItemsShown = 0;
		this.iPlatform = 1;
		this.fListHeight = this.border._height;
		this.ListScrollbar = this.scrollbar;
		this.iMaxItemsShown = 0;
		var __reg3 = this.GetClipByIndex(this.iMaxItemsShown);
		for (;;) 
		{
			if (__reg3 == undefined) 
			{
				return;
			}
			__reg3.clipIndex = this.iMaxItemsShown;
			__reg3.onRollOver = function ()
			{
				if (!this._parent.listAnimating && !this._parent.bDisableInput && this.itemIndex != undefined) 
				{
					this._parent.doSetSelectedIndex(this.itemIndex, 0);
					this._parent.bMouseDrivenNav = true;
				}
			}
			__reg3.onPress = function (aiMouseIndex, aiKeyboardOrMouse)
			{
				if (this.itemIndex != undefined) 
				{
					this._parent.onItemPress(aiKeyboardOrMouse);
					if (!this._parent.bDisableInput && this.onMousePress != undefined) 
					{
						this.onMousePress();
					}
				}
			}
			__reg3.onPressAux = function (aiMouseIndex, aiKeyboardOrMouse, aiButtonIndex)
			{
				if (this.itemIndex != undefined) 
				{
					this._parent.onItemPressAux(aiKeyboardOrMouse, aiButtonIndex);
				}
			}
			__reg3 = this.GetClipByIndex(++this.iMaxItemsShown);
		}
	}

	function onLoad()
	{
		if (this.ListScrollbar != undefined) 
		{
			this.ListScrollbar.position = 0;
			this.ListScrollbar.addEventListener("scroll", this, "onScroll");
		}
	}

	function ClearList()
	{
		this.EntriesA.splice(0, this.EntriesA.length);
	}

	function GetClipByIndex(aiIndex)
	{
		return this["Entry" + aiIndex];
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var __reg2 = false;
		if (!this.bDisableInput) 
		{
			var __reg4 = this.GetClipByIndex(this.selectedIndex - this.scrollPosition);
			__reg2 = __reg4 != undefined && __reg4.handleInput != undefined && __reg4.handleInput(details, pathToFocus.slice(1));
			if (!__reg2 && Shared.GlobalFunc.IsKeyPressed(details)) 
			{
				if (details.navEquivalent == gfx.ui.NavigationCode.UP) 
				{
					this.moveSelectionUp();
					__reg2 = true;
				}
				else if (details.navEquivalent == gfx.ui.NavigationCode.DOWN) 
				{
					this.moveSelectionDown();
					__reg2 = true;
				}
				else if (!this.bDisableSelection && details.navEquivalent == gfx.ui.NavigationCode.ENTER) 
				{
					this.onItemPress();
					__reg2 = true;
				}
			}
		}
		return __reg2;
	}

	function onMouseWheel(delta)
	{
		if (this.bDisableInput) 
		{
			return;
		}
		var __reg2 = Mouse.getTopMostEntity();
		for (;;) 
		{
			if (!(__reg2 && __reg2 != undefined)) 
			{
				return;
			}
			if (__reg2 == this) 
			{
				this.doSetSelectedIndex(-1, 0);
				if (delta < 0) 
				{
					this.scrollPosition = this.scrollPosition + 1;
				}
				else if (delta > 0) 
				{
					this.scrollPosition = this.scrollPosition - 1;
				}
			}
			__reg2 = __reg2._parent;
		}
	}

	function get selectedIndex()
	{
		return this.iSelectedIndex;
	}

	function set selectedIndex(aiNewIndex)
	{
		this.doSetSelectedIndex(aiNewIndex);
	}

	function get listAnimating()
	{
		return this.bListAnimating;
	}

	function set listAnimating(abFlag)
	{
		this.bListAnimating = abFlag;
	}

	function doSetSelectedIndex(aiNewIndex, aiKeyboardOrMouse)
	{
		if (!this.bDisableSelection && aiNewIndex != this.iSelectedIndex) 
		{
			var __reg2 = this.iSelectedIndex;
			this.iSelectedIndex = aiNewIndex;
			if (__reg2 != -1) 
			{
				this.SetEntry(this.GetClipByIndex(this.EntriesA[__reg2].clipIndex), this.EntriesA[__reg2]);
			}
			if (this.iSelectedIndex != -1) 
			{
				if (this.iPlatform == 0) 
				{
					this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex), this.EntriesA[this.iSelectedIndex]);
				}
				else if (this.iSelectedIndex < this.iScrollPosition) 
				{
					this.scrollPosition = this.iSelectedIndex;
				}
				else if (this.iSelectedIndex >= this.iScrollPosition + this.iListItemsShown) 
				{
					this.scrollPosition = Math.min(this.iSelectedIndex - this.iListItemsShown + 1, this.iMaxScrollPosition);
				}
				else 
				{
					this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex), this.EntriesA[this.iSelectedIndex]);
				}
			}
			this.dispatchEvent({type: "selectionChange", index: this.iSelectedIndex, keyboardOrMouse: aiKeyboardOrMouse});
		}
	}

	function get scrollPosition()
	{
		return this.iScrollPosition;
	}

	function get maxScrollPosition()
	{
		return this.iMaxScrollPosition;
	}

	function set scrollPosition(aiNewPosition)
	{
		if (aiNewPosition != this.iScrollPosition && aiNewPosition >= 0 && aiNewPosition <= this.iMaxScrollPosition) 
		{
			if (this.ListScrollbar == undefined) 
			{
				this.updateScrollPosition(aiNewPosition);
			}
			else 
			{
				this.ListScrollbar.position = aiNewPosition;
			}
		}
	}

	function updateScrollPosition(aiPosition)
	{
		this.iScrollPosition = aiPosition;
		this.UpdateList();
	}

	function get selectedEntry()
	{
		return this.EntriesA[this.iSelectedIndex];
	}

	function get entryList()
	{
		return this.EntriesA;
	}

	function set entryList(anewArray)
	{
		this.EntriesA = anewArray;
	}

	function get disableSelection()
	{
		return this.bDisableSelection;
	}

	function set disableSelection(abFlag)
	{
		this.bDisableSelection = abFlag;
	}

	function get disableInput()
	{
		return this.bDisableInput;
	}

	function set disableInput(abFlag)
	{
		this.bDisableInput = abFlag;
	}

	function get maxEntries()
	{
		return this.iMaxItemsShown;
	}

	function get textOption()
	{
		return this.iTextOption;
	}

	function set textOption(strNewOption)
	{
		if (strNewOption == "None") 
		{
			this.iTextOption = Shared.BSScrollingList.TEXT_OPTION_NONE;
		}
		else if (strNewOption == "Shrink To Fit") 
		{
			this.iTextOption = Shared.BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
		}
		else if (strNewOption == "Multi-Line") 
		{
			this.iTextOption = Shared.BSScrollingList.TEXT_OPTION_MULTILINE;
		}
	}

	function UpdateList()
	{
		var __reg6 = this.GetClipByIndex(0)._y;
		var __reg5 = 0;
		var __reg2 = 0;
		while (__reg2 < this.iScrollPosition) 
		{
			this.EntriesA[__reg2].clipIndex = undefined;
			++__reg2;
		}
		this.iListItemsShown = 0;
		__reg2 = this.iScrollPosition;
		while (__reg2 < this.EntriesA.length && this.iListItemsShown < this.iMaxItemsShown && __reg5 <= this.fListHeight) 
		{
			var __reg3 = this.GetClipByIndex(this.iListItemsShown);
			this.SetEntry(__reg3, this.EntriesA[__reg2]);
			this.EntriesA[__reg2].clipIndex = this.iListItemsShown;
			__reg3.itemIndex = __reg2;
			__reg3._y = __reg6 + __reg5;
			__reg3._visible = true;
			__reg5 = __reg5 + __reg3._height;
			if (__reg5 <= this.fListHeight && this.iListItemsShown < this.iMaxItemsShown) 
			{
				++this.iListItemsShown;
			}
			++__reg2;
		}
		var __reg4 = this.iListItemsShown;
		while (__reg4 < this.iMaxItemsShown) 
		{
			this.GetClipByIndex(__reg4)._visible = false;
			++__reg4;
		}
		if (this.ScrollUp != undefined) 
		{
			this.ScrollUp._visible = this.scrollPosition > 0;
		}
		if (this.ScrollDown != undefined) 
		{
			this.ScrollDown._visible = this.scrollPosition < this.iMaxScrollPosition;
		}
	}

	function InvalidateData()
	{
		var __reg2 = this.iMaxScrollPosition;
		this.fListHeight = this.border._height;
		this.CalculateMaxScrollPosition();
		if (this.ListScrollbar != undefined) 
		{
			if (__reg2 == this.iMaxScrollPosition) 
			{
				this.SetScrollbarVisibility();
			}
			else 
			{
				this.ListScrollbar._visible = false;
				this.ListScrollbar.setScrollProperties(this.iMaxItemsShown, 0, this.iMaxScrollPosition);
				if (this.iScrollbarDrawTimerID != undefined) 
				{
					clearInterval(this.iScrollbarDrawTimerID);
				}
				this.iScrollbarDrawTimerID = setInterval(this, "SetScrollbarVisibility", 50);
			}
		}
		if (this.iSelectedIndex >= this.EntriesA.length) 
		{
			this.iSelectedIndex = this.EntriesA.length - 1;
		}
		if (this.iScrollPosition > this.iMaxScrollPosition) 
		{
			this.iScrollPosition = this.iMaxScrollPosition;
		}
		this.UpdateList();
	}

	function SetScrollbarVisibility()
	{
		clearInterval(this.iScrollbarDrawTimerID);
		this.iScrollbarDrawTimerID = undefined;
		this.ListScrollbar._visible = this.iMaxScrollPosition > 0;
	}

	function CalculateMaxScrollPosition()
	{
		var __reg3 = 0;
		var __reg2 = this.EntriesA.length - 1;
		while (__reg2 >= 0 && __reg3 <= this.fListHeight) 
		{
			__reg3 = __reg3 + this.GetEntryHeight(__reg2);
			if (__reg3 <= this.fListHeight) 
			{
				--__reg2;
			}
		}
		this.iMaxScrollPosition = __reg2 + 1;
	}

	function GetEntryHeight(aiEntryIndex)
	{
		var __reg2 = this.GetClipByIndex(0);
		this.SetEntry(__reg2, this.EntriesA[aiEntryIndex]);
		return __reg2._height;
	}

	function moveSelectionUp()
	{
		if (!this.bDisableSelection) 
		{
			if (this.selectedIndex > 0) 
			{
				this.selectedIndex = this.selectedIndex - 1;
			}
			return;
		}
		this.scrollPosition = this.scrollPosition - 1;
	}

	function moveSelectionDown()
	{
		if (!this.bDisableSelection) 
		{
			if (this.selectedIndex < this.EntriesA.length - 1) 
			{
				this.selectedIndex = this.selectedIndex + 1;
			}
			return;
		}
		this.scrollPosition = this.scrollPosition + 1;
	}

	function onItemPress(aiKeyboardOrMouse)
	{
		if (!this.bDisableInput && !this.bDisableSelection && this.iSelectedIndex != -1) 
		{
			this.dispatchEvent({type: "itemPress", index: this.iSelectedIndex, entry: this.EntriesA[this.iSelectedIndex], keyboardOrMouse: aiKeyboardOrMouse});
			return;
		}
		this.dispatchEvent({type: "listPress"});
	}

	function onItemPressAux(aiKeyboardOrMouse, aiButtonIndex)
	{
		if (!this.bDisableInput && !this.bDisableSelection && this.iSelectedIndex != -1 && aiButtonIndex == 1) 
		{
			this.dispatchEvent({type: "itemPressAux", index: this.iSelectedIndex, entry: this.EntriesA[this.iSelectedIndex], keyboardOrMouse: aiKeyboardOrMouse});
		}
	}

	function SetEntry(aEntryClip, aEntryObject)
	{
		if (aEntryClip != undefined) 
		{
			if (aEntryObject == this.selectedEntry) 
			{
				aEntryClip.gotoAndStop("Selected");
			}
			else 
			{
				aEntryClip.gotoAndStop("Normal");
			}
			this.SetEntryText(aEntryClip, aEntryObject);
		}
	}

	function SetEntryText(aEntryClip, aEntryObject)
	{
		if (aEntryClip.textField != undefined) 
		{
			if (this.textOption == Shared.BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT) 
			{
				aEntryClip.textField.textAutoSize = "shrink";
			}
			else if (this.textOption == Shared.BSScrollingList.TEXT_OPTION_MULTILINE) 
			{
				aEntryClip.textField.verticalAutoSize = "top";
			}
			if (aEntryObject.text == undefined) 
			{
				aEntryClip.textField.SetText(" ");
			}
			else 
			{
				aEntryClip.textField.SetText(aEntryObject.text);
			}
			if (aEntryObject.enabled != undefined) 
			{
				aEntryClip.textField.textColor = aEntryObject.enabled == false ? 6316128 : 16777215;
			}
			if (aEntryObject.disabled != undefined) 
			{
				aEntryClip.textField.textColor = aEntryObject.disabled == true ? 6316128 : 16777215;
			}
		}
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean)
	{
		this.iPlatform = aiPlatform;
		this.bMouseDrivenNav = this.iPlatform == 0;
	}

	function onScroll(event)
	{
		this.updateScrollPosition(Math.floor(event.position + 0.5));
	}

}
