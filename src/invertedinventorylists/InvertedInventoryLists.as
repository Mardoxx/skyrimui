dynamic class InvertedInventoryLists extends InventoryLists
{
	var strHideItemsCode;
	var strShowItemsCode;

	function InvertedInventoryLists()
	{
		super();
		this.strHideItemsCode = gfx.ui.NavigationCode.RIGHT;
		this.strShowItemsCode = gfx.ui.NavigationCode.LEFT;
	}

}
