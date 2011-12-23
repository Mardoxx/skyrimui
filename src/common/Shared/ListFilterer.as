dynamic class Shared.ListFilterer
{
	var EntryMatchesFunc;
	var _filterArray;
	var dispatchEvent;
	var iItemFilter;

	function ListFilterer()
	{
		this.iItemFilter = 4294967295;
		this.EntryMatchesFunc = this.EntryMatchesFilter;
		gfx.events.EventDispatcher.initialize(this);
	}

	function get itemFilter()
	{
		return this.iItemFilter;
	}

	function set itemFilter(aiNewFilter)
	{
		var __reg2 = this.iItemFilter != aiNewFilter;
		this.iItemFilter = aiNewFilter;
		if (__reg2 == true) 
		{
			this.dispatchEvent({type: "filterChange"});
		}
	}

	function get filterArray()
	{
		return this._filterArray;
	}

	function set filterArray(aNewArray)
	{
		this._filterArray = aNewArray;
	}

	function SetPartitionedFilterMode(abPartition)
	{
		this.EntryMatchesFunc = abPartition ? this.EntryMatchesPartitionedFilter : this.EntryMatchesFilter;
	}

	function EntryMatchesFilter(aEntry)
	{
		return aEntry != undefined && (aEntry.filterFlag == undefined || (aEntry.filterFlag & this.iItemFilter) != 0);
	}

	function EntryMatchesPartitionedFilter(aEntry)
	{
		var __reg3 = false;
		if (aEntry != undefined) 
		{
			if (this.iItemFilter == 4294967295) 
			{
				__reg3 = true;
			}
			else 
			{
				var __reg2 = aEntry.filterFlag;
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
		if (aiStartIndex != undefined) 
		{
			var __reg2 = aiStartIndex - 1;
			while (__reg2 >= 0 && __reg3 == undefined) 
			{
				if (this.EntryMatchesFunc(this._filterArray[__reg2])) 
				{
					__reg3 = __reg2;
				}
				--__reg2;
			}
		}
		return __reg3;
	}

	function GetNextFilterMatch(aiStartIndex)
	{
		var __reg3 = undefined;
		if (aiStartIndex != undefined) 
		{
			var __reg2 = aiStartIndex + 1;
			while (__reg2 < this._filterArray.length && __reg3 == undefined) 
			{
				if (this.EntryMatchesFunc(this._filterArray[__reg2])) 
				{
					__reg3 = __reg2;
				}
				++__reg2;
			}
		}
		return __reg3;
	}

	function ClampIndex(aiStartIndex)
	{
		var __reg2 = aiStartIndex;
		if (aiStartIndex != undefined && !this.EntryMatchesFunc(this._filterArray[__reg2])) 
		{
			var __reg4 = this.GetNextFilterMatch(__reg2);
			var __reg3 = this.GetPrevFilterMatch(__reg2);
			if (__reg4 == undefined) 
			{
				if (__reg3 == undefined) 
				{
					__reg2 = -1;
				}
				else 
				{
					__reg2 = __reg3;
				}
			}
			else 
			{
				__reg2 = __reg4;
			}
			if (__reg4 != undefined && __reg3 != undefined && __reg3 != __reg4 && __reg2 == __reg4 && this._filterArray[__reg3].text == this._filterArray[aiStartIndex].text) 
			{
				__reg2 = __reg3;
			}
		}
		return __reg2;
	}

}
