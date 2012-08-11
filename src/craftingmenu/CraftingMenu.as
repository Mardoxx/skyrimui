import gfx.managers.FocusHandler;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;

class CraftingMenu extends MovieClip
{
	static var MT_SINGLE_PANEL: Number = 0;
	static var MT_DOUBLE_PANEL: Number = 1;
	static var LIST_OFFSET: Number = 20;
	static var SELECT_BUTTON: Number = 0;
	static var EXIT_BUTTON: Number = 1;
	static var AUX_BUTTON: Number = 2;
	static var CRAFT_BUTTON: Number = 3;
	
	var AdditionalDescription;
	var AdditionalDescriptionHolder;
	var BottomBarInfo;
	var ButtonText;
	var CategoryList;
	var ExitMenuRect;
	var InventoryLists;
	var ItemInfo;
	var ItemInfoHolder;
	var ItemList;
	var ItemListTweener;
	var ItemsListInputCatcher;
	var MenuDescription;
	var MenuDescriptionHolder;
	var MenuName;
	var MenuNameHolder;
	var MenuType;
	var MouseRotationRect;
	var Platform;
	var RestoreCategoryRect;
	var SavedCategoryCenterText;
	var SavedCategoryScrollRatio;
	var SavedCategorySelectedText;
	var _bCanCraft;
	var _bCanFadeItemInfo;
	var _bItemCardAdditionalDescription;
	var bCanExpandPanel;
	var bHideAdditionalDescription;

	function CraftingMenu()
	{
		super();
		_bCanCraft = false;
		bCanExpandPanel = true;
		_bCanFadeItemInfo = true;
		bHideAdditionalDescription = false;
		_bItemCardAdditionalDescription = false;
		ButtonText = new Array("", "", "", "");
		Platform = 0;
		CategoryList = InventoryLists;
		ItemInfo = ItemInfoHolder.ItemInfo;
		Mouse.addListener(this);
	}

	function Initialize(): Void
	{
		ItemInfoHolder = ItemInfoHolder;
		ItemInfoHolder.gotoAndStop("default");
		ItemInfo.addEventListener("endEditItemName", this, "OnEndEditItemName");
		ItemInfo.addEventListener("subMenuAction", this, "OnSubMenuAction");
		BottomBarInfo = BottomBarInfo;
		AdditionalDescriptionHolder = ItemInfoHolder.AdditionalDescriptionHolder;
		AdditionalDescription = AdditionalDescriptionHolder.AdditionalDescription;
		AdditionalDescription.textAutoSize = "shrink";
		MenuName = CategoryList.CategoriesList._parent.CategoryLabel;
		MenuName.autoSize = "left";
		MenuNameHolder._visible = false;
		MenuDescription = MenuDescriptionHolder.MenuDescription;
		MenuDescription.autoSize = "center";
		BottomBarInfo.SetButtonsArt([{PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"}, {PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"}, {PCArt: "F", XBoxArt: "360_Y", PS3Art: "PS3_Y"}, {PCArt: "R", XBoxArt: "360_X", PS3Art: "PS3_X"}]);
		if (ItemListTweener == undefined) {
			if (CategoryList != undefined) {
				MenuType = CraftingMenu.MT_DOUBLE_PANEL;
				FocusHandler.instance.setFocus(CategoryList, 0);
				CategoryList.ShowCategoriesList();
				CategoryList.addEventListener("itemHighlightChange", this, "OnItemHighlightChange");
				CategoryList.addEventListener("showItemsList", this, "OnShowItemsList");
				CategoryList.addEventListener("hideItemsList", this, "OnHideItemsList");
				CategoryList.addEventListener("categoryChange", this, "OnCategoryListChange");
				ItemList = CategoryList.ItemsList;
				ItemList.addEventListener("itemPress", this, "OnItemSelect");
			}
		} else {
			MenuType = CraftingMenu.MT_SINGLE_PANEL;
			ItemList = ItemListTweener.List_mc;
			ItemListTweener.gotoAndPlay("showList");
			FocusHandler.instance.setFocus(ItemList, 0);
			ItemList.addEventListener("listMovedUp", this, "OnItemListMovedUp");
			ItemList.addEventListener("listMovedDown", this, "OnItemListMovedDown");
			ItemList.addEventListener("itemPress", this, "OnItemListPressed");
		}
		BottomBarInfo["Button" + CraftingMenu.CRAFT_BUTTON].addEventListener("press", this, "onCraftButtonPress");
		BottomBarInfo["Button" + CraftingMenu.EXIT_BUTTON].addEventListener("click", this, "onExitButtonPress");
		BottomBarInfo["Button" + CraftingMenu.EXIT_BUTTON].disabled = false;
		BottomBarInfo["Button" + CraftingMenu.AUX_BUTTON].addEventListener("click", this, "onAuxButtonPress");
		BottomBarInfo["Button" + CraftingMenu.AUX_BUTTON].disabled = false;
		ItemsListInputCatcher.onMouseDown = function ()
		{
			if (Mouse.getTopMostEntity() == this) {
				_parent.onItemsListInputCatcherClick();
			}
		};
		RestoreCategoryRect.onRollOver = function ()
		{
			if (_parent.CategoryList.currentState == InventoryLists.TWO_PANELS) {
				_parent.CategoryList.RestoreCategoryIndex();
			}
		};
		ExitMenuRect.onPress = function ()
		{
			GameDelegate.call("CloseMenu", []);
		};
		bCanCraft = false;
		PositionElements();
		SetPlatform(Platform);
	}

