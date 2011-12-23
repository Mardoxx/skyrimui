dynamic class Shared.CenteredScrollingList extends Shared.BSScrollingList
{
	var EntriesA;
	var GetClipByIndex;
	var SetEntryText;
	var _filterer;
	var bDisableInput;
	var bMouseDrivenNav;
	var bRecenterSelection;
	var border;
	var dispatchEvent;
	var doSetSelectedIndex;
	var fListHeight;
	var iDividerIndex;
	var iListItemsShown;
	var iMaxItemsShown;
	var iMaxScrollPosition;
	var iMaxTextLength;
	var iNumTopHalfEntries;
	var iNumUnfilteredItems;
	var iPlatform;
	var iScrollPosition;
	var iSelectedIndex;

	function CenteredScrollingList()
	{
		super();
		this._filterer = new Shared.ListFilterer();
		this._filterer.addEventListener("filterChange", this, "onFilterChange");
		this.bRecenterSelection = false;
		this.iMaxTextLength = 256;
		this.iDividerIndex = -1;
		this.iNumUnfilteredItems = 0;
	}

	function get filterer()
	{
		return this._filterer;
	}

	function set maxTextLength(aLength)
	{
		if (aLength > 3) 
		{
			this.iMaxTextLength = aLength;
		}
	}

	function get numUnfilteredItems()
	{
		return this.iNumUnfilteredItems;
	}

	function get maxTextLength()
	{
		return this.iMaxTextLength;
	}

	function get numTopHalfEntries()
	{
		return this.iNumTopHalfEntries;
	}

	function set numTopHalfEntries(aiNum)
	{
		this.iNumTopHalfEntries = aiNum;
	}

	function get centeredEntry()
	{
		return this.EntriesA[this.GetClipByIndex(this.iNumTopHalfEntries).itemIndex];
	}

	function IsDivider(aEntry)
	{
		return aEntry.divider == true || aEntry.flag == 0;
	}
    
	function IsSelectionAboveDivider()
	{
		return this.iDividerIndex == -1 || this.selectedIndex < this.iDividerIndex;
	}

	function get dividerIndex()
	{
		return this.iDividerIndex;
	}

	function RestoreScrollPosition(aiNewPosition, abRecenterSelection)
	{
		this.iScrollPosition = aiNewPosition;
		if (this.iScrollPosition < 0) 
		{
			this.iScrollPosition = 0;
		}
		if (this.iScrollPosition > this.iMaxScrollPosition) 
		{
			this.iScrollPosition = this.iMaxScrollPosition;
		}
		this.bRecenterSelection = abRecenterSelection;
	}

	function UpdateList()
	{
		var __reg10 = this.GetClipByIndex(0)._y;
		var __reg6 = 0;
		var __reg2 = this.filterer.ClampIndex(0);
		this.iDividerIndex = -1;
		var __reg7 = 0;
		while (__reg7 < this.EntriesA.length) 
		{
			if (this.IsDivider(this.EntriesA[__reg7])) 
			{
				this.iDividerIndex = __reg7;
			}
			++__reg7;
		}
		if (this.bRecenterSelection || this.iPlatform != 0) 
		{
			this.iSelectedIndex = -1;
		}
		else 
		{
			this.iSelectedIndex = this.filterer.ClampIndex(this.iSelectedIndex);
		}
		var __reg9 = 0;
		while (__reg9 < this.iScrollPosition - this.iNumTopHalfEntries) 
		{
			this.EntriesA[__reg2].clipIndex = undefined;
			__reg2 = this.filterer.GetNextFilterMatch(__reg2);
			++__reg9;
		}
		this.iListItemsShown = 0;
		this.iNumUnfilteredItems = 0;
		var __reg4 = 0;
		while (__reg4 < this.iNumTopHalfEntries) 
		{
			var __reg5 = this.GetClipByIndex(__reg4);
			if (this.iScrollPosition - this.iNumTopHalfEntries + __reg4 >= 0) 
			{
				this.SetEntry(__reg5, this.EntriesA[__reg2]);
				__reg5._visible = true;
				__reg5.itemIndex = this.IsDivider(this.EntriesA[__reg2]) == true ? undefined : __reg2;
				this.EntriesA[__reg2].clipIndex = __reg4;
				__reg2 = this.filterer.GetNextFilterMatch(__reg2);
				++this.iNumUnfilteredItems;
			}
			else 
			{
				__reg5._visible = false;
				__reg5.itemIndex = undefined;
			}
			__reg5._y = __reg10 + __reg6;
			__reg6 = __reg6 + __reg5._height;
			++this.iListItemsShown;
			++__reg4;
		}
		if (__reg2 != undefined && (this.bRecenterSelection || this.iPlatform != 0)) 
		{
			this.iSelectedIndex = __reg2;
		}
		while (__reg2 != undefined && __reg2 != -1 && __reg2 < this.EntriesA.length && this.iListItemsShown < this.iMaxItemsShown && __reg6 <= this.fListHeight) 
		{
			__reg5 = this.GetClipByIndex(this.iListItemsShown);
			this.SetEntry(__reg5, this.EntriesA[__reg2]);
			this.EntriesA[__reg2].clipIndex = this.iListItemsShown;
			__reg5.itemIndex = this.IsDivider(this.EntriesA[__reg2]) == true ? undefined : __reg2;
			__reg5._y = __reg10 + __reg6;
			__reg5._visible = true;
			__reg6 = __reg6 + __reg5._height;
			if (__reg6 <= this.fListHeight && this.iListItemsShown < this.iMaxItemsShown) 
			{
				++this.iListItemsShown;
				++this.iNumUnfilteredItems;
			}
			__reg2 = this.filterer.GetNextFilterMatch(__reg2);
		}
		var __reg8 = this.iListItemsShown;
		while (__reg8 < this.iMaxItemsShown) 
		{
			this.GetClipByIndex(__reg8)._visible = false;
			this.GetClipByIndex(__reg8).itemIndex = undefined;
			++__reg8;
		}
		if (this.bMouseDrivenNav && !this.bRecenterSelection) 
		{
			var __reg3 = Mouse.getTopMostEntity();
			while (__reg3 != undefined) 
			{
				if (__reg3._parent == this && __reg3._visible && __reg3.itemIndex != undefined) 
				{
					this.doSetSelectedIndex(__reg3.itemIndex, 0);
				}
				__reg3 = __reg3._parent;
			}
		}
		this.bRecenterSelection = false;
	}

	function InvalidateData()
	{
		this.filterer.filterArray = this.EntriesA;
		this.fListHeight = this.border._height;
		this.CalculateMaxScrollPosition();
		if (this.iScrollPosition > this.iMaxScrollPosition) 
		{
			this.iScrollPosition = this.iMaxScrollPosition;
		}
		this.UpdateList();
	}

	function onFilterChange()
	{
		this.iSelectedIndex = this.filterer.ClampIndex(this.iSelectedIndex);
		this.CalculateMaxScrollPosition();
	}

	function moveSelectionUp()
	{
		var __reg4 = this.GetClipByIndex(this.iNumTopHalfEntries);
		var __reg2 = this.filterer.GetPrevFilterMatch(this.iSelectedIndex);
		var __reg3 = this.iScrollPosition;
		if (__reg2 != undefined && this.IsDivider(this.EntriesA[__reg2]) == true) 
		{
			--this.iScrollPosition;
			__reg2 = this.filterer.GetPrevFilterMatch(__reg2);
		}
		if (__reg2 != undefined) 
		{
			this.iSelectedIndex = __reg2;
			if (this.iScrollPosition > 0) 
			{
				--this.iScrollPosition;
			}
			this.bMouseDrivenNav = false;
			this.UpdateList();
			this.dispatchEvent({type: "listMovedUp", index: this.iSelectedIndex, scrollChanged: __reg3 != this.iScrollPosition});
		}
	}

	function moveSelectionDown()
	{
		var __reg4 = this.GetClipByIndex(this.iNumTopHalfEntries);
		var __reg2 = this.filterer.GetNextFilterMatch(this.iSelectedIndex);
		var __reg3 = this.iScrollPosition;
		if (__reg2 != undefined && this.IsDivider(this.EntriesA[__reg2]) == true) 
		{
			++this.iScrollPosition;
			__reg2 = this.filterer.GetNextFilterMatch(__reg2);
		}
		if (__reg2 != undefined) 
		{
			this.iSelectedIndex = __reg2;
			if (this.iScrollPosition < this.iMaxScrollPosition) 
			{
				++this.iScrollPosition;
			}
			this.bMouseDrivenNav = false;
			this.UpdateList();
			this.dispatchEvent({type: "listMovedDown", index: this.iSelectedIndex, scrollChanged: __reg3 != this.iScrollPosition});
		}
	}

	function onMouseWheel(delta)
	{
		if (this.bDisableInput) 
		{
			return;
		}
		var __reg2 = Mouse.getTopMostEntity();
		while (__reg2 && __reg2 != undefined) 
		{
			if (__reg2 == this) 
			{
				if (delta < 0) 
				{
					var __reg4 = this.GetClipByIndex(this.iNumTopHalfEntries + 1);
					if (__reg4._visible == true) 
					{
						if (__reg4.itemIndex == undefined) 
						{
							this.scrollPosition = this.scrollPosition + 2;
						}
						else 
						{
							this.scrollPosition = this.scrollPosition + 1;
						}
					}
				}
				else if (delta > 0) 
				{
					var __reg3 = this.GetClipByIndex(this.iNumTopHalfEntries - 1);
					if (__reg3._visible == true) 
					{
						if (__reg3.itemIndex == undefined) 
						{
							this.scrollPosition = this.scrollPosition - 2;
						}
						else 
						{
							this.scrollPosition = this.scrollPosition - 1;
						}
					}
				}
			}
			__reg2 = __reg2._parent;
		}
		this.bMouseDrivenNav = true;
	}

	function CalculateMaxScrollPosition()
	{
		this.iMaxScrollPosition = -1;
		var __reg2 = this.filterer.ClampIndex(0);
		while (__reg2 != undefined) 
		{
			++this.iMaxScrollPosition;
			__reg2 = this.filterer.GetNextFilterMatch(__reg2);
		}
		if (this.iMaxScrollPosition == undefined || this.iMaxScrollPosition < 0) 
		{
			this.iMaxScrollPosition = 0;
		}
	}

	function SetEntry(aEntryClip, aEntryObject)
	{
		if (aEntryClip != undefined) 
		{
			if (this.IsDivider(aEntryObject) == true) 
			{
				aEntryClip.gotoAndStop("Divider");
			}
			else 
			{
				aEntryClip.gotoAndStop("Normal");
			}
			if (this.iPlatform == 0) 
			{
				aEntryClip._alpha = aEntryObject == this.selectedEntry ? 100 : 60;
			}
			else 
			{
				var __reg3 = 4;
				if (aEntryClip.clipIndex < this.iNumTopHalfEntries) 
				{
					aEntryClip._alpha = 60 - __reg3 * (this.iNumTopHalfEntries - aEntryClip.clipIndex);
				}
				else if (aEntryClip.clipIndex > this.iNumTopHalfEntries) 
				{
					aEntryClip._alpha = 60 - __reg3 * (aEntryClip.clipIndex - this.iNumTopHalfEntries);
				}
				else 
				{
					aEntryClip._alpha = 100;
				}
			}
			this.SetEntryText(aEntryClip, aEntryObject);
		}
	}

}
