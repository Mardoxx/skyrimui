import gfx.io.GameDelegate;
import gfx.events.EventDispatcher;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.CrossPlatformButtons;

class RaceSexPanels extends MovieClip
{
	static var RACE_CATEGORY: Number = 0;
	static var BODY_CATEGORY: Number = 1;
	static var HEAD_CATEGORY: Number = 2;
	static var UpdateInterval: Number = -1;
	
	var BackButton: CrossPlatformButtons;
	var DoneButton: CrossPlatformButtons;
	var Mode: Number;
	var NAME_ENTRY: Number;
	var NameEntryInstance: MovieClip;
	var PANEL_ONE: Number;
	var PANEL_TWO_NARROW: Number;
	var PANEL_TWO_WIDE: Number;
	var PanelTwoNarrowInstance: MovieClip;
	var PanelTwoWideInstance: MovieClip;
	var PlayerName: TextField;
	var PlayerRace: TextField;
	var RaceDescriptionInstance: MovieClip;
	var _CategoriesList: MovieClip;
	var _SubList1: MovieClip;
	var _SubList2: MovieClip;
	var _TextEntryField: MovieClip;
	var bLimitedMenu: Boolean;
	var bShowTextEntry: Boolean;
	var iPlatform: Number;

	function RaceSexPanels()
	{
		super();
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		_CategoriesList = _parent.CagetoryLockBaseInstance.CategoryInstance.List_mc;
		_SubList1 = PanelTwoNarrowInstance.List_mc;
		_SubList2 = PanelTwoWideInstance.List_mc;
		_TextEntryField = NameEntryInstance;
		BackButton = _root.RaceSexMenuBaseInstance.BottomBarInstance.ButtonsInstance.BackInstance;
		BackButton._alpha = 0;
		DoneButton = _root.RaceSexMenuBaseInstance.BottomBarInstance.ButtonsInstance.XButtonInstance;
		PlayerName = _root.RaceSexMenuBaseInstance.BottomBarInstance.PlayerInfo_mc.PlayerName;
		PlayerName.textAutoSize = "shrink";
		PlayerRace = _root.RaceSexMenuBaseInstance.BottomBarInstance.PlayerInfo_mc.PlayerRace;
		_TextEntryField._alpha = 0;
		_TextEntryField._x = -2500;
		GameDelegate.addCallBack("SetCategoriesList", this, "SetCategoriesList");
		GameDelegate.addCallBack("ShowTextEntry", this, "ShowTextEntry");
		GameDelegate.addCallBack("SetNameText", this, "SetNameText");
		GameDelegate.addCallBack("SetRaceText", this, "SetRaceText");
		GameDelegate.addCallBack("SetRaceList", this, "SetRaceList");
		GameDelegate.addCallBack("SetOptionSliders", this, "SetSliders");
		GameDelegate.addCallBack("ShowTextEntryField", this, "ShowTextEntryField");
		GameDelegate.addCallBack("moveCategoriesUp", this, "moveCategoriesUp");
		GameDelegate.addCallBack("HideLoadingIcon", this, "HideLoadingIcon");
		GameDelegate.addCallBack("FadeOut", this, "FadeOut");
		EventDispatcher.initialize(this);
		FocusHandler.instance.setFocus(_CategoriesList, 0);
		NAME_ENTRY = 0;
		gotoAndStop("1st stop on position");
		PANEL_ONE = _currentframe;
		gotoAndStop("NarrowPanelIn");
		PANEL_TWO_NARROW = _currentframe;
		gotoAndStop("WidePanelIn");
		PANEL_TWO_WIDE = _currentframe;
		Mode = PANEL_TWO_NARROW;
		_root.RaceSexMenuBaseInstance.LoadingIconInstance._visible = false;
	}

	function InitExtensions(): Void
	{
		_root.RaceSexMenuBaseInstance.RaceSexPanelsInstance.Lock("L");
		_root.RaceSexMenuBaseInstance.BottomBarInstance.Lock("B");
		_root.RaceSexMenuBaseInstance.BottomBarInstance.ButtonsInstance.Lock("L");
		_root.RaceSexMenuBaseInstance.BottomBarInstance.PlayerInfo_mc.Lock("R");
		_root.RaceSexMenuBaseInstance.CagetoryLockBaseInstance.Lock("T");
		_TextEntryField.SetupButtons();
		_TextEntryField.TextInputInstance.maxChars = 26;
	}