	function get bCanCraft(): Boolean
	{
		return _bCanCraft;
	}

	function set bCanCraft(abCanCraft: Boolean): Void
	{
		_bCanCraft = abCanCraft;
		UpdateButtonText();
	}

	function onCraftButtonPress()
	{
		if (bCanCraft) 
		{
			GameDelegate.call("CraftButtonPress", []);
		}
	}

	function onExitButtonPress()
	{
		GameDelegate.call("CloseMenu", []);
	}

	function onAuxButtonPress()
	{
		GameDelegate.call("AuxButtonPress", []);
	}

	function get bCanFadeItemInfo()
	{
		GameDelegate.call("CanFadeItemInfo", [], this, "SetCanFadeItemInfo");
		return _bCanFadeItemInfo;
	}

	function SetCanFadeItemInfo(abCanFade)
	{
		_bCanFadeItemInfo = abCanFade;
	}

	function get bItemCardAdditionalDescription()
	{
		return _bItemCardAdditionalDescription;
	}

	function set bItemCardAdditionalDescription(abItemCardDesc)
	{
		_bItemCardAdditionalDescription = abItemCardDesc;
		if (abItemCardDesc) 
		{
			AdditionalDescription.text = "";
		}
	}

	function SetPartitionedFilterMode(abPartitioned)
	{
		CategoryList.ItemsList.filterer.SetPartitionedFilterMode(abPartitioned);
	}

	function GetItemShown()
	{
		return ItemList.selectedIndex >= 0 && (CategoryList == undefined || CategoryList.currentState == InventoryLists.TWO_PANELS || CategoryList.currentState == InventoryLists.TRANSITIONING_TO_TWO_PANELS);
	}

	function GetNumCategories()
	{
		return CategoryList != undefined && CategoryList.CategoriesList != undefined ? CategoryList.CategoriesList.entryList.length : 0;
	}

	function onMouseUp()
	{
		if (ItemInfo.bEditNameMode && !ItemInfo.hitTest(_root._xmouse, _root._ymouse)) 
		{
			OnEndEditItemName({useNewName: false, newName: ""});
		}
	}

