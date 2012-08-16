import gfx.io.GameDelegate;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

class InventoryMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
	var AltButtonArt: Object;
	var BottomBar_mc: MovieClip;
	var ChargeButtonArt: Object;
	var EquipButtonArt: Object;
	var InventoryLists_mc: MovieClip;
	var ItemCardListButtonArt: Array;
	var ItemCard_mc: MovieClip;
	var PrevButtonArt: Array;
	var bFadedIn: Boolean;
	var bMenuClosing: Boolean;

	function InventoryMenu()
	{
		super();
		bMenuClosing = false;
		EquipButtonArt = {PCArt: "M1M2", XBoxArt: "360_LTRT", PS3Art: "PS3_LBRB"};
		AltButtonArt = {PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"};
		ChargeButtonArt = {PCArt: "T", XBoxArt: "360_RB", PS3Art: "PS3_RT"};
		ItemCardListButtonArt = [{PCArt: "Enter", XBoxArt: "360_A", PS3Art: "PS3_A"}, {PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}];
		PrevButtonArt = undefined;
	}

	function InitExtensions(): Void
	{
		super.InitExtensions();
		Shared.GlobalFunc.AddReverseFunctions();
		InventoryLists_mc.ZoomButtonHolderInstance.gotoAndStop(1);
		BottomBar_mc.SetButtonArt(ChargeButtonArt, 3);
		GameDelegate.addCallBack("AttemptEquip", this, "AttemptEquip");
		GameDelegate.addCallBack("DropItem", this, "DropItem");
		GameDelegate.addCallBack("AttemptChargeItem", this, "AttemptChargeItem");
		GameDelegate.addCallBack("ItemRotating", this, "ItemRotating");
		ItemCard_mc.addEventListener("itemPress", this, "onItemCardListPress");
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (bFadedIn && !pathToFocus[0].handleInput(details, pathToFocus.slice(1))) {
			if (Shared.GlobalFunc.IsKeyPressed(details)) {
				if (InventoryLists_mc.currentState == InventoryLists.ONE_PANEL && details.navEquivalent == NavigationCode.LEFT) {
					StartMenuFade();
					GameDelegate.call("ShowTweenMenu", []);
				} else if (details.navEquivalent == NavigationCode.TAB) {
					StartMenuFade();
					GameDelegate.call("CloseTweenMenu", []);
				}
			}
		}
		return true;
	}

	function onExitMenuRectClick(): Void
	{
		StartMenuFade();
		GameDelegate.call("ShowTweenMenu", []);
	}

	function StartMenuFade(): Void
	{
		InventoryLists_mc.HideCategoriesList();
		ToggleMenuFade();
		SaveIndices();
		bMenuClosing = true;
	}

	function onFadeCompletion(): Void
	{
		if (bMenuClosing) {
			GameDelegate.call("CloseMenu", []);
		}
	}

	function onShowItemsList(event: Object): Void
	{
		super.onShowItemsList(event);
		if (event.index != -1) {
			UpdateBottomBarButtons();
		}
	}

	function onItemHighlightChange(event: Object): Void
	{
		super.onItemHighlightChange(event);
		if (event.index != -1) 
		{
			UpdateBottomBarButtons();
		}
	}

	function UpdateBottomBarButtons(): Void
	{
		BottomBar_mc.SetButtonArt(AltButtonArt, 0);
		
		switch(ItemCard_mc.itemInfo.type) {
			case InventoryDefines.ICT_ARMOR:
				BottomBar_mc.SetButtonText("$Equip", 0);
				break;
			case InventoryDefines.ICT_BOOK:
				BottomBar_mc.SetButtonText("$Read", 0);
				break;
			case InventoryDefines.ICT_POTION:
				BottomBar_mc.SetButtonText("$Use", 0);
				break;
			case InventoryDefines.ICT_FOOD:
				BottomBar_mc.SetButtonText("$Eat", 0);
				break;
			case InventoryDefines.ICT_INGREDIENT:
				BottomBar_mc.SetButtonText("$Eat", 0);
				break;
			default:
				BottomBar_mc.SetButtonArt(EquipButtonArt, 0);
				BottomBar_mc.SetButtonText("$Equip", 0);
		}
		
		BottomBar_mc.SetButtonText("$Drop", 1);
		if ((InventoryLists_mc.ItemsList.selectedEntry.filterFlag & InventoryLists_mc.CategoriesList.entryList[0].flag) == 0) {
			BottomBar_mc.SetButtonText("$Favorite", 2);
		} else {
			BottomBar_mc.SetButtonText("$Unfavorite", 2);
		}
		if (ItemCard_mc.itemInfo.charge != undefined && ItemCard_mc.itemInfo.charge < 100) {
			BottomBar_mc.SetButtonText("$Charge", 3);
			return;
		}
		BottomBar_mc.SetButtonText("", 3);
	}

	function onHideItemsList(event: Object): Void
	{
		super.onHideItemsList(event);
		BottomBar_mc.UpdatePerItemInfo({type: InventoryDefines.ICT_NONE});
	}

	function onItemSelect(event: Object): Void
	{
		if (event.entry.enabled && event.keyboardOrMouse != 0) 
		{
			GameDelegate.call("ItemSelect", []);
		}
	}

	function AttemptEquip(aiSlot: Number, abCheckOverList: Boolean): Void
	{
		var processInput: Boolean = abCheckOverList == undefined ? true : abCheckOverList;
		if (ShouldProcessItemsListInput(processInput)) {
			GameDelegate.call("ItemSelect", [aiSlot]);
		}
	}

	function DropItem(): Void
	{
		if (ShouldProcessItemsListInput(false) && InventoryLists_mc.ItemsList.selectedEntry != undefined) {
			if (InventoryLists_mc.ItemsList.selectedEntry.count <= InventoryDefines.QUANTITY_MENU_COUNT_LIMIT) {
				onQuantityMenuSelect({amount: 1});
				return;
			}
			ItemCard_mc.ShowQuantityMenu(InventoryLists_mc.ItemsList.selectedEntry.count);
		}
	}

	function AttemptChargeItem(): Void
	{
		if (ShouldProcessItemsListInput(false) && ItemCard_mc.itemInfo.charge != undefined && ItemCard_mc.itemInfo.charge < 100) {
			GameDelegate.call("ShowSoulGemList", []);
		}
	}

	function onQuantityMenuSelect(event: Object): Void
	{
		GameDelegate.call("ItemDrop", [event.amount]);
	}

	function onMouseRotationFastClick(aiMouseButton: Number): Void
	{
		GameDelegate.call("CheckForMouseEquip", [aiMouseButton], this, "AttemptEquip");
	}

	function onItemCardListPress(event: Object): Void
	{
		GameDelegate.call("ItemCardListCallback", [event.index]);
	}

	function onItemCardSubMenuAction(event: Object): Void
	{
		super.onItemCardSubMenuAction(event);
		if (event.menu == "quantity") {
			GameDelegate.call("QuantitySliderOpen", [event.opening]);
		}
		if (event.menu == "list") {
			if (event.opening == true) {
				PrevButtonArt = BottomBar_mc.GetButtonsArt();
				BottomBar_mc.SetButtonsText("$Select", "$Cancel");
				BottomBar_mc.SetButtonsArt(ItemCardListButtonArt);
				return;
			}
			BottomBar_mc.SetButtonsArt(PrevButtonArt);
			PrevButtonArt = undefined;
			GameDelegate.call("RequestItemCardInfo", [], this, "UpdateItemCardInfo");
			UpdateBottomBarButtons();
		}
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		InventoryLists_mc.ZoomButtonHolderInstance.gotoAndStop(1);
		InventoryLists_mc.ZoomButtonHolderInstance.ZoomButton._visible = aiPlatform != 0;
		InventoryLists_mc.ZoomButtonHolderInstance.ZoomButton.SetPlatform(aiPlatform, abPS3Switch);
		super.SetPlatform(aiPlatform, abPS3Switch);
	}

	function ItemRotating(): Void
	{
		InventoryLists_mc.ZoomButtonHolderInstance.PlayForward(InventoryLists_mc.ZoomButtonHolderInstance._currentframe);
	}

}
