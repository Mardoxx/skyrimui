import Shared.GlobalFunc;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.events.EventDispatcher;

/*
  Method summary:
 
  function BSScrollingList()
	function ClearList(): Void
  function GetClipByIndex(aiIndex: Number): MovieClip
	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	function set selectedIndex(aiNewIndex: Number): Void
	function set listAnimating(abFlag: Boolean): Void
	function doSetSelectedIndex(aiNewIndex:Number, aiKeyboardOrMouse: Number): Void
	function set scrollPosition(aiNewPosition: Number): Void
	function updateScrollPosition(aiPosition: Number): Void
	function UpdateList(): Void
	function InvalidateData(): Void
	function SetScrollbarVisibility(): Void
	function CalculateMaxScrollPosition(): Void
	function GetEntryHeight(aiEntryIndex: Number): Number
	function moveSelectionUp(): Void
	function moveSelectionDown(): Void
	
	function onLoad(): Void
	function onMouseWheel(delta: Number): Void
	function onItemPress(aiKeyboardOrMouse: Number): Void
	function onItemPressAux(aiKeyboardOrMouse: Number, aiButtonIndex: Number)
	function onScroll(event: Object): Void

	function SetEntry(aEntryClip: MovieClip, aEntryObject: Object): Void
	function SetEntryText(aEntryClip: MovieClip, aEntryObject: Object): Void
	
	Getters/Setters:
	
	function get selectedIndex(): Number
	function get listAnimating(): Boolean
	function get selectedEntry(): Object
	function get scrollPosition(): Number
	function get maxScrollPosition(): Number
	function get entryList(): Array
	function get disableSelection(): Boolean
	function get disableInput(): Boolean
	function get maxEntries(): Number
	function get textOption(): Number
  
	*/

class Shared.BSScrollingList extends MovieClip
{
	static var TEXT_OPTION_NONE: Number = 0;
	static var TEXT_OPTION_SHRINK_TO_FIT: Number = 1;
	static var TEXT_OPTION_MULTILINE: Number = 2;
	
	var EntriesA: Array;
	
	var scrollbar: Object;
	var ListScrollbar: Object;
	
	var ScrollDown: MovieClip;
	var ScrollUp: MovieClip;
	var border: MovieClip;
	
	var bDisableInput: Boolean;
	var bDisableSelection: Boolean;
	var bListAnimating: Boolean;
	var bMouseDrivenNav: Boolean;
	
	var dispatchEvent: Function;
	var onMousePress: Function;
	
	var fListHeight: Number;
	var iListItemsShown: Number;
	var iMaxItemsShown: Number;
	var iMaxScrollPosition: Number;
	var iPlatform: Number;
	var iScrollPosition: Number;
	var iScrollbarDrawTimerID: Number;
	var iSelectedIndex: Number;
	var iHighlightedIndex: Number;  // new
	var iTextOption: Number;
	var itemIndex: Number;
	
	function BSScrollingList()
	{
		super();
		EntriesA = new Array();
		bDisableSelection = false;
		bDisableInput = false;
		bMouseDrivenNav = false;
		EventDispatcher.initialize(this);
		Mouse.addListener(this);
		
		iSelectedIndex = -1;
		iHighlightedIndex = -1;
		iScrollPosition = 0;
		iMaxScrollPosition = 0;
		iListItemsShown = 0;
		iPlatform = 1;
		fListHeight = border._height;
		ListScrollbar = scrollbar;
		iMaxItemsShown = 0;
		
		for (var item: MovieClip = GetClipByIndex(iMaxItemsShown); item != undefined; item = GetClipByIndex(++iMaxItemsShown)) {
			item.clipIndex = iMaxItemsShown;

			item.onRollOver = function ()
			{
				if (!_parent.listAnimating && !_parent.bDisableInput && itemIndex != undefined) {
//GlobalFunc.getInstance().Deebug("onRollOver() doSetSelectedIndex " + itemIndex);
					_parent.doSetSelectedIndex(itemIndex, 0, true);
					_parent.bMouseDrivenNav = true;
				}
			};
			item.onPress = function (aiMouseIndex, aiKeyboardOrMouse)
			{
				if (itemIndex != undefined) {
//GlobalFunc.getInstance().Deebug("item::onPress() " + aiKeyboardOrMouse);
					_parent.onItemPress(aiKeyboardOrMouse);
					if (!_parent.bDisableInput && onMousePress != undefined)
						onMousePress();
				}
			};
			item.onPressAux = function (aiMouseIndex, aiKeyboardOrMouse, aiButtonIndex)
			{
				if (itemIndex != undefined) 
					_parent.onItemPressAux(aiKeyboardOrMouse, aiButtonIndex);
			};
		}
	}

