class DialogueCenteredList extends Shared.CenteredScrollingList
{
	var EntriesA: Array;
	
	var bDisableInput: Boolean;
	var bRecenterSelection: Boolean;
	
	var fCenterY: Number;
	var fListHeight: Number;
	var iListItemsShown: Number;
	var iMaxItemsShown: Number;
	var iNumTopHalfEntries: Number;
	var iPlatform: Number;
	var iScrollPosition: Number;
	var iSelectedIndex: Number;

	function DialogueCenteredList()
	{
		super();
		fCenterY = GetClipByIndex(iNumTopHalfEntries)._y + GetClipByIndex(iNumTopHalfEntries)._height / 2;
	}

	function SetEntryText(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		super.SetEntryText(aEntryClip, aEntryObject);
		if (aEntryClip.textField != undefined) {
			aEntryClip.textField.textColor = aEntryObject.topicIsNew == undefined || aEntryObject.topicIsNew ? 0xFFFFFF : 0x606060;
		}
	}

	function UpdateList(): Void
	{
		var listItemSpacing = 0;
		var listCumulativeHeight = 0;
		
		var centerIndex: Number = iScrollPosition - iNumTopHalfEntries < 0 ? 0 : iScrollPosition - iNumTopHalfEntries;
		
		iListItemsShown = 0;
		
		for (var i: Number = 0;  i < iNumTopHalfEntries; i++) {
			var listItem: MovieClip = GetClipByIndex(i);
			if (iScrollPosition - iNumTopHalfEntries + i >= 0) {
				SetEntry(listItem, EntriesA[centerIndex]);
				listItem._visible = true;
				listItem.itemIndex = centerIndex;
				EntriesA[centerIndex].clipIndex = i;
				++centerIndex;
			} else {
				SetEntry(listItem, {text: " "});
				listItem._visible = false;
				listItem.itemIndex = undefined;
			}
			listItem._y = listItemSpacing + listCumulativeHeight;
			listCumulativeHeight += listItem._height;
			++iListItemsShown;
		}
		
		if (bRecenterSelection || iPlatform != 0) {
			iSelectedIndex = centerIndex;
		}
		
		for (var i = centerIndex; i < EntriesA.length && iListItemsShown < iMaxItemsShown && listCumulativeHeight <= fListHeight; i++) {
			listItem = GetClipByIndex(iListItemsShown);
			SetEntry(listItem, EntriesA[i]);
			EntriesA[i].clipIndex = iListItemsShown;
			listItem.itemIndex = i;
			listItem._y = listItemSpacing + listCumulativeHeight;
			listItem._visible = true;
			listCumulativeHeight += listItem._height;
			if (listCumulativeHeight <= fListHeight && iListItemsShown < iMaxItemsShown) {
				++iListItemsShown;
			}
		}
		
		for (var i: Number = iListItemsShown; i < iMaxItemsShown; i++) {
			GetClipByIndex(i)._visible = false;
			GetClipByIndex(i).itemIndex = undefined;
		}
		
		
		if (!bRecenterSelection) {
			for (var target: Object = Mouse.getTopMostEntity(); target != undefined; target = target._parent) {
				if (target._parent == this && target._visible && target.itemIndex != undefined) {
					doSetSelectedIndex(target.itemIndex,0);
				}
			}
		}
		
		bRecenterSelection = false;
		RepositionEntries();
		var imaxItemsBelowShown: Number = 3;
		_parent.ScrollIndicators.Up._visible = scrollPosition > iNumTopHalfEntries;
		_parent.ScrollIndicators.Down._visible = EntriesA.length - scrollPosition - 1 > imaxItemsBelowShown || listCumulativeHeight > fListHeight;
	}

	function RepositionEntries()
	{
		var item_yOffset = GetClipByIndex(iNumTopHalfEntries)._y + GetClipByIndex(iNumTopHalfEntries)._height / 2;
		var item_yPosition = fCenterY - item_yOffset;

		for (var i: Number = 0; i < iMaxItemsShown; i++) {
			GetClipByIndex(i)._y += item_yPosition;
		}
		
		return;
	}

	function onMouseWheel(delta: Number): Void
	{
		if (bDisableInput) {
			return;
		}
		
		iSelectedIndex = -1;
		bRecenterSelection = true;
		
		for (var target: Object = Mouse.getTopMostEntity(); target && target != undefined; target = target._parent) {
			if (target == this) {
				bRecenterSelection = false;
			}
		}
		
		var listItem: MovieClip
		
		if (delta < 0) {
			listItem = GetClipByIndex(iNumTopHalfEntries + 1);
			if (listItem._visible == true) {
				scrollPosition = scrollPosition + 1;
			}
		} else {
			listItem = GetClipByIndex(iNumTopHalfEntries - 1);
			if (listItem._visible == true) {
				scrollPosition = scrollPosition - 1;
			}
		}
		return;
	}

	function SetSelectedTopic(aiTopicIndex: Number): Void
	{
		iSelectedIndex = 0;
		iScrollPosition = 0;
		
		for (var i: Number = 0; i < EntriesA.length; i++) {
			if (EntriesA[i].topicIndex == aiTopicIndex) {
				iScrollPosition = i;
			}
		}
	}

}