	static function CallCode(callBack: String, sliderValue: Number, sliderID: Number): Void
	{
		clearInterval(RaceSexPanels.UpdateInterval);
		RaceSexPanels.UpdateInterval = -1;
		GameDelegate.call(callBack, [sliderValue, sliderID]);
	}

	static function PrepForCallCode(callBack: String, sliderValue: Number, sliderID: Number): Void
	{
		clearInterval(RaceSexPanels.UpdateInterval);
		RaceSexPanels.UpdateInterval = -1;
		_root.RaceSexMenuBaseInstance.LoadingIconInstance._visible = true;
		RaceSexPanels.UpdateInterval = setInterval(RaceSexPanels.CallCode, 30, callBack, sliderValue, sliderID);
	}

	function HideLoadingIcon(): Void
	{
		_root.RaceSexMenuBaseInstance.LoadingIconInstance._visible = false;
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		iPlatform = aiPlatform;
		_TextEntryField.SetPlatform(aiPlatform, abPS3Switch);
		_root.RaceSexMenuBaseInstance.BottomBarInstance.ButtonsInstance.XButtonInstance.SetPlatform(aiPlatform, abPS3Switch);
		_root.RaceSexMenuBaseInstance.BottomBarInstance.ButtonsInstance.BackInstance.SetPlatform(aiPlatform, abPS3Switch);
		_root.RaceSexMenuBaseInstance.CagetoryLockBaseInstance.CategoryInstance.ButtonHintRightInstance.SetPlatform(aiPlatform, abPS3Switch);
		_root.RaceSexMenuBaseInstance.CagetoryLockBaseInstance.CategoryInstance.ButtonHintRightInstance.label = "";
		_root.RaceSexMenuBaseInstance.CagetoryLockBaseInstance.CategoryInstance.ButtonHintLeftInstance.SetPlatform(aiPlatform, abPS3Switch);
		_root.RaceSexMenuBaseInstance.CagetoryLockBaseInstance.CategoryInstance.ButtonHintLeftInstance.label = "";
	}

	function ShowTextEntry(abShowTextEntry: Boolean): Void
	{
		bShowTextEntry = abShowTextEntry;
	}

	function SetNameText(astrPlayerName: String): Void
	{
		PlayerName.SetText(astrPlayerName);
	}

	function SetRaceText(astrPlayerRace: String): Void
	{
		PlayerRace.SetText(astrPlayerRace);
	}

	function onLoad(): Void
	{
		_CategoriesList.addEventListener("listMovedUp", this, "onFiltersListMoveUp");
		_CategoriesList.addEventListener("listMovedDown", this, "onFiltersListMoveDown");
		_CategoriesList.addEventListener("itemPress", this, "onItemSelect");
		_parent.LeftClickInstance.addEventListener("click", this, "moveCategoriesDown");
		_parent.RightClickInstance.addEventListener("click", this, "moveCategoriesUp");
		_SubList1.addEventListener("listMovedUp", this, "onNarrowListMoveUp");
		_SubList1.addEventListener("listMovedDown", this, "onNarrowListMoveDown");
		_SubList1.addEventListener("itemPress", this, "onRaceSelect");
		_SubList2.addEventListener("listMovedUp", this, "onWideListMoveUp");
		_SubList2.addEventListener("listMovedDown", this, "onWideListMoveDown");
		_TextEntryField.addEventListener("nameChange", this, "onNameChange");
		DoneButton.addEventListener("click", this, "onDoneClicked");
	}

	function onDoneClicked(): Void
	{
		GameDelegate.call("ConfirmDone", []);
	}

