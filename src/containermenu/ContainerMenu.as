import gfx.io.GameDelegate;
import gfx.ui.InputDetails;

class ContainerMenu extends ItemMenu
{
	static var NULL_HAND: Number = -1;
	static var RIGHT_HAND: Number = 0;
	static var LEFT_HAND: Number = 1;
	
	var BottomBar_mc: MovieClip;
	var ContainerButtonArt: Array;
	var InventoryButtonArt: Array;
	var InventoryLists_mc: MovieClip;
	var ItemCardFadeHolder_mc: MovieClip;
	var ItemCard_mc: MovieClip;
	var bPCControlsReady: Boolean = true;
	var bNPCMode: Boolean;
	var bShowEquipButtonHelp: Boolean;
	var iEquipHand: Number;
	var iPlatform: Number;
	var iSelectedCategory: Number;

	function ContainerMenu()
	{
		super();
		ContainerButtonArt = [{PCArt: "M1M2", XBoxArt: "360_LTRT", PS3Art: "PS3_LBRB"}, {PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"}, {PCArt: "R", XBoxArt: "360_X", PS3Art: "PS3_X"}];
		InventoryButtonArt = [{PCArt: "M1M2", XBoxArt: "360_LTRT", PS3Art: "PS3_LBRB"}, {PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"}, {PCArt: "R", XBoxArt: "360_X", PS3Art: "PS3_X"}, {PCArt: "F", XBoxArt: "360_Y", PS3Art: "PS3_Y"}];
		bNPCMode = false;
		bShowEquipButtonHelp = true;
		iEquipHand = undefined;
	}

	function InitExtensions(): Void
	{
		super.InitExtensions(false);
		GameDelegate.addCallBack("AttemptEquip", this, "AttemptEquip");
		GameDelegate.addCallBack("XButtonPress", this, "onXButtonPress");
		ItemCardFadeHolder_mc.StealTextInstance._visible = false;
		updateButtons();
	}

	function ShowItemsList(): Void
	{
		InventoryLists_mc.ShowItemsList(false);
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		super.handleInput(details, pathToFocus);
		if (ShouldProcessItemsListInput(false)) {
			if (iPlatform == 0 && details.code == 16) {
				bShowEquipButtonHelp = details.value != "keyUp";
				updateButtons();
			}
		}
		return true;
	}

	function onXButtonPress(): Void
	{
		if (isViewingContainer() && !bNPCMode) {
			GameDelegate.call("TakeAllItems", []);
			return;
		}
		if (isViewingContainer()) {
			return;
		}
		StartItemTransfer();
	}

	function UpdateItemCardInfo(aUpdateObj: Object): Void
	{
		super.UpdateItemCardInfo(aUpdateObj);
		updateButtons();
		if (aUpdateObj.pickpocketChance != undefined) {
			ItemCardFadeHolder_mc.StealTextInstance._visible = true;
			ItemCardFadeHolder_mc.StealTextInstance.PercentTextInstance.html = true;
			ItemCardFadeHolder_mc.StealTextInstance.PercentTextInstance.htmlText = "<font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + aUpdateObj.pickpocketChance + "%</font>" + (isViewingContainer() ? _root.TranslationBass.ToStealTextInstance.text : _root.TranslationBass.ToPlaceTextInstance.text);
			return;
		}
		ItemCardFadeHolder_mc.StealTextInstance._visible = false;
	}

	function onShowItemsList(event: Object): Void
	{
		iSelectedCategory = InventoryLists_mc.CategoriesList.selectedIndex;
		updateButtons();
		super.onShowItemsList(event);
	}

	function onHideItemsList(event: Object): Void
	{
		super.onHideItemsList(event);
		BottomBar_mc.UpdatePerItemInfo({type: InventoryDefines.ICT_NONE});
		updateButtons();
	}

	function updateButtons(): Void
	{
		BottomBar_mc.SetButtonsArt(isViewingContainer() ? ContainerButtonArt : InventoryButtonArt);
		
		if (InventoryLists_mc.currentState != InventoryLists.TRANSITIONING_TO_TWO_PANELS && InventoryLists_mc.currentState != InventoryLists.TWO_PANELS) {
			BottomBar_mc.SetButtonText("", 0);
			BottomBar_mc.SetButtonText("", 1);
			BottomBar_mc.SetButtonText("", 2);
			BottomBar_mc.SetButtonText("", 3);
			return;
		}
		
		updateEquipButtonText();
		
		if (isViewingContainer()) {
			BottomBar_mc.SetButtonText("$Take", 1);
		} else {
			BottomBar_mc.SetButtonText(bShowEquipButtonHelp ? "" : InventoryDefines.GetEquipText(ItemCard_mc.itemInfo.type), 1);
		}
		
		if (isViewingContainer()) {
			if (bNPCMode) {
				BottomBar_mc.SetButtonText("", 2);
			} else if (isViewingContainer()) {
				BottomBar_mc.SetButtonText("$Take All", 2);
			}
		} else if (bNPCMode) {
			BottomBar_mc.SetButtonText("$Give", 2);
		} else {
			BottomBar_mc.SetButtonText("$Store", 2);
		}
		updateFavoriteText();
	}

	function onMouseRotationFastClick(aiMouseButton: Number): Void
	{
		GameDelegate.call("CheckForMouseEquip", [aiMouseButton], this, "AttemptEquip");
	}

	function updateEquipButtonText(): Void
	{
		BottomBar_mc.SetButtonText(bShowEquipButtonHelp ? InventoryDefines.GetEquipText(ItemCard_mc.itemInfo.type) : "", 0);
	}

	function updateFavoriteText(): Void
	{
		if (!isViewingContainer()) {
			BottomBar_mc.SetButtonText(ItemCard_mc.itemInfo.favorite ? "$Unfavorite" : "$Favorite", 3);
			return;
		}
		BottomBar_mc.SetButtonText("", 3);
	}

	function isViewingContainer(): Boolean
	{
		var dividerIdx: Number = InventoryLists_mc.CategoriesList.dividerIndex;
		return dividerIdx != undefined && iSelectedCategory < dividerIdx;
	}

	function onQuantityMenuSelect(event: Object): Void
	{
		if (iEquipHand != undefined) {
			GameDelegate.call("EquipItem", [iEquipHand, event.amount]);
			iEquipHand = undefined;
			return;
		}
		if (InventoryLists_mc.ItemsList.selectedEntry.enabled) {
			GameDelegate.call("ItemTransfer", [event.amount, isViewingContainer()]);
			return;
		}
		GameDelegate.call("DisabledItemSelect", []);
	}

	function AttemptEquip(aiSlot: Number, abCheckOverList: Boolean): Void
	{
		var bCheckOverList: Boolean = abCheckOverList == undefined ? true : abCheckOverList;
		if (ShouldProcessItemsListInput(bCheckOverList)) {
			if (iPlatform == 0) {
				if (!isViewingContainer() || bShowEquipButtonHelp) {
					StartItemEquip(aiSlot);
				} else {
					StartItemTransfer();
				}
				return;
			}
			StartItemEquip(aiSlot);
		}
	}

	function onItemSelect(event: Object): Void
	{
		if (event.keyboardOrMouse != 0) {
			if (!isViewingContainer()) {
				StartItemEquip(ContainerMenu.NULL_HAND);
				return;
			}
			StartItemTransfer();
		}
	}

	function StartItemTransfer(): Void
	{
		if (ItemCard_mc.itemInfo.weight == 0 && isViewingContainer()) {
			onQuantityMenuSelect({amount: InventoryLists_mc.ItemsList.selectedEntry.count});
			return;
		}
		if (InventoryLists_mc.ItemsList.selectedEntry.count <= InventoryDefines.QUANTITY_MENU_COUNT_LIMIT) {
			onQuantityMenuSelect({amount: 1});
			return;
		}
		ItemCard_mc.ShowQuantityMenu(InventoryLists_mc.ItemsList.selectedEntry.count);
	}

	function StartItemEquip(aiEquipHand: Number): Void
	{
		if (isViewingContainer()) {
			iEquipHand = aiEquipHand;
			StartItemTransfer();
			return;
		}
		GameDelegate.call("EquipItem", [aiEquipHand]);
	}

	function onItemCardSubMenuAction(event: Object): Void
	{
		super.onItemCardSubMenuAction(event);
		if (event.menu == "quantity") {
			GameDelegate.call("QuantitySliderOpen", [event.opening]);
		}
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		super.SetPlatform(aiPlatform, abPS3Switch);
		iPlatform = aiPlatform;
		bShowEquipButtonHelp = aiPlatform != 0;
		updateButtons();
	}

}
