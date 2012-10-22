class FilteredList extends Shared.CenteredList
{
	var BottomHalf: Array;
	var EntriesA: Array;
	var EntryMatchesFunc: Function;
	var RepositionEntries: Function;
	var SelectedEntry: MovieClip;
	var TopHalf: Array;
	var bMultilineList: Boolean;
	var bToFitList: Boolean;
	var dispatchEvent: Function;
	var iDividerIndex: Number;
	var iItemFilter: Number;
	var iMaxEntriesBottomHalf: Number;
	var iMaxEntriesTopHalf: Number;
	var iSelectedIndex: Number;

	function FilteredList()
	{
		super();
		iItemFilter = 0xFFFFFFFF;
		EntryMatchesFunc = EntryMatchesFilter;
		iDividerIndex = -1;
	}

	function get itemFilter(): Number
	{
		return iItemFilter;
	}

	function set itemFilter(aiNewFilter: Number): Void
	{
		iItemFilter = aiNewFilter;
	}

	function SetPartitionedFilterMode(abPartition: Boolean): Void
	{
		EntryMatchesFunc = abPartition ? EntryMatchesPartitionedFilter : EntryMatchesFilter;
	}

	function IsDivider(aEntry: Object): Boolean
	{
		return aEntry.divider == true || aEntry.flag == 0;
	}

	function moveListUp(): Void
	{
		var nextMatchIdx: Number = GetNextFilterMatch(iSelectedIndex);
		if (nextMatchIdx != undefined && IsDivider(EntriesA[nextMatchIdx])) {
			nextMatchIdx = GetNextFilterMatch(nextMatchIdx);
		}
		if (nextMatchIdx != undefined) {
			iSelectedIndex = nextMatchIdx;
			UpdateList();
			dispatchEvent({type: "listMovedUp"});
		}
	}

	function moveListDown(): Void
	{
		var prevMatchIdx: Number = GetPrevFilterMatch(iSelectedIndex);
		if (prevMatchIdx != undefined && IsDivider(EntriesA[prevMatchIdx])) {
			prevMatchIdx = GetPrevFilterMatch(prevMatchIdx);
		}
		if (prevMatchIdx != undefined) {
			iSelectedIndex = prevMatchIdx;
			UpdateList();
			dispatchEvent({type: "listMovedDown"});
		}
	}

	function EntryMatchesFilter(aiIndex: Number): Boolean
	{
		return EntriesA[aiIndex] != undefined && (EntriesA[aiIndex].filterFlag & iItemFilter) != 0;
	}

	function EntryMatchesPartitionedFilter(aiIndex: Number): Boolean
	{
		var match: Boolean = false;
		if (EntriesA[aiIndex] != undefined) {
			if (iItemFilter == 0xFFFFFFFF) {
				match = true;
			} else {
				var filterFlag: Number = EntriesA[aiIndex].filterFlag;
				var byte0: Number = (filterFlag & 0x000000FF);
				var byte1: Number = (filterFlag & 0x0000FF00) >>> 8;
				var byte2: Number = (filterFlag & 0x00FF0000) >>> 16;
				var byte3: Number = (filterFlag & 0xFF000000) >>> 24;
				match = byte0 == iItemFilter || byte1 == iItemFilter || byte2 == iItemFilter || byte3 == iItemFilter;
			}
		}
		return match;
	}

	function GetPrevFilterMatch(aiStartIndex: Number): Number
	{
		var prevIdx = undefined;
		
		for (var i: Number = aiStartIndex - 1; i >= 0 && prevIdx == undefined; i--) {
			if (EntryMatchesFunc(i)) {
				prevIdx = i;
			}
		}
		
		return prevIdx;
	}

	function GetNextFilterMatch(aiStartIndex: Number): Number
	{
		var nextIdx = undefined;
		
		for (var i: Number = aiStartIndex + 1; i < EntriesA.length && nextIdx == undefined; i++) {
			if (EntryMatchesFunc(i)) {
				nextIdx = i;
			}
		}
		
		return nextIdx;
	}

	function UpdateList(): Void
	{
		if (iSelectedIndex == undefined) {
			iSelectedIndex = 0;
		}
		iDividerIndex = -1;
		
		for (var i: Number = 0; i < EntriesA.length; i++ ) {
			if (IsDivider(EntriesA[i])) {
				iDividerIndex = i;
			}
		}
		
		if (!EntryMatchesFunc(iSelectedIndex)) {
			var nextIdx: Number = GetNextFilterMatch(iSelectedIndex);
			if (nextIdx == undefined) {
				nextIdx = GetPrevFilterMatch(iSelectedIndex);
			}
			if (nextIdx == undefined) {
				nextIdx = -1;
			}
			iSelectedIndex = nextIdx;
		}
		
		UpdateTopHalf();
		SetEntry(SelectedEntry, EntriesA[iSelectedIndex]);
		UpdateBottomHalf();
		RepositionEntries();
	}

	function IsSelectionAboveDivider(): Boolean
	{
		return iDividerIndex == -1 || selectedIndex < iDividerIndex;
	}

	function UpdateTopHalf(): Void
	{
		var prevIdx: Number = GetPrevFilterMatch(iSelectedIndex);
		
		for (var i: Number = iMaxEntriesTopHalf - 1; i >= 0; i--) {
			if (prevIdx == undefined) {
				SetEntry(TopHalf["Entry" + i]);
			} else {
				SetEntry(TopHalf["Entry" + i], EntriesA[prevIdx]);
				prevIdx = GetPrevFilterMatch(prevIdx);
			}
		}
	}

	function UpdateBottomHalf(): Void
	{
		var nextIdx: Number = GetNextFilterMatch(iSelectedIndex);
		
		for (var i: Number = 0; i < iMaxEntriesBottomHalf; i++) {
			if (nextIdx == undefined) {
				SetEntry(BottomHalf["Entry" + i]);
			} else {
				SetEntry(BottomHalf["Entry" + i], EntriesA[nextIdx]);
				nextIdx = GetNextFilterMatch(nextIdx);
			}
		}
	}

	function SetEntry(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		if (IsDivider(aEntryObject)) {
			aEntryClip.gotoAndStop("Divider");
		} else {
			aEntryClip.gotoAndStop(aEntryObject.enabled == false ? "Disabled" : "Normal");
		}
		if (aEntryClip.textField != undefined) {
			if (aEntryObject.text == undefined) {
				aEntryClip.textField.SetText(" ");
			} else {
				aEntryClip.textField.SetText(aEntryObject.text);
			}
			if (bMultilineList == true) {
				aEntryClip.textField.verticalAutoSize = "top";
			}
			if (bToFitList == true) {
				aEntryClip.textField.textAutoSize = "shrink";
			}
		}
	}

}