	function onMouseWheel(delta)
	{
		if (CategoryList.currentState == InventoryLists.TWO_PANELS && !ItemList.disableSelection && !ItemList.disableInput) 
		{
			var __reg2 = Mouse.getTopMostEntity();
			for (;;) 
			{
				if (!(__reg2 && __reg2 != undefined)) 
				{
					return;
				}
				if (__reg2 == ItemsListInputCatcher || __reg2 == MouseRotationRect) 
				{
					if (delta == 1) 
					{
						ItemList.moveSelectionUp();
					}
					else if (delta == -1) 
					{
						ItemList.moveSelectionDown();
					}
				}
				__reg2 = __reg2._parent;
			}
		}
	}

	function onMouseRotationStart()
	{
		GameDelegate.call("StartMouseRotation", []);
		CategoryList.CategoriesList.disableSelection = true;
		ItemList.disableSelection = true;
	}

	function onMouseRotationStop()
	{
		GameDelegate.call("StopMouseRotation", []);
		CategoryList.CategoriesList.disableSelection = false;
		ItemList.disableSelection = false;
	}

	function onItemsListInputCatcherClick()
	{
		if (CategoryList.currentState == InventoryLists.TWO_PANELS && !ItemList.disableSelection && !ItemList.disableInput) 
		{
			OnItemSelect({index: ItemList.selectedIndex});
		}
	}

	function onMouseRotationFastClick(aiMouseButton)
	{
		if (aiMouseButton == 0) 
		{
			onItemsListInputCatcherClick();
		}
	}

	function UpdateButtonText()
	{
		var __reg2 = ButtonText.concat();
		if (!bCanCraft) 
		{
			__reg2[CraftingMenu.CRAFT_BUTTON] = "";
		}
		if (!GetItemShown()) 
		{
			__reg2[CraftingMenu.SELECT_BUTTON] = "";
		}
		BottomBarInfo.SetButtonsText.apply(BottomBarInfo, __reg2);
	}

	function UpdateItemList(abFullRebuild)
	{
		if (abFullRebuild == true) 
		{
			CategoryList.InvalidateListData();
		}
		else 
		{
			ItemList.UpdateList();
		}
		if (MenuType == CraftingMenu.MT_SINGLE_PANEL) 
		{
			FadeInfoCard(ItemList.entryList.length == 0);
		}
	}

	function UpdateItemDisplay()
	{
		var __reg2 = GetItemShown();
		FadeInfoCard(!__reg2);
		SetSelectedItem(ItemList.selectedIndex);
		GameDelegate.call("ShowItem3D", [__reg2]);
	}

	function FadeInfoCard(abFadeOut)
	{
		if (abFadeOut && bCanFadeItemInfo) 
		{
			ItemInfo.FadeOutCard();
			if (bHideAdditionalDescription) 
			{
				AdditionalDescriptionHolder._visible = false;
			}
			return;
		}
		if (abFadeOut) 
		{
			return;
		}
		ItemInfo.FadeInCard();
		if (bHideAdditionalDescription) 
		{
			AdditionalDescriptionHolder._visible = true;
		}
	}

	function PositionElements()
	{
		GlobalFunc.SetLockFunction();
		if (MenuType == CraftingMenu.MT_SINGLE_PANEL) 
		{
			ItemListTweener.Lock("L");
			ItemListTweener._x = ItemListTweener._x - CraftingMenu.LIST_OFFSET;
		}
		else if (MenuType == CraftingMenu.MT_DOUBLE_PANEL) 
		{
			MovieClip(CategoryList).Lock("L");
			CategoryList._x = CategoryList._x - CraftingMenu.LIST_OFFSET;
		}
		MenuNameHolder.Lock("L");
		MenuNameHolder._x = MenuNameHolder._x - CraftingMenu.LIST_OFFSET;
		MenuDescriptionHolder.Lock("TR");
		var __reg3 = Stage.visibleRect.x + Stage.safeRect.x;
		var __reg4 = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		BottomBarInfo.PositionElements(__reg3, __reg4);
		MovieClip(ExitMenuRect).Lock("TL");
		ExitMenuRect._x = ExitMenuRect._x - (Stage.safeRect.x + 10);
		ExitMenuRect._y = ExitMenuRect._y - Stage.safeRect.y;
		RestoreCategoryRect._x = ExitMenuRect._x + CategoryList.CategoriesList._parent._width + 25;
		ItemsListInputCatcher._x = RestoreCategoryRect._x + RestoreCategoryRect._width;
		ItemsListInputCatcher._width = _root._width - ItemsListInputCatcher._x;
		MovieClip(MouseRotationRect).Lock("T");
		MouseRotationRect._x = ItemInfo._parent._x;
		MouseRotationRect._width = ItemInfo._parent._width;
		MouseRotationRect._height = 0.55 * Stage.visibleRect.height;
	}

