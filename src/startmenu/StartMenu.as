class StartMenu extends MovieClip
{
	static var PRESS_START_STATE: String = "PressStart";
	static var MAIN_STATE: String = "Main";
	static var MAIN_CONFIRM_STATE: String = "MainConfirm";
	static var SAVE_LOAD_STATE: String = "SaveLoad";
	static var SAVE_LOAD_CONFIRM_STATE: String = "SaveLoadConfirm";
	static var DELETE_SAVE_CONFIRM_STATE: String = "DeleteSaveConfirm";
	static var DLC_STATE: String = "DLC";
	static var MARKETPLACE_CONFIRM_STATE: String = "MarketplaceConfirm";
	static var CONTINUE_INDEX: Number = 0;
	static var NEW_INDEX: Number = 1;
	static var LOAD_INDEX: Number = 2;
	static var DLC_INDEX: Number = 3;
	static var CREDITS_INDEX: Number = 4;
	static var QUIT_INDEX: Number = 5;
	
	var ButtonRect: MovieClip;
	var ConfirmPanel_mc: MovieClip;
	var DLCList_mc: MovieClip;
	var DLCPanel: MovieClip;
	var DeleteButton: Components.CrossPlatformButtons;
	var DeleteSaveButton: Components.CrossPlatformButtons;
	var LoadingContentMessage: MovieClip;
	var Logo_mc: MovieClip;
	var MainList: MovieClip;
	var MainListHolder: MovieClip;
	var MarketplaceButton: MovieClip;
	var SaveLoadConfirmText: TextField;
	var SaveLoadListHolder: MovieClip;
	var SaveLoadPanel_mc: MovieClip;
	var VersionText: TextField;
	var fadeOutParams: Array;
	var iLoadDLCContentMessageTimerID: Number;
	var iLoadDLCListTimerID: Number;
	var iPlatform: Number;
	var strCurrentState: String;
	var strFadeOutCallback: String;

	function StartMenu()
	{
		super();
		MainList = MainListHolder.List_mc;
		SaveLoadListHolder = SaveLoadPanel_mc;
		DLCList_mc = DLCPanel.DLCList;
		DeleteSaveButton = DeleteButton;
		MarketplaceButton = DLCPanel.MarketplaceButton;
	}

	function InitExtensions()
	{
		Shared.GlobalFunc.SetLockFunction();
		_parent.Lock("BR");
		Logo_mc.Lock("BL");
		Logo_mc._y = Logo_mc._y - 80;
		gfx.io.GameDelegate.addCallBack("sendMenuProperties", this, "setupMainMenu");
		gfx.io.GameDelegate.addCallBack("ConfirmNewGame", this, "ShowConfirmScreen");
		gfx.io.GameDelegate.addCallBack("ConfirmContinue", this, "ShowConfirmScreen");
		gfx.io.GameDelegate.addCallBack("FadeOutMenu", this, "DoFadeOutMenu");
		gfx.io.GameDelegate.addCallBack("FadeInMenu", this, "DoFadeInMenu");
		gfx.io.GameDelegate.addCallBack("onProfileChange", this, "onProfileChange");
		gfx.io.GameDelegate.addCallBack("StartLoadingDLC", this, "StartLoadingDLC");
		gfx.io.GameDelegate.addCallBack("DoneLoadingDLC", this, "DoneLoadingDLC");
		MainList.addEventListener("itemPress", this, "onMainButtonPress");
		MainList.addEventListener("listPress", this, "onMainListPress");
		MainList.addEventListener("listMovedUp", this, "onMainListMoveUp");
		MainList.addEventListener("listMovedDown", this, "onMainListMoveDown");
		MainList.addEventListener("selectionChange", this, "onMainListMouseSelectionChange");
		ButtonRect.handleInput = function ()
		{
			return false;
		};
		ButtonRect.AcceptMouseButton.addEventListener("click", this, "onAcceptMousePress");
		ButtonRect.CancelMouseButton.addEventListener("click", this, "onCancelMousePress");
		ButtonRect.AcceptMouseButton.SetPlatform(0, false);
		ButtonRect.CancelMouseButton.SetPlatform(0, false);
		SaveLoadListHolder.addEventListener("loadGameSelected", this, "ConfirmLoadGame");
		SaveLoadListHolder.addEventListener("saveListPopulated", this, "OnSaveListOpenSuccess");
		SaveLoadListHolder.addEventListener("saveHighlighted", this, "onSaveHighlight");
		SaveLoadListHolder.List_mc.addEventListener("listPress", this, "onSaveLoadListPress");
		DeleteSaveButton._alpha = 50;
		MarketplaceButton._alpha = 50;
		DLCList_mc._visible = false;
	}

	function setupMainMenu(): Void
	{
		var ALLOW_QUIT: Number = 0;
		var ALLOW_LOAD: Number = 1;
		var VERSION: Number = 2;
		var IS_CONSOLE: Number = 3;
		var ALLOW_DLC: Number = 4;
        
		var icurrentIndex: Number = StartMenu.NEW_INDEX;
		if (MainList.entryList.length > 0) {
			icurrentIndex = MainList.centeredEntry.index;
		}
		
		MainList.ClearList();
		if (arguments[ALLOW_LOAD]) {
			MainList.entryList.push({text: "$CONTINUE", index: StartMenu.CONTINUE_INDEX, disabled: false});
			if (icurrentIndex == StartMenu.NEW_INDEX) {
				icurrentIndex = StartMenu.CONTINUE_INDEX;
			}
		}
		
		MainList.entryList.push({text: "$NEW", index: StartMenu.NEW_INDEX, disabled: false});
		MainList.entryList.push({text: "$LOAD", disabled: !arguments[ALLOW_LOAD], index: StartMenu.LOAD_INDEX});
		
		if (arguments[ALLOW_DLC]) {
			MainList.entryList.push({text: "$DOWNLOADABLE CONTENT", index: StartMenu.DLC_INDEX, disabled: false});
		}
		
		MainList.entryList.push({text: "$CREDITS", index: StartMenu.CREDITS_INDEX, disabled: false});
		
		if (arguments[ALLOW_QUIT]) {
			MainList.entryList.push({text: "$QUIT", index: StartMenu.QUIT_INDEX, disabled: false});
		}
		
		for (var i: Number; i < MainList.entryList.length; i++) {
			if (MainList.entryList[i].index == icurrentIndex) {
				MainList.RestoreScrollPosition(i, false);
			}
		}
		
		MainList.InvalidateData();
		
		if (currentState == undefined) {
			if (arguments[IS_CONSOLE]) {
				StartState(StartMenu.PRESS_START_STATE);
			} else {
				StartState(StartMenu.MAIN_STATE);
			}
		} else if (currentState == StartMenu.SAVE_LOAD_STATE || currentState == StartMenu.SAVE_LOAD_CONFIRM_STATE || currentState == StartMenu.DELETE_SAVE_CONFIRM_STATE) {
			ShowDeleteButtonHelp(false);
			StartState(StartMenu.MAIN_STATE);
		}
		
		if (arguments[VERSION] != undefined) {
			VersionText.SetText("v " + arguments[VERSION]);
		} else {
			VersionText.SetText(" ");
		}
	}

	function get currentState(): String
	{
		return strCurrentState;
	}

	function set currentState(strNewState): Void
	{
		if (strNewState == StartMenu.MAIN_STATE) {
			MainList.disableSelection = false;
		}
		strCurrentState = strNewState;
		ChangeStateFocus(strNewState);
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		if (currentState == StartMenu.PRESS_START_STATE) {
			if (Shared.GlobalFunc.IsKeyPressed(details) && (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_START || details.navEquivalent == gfx.ui.NavigationCode.ENTER)) {
				EndState(StartMenu.PRESS_START_STATE);
			}
			gfx.io.GameDelegate.call("EndPressStartState", []);
		} else if (pathToFocus.length > 0 && !pathToFocus[0].handleInput(details, pathToFocus.slice(1))) {
			if (Shared.GlobalFunc.IsKeyPressed(details)) {
				if (details.navEquivalent == gfx.ui.NavigationCode.ENTER) {
					onAcceptPress();
				} else if (details.navEquivalent == gfx.ui.NavigationCode.TAB) {
					onCancelPress();
				} else if ((details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_X || details.code == 88) && DeleteSaveButton._visible && DeleteSaveButton._alpha == 100) {
					ConfirmDeleteSave();
				} else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_Y && currentState == StartMenu.DLC_STATE && MarketplaceButton._visible && MarketplaceButton._alpha == 100) {
					SaveLoadConfirmText.textField.SetText("$Open Xbox LIVE Marketplace?");
					SetPlatform(iPlatform);
					StartState(StartMenu.MARKETPLACE_CONFIRM_STATE);
				}
			}
		}
		
		return true;
	}

	function onAcceptPress(): Void
	{
		switch(strCurrentState) {
			case StartMenu.MAIN_CONFIRM_STATE:
				if (MainList.selectedEntry.index == StartMenu.NEW_INDEX) {
					gfx.io.GameDelegate.call("PlaySound", ["UIStartNewGame"]);
					FadeOutAndCall("StartNewGame");
				} else if (MainList.selectedEntry.index == StartMenu.CONTINUE_INDEX) {
					gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
					FadeOutAndCall("ContinueLastSavedGame");
				} else if (MainList.selectedEntry.index == StartMenu.QUIT_INDEX) {
					gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
					gfx.io.GameDelegate.call("QuitToDesktop", []);
				}
				break;
				
			case StartMenu.SAVE_LOAD_CONFIRM_STATE:
			case "SaveLoadConfirmStartAnim":
				gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
				FadeOutAndCall("LoadGame", [SaveLoadListHolder.selectedIndex]);
				break;
				
			case StartMenu.DELETE_SAVE_CONFIRM_STATE:
				SaveLoadListHolder.DeleteSelectedSave();
				if (SaveLoadListHolder.numSaves == 0) {
					ShowDeleteButtonHelp(false);
					StartState(StartMenu.MAIN_STATE);
					
					if (MainList.entryList[2].index == StartMenu.LOAD_INDEX) {
						MainList.entryList[2].disabled = true;
					}
					if (MainList.entryList[0].index == StartMenu.CONTINUE_INDEX) {
						MainList.entryList.shift();
					}
					MainList.RestoreScrollPosition(1, true);
					MainList.InvalidateData();
				} else {
					EndState();
				}
				break;
				
			case StartMenu.MARKETPLACE_CONFIRM_STATE:	
				gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
				gfx.io.GameDelegate.call("OpenMarketplace", []);
				StartState(StartMenu.MAIN_STATE);
				break;
		}
	}

	function isConfirming(): Boolean
	{
		return strCurrentState == StartMenu.SAVE_LOAD_CONFIRM_STATE || strCurrentState == StartMenu.DELETE_SAVE_CONFIRM_STATE || strCurrentState == StartMenu.MARKETPLACE_CONFIRM_STATE || strCurrentState == StartMenu.MAIN_CONFIRM_STATE;
	}

	function onAcceptMousePress(): Void
	{
		if (isConfirming()) {
			onAcceptPress();
		}
	}

	function onCancelMousePress(): Void
	{
		if (isConfirming()) {
			onCancelPress();
		}
	}

	function onCancelPress(): Void
	{
		switch(strCurrentState) {
			case StartMenu.MAIN_CONFIRM_STATE:
			case StartMenu.SAVE_LOAD_STATE:
			case StartMenu.SAVE_LOAD_CONFIRM_STATE:
			case StartMenu.DELETE_SAVE_CONFIRM_STATE:
			case StartMenu.DLC_STATE:
			case StartMenu.MARKETPLACE_CONFIRM_STATE:
				gfx.io.GameDelegate.call("PlaySound", ["UIMenuCancel"]);
				EndState();
				break;
		}
	}

	function onMainButtonPress(event: Object): Void
	{
		if (strCurrentState == StartMenu.MAIN_STATE || iPlatform == 0) {
			switch(event.entry.index) {
				case StartMenu.CONTINUE_INDEX:
					gfx.io.GameDelegate.call("CONTINUE", []);
					gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
					break;
					
				case StartMenu.NEW_INDEX:
					gfx.io.GameDelegate.call("NEW", []);
					gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
					break;
				
				case StartMenu.QUIT_INDEX:
					ShowConfirmScreen("$Quit to desktop?  Any unsaved progress will be lost.");
					gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
					break;
					
				case StartMenu.LOAD_INDEX:
					if (event.entry.disabled) {
						gfx.io.GameDelegate.call("OnDisabledLoadPress", []);
					} else {
						SaveLoadListHolder.isSaving = false;
						gfx.io.GameDelegate.call("LOAD", [SaveLoadListHolder.List_mc.entryList, SaveLoadListHolder.batchSize]);
					}
					break;
			
				case StartMenu.DLC_INDEX:
					StartState(StartMenu.DLC_STATE);
					break;
					
				case StartMenu.CREDITS_INDEX:
					FadeOutAndCall("OpenCreditsMenu");
					break;
					
				default:
					gfx.io.GameDelegate.call("PlaySound", ["UIMenuCancel"]);
					break;
			}
		}
	}

	function onMainListPress(event: Object): Void
	{
		onCancelPress();
	}

	function onPCQuitButtonPress(event: Object): Void
	{
		if (event.index == 0) {
			gfx.io.GameDelegate.call("QuitToMainMenu", []);
		} else if (event.index == 1) {
			gfx.io.GameDelegate.call("QuitToDesktop", []);
		}
		return;
	}

	function onSaveLoadListPress(): Void
	{
		onAcceptPress();
	}

	function onMainListMoveUp(event: Object): Void
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) {
			MainList._parent.gotoAndPlay("moveUp");
		}
	}

	function onMainListMoveDown(event: Object): Void
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) {
			MainList._parent.gotoAndPlay("moveDown");
		}
	}

	function onMainListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0 && event.index != -1) {
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		}
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		ButtonRect.AcceptGamepadButton._visible = aiPlatform != 0;
		ButtonRect.CancelGamepadButton._visible = aiPlatform != 0;
		ButtonRect.AcceptMouseButton._visible = aiPlatform == 0;
		ButtonRect.CancelMouseButton._visible = aiPlatform == 0;
		DeleteSaveButton.SetPlatform(aiPlatform, abPS3Switch);
		MarketplaceButton.SetPlatform(aiPlatform, abPS3Switch);
		MainListHolder.SelectionArrow._visible = aiPlatform != 0;
		if (aiPlatform != 0) {
			ButtonRect.AcceptGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
			ButtonRect.CancelGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
		}
		MarketplaceButton._visible = aiPlatform == 2;
		iPlatform = aiPlatform;
		SaveLoadListHolder.platform = iPlatform;
		MainList.SetPlatform(aiPlatform, abPS3Switch);
	}

	function DoFadeOutMenu(): Void
	{
		FadeOutAndCall();
	}

	function DoFadeInMenu(): Void
	{
		_parent.gotoAndPlay("fadeIn");
		EndState();
	}

	function FadeOutAndCall(strCallback: String, paramList: Array): Void
	{
		strFadeOutCallback = strCallback;
		fadeOutParams = paramList;
		_parent.gotoAndPlay("fadeOut");
		gfx.io.GameDelegate.call("fadeOutStarted", []);
	}

	function onFadeOutCompletion(): Void
	{
		if (strFadeOutCallback != undefined && strFadeOutCallback.length > 0) {
			if (fadeOutParams != undefined) {
				gfx.io.GameDelegate.call(strFadeOutCallback, fadeOutParams);
				return;
			}
			gfx.io.GameDelegate.call(strFadeOutCallback, []);
		}
	}

	function StartState(strStateName: String): Void
	{
		if (strStateName == StartMenu.SAVE_LOAD_STATE) {
			ShowDeleteButtonHelp(true);
		} else if (strStateName == StartMenu.DLC_STATE) {
			ShowMarketplaceButtonHelp(true);
		}
		if (strCurrentState == StartMenu.MAIN_STATE) {
			MainList.disableSelection = true;
		}
		strCurrentState = strStateName + "StartAnim";
		gotoAndPlay(strCurrentState);
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
	}

	function EndState(): Void
	{
		if (strCurrentState == StartMenu.SAVE_LOAD_STATE) {
			ShowDeleteButtonHelp(false);
		} else if (strCurrentState == StartMenu.DLC_STATE) {
			ShowMarketplaceButtonHelp(false);
		}
		if (strCurrentState != StartMenu.MAIN_STATE) {
			strCurrentState = strCurrentState + "EndAnim";
			gotoAndPlay(strCurrentState);
		}
	}

	function ChangeStateFocus(strNewState: String): Void
	{
		switch (strNewState) {
			case StartMenu.MAIN_STATE:
				gfx.managers.FocusHandler.instance.setFocus(MainList, 0);
				break;
			
			case StartMenu.SAVE_LOAD_STATE:
				gfx.managers.FocusHandler.instance.setFocus(SaveLoadListHolder.List_mc, 0);
				SaveLoadListHolder.List_mc.disableSelection = false;
				break;
				
			case StartMenu.DLC_STATE:
				iLoadDLCListTimerID = setInterval(this, "DoLoadDLCList", 500);
				gfx.managers.FocusHandler.instance.setFocus(DLCList_mc, 0);
				break;
				
			case StartMenu.MAIN_CONFIRM_STATE:
			case StartMenu.SAVE_LOAD_CONFIRM_STATE:
			case StartMenu.DELETE_SAVE_CONFIRM_STATE:
			case StartMenu.PRESS_START_STATE:
			case StartMenu.MARKETPLACE_CONFIRM_STATE:
				gfx.managers.FocusHandler.instance.setFocus(ButtonRect, 0);
				break;
		}
	}

	function ShowConfirmScreen(astrConfirmText: String): Void
	{
		ConfirmPanel_mc.textField.SetText(astrConfirmText);
		SetPlatform(iPlatform);
		StartState(StartMenu.MAIN_CONFIRM_STATE);
	}

	function OnSaveListOpenSuccess(): Void
	{
		if (SaveLoadListHolder.numSaves > 0) {
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
			StartState(StartMenu.SAVE_LOAD_STATE);
			return;
		}
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuCancel"]);
	}

	function onSaveHighlight(event: Object): Void
	{
		DeleteSaveButton._alpha = event.index == -1 ? 50 : 100;
		if (iPlatform == 0) {
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		}
	}

	function ConfirmLoadGame(event: Object): Void
	{
		SaveLoadListHolder.List_mc.disableSelection = true;
		SaveLoadConfirmText.textField.SetText("$Load this game?");
		SetPlatform(iPlatform);
		StartState(StartMenu.SAVE_LOAD_CONFIRM_STATE);
	}

	function ConfirmDeleteSave(): Void
	{
		SaveLoadListHolder.List_mc.disableSelection = true;
		SaveLoadConfirmText.textField.SetText("$Delete this save?");
		SetPlatform(iPlatform);
		StartState(StartMenu.DELETE_SAVE_CONFIRM_STATE);
	}

	function ShowDeleteButtonHelp(abFlag: Boolean): Void
	{
		DeleteSaveButton._visible = abFlag;
		VersionText._visible = !abFlag;
	}

	function ShowMarketplaceButtonHelp(abFlag: Boolean): Void
	{
		MarketplaceButton._visible = abFlag;
		VersionText._visible = !abFlag;
	}

	function onProfileChange(): Void
	{
		ShowDeleteButtonHelp(false);
		if (strCurrentState != StartMenu.MAIN_STATE && strCurrentState != StartMenu.PRESS_START_STATE) {
			StartState(StartMenu.MAIN_STATE);
		}
	}

	function StartLoadingDLC(): Void
	{
		LoadingContentMessage.gotoAndPlay("startFadeIn");
		clearInterval(iLoadDLCContentMessageTimerID);
		iLoadDLCContentMessageTimerID = setInterval(this, "onLoadingDLCMessageFadeCompletion", 1000);
	}

	function onLoadingDLCMessageFadeCompletion(): Void
	{
		clearInterval(iLoadDLCContentMessageTimerID);
		gfx.io.GameDelegate.call("DoLoadDLCPlugins", []);
	}

	function DoneLoadingDLC(): Void
	{
		LoadingContentMessage.gotoAndPlay("startFadeOut");
	}

	function DoLoadDLCList(): Void
	{
		clearInterval(iLoadDLCListTimerID);
		DLCList_mc.entryList.splice(0, DLCList_mc.entryList.length);
		gfx.io.GameDelegate.call("LoadDLC", [DLCList_mc.entryList], this, "UpdateDLCPanel");
	}

	function UpdateDLCPanel(abMarketplaceAvail: Boolean, abNewDLCAvail: Boolean): Void
	{
		if (DLCList_mc.entryList.length > 0) {
			DLCList_mc._visible = true;
			DLCPanel.warningText.SetText(" ");
			if (iPlatform != 0) {
				DLCList_mc.selectedIndex = 0;
			}
			DLCList_mc.InvalidateData();
		} else {
			DLCList_mc._visible = false;
			DLCPanel.warningText.SetText("$No content downloaded");
		}
		MarketplaceButton._alpha = abMarketplaceAvail ? 100 : 50;
		if (abNewDLCAvail == true) {
			DLCPanel.NewContentAvail.SetText("$New content available");
		}
	}

}