	function onLoad(): Void
	{
		if (ListScrollbar != undefined) {
			ListScrollbar.position = 0;
			ListScrollbar.addEventListener("scroll", this, "onScroll");
		}
	}

	function ClearList(): Void
	{
		EntriesA.splice(0, EntriesA.length);
	}

	function GetClipByIndex(aiIndex: Number): MovieClip
	{
		return this["Entry" + aiIndex];
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
//GlobalFunc.getInstance().Deebug("handleInput() BSScrollingList");
		var bHandledInput: Boolean = false;
		if (!bDisableInput) {
			var item: MovieClip = GetClipByIndex(selectedIndex - scrollPosition);
			bHandledInput = item != undefined && item.handleInput != undefined && item.handleInput(details, pathToFocus.slice(1));
			if (!bHandledInput && GlobalFunc.IsKeyPressed(details)) {
				if (details.navEquivalent == NavigationCode.UP) {
					moveSelectionUp();
					bHandledInput = true;
				} else if (details.navEquivalent == NavigationCode.DOWN) {
					moveSelectionDown();
					bHandledInput = true;
				} else if (!bDisableSelection && details.navEquivalent == NavigationCode.ENTER) {
					onItemPress();
					bHandledInput = true;
				}
			}
		}
		return bHandledInput;
	}

	function onMouseWheel(delta: Number): Void
	{
		if (!bDisableInput) {
			for (var target = Mouse.getTopMostEntity(); target && target != undefined; target = target._parent) {
				if (target == this) {
					doSetSelectedIndex(-1,0);
					if (delta < 0)
						scrollPosition = scrollPosition + 1;
					else if (delta > 0)
						scrollPosition = scrollPosition - 1;
				}
			}
		}
	}

	function get selectedIndex(): Number
	{
		return iSelectedIndex;
	}

	function set selectedIndex(aiNewIndex: Number): Void
	{
		doSetSelectedIndex(aiNewIndex);
	}

	function get listAnimating(): Boolean
	{
		return bListAnimating;
	}

	function set listAnimating(abFlag: Boolean): Void
	{
		bListAnimating = abFlag;
	}

	//fabd++ The function can now set mouse highlight (visual) separately from the selected state
	function doSetSelectedIndex(aiNewIndex:Number, aiKeyboardOrMouse: Number, abMouseFocus: Boolean): Void
	{
		// current focus is selectedindex, or mouse highlighted index (decoupled from selection)
		var iCurHighlightIndex = iHighlightedIndex; //  abMouseFocus ? iHighlightedIndex : iSelectedIndex;

		if (!bDisableSelection) {

			// change selectedIndex, unless explicitly doing the mouse highlighting
			if  (abMouseFocus !== true) {
				iSelectedIndex = aiNewIndex;
			}

			if (aiNewIndex != iCurHighlightIndex) {
				var iCurrentIndex: Number = iHighlightedIndex;

				iHighlightedIndex = aiNewIndex;
//GlobalFunc.getInstance().Deebug("iHighlightedIndex = " + iHighlightedIndex);
				
				if (iCurrentIndex != -1)
					SetEntry(GetClipByIndex(EntriesA[iCurrentIndex].clipIndex), EntriesA[iCurrentIndex]);

				if (iHighlightedIndex != -1) {
					if (iPlatform != 0) {
						if (iHighlightedIndex < iScrollPosition)
							scrollPosition = iHighlightedIndex;
						else if (iHighlightedIndex >= iScrollPosition + iListItemsShown)
							scrollPosition = Math.min(iHighlightedIndex - iListItemsShown + 1, iMaxScrollPosition);
						else
							SetEntry(GetClipByIndex(EntriesA[iHighlightedIndex].clipIndex),EntriesA[iHighlightedIndex]);
					} else {
						SetEntry(GetClipByIndex(EntriesA[iHighlightedIndex].clipIndex),EntriesA[iHighlightedIndex]);
					}
				}

				// note: this could have unwanted effects here, since highlighted is not always *selected*
				// note: OR... dispatch only when selectedIndex changes... usually would want highlight change
				dispatchEvent({type:"selectionChange", index:iHighlightedIndex, keyboardOrMouse:aiKeyboardOrMouse});
			}
		}
	}