	function OnItemListPressed(event)
	{
		GameDelegate.call("CraftSelectedItem", [ItemList.selectedIndex]);
		GameDelegate.call("SetSelectedItem", [ItemList.selectedIndex]);
	}

	function OnItemSelect(event)
	{
		GameDelegate.call("ChooseItem", [event.index]);
		GameDelegate.call("ShowItem3D", [event.index != -1]);
		UpdateButtonText();
	}

	function OnItemHighlightChange(event)
	{
		SetSelectedItem(event.index);
		FadeInfoCard(event.index == -1);
		UpdateButtonText();
		GameDelegate.call("ShowItem3D", [event.index != -1]);
	}

	function OnShowItemsList(event)
	{
		if (Platform == 0) 
		{
			GameDelegate.call("SetSelectedCategory", [CategoryList.CategoriesList.selectedIndex]);
		}
		OnItemHighlightChange(event);
	}

	function OnHideItemsList(event)
	{
		SetSelectedItem(event.index);
		FadeInfoCard(true);
		UpdateButtonText();
		GameDelegate.call("ShowItem3D", [false]);
	}

	function OnCategoryListChange(event)
	{
		if (Platform != 0) 
		{
			GameDelegate.call("SetSelectedCategory", [event.index]);
		}
	}

	function SetSelectedItem(aSelection)
	{
		GameDelegate.call("SetSelectedItem", [aSelection]);
	}

	function handleInput(aInputEvent, aPathToFocus)
	{
		if (bCanExpandPanel && aPathToFocus.length > 0) 
		{
			aPathToFocus[0].handleInput(aInputEvent, aPathToFocus.slice(1));
		}
		else if (MenuType == CraftingMenu.MT_DOUBLE_PANEL && aPathToFocus.length > 1) 
		{
			aPathToFocus[1].handleInput(aInputEvent, aPathToFocus.slice(2));
		}
		return true;
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean)
	{
		Platform = aiPlatform;
		BottomBarInfo.SetPlatform(aiPlatform, abPS3Switch);
		ItemInfo.SetPlatform(aiPlatform, abPS3Switch);
		CategoryList.SetPlatform(aiPlatform, abPS3Switch);
	}

	function UpdateIngredients(aLineTitle, aIngredients, abShowPlayerCount)
	{
		var __reg4 = bItemCardAdditionalDescription ? ItemInfo.GetItemName() : AdditionalDescription;
		__reg4.text = aLineTitle != undefined && aLineTitle.length > 0 ? aLineTitle + ": " : "";
		var __reg11 = __reg4.getNewTextFormat();
		var __reg9 = __reg4.getNewTextFormat();
		var __reg3 = 0;
		while (__reg3 < aIngredients.length) 
		{
			var __reg2 = aIngredients[__reg3];
			__reg9.color = __reg2.PlayerCount < __reg2.RequiredCount ? 7829367 : 16777215;
			__reg4.setNewTextFormat(__reg9);
			var __reg6 = "";
			if (__reg2.RequiredCount > 1) 
			{
				__reg6 = __reg2.RequiredCount + " ";
			}
			var __reg5 = "";
			if (abShowPlayerCount && __reg2.PlayerCount >= 1) 
			{
				__reg5 = " (" + __reg2.PlayerCount + ")";
			}
			var __reg8 = __reg6 + __reg2.Name + __reg5 + (__reg3 >= aIngredients.length - 1 ? "" : ", ");
			__reg4.replaceText(__reg4.length, __reg4.length + 1, __reg8);
			++__reg3;
		}
		__reg4.setNewTextFormat(__reg11);
	}