	function SetCategoriesList(): Void
	{
		var CAT_TEXT: Number = 0;
		var CAT_FLAG: Number = 1;
		var CAT_STRIDE: Number = 2;
		_CategoriesList.entryList.splice(0, _CategoriesList.entryList.length);
		
		for (var i: Number = 0; i < arguments.length; i += CAT_STRIDE) {
			var entryObject: Object = {text: arguments[i + CAT_TEXT], flag: arguments[i + CAT_FLAG], savedItemIndex: -1};
			_CategoriesList.entryList.push(entryObject);
		}
		
		if (bLimitedMenu) {
			_CategoriesList.selectedIndex = RaceSexPanels.BODY_CATEGORY;
		}
		_CategoriesList.UpdateList();
	}

	function SetRaceList(): Void
	{
		var RACE_NAME: Number = 0;
		var RACE_DESCRIPTION: Number = 1;
		var RACE_EQUIPSTATE: Number = 2;
		var RACE_STRIDE: Number = 3;
		_SubList1.entryList.splice(0, _SubList1.entryList.length);
		
		for (var i: Number = 0; i < arguments.length; i += RACE_STRIDE) {
			var entryObject: Object = {text: arguments[i + RACE_NAME], flag: bLimitedMenu ? RaceSexPanels.BODY_CATEGORY : RaceSexPanels.RACE_CATEGORY, raceDescription: arguments[i + RACE_DESCRIPTION].length <= 0 ? "No race description for " + arguments[i + RACE_NAME] : arguments[i + RACE_DESCRIPTION], equipState: arguments[i + RACE_EQUIPSTATE]};
			if (entryObject.equipState > 0) {
				_CategoriesList.entryList[entryObject.flag].savedItemIndex = i / RACE_STRIDE;
				SetRaceText(entryObject.text);
			}
			_SubList1.entryList.push(entryObject);
		}
		
		_SubList1.UpdateList();
		if (bLimitedMenu) {
			_CategoriesList.selectedIndex = RaceSexPanels.BODY_CATEGORY;
		} else {
			_CategoriesList.selectedIndex = RaceSexPanels.RACE_CATEGORY;
		}
		ShowItemsList();
	}