	//fabd-- the old code for reference
	/*
	function doSetSelectedIndex(aiNewIndex:Number, aiKeyboardOrMouse: Number): Void
	{
		if (!bDisableSelection && aiNewIndex != iSelectedIndex) {
			var iCurrentIndex: Number = iSelectedIndex;
			iSelectedIndex = aiNewIndex;
			
			if (iCurrentIndex != -1)
				SetEntry(GetClipByIndex(EntriesA[iCurrentIndex].clipIndex),EntriesA[iCurrentIndex]);

			if (iSelectedIndex != -1) {
				if (iPlatform != 0) {
					if (iSelectedIndex < iScrollPosition)
						scrollPosition = iSelectedIndex;
					else if (iSelectedIndex >= iScrollPosition + iListItemsShown)
						scrollPosition = Math.min(iSelectedIndex - iListItemsShown + 1, iMaxScrollPosition);
					else
						SetEntry(GetClipByIndex(EntriesA[iSelectedIndex].clipIndex),EntriesA[iSelectedIndex]);
				} else {
					SetEntry(GetClipByIndex(EntriesA[iSelectedIndex].clipIndex),EntriesA[iSelectedIndex]);
				}
			}
			dispatchEvent({type:"selectionChange", index:iSelectedIndex, keyboardOrMouse:aiKeyboardOrMouse});
		}
	}
	*/

	function get scrollPosition(): Number
	{
		return iScrollPosition;
	}

	function get maxScrollPosition(): Number
	{
		return iMaxScrollPosition;
	}

	function set scrollPosition(aiNewPosition: Number): Void
	{
		if (aiNewPosition != iScrollPosition && aiNewPosition >= 0 && aiNewPosition <= iMaxScrollPosition) {
			if (ListScrollbar == undefined) 
				updateScrollPosition(aiNewPosition);
			else 
				ListScrollbar.position = aiNewPosition;
		}
	}

	function updateScrollPosition(aiPosition: Number): Void
	{
		iScrollPosition = aiPosition;
		UpdateList();
	}

	function get selectedEntry(): Object
	{
		return EntriesA[iSelectedIndex];
	}

	function get entryList(): Array
	{
		return EntriesA;
	}

	function set entryList(anewArray: Array): Void
	{
		EntriesA = anewArray;
	}

	function get disableSelection(): Boolean
	{
		return bDisableSelection;
	}

	function set disableSelection(abFlag: Boolean): Void
	{
		bDisableSelection = abFlag;
	}

	function get disableInput(): Boolean
	{
		return bDisableInput;
	}

	function set disableInput(abFlag: Boolean): Void
	{
		bDisableInput = abFlag;
	}

	function get maxEntries(): Number
	{
		return iMaxItemsShown;
	}

	function get textOption(): Number
	{
		return iTextOption;
	}

	function set textOption(strNewOption: String): Void
	{
		if (strNewOption == "None") 
			iTextOption = Shared.BSScrollingList.TEXT_OPTION_NONE;
		else if (strNewOption == "Shrink To Fit") 
			iTextOption = Shared.BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
		else if (strNewOption == "Multi-Line") 
			iTextOption = Shared.BSScrollingList.TEXT_OPTION_MULTILINE;
	}

	function UpdateList(): Void
	{
		var iFirstItemy: Number = GetClipByIndex(0)._y;
		var iItemHeightSum: Number = 0;
		var i: Number = 0;
		while (i < iScrollPosition) {
			EntriesA[i].clipIndex = undefined;
			++i;
		}
		iListItemsShown = 0;
		i = iScrollPosition;
		while (i < EntriesA.length && iListItemsShown < iMaxItemsShown && iItemHeightSum <= fListHeight) {
			var item: MovieClip = GetClipByIndex(iListItemsShown);
			SetEntry(item, EntriesA[i]);
			EntriesA[i].clipIndex = iListItemsShown;
			item.itemIndex = i;
			item._y = iFirstItemy + iItemHeightSum;
			item._visible = true;
			iItemHeightSum += item._height;
			if (iItemHeightSum <= fListHeight && iListItemsShown < iMaxItemsShown) 
				++iListItemsShown;
			++i;
		}
		var iLastItemIndex: Number = iListItemsShown;
		while (iLastItemIndex < iMaxItemsShown) {
			GetClipByIndex(iLastItemIndex)._visible = false;
			++iLastItemIndex;
		}
		if (ScrollUp != undefined) 
			ScrollUp._visible = scrollPosition > 0;
		if (ScrollDown != undefined) 
			ScrollDown._visible = scrollPosition < iMaxScrollPosition;
	}

