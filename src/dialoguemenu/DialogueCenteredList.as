dynamic class DialogueCenteredList extends Shared.CenteredScrollingList
{
	var EntriesA;
	var GetClipByIndex;
	var SetEntry;
	var _parent;
	var bDisableInput;
	var bRecenterSelection;
	var doSetSelectedIndex;
	var fCenterY;
	var fListHeight;
	var iListItemsShown;
	var iMaxItemsShown;
	var iNumTopHalfEntries;
	var iPlatform;
	var iScrollPosition;
	var iSelectedIndex;

	function DialogueCenteredList()
	{
		super();
		this.fCenterY = this.GetClipByIndex(this.iNumTopHalfEntries)._y + this.GetClipByIndex(this.iNumTopHalfEntries)._height / 2;
	}

	function SetEntryText(aEntryClip, aEntryObject)
	{
		super.SetEntryText(aEntryClip, aEntryObject);
		if (aEntryClip.textField != undefined) 
		{
			aEntryClip.textField.textColor = aEntryObject.topicIsNew == undefined || aEntryObject.topicIsNew ? 16777215 : 6316128;
		}
	}

	function UpdateList()
	{
		var __reg8 = 0;
		var __reg6 = 0;
		var __reg2 = 0;
		while (__reg2 < this.iScrollPosition - this.iNumTopHalfEntries) 
		{
			++__reg2;
		}
		this.iListItemsShown = 0;
		var __reg4 = 0;
		while (__reg4 < this.iNumTopHalfEntries) 
		{
			var __reg5 = this.GetClipByIndex(__reg4);
			if (this.iScrollPosition - this.iNumTopHalfEntries + __reg4 >= 0) 
			{
				this.SetEntry(__reg5, this.EntriesA[__reg2]);
				__reg5._visible = true;
				__reg5.itemIndex = __reg2;
				this.EntriesA[__reg2].clipIndex = __reg4;
				++__reg2;
			}
			else 
			{
				this.SetEntry(__reg5, {text: " "});
				__reg5._visible = false;
				__reg5.itemIndex = undefined;
			}
			__reg5._y = __reg8 + __reg6;
			__reg6 = __reg6 + __reg5._height;
			++this.iListItemsShown;
			++__reg4;
		}
		if (this.bRecenterSelection || this.iPlatform != 0) 
		{
			this.iSelectedIndex = __reg2;
		}
		while (__reg2 < this.EntriesA.length && this.iListItemsShown < this.iMaxItemsShown && __reg6 <= this.fListHeight) 
		{
			__reg5 = this.GetClipByIndex(this.iListItemsShown);
			this.SetEntry(__reg5, this.EntriesA[__reg2]);
			this.EntriesA[__reg2].clipIndex = this.iListItemsShown;
			__reg5.itemIndex = __reg2;
			__reg5._y = __reg8 + __reg6;
			__reg5._visible = true;
			__reg6 = __reg6 + __reg5._height;
			if (__reg6 <= this.fListHeight && this.iListItemsShown < this.iMaxItemsShown) 
			{
				++this.iListItemsShown;
			}
			++__reg2;
		}
		var __reg7 = this.iListItemsShown;
		while (__reg7 < this.iMaxItemsShown) 
		{
			this.GetClipByIndex(__reg7)._visible = false;
			this.GetClipByIndex(__reg7).itemIndex = undefined;
			++__reg7;
		}
		if (!this.bRecenterSelection) 
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
		this.RepositionEntries();
		var __reg10 = 3;
		this._parent.ScrollIndicators.Up._visible = this.scrollPosition > this.iNumTopHalfEntries;
		this._parent.ScrollIndicators.Down._visible = this.EntriesA.length - this.scrollPosition - 1 > __reg10 || __reg6 > this.fListHeight;
	}

	function RepositionEntries()
	{
		var __reg4 = this.GetClipByIndex(this.iNumTopHalfEntries)._y + this.GetClipByIndex(this.iNumTopHalfEntries)._height / 2;
		var __reg3 = this.fCenterY - __reg4;
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.iMaxItemsShown) 
			{
				return;
			}
			this.GetClipByIndex(__reg2)._y = this.GetClipByIndex(__reg2)._y + __reg3;
			++__reg2;
		}
	}

	function onMouseWheel(delta)
	{
		if (this.bDisableInput) 
		{
			return;
		}
		var __reg2 = Mouse.getTopMostEntity();
		this.iSelectedIndex = -1;
		this.bRecenterSelection = true;
		while (__reg2 != undefined) 
		{
			if (__reg2 == this) 
			{
				this.bRecenterSelection = false;
			}
			__reg2 = __reg2._parent;
		}
		if (delta < 0) 
		{
			var __reg4 = this.GetClipByIndex(this.iNumTopHalfEntries + 1);
			if (__reg4._visible == true) 
			{
				this.scrollPosition = this.scrollPosition + 1;
			}
			return;
		}
		if (delta > 0) 
		{
			var __reg3 = this.GetClipByIndex(this.iNumTopHalfEntries - 1);
			if (__reg3._visible == true) 
			{
				this.scrollPosition = this.scrollPosition - 1;
			}
		}
	}

	function SetSelectedTopic(aiTopicIndex)
	{
		this.iSelectedIndex = 0;
		this.iScrollPosition = 0;
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.EntriesA.length) 
			{
				return;
			}
			if (this.EntriesA[__reg2].topicIndex == aiTopicIndex) 
			{
				this.iScrollPosition = __reg2;
			}
			++__reg2;
		}
	}

}
