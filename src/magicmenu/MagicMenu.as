import gfx.io.GameDelegate;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;

class MagicMenu extends ItemMenu
{
	var bPCControlsReady: Boolean = true;
	var BottomBar_mc: MovieClip;
	var ExitMenuRect: MovieClip;
	var InventoryLists_mc: MovieClip;
	var ItemCard_mc: MovieClip;
	var ItemsListInputCatcher: MovieClip;
	var MagicButtonArt: Array;
	var RestoreCategoryRect: MovieClip;
	var bFadedIn: Boolean;
	var bMenuClosing: Boolean;
	var iHideButtonFlag: Number;

	function MagicMenu()
	{
		super();
		bMenuClosing = false;
		iHideButtonFlag = 0;
	}

	function InitExtensions(): Void
	{
		super.InitExtensions();
		GameDelegate.addCallBack("DragonSoulSpent", this, "DragonSoulSpent");
		GameDelegate.addCallBack("AttemptEquip", this, "AttemptEquip");
		BottomBar_mc.UpdatePerItemInfo({type: InventoryDefines.ICT_SPELL_DEFAULT});
		MagicButtonArt = [{PCArt: "M1M2", XBoxArt: "360_LTRT", PS3Art: "PS3_LBRB"}, {PCArt: "F", XBoxArt: "360_Y", PS3Art: "PS3_Y"}, {PCArt: "R", XBoxArt: "360_X", PS3Art: "PS3_X"}, {PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}];
		BottomBar_mc.SetButtonsArt(MagicButtonArt);
	}

	function PositionElements(): Void
	{
		super.PositionElements();
		MovieClip(InventoryLists_mc).Lock("R");
		InventoryLists_mc._x = InventoryLists_mc._x + 20;
		var xOffset: Number = Stage.visibleRect.x + Stage.safeRect.x;
		ItemCard_mc._parent._x = (xOffset + InventoryLists_mc._x - InventoryLists_mc._width) / 2 - ItemCard_mc._parent._width / 2 + 25;
		MovieClip(ExitMenuRect).Lock("TR");
		ExitMenuRect._y = ExitMenuRect._y - Stage.safeRect.y;
		RestoreCategoryRect._x = ExitMenuRect._x - InventoryLists_mc.CategoriesList._parent._width;
		MovieClip(ItemsListInputCatcher).Lock("L");
		ItemsListInputCatcher._x = ItemsListInputCatcher._x - Stage.safeRect.x;
		ItemsListInputCatcher._width = RestoreCategoryRect._x - Stage.visibleRect.x + 10;
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (bFadedIn && !pathToFocus[0].handleInput(details, pathToFocus.slice(1))) {
			if (GlobalFunc.IsKeyPressed(details)) {
				if (InventoryLists_mc.currentState == InventoryLists.ONE_PANEL && details.navEquivalent == NavigationCode.RIGHT) {
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
			UpdateButtonText();
		}
	}

	function onItemHighlightChange(event: Object): Void
	{
		super.onItemHighlightChange(event);
		if (event.index != -1) {
			UpdateButtonText();
		}
	}

	function DragonSoulSpent(): Void
	{
		ItemCard_mc.itemInfo.soulSpent = true;
		UpdateButtonText();
	}

	function get hideButtonFlag(): Number
	{
		return iHideButtonFlag;
	}

	function set hideButtonFlag(aiHideFlag: Number): Void
	{
		iHideButtonFlag = aiHideFlag;
	}

	function UpdateButtonText(): Void
	{
		if (InventoryLists_mc.ItemsList.selectedEntry != undefined) {
			var favoriteStr: String = (InventoryLists_mc.ItemsList.selectedEntry.filterFlag & InventoryLists_mc.CategoriesList.entryList[0].flag) == 0 ? "$Favorite" : "$Unfavorite";
			var unlockStr: String = ItemCard_mc.itemInfo.showUnlocked == true ? "$Unlock" : "";
			if ((InventoryLists_mc.ItemsList.selectedEntry.filterFlag & iHideButtonFlag) != 0) {
				BottomBar_mc.HideButtons();
				return;
			}
			BottomBar_mc.SetButtonsText("$Equip", favoriteStr, unlockStr);
		}
	}

	function onHideItemsList(event: Object): Void
	{
		super.onHideItemsList(event);
		BottomBar_mc.UpdatePerItemInfo({type: InventoryDefines.ICT_SPELL_DEFAULT});
	}

	function AttemptEquip(aiSlot: Number): Void
	{
		if (ShouldProcessItemsListInput(true)) {
			GameDelegate.call("ItemSelect", [aiSlot]);
		}
	}

	function onItemSelect(event: Object): Void
	{
		if (event.entry.enabled) {
			if (event.keyboardOrMouse != 0) {
				GameDelegate.call("ItemSelect", []);
			}
			return;
		}
		GameDelegate.call("ShowShoutFail", []);
	}

}