	function EditItemName(aInitialText, aMaxChars)
	{
		ItemInfo.StartEditName(aInitialText, aMaxChars);
	}

	function OnEndEditItemName(event)
	{
		ItemInfo.EndEditName();
		GameDelegate.call("EndItemRename", [event.useNewName, event.newName]);
	}

	function ShowSlider(aiMaxValue, aiMinValue, aiCurrentValue, aiSnapInterval)
	{
		ItemInfo.ShowEnchantingSlider(aiMaxValue, aiMinValue, aiCurrentValue);
		ItemInfo.quantitySlider.snapping = true;
		ItemInfo.quantitySlider.snapInterval = aiSnapInterval;
		ItemInfo.quantitySlider.addEventListener("change", this, "OnSliderChanged");
		OnSliderChanged();
	}

	function OnSliderChanged(event)
	{
		GameDelegate.call("CalculateCharge", [ItemInfo.quantitySlider.value], this, "SetChargeValues");
	}

	function SetSliderValue(aValue)
	{
		ItemInfo.quantitySlider.value = aValue;
	}

	function OnSubMenuAction(event)
	{
		if (event.opening == true) 
		{
			ItemList.disableSelection = true;
			ItemList.disableInput = true;
			CategoryList.CategoriesList.disableSelection = true;
			CategoryList.CategoriesList.disableInput = true;
		}
		else if (event.opening == false) 
		{
			ItemList.disableSelection = false;
			ItemList.disableInput = false;
			CategoryList.CategoriesList.disableSelection = false;
			CategoryList.CategoriesList.disableInput = false;
		}
		if (event.menu == "quantity") 
		{
			if (event.opening) 
			{
				return;
			}
			GameDelegate.call("SliderClose", [!event.canceled, event.value]);
		}
	}

	function PreRebuildList()
	{
		SavedCategoryCenterText = CategoryList.CategoriesList.centeredEntry.text;
		SavedCategorySelectedText = CategoryList.CategoriesList.selectedEntry.text;
		SavedCategoryScrollRatio = CategoryList.CategoriesList.maxScrollPosition <= 0 ? 0 : CategoryList.CategoriesList.scrollPosition / CategoryList.CategoriesList.maxScrollPosition;
	}

	function PostRebuildList(abRestoreSelection)
	{
		if (abRestoreSelection) 
		{
			var __reg3 = CategoryList.CategoriesList.entryList;
			var __reg4 = -1;
			var __reg5 = -1;
			var __reg2 = 0;
			while (__reg2 < __reg3.length) 
			{
				if (SavedCategoryCenterText == __reg3[__reg2].text) 
				{
					__reg4 = __reg2;
				}
				if (SavedCategorySelectedText == __reg3[__reg2].text) 
				{
					__reg5 = __reg2;
				}
				++__reg2;
			}
			if (__reg4 == -1) 
			{
				__reg4 = Math.floor(SavedCategoryScrollRatio * __reg3.length);
			}
			__reg4 = Math.max(0, __reg4);
			CategoryList.CategoriesList.RestoreScrollPosition(__reg4, false);
			if (__reg5 != -1) 
			{
				CategoryList.CategoriesList.selectedIndex = __reg5;
			}
			CategoryList.CategoriesList.UpdateList();
			CategoryList.ItemsList.filterer.itemFilter = CategoryList.CategoriesList.selectedEntry.flag;
			CategoryList.ItemsList.UpdateList();
		}
	}

}