	function InvalidateData(): Void
	{
		var iMaxScrollPos: Number = iMaxScrollPosition;
		fListHeight = border._height;
		CalculateMaxScrollPosition();
		if (ListScrollbar != undefined) {
			if (iMaxScrollPos == iMaxScrollPosition) {
				SetScrollbarVisibility();
			} else {
				ListScrollbar._visible = false;
				ListScrollbar.setScrollProperties(iMaxItemsShown, 0, iMaxScrollPosition);
				if (iScrollbarDrawTimerID != undefined) 
					clearInterval(iScrollbarDrawTimerID);
				iScrollbarDrawTimerID = setInterval(this, "SetScrollbarVisibility", 50);
			}
		}
		if (iSelectedIndex >= EntriesA.length) 
			iSelectedIndex = EntriesA.length - 1;
		if (iScrollPosition > iMaxScrollPosition) 
			iScrollPosition = iMaxScrollPosition;
		UpdateList();
	}

	function SetScrollbarVisibility(): Void
	{
		clearInterval(iScrollbarDrawTimerID);
		iScrollbarDrawTimerID = undefined;
		ListScrollbar._visible = iMaxScrollPosition > 0;
	}

	function CalculateMaxScrollPosition(): Void
	{
		var iItemHeightSum: Number = 0;
		var iLastItemIndex: Number = EntriesA.length - 1;
		while (iLastItemIndex >= 0 && iItemHeightSum <= fListHeight) {
			iItemHeightSum += GetEntryHeight(iLastItemIndex);
			if (iItemHeightSum <= fListHeight) 
				--iLastItemIndex;
		}
		iMaxScrollPosition = iLastItemIndex + 1;
	}

	function GetEntryHeight(aiEntryIndex: Number): Number
	{
		var item: MovieClip = GetClipByIndex(0);
		SetEntry(item, EntriesA[aiEntryIndex]);
		return item._height;
	}

	function moveSelectionUp(): Void
	{
		if (!bDisableSelection) {
			if (selectedIndex > 0) 
				selectedIndex = selectedIndex - 1;
			return;
		}
		scrollPosition = scrollPosition - 1;
	}

	function moveSelectionDown(): Void
	{
		if (!bDisableSelection) {
			if (selectedIndex < EntriesA.length - 1) 
				selectedIndex = selectedIndex + 1;
			return;
		}
		scrollPosition = scrollPosition + 1;
	}

	/**
	 * MovieClip onPress() aiKeyboardOrMouse == 0
	 *
	 * If keyboard (handleInput), aiKeyboardOrMouse is undefined.
	 *
	 */
	function onItemPress(aiKeyboardOrMouse: Number): Void
	{
		if (!bDisableInput && !bDisableSelection && iSelectedIndex != -1) {
//GlobalFunc.getInstance().Deebug("onItemPress() aiKeyboardOrMouse = " + aiKeyboardOrMouse);
			dispatchEvent({type: "itemPress", index: iSelectedIndex, entry: EntriesA[iSelectedIndex], keyboardOrMouse: aiKeyboardOrMouse});
			return;
		}
		dispatchEvent({type: "listPress"});
	}

	function onItemPressAux(aiKeyboardOrMouse: Number, aiButtonIndex: Number)
	{
		if (!bDisableInput && !bDisableSelection && iSelectedIndex != -1 && aiButtonIndex == 1) 
			dispatchEvent({type: "itemPressAux", index: iSelectedIndex, entry: EntriesA[iSelectedIndex], keyboardOrMouse: aiKeyboardOrMouse});
	}

	// New: aSelectedEntry is based on highlighted index, which is not always selected index
	function SetEntry(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		var aSelectedEntry: Object = EntriesA[iHighlightedIndex];

		if (aEntryClip != undefined) {
			if (aEntryObject == aSelectedEntry) 
				aEntryClip.gotoAndStop("Selected");
			else 
				aEntryClip.gotoAndStop("Normal");
			SetEntryText(aEntryClip, aEntryObject);
		}
	}

	function SetEntryText(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		if (aEntryClip.textField != undefined) {
			if (textOption == Shared.BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT) 
				aEntryClip.textField.textAutoSize = "shrink";
			else if (textOption == Shared.BSScrollingList.TEXT_OPTION_MULTILINE) 
				aEntryClip.textField.verticalAutoSize = "top";
			if (aEntryObject.text == undefined) 
				aEntryClip.textField.SetText(" ");
			else 
				aEntryClip.textField.SetText(aEntryObject.text);
			if (aEntryObject.enabled != undefined) 
				aEntryClip.textField.textColor = aEntryObject.enabled == false ? 0x606060 : 0xFFFFFF;
			if (aEntryObject.disabled != undefined) 
				aEntryClip.textField.textColor = aEntryObject.disabled == true ? 0x606060 : 0xFFFFFF;
		}
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		iPlatform = aiPlatform;
		bMouseDrivenNav = iPlatform == 0;
	}

	function onScroll(event: Object): Void
	{
		updateScrollPosition(Math.floor(event.position + 0.5));
	}

}
