dynamic class FilteredList extends Shared.CenteredList
{
	var BottomHalf;
	var EntriesA;
	var EntryMatchesFunc;
	var RepositionEntries;
	var SelectedEntry;
	var TopHalf;
	var bMultilineList;
	var bToFitList;
	var dispatchEvent;
	var iDividerIndex;
	var iItemFilter;
	var iMaxEntriesBottomHalf;
	var iMaxEntriesTopHalf;
	var iSelectedIndex;

	function FilteredList()
	{
		super();
		this.iItemFilter = 4294967295;
		this.EntryMatchesFunc = this.EntryMatchesFilter;
		this.iDividerIndex = -1;
	}

	function get itemFilter()
	{
		return this.iItemFilter;
	}

	function set itemFilter(aiNewFilter)
	{
		this.iItemFilter = aiNewFilter;
	}

	function SetPartitionedFilterMode(abPartition)
	{
		this.EntryMatchesFunc = abPartition ? this.EntryMatchesPartitionedFilter : this.EntryMatchesFilter;
	}

	function IsDivider(aEntry)
	{
		return aEntry.divider == true || aEntry.flag == 0;
	}

	function moveListUp()
	{
		var __reg2 = this.GetNextFilterMatch(this.iSelectedIndex);
		if (__reg2 != undefined && this.IsDivider(this.EntriesA[__reg2])) 
		{
			__reg2 = this.GetNextFilterMatch(__reg2);
		}
		if (__reg2 != undefined) 
		{
			this.iSelectedIndex = __reg2;
			this.UpdateList();
			this.dispatchEvent({type: "listMovedUp"});
		}
	}

	function moveListDown()
	{
		var __reg2 = this.GetPrevFilterMatch(this.iSelectedIndex);
		if (__reg2 != undefined && this.IsDivider(this.EntriesA[__reg2])) 
		{
			__reg2 = this.GetPrevFilterMatch(__reg2);
		}
		if (__reg2 != undefined) 
		{
			this.iSelectedIndex = __reg2;
			this.UpdateList();
			this.dispatchEvent({type: "listMovedDown"});
		}
	}

	function EntryMatchesFilter(aiIndex)
	{
		return this.EntriesA[aiIndex] != undefined && (this.EntriesA[aiIndex].filterFlag & this.iItemFilter) != 0;
	}

	function EntryMatchesPartitionedFilter(aiIndex)
	{
		var __reg3 = false;
		if (this.EntriesA[aiIndex] != undefined) 
		{
			if (this.iItemFilter == 4294967295) 
			{
				__reg3 = true;
			}
			else 
			{
				var __reg2 = this.EntriesA[aiIndex].filterFlag;
				var __reg4 = __reg2 & 255;
				var __reg7 = (__reg2 & 65280) >>> 8;
				var __reg6 = (__reg2 & 16711680) >>> 16;
				var __reg5 = (__reg2 & 4278190080) >>> 24;
				__reg3 = __reg4 == this.iItemFilter || __reg7 == this.iItemFilter || __reg6 == this.iItemFilter || __reg5 == this.iItemFilter;
			}
		}
		return __reg3;
	}

	function GetPrevFilterMatch(aiStartIndex)
	{
		var __reg3 = undefined;
		var __reg2 = aiStartIndex - 1;
		while (__reg2 >= 0 && __reg3 == undefined) 
		{
			if (this.EntryMatchesFunc(__reg2)) 
			{
				__reg3 = __reg2;
			}
			--__reg2;
		}
		return __reg3;
	}

	function GetNextFilterMatch(aiStartIndex)
	{
		var __reg3 = undefined;
		var __reg2 = aiStartIndex + 1;
		while (__reg2 < this.EntriesA.length && __reg3 == undefined) 
		{
			if (this.EntryMatchesFunc(__reg2)) 
			{
				__reg3 = __reg2;
			}
			++__reg2;
		}
		return __reg3;
	}

	function UpdateList()
	{
		if (this.iSelectedIndex == undefined) 
		{
			this.iSelectedIndex = 0;
		}
		this.iDividerIndex = -1;
		var __reg2 = 0;
		while (__reg2 < this.EntriesA.length) 
		{
			if (this.IsDivider(this.EntriesA[__reg2])) 
			{
				this.iDividerIndex = __reg2;
			}
			++__reg2;
		}
		if (!this.EntryMatchesFunc(this.iSelectedIndex)) 
		{
			var __reg3 = this.GetNextFilterMatch(this.iSelectedIndex);
			if (__reg3 == undefined) 
			{
				__reg3 = this.GetPrevFilterMatch(this.iSelectedIndex);
			}
			if (__reg3 == undefined) 
			{
				__reg3 = -1;
			}
			this.iSelectedIndex = __reg3;
		}
		this.UpdateTopHalf();
		this.SetEntry(this.SelectedEntry, this.EntriesA[this.iSelectedIndex]);
		this.UpdateBottomHalf();
		this.RepositionEntries();
	}

	function IsSelectionAboveDivider()
	{
		return this.iDividerIndex == -1 || this.selectedIndex < this.iDividerIndex;
	}

	function UpdateTopHalf()
	{
		var __reg3 = this.GetPrevFilterMatch(this.iSelectedIndex);
		var __reg2 = this.iMaxEntriesTopHalf - 1;
		for (;;) 
		{
			if (__reg2 < 0) 
			{
				return;
			}
			if (__reg3 == undefined) 
			{
				this.SetEntry(this.TopHalf["Entry" + __reg2]);
			}
			else 
			{
				this.SetEntry(this.TopHalf["Entry" + __reg2], this.EntriesA[__reg3]);
				__reg3 = this.GetPrevFilterMatch(__reg3);
			}
			--__reg2;
		}
	}

	function UpdateBottomHalf()
	{
		var __reg3 = this.GetNextFilterMatch(this.iSelectedIndex);
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.iMaxEntriesBottomHalf) 
			{
				return;
			}
			if (__reg3 == undefined) 
			{
				this.SetEntry(this.BottomHalf["Entry" + __reg2]);
			}
			else 
			{
				this.SetEntry(this.BottomHalf["Entry" + __reg2], this.EntriesA[__reg3]);
				__reg3 = this.GetNextFilterMatch(__reg3);
			}
			++__reg2;
		}
	}

	function SetEntry(aEntryClip, aEntryObject)
	{
		if (this.IsDivider(aEntryObject)) 
		{
			aEntryClip.gotoAndStop("Divider");
		}
		else 
		{
			aEntryClip.gotoAndStop(aEntryObject.enabled == false ? "Disabled" : "Normal");
		}
		if (aEntryClip.textField != undefined) 
		{
			if (aEntryObject.text == undefined) 
			{
				aEntryClip.textField.SetText(" ");
			}
			else 
			{
				aEntryClip.textField.SetText(aEntryObject.text);
			}
			if (this.bMultilineList == true) 
			{
				aEntryClip.textField.verticalAutoSize = "top";
			}
			if (this.bToFitList == true) 
			{
				aEntryClip.textField.textAutoSize = "shrink";
			}
		}
	}

}
