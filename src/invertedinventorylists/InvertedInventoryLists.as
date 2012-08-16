import gfx.ui.NavigationCode;

class InvertedInventoryLists extends InventoryLists
{
	var strHideItemsCode: String;
	var strShowItemsCode: String;

	function InvertedInventoryLists() {
		super();
		strHideItemsCode = NavigationCode.RIGHT;
		strShowItemsCode = NavigationCode.LEFT;
	}

}