	function SetSliders(): Void
	{
		var SLIDER_NAME = 0;
		var SLIDER_FILTERFLAG = 1;
		var SLIDER_CALLBACKNAME = 2;
		var SLIDER_MIN = 3;
		var SLIDER_MAX = 4;
		var SLIDER_POSITION = 5;
		var SLIDER_INTERVAL = 6;
		var SLIDER_ID = 7;
		var SLIDER_STRIDE = 8;
		
		_SubList2.entryList.splice(0, _SubList2.entryList.length);
		
		for (var i: Number = 0; i < arguments.length; i += SLIDER_STRIDE) {
			var entryObject: Object = {text: arguments[i + SLIDER_NAME], filterFlag: arguments[i + SLIDER_FILTERFLAG], callbackName: arguments[i + SLIDER_CALLBACKNAME], sliderMin: arguments[i + SLIDER_MIN], sliderMax: arguments[i + SLIDER_MAX], sliderID: arguments[i + SLIDER_ID], position: arguments[i + SLIDER_POSITION], interval: arguments[i + SLIDER_INTERVAL]};
			_SubList2.entryList.push(entryObject);
		}
		_SubList2.UpdateList();
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var handledInput: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.ENTER && Mode == NAME_ENTRY) {
				_TextEntryField.onAccept();
			} else if (details.navEquivalent == NavigationCode.TAB && Mode == NAME_ENTRY) {
				_TextEntryField.onCancel();
				GameDelegate.call("ChangeName", []);
				handledInput = true;
				if (_CategoriesList.selectedIndex == RaceSexPanels.RACE_CATEGORY) {
					FocusHandler.instance.setFocus(_SubList1, 0);
				} else {
					FocusHandler.instance.setFocus(_SubList2, 0);
				}
			} else if (iPlatform != 0) {
				if (details.navEquivalent == NavigationCode.GAMEPAD_R2 && RaceSexPanels.UpdateInterval == -1) {
					moveCategoriesUp();
				} else if (details.navEquivalent == NavigationCode.GAMEPAD_L2 && RaceSexPanels.UpdateInterval == -1) {
					moveCategoriesDown();
				}
			}
		}
		if (!handledInput && (RaceSexPanels.UpdateInterval == -1 || _CategoriesList.selectedIndex == RaceSexPanels.RACE_CATEGORY)) {
			pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		return true;
	}

	function moveCategoriesUp(): Void
	{
		switch (_CategoriesList.selectedIndex) {
			case RaceSexPanels.RACE_CATEGORY:
				_CategoriesList.selectedEntry.savedItemIndex = _SubList1.selectedIndex;
				break;
			default:
				_CategoriesList.selectedEntry.savedItemIndex = _SubList2.selectedIndex;
		}
		
		_CategoriesList.moveListUp();
	}

	function moveCategoriesDown(): Void
	{
		switch (_CategoriesList.selectedIndex) {
			case RaceSexPanels.RACE_CATEGORY:
				_CategoriesList.selectedEntry.savedItemIndex = _SubList1.selectedIndex;
				break;
			default:
				_CategoriesList.selectedEntry.savedItemIndex = _SubList2.selectedIndex;
		}
		
		if (bLimitedMenu != true || _CategoriesList.selectedIndex > RaceSexPanels.BODY_CATEGORY) {
			_CategoriesList.moveListDown();
		}
	}

	function onFiltersListMoveUp(): Void
	{
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		_CategoriesList._parent.gotoAndPlay("moveLeft");
		if (_CategoriesList.selectedIndex == RaceSexPanels.HEAD_CATEGORY) 
		{
			GameDelegate.call("ZoomPC", [true]);
		}
		else if (_CategoriesList.selectedIndex == RaceSexPanels.BODY_CATEGORY) 
		{
			GameDelegate.call("ZoomPC", [false]);
		}
		ShowItemsList();
	}

	function onFiltersListMoveDown(event: Object): Void
	{
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		_CategoriesList._parent.gotoAndPlay("moveRight");
		if (_CategoriesList.selectedIndex == RaceSexPanels.BODY_CATEGORY) {
			GameDelegate.call("ZoomPC", [false]);
		} else if (_CategoriesList.selectedIndex == RaceSexPanels.RACE_CATEGORY) {
			GameDelegate.call("ZoomPC", [true]);
		}
		ShowItemsList();
	}

	function ShowTextEntryField(): Void
	{
		if (bShowTextEntry) {
			_TextEntryField.TextInputInstance.text = "";
			_TextEntryField.TextInputInstance.focused = true;
			FadeTextEntry(true);
			GameDelegate.call("SetAllowTextInput", []);
			return;
		}
		GameDelegate.call("ShowVirtualKeyboard", []);
	}

	function onItemSelect(event: Object): Void
	{
		if (_currentframe == PANEL_ONE) {
			ShowItemsList();
		}
	}

	function onNarrowListMoveUp(): Void
	{
		if (_CategoriesList.selectedIndex == RaceSexPanels.RACE_CATEGORY) {
			GameDelegate.call("PlaySound", ["UIMenuFocus"]);
			_SubList1._parent.gotoAndPlay("moveUp");
			RaceDescriptionInstance.RaceTextInstance.SetText(_SubList1.entryList[_SubList1.selectedIndex].raceDescription);
			if (RaceSexPanels.UpdateInterval >= 0) {
				clearInterval(RaceSexPanels.UpdateInterval);
				RaceSexPanels.UpdateInterval = -1;
				_root.RaceSexMenuBaseInstance.LoadingIconInstance._visible = false;
			}
			RaceSexPanels.UpdateInterval = setInterval(RaceSexPanels.PrepForCallCode, 600, "ChangeRace", _SubList1.selectedIndex, _SubList1.entryList[_SubList1.selectedIndex].sliderID);
		}
	}

	function onNarrowListMoveDown(event: Object): Void
	{
		if (_CategoriesList.selectedIndex == RaceSexPanels.RACE_CATEGORY) {
			GameDelegate.call("PlaySound", ["UIMenuFocus"]);
			_SubList1._parent.gotoAndPlay("moveDown");
			RaceDescriptionInstance.RaceTextInstance.SetText(_SubList1.entryList[_SubList1.selectedIndex].raceDescription);
			if (RaceSexPanels.UpdateInterval >= 0) {
				clearInterval(RaceSexPanels.UpdateInterval);
				RaceSexPanels.UpdateInterval = -1;
				_root.RaceSexMenuBaseInstance.LoadingIconInstance._visible = false;
			}
			RaceSexPanels.UpdateInterval = setInterval(RaceSexPanels.PrepForCallCode, 600, "ChangeRace", _SubList1.selectedIndex, _SubList1.entryList[_SubList1.selectedIndex].sliderID);
		}
	}

	function onWideListMoveUp(): Void
	{
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (RaceSexPanels.UpdateInterval >= 0) {
			_SubList2._parent.gotoAndPlay("moveUp");
		}
	}

	function onWideListMoveDown(event: Object): Void
	{
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (RaceSexPanels.UpdateInterval >= 0) {
			_SubList2._parent.gotoAndPlay("moveDown");
		}
	}

	function onNameChange(event: Object): Void
	{
		if (event.nameChanged == true) {
			GameDelegate.call("ChangeName", [_TextEntryField.TextInputInstance.text]);
		}
		if (_CategoriesList.selectedIndex == RaceSexPanels.RACE_CATEGORY) {
			FocusHandler.instance.setFocus(_SubList1, 0);
		} else {
			FocusHandler.instance.setFocus(_SubList2, 0);
		}
		FadeTextEntry(false);
	}

	function FadeTextEntry(bIn: Boolean): Void
	{
		Mode = bIn ? NAME_ENTRY : PANEL_ONE;
		if (bIn) {
			_TextEntryField._x = 500;
		}
		_TextEntryField.onEnterFrame = function ()
		{
			_alpha = _alpha + (bIn ? 10 : -10);
			if (bIn ? _alpha >= 100 : _alpha <= 0) {
				if (!bIn) {
					if (_TextEntryField.TextInputInstance.text == undefined) {
						GameDelegate.call("ChangeName", []);
					} else {
						GameDelegate.call("ChangeName", [_TextEntryField.TextInputInstance.text]);
					}
				}
				delete onEnterFrame;
				if (bIn) {
					return;
				}
				_TextEntryField.TextInputInstance._x = -2500;
			}
		};
	}

	function ShowItemsList(): Void
	{
		switch (_CategoriesList.selectedIndex) {
			case RaceSexPanels.RACE_CATEGORY:
				gotoAndPlay("narrowPanel2Show");
				FadeTextEntry(false);
				FocusHandler.instance.setFocus(_SubList1, 0);
				_SubList1.selectedIndex = _CategoriesList.selectedEntry.savedItemIndex;
				_SubList1.UpdateList();
				RaceDescriptionInstance.RaceTextInstance.SetText(_SubList1.entryList[_SubList1.selectedIndex].raceDescription);
				break;
			default:
				gotoAndPlay("widePanel2Show");
				FadeTextEntry(false);
				FocusHandler.instance.setFocus(_SubList2, 0);
				_SubList2.itemFilter = _CategoriesList.selectedEntry.flag;
				_SubList2.selectedIndex = _CategoriesList.selectedEntry.savedItemIndex;
				_SubList2.UpdateList();
		}
		
		GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
	}

	function HideItemsList(): Void
	{
		switch (_CategoriesList.selectedIndex) {
			case RaceSexPanels.RACE_CATEGORY:
				gotoAndPlay("narrowPanel2Hide");
				FocusHandler.instance.setFocus(_CategoriesList, 0);
				_CategoriesList.selectedEntry.savedItemIndex = _SubList1.selectedIndex;
				break;
			default:
				gotoAndPlay("widePanel2Hide");
				FocusHandler.instance.setFocus(_CategoriesList, 0);
				_CategoriesList.selectedEntry.savedItemIndex = _SubList2.selectedIndex;
				BackButton._alpha = 0;
		}
		
		GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
	}

	function FadeOut(): Void
	{
		_root.gotoAndPlay(2);
	}

}
