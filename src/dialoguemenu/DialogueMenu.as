import gfx.io.GameDelegate;
import Components.CrossPlatformButtons;
import Shared.GlobalFunc;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

class DialogueMenu extends MovieClip
{
	static var ALLOW_PROGRESS_DELAY: Number = 750;
	static var iMouseDownExecutionCount: Number = 0;
	
	static var SHOW_GREETING: Number = 0;
	static var TOPIC_LIST_SHOWN: Number = 1;
	static var TOPIC_CLICKED: Number = 2;
	static var TRANSITIONING: Number = 3;
	
	
	var ExitButton: CrossPlatformButtons;
	var SpeakerName: TextField;
	var SubtitleText: TextField;
	var TopicList: MovieClip;
	var TopicListHolder: Object;
	var bAllowProgress: Boolean;
	var bFadedIn: Boolean;
	var eMenuState: Number;
	var iAllowProgressTimerID: Number;

	function DialogueMenu()
	{
		super();
		TopicList = TopicListHolder.List_mc;
		eMenuState = DialogueMenu.SHOW_GREETING;
		bFadedIn = true;
		bAllowProgress = false;
	}

	function InitExtensions()
	{
		Mouse.addListener(this);
		
		GameDelegate.addCallBack("Cancel", this, "onCancelPress");
		GameDelegate.addCallBack("ShowDialogueText", this, "ShowDialogueText");
		GameDelegate.addCallBack("HideDialogueText", this, "HideDialogueText");
		GameDelegate.addCallBack("PopulateDialogueList", this, "PopulateDialogueLists");
		GameDelegate.addCallBack("ShowDialogueList", this, "DoShowDialogueList");
		GameDelegate.addCallBack("StartHideMenu", this, "StartHideMenu");
		GameDelegate.addCallBack("SetSpeakerName", this, "SetSpeakerName");
		GameDelegate.addCallBack("NotifyVoiceReady", this, "OnVoiceReady");
		GameDelegate.addCallBack("AdjustForPALSD", this, "AdjustForPALSD");
		
		TopicList.addEventListener("listMovedUp", this, "playListUpAnim");
		TopicList.addEventListener("listMovedDown", this, "playListDownAnim");
		TopicList.addEventListener("itemPress", this, "onItemSelect");
		
		GlobalFunc.SetLockFunction();
		
		ExitButton.Lock("BR");
		ExitButton._x = ExitButton._x - 50;
		ExitButton._y = ExitButton._y - 30;
		ExitButton.addEventListener("click", this, "onCancelPress");
		
		TopicListHolder._visible = false;
		TopicListHolder.TextCopy_mc._visible = false;
		TopicListHolder.TextCopy_mc.textField.textColor = 0x606060;
		TopicListHolder.TextCopy_mc.textField.verticalAutoSize = "top";
		TopicListHolder.PanelCopy_mc._visible = false;
		
		FocusHandler.instance.setFocus(TopicList, 0);
		
		SubtitleText.verticalAutoSize = "top";
		SubtitleText.SetText(" ");
		
		SpeakerName.verticalAutoSize = "top";
		SpeakerName.SetText(" ");
	}

	function AdjustForPALSD(): Void
	{
		_root.DialogueMenu_mc._x = _root.DialogueMenu_mc._x - 35;
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		ExitButton.SetPlatform(aiPlatform, abPS3Switch);
		TopicList.SetPlatform(aiPlatform, abPS3Switch);
	}

	function SetSpeakerName(strName: String): Void
	{
		SpeakerName.SetText(strName);
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (bFadedIn && GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.TAB) {
				onCancelPress();
			} else if ((details.navEquivalent != NavigationCode.UP && details.navEquivalent != NavigationCode.DOWN) || eMenuState == DialogueMenu.TOPIC_LIST_SHOWN) {
				pathToFocus[0].handleInput(details, pathToFocus.slice(1));
			}
		}
		return true;
	}

	function get menuState(): Number
	{
		return eMenuState;
	}

	function set menuState(aNewState: Number): Void
	{
		eMenuState = aNewState;
	}

	function ShowDialogueText(astrText: String): Void
	{
		SubtitleText.SetText(astrText);
	}

	function OnVoiceReady(): Void
	{
		StartProgressTimer();
	}

	function StartProgressTimer(): Void
	{
		bAllowProgress = false;
		clearInterval(iAllowProgressTimerID);
		iAllowProgressTimerID = setInterval(this, "SetAllowProgress", DialogueMenu.ALLOW_PROGRESS_DELAY);
	}

	function HideDialogueText(): Void
	{
		SubtitleText.SetText(" ");
	}

	function SetAllowProgress(): Void
	{
		clearInterval(iAllowProgressTimerID);
		bAllowProgress = true;
	}

	function PopulateDialogueLists(): Void
	{
		var TOPIC_TEXT: Number = 0;
		var TOPIC_ISNEW: Number = 1;
		var TOPIC_INDEX: Number = 2;
		var TOPIC_STRIDE: Number = 3;
		
		TopicList.ClearList();
		
		for (var i: Number = 0; i < arguments.length - 1; i += TOPIC_STRIDE) {
			var topicData: Object = {text: arguments[i + TOPIC_TEXT], topicIsNew: arguments[i + TOPIC_ISNEW], topicIndex: arguments[i + TOPIC_INDEX]};
			TopicList.entryList.push(topicData);
		}
		if (arguments[arguments.length - 1] != -1) {
			// Select last topic entry if valid
			TopicList.SetSelectedTopic(arguments[arguments.length - 1]);
		}
		
		TopicList.InvalidateData();
	}

	function DoShowDialogueList(abNewList: Boolean, abHideExitButton: Boolean): Void
	{
		if (eMenuState == DialogueMenu.TOPIC_CLICKED || (eMenuState == DialogueMenu.SHOW_GREETING && TopicList.entryList.length > 0)) {
			ShowDialogueList(abNewList, abNewList && eMenuState == DialogueMenu.TOPIC_CLICKED);
		}
		ExitButton._visible = !abHideExitButton;
	}

	function ShowDialogueList(abSlideAnim: Boolean, abCopyVisible: Boolean): Void
	{
		TopicListHolder._visible = true;
		TopicListHolder.gotoAndPlay(abSlideAnim ? "slideListIn" : "fadeListIn");
		eMenuState = DialogueMenu.TRANSITIONING;
		TopicListHolder.TextCopy_mc._visible = abCopyVisible;
		TopicListHolder.PanelCopy_mc._visible = abCopyVisible;
	}

	function onItemSelect(event: Object): Void
	{
		if (bAllowProgress && event.keyboardOrMouse != 0) {
			if (eMenuState == DialogueMenu.TOPIC_LIST_SHOWN) {
				onSelectionClick();
			} else if (eMenuState == DialogueMenu.TOPIC_CLICKED || eMenuState == DialogueMenu.SHOW_GREETING) {
				SkipText();
			}
			bAllowProgress = false;
		}
	}

	function SkipText(): Void
	{
		if (bAllowProgress) {
			GameDelegate.call("SkipText", []);
			bAllowProgress = false;
		}
	}

	function onMouseDown(): Void
	{
		++DialogueMenu.iMouseDownExecutionCount;
		if (DialogueMenu.iMouseDownExecutionCount % 2 != 0) {
			onItemSelect();
		}
	}

	function onCancelPress(): Void
	{
		if (eMenuState == DialogueMenu.SHOW_GREETING) {
			SkipText();
			return;
		}
		StartHideMenu();
	}

	function StartHideMenu(): Void
	{
		SubtitleText._visible = false;
		bFadedIn = false;
		SpeakerName.SetText(" ");
		ExitButton._visible = false;
		_parent.gotoAndPlay("startFadeOut");
		GameDelegate.call("CloseMenu", []);
	}

	function playListUpAnim(aEvent: Object): Void
	{
		if (aEvent.scrollChanged == true) {
			aEvent.target._parent.gotoAndPlay("moveUp");
		}
	}

	function playListDownAnim(aEvent: Object): Void
	{
		if (aEvent.scrollChanged == true) {
			aEvent.target._parent.gotoAndPlay("moveDown");
		}
	}

	function onSelectionClick(): Void
	{
		if (eMenuState == DialogueMenu.TOPIC_LIST_SHOWN) {
			eMenuState = DialogueMenu.TOPIC_CLICKED;
		}
		if (TopicList.scrollPosition != TopicList.selectedIndex) {
			TopicList.RestoreScrollPosition(TopicList.selectedIndex, true);
			TopicList.UpdateList();
		}
		TopicListHolder.gotoAndPlay("topicClicked");
		TopicListHolder.TextCopy_mc._visible = true;
		TopicListHolder.TextCopy_mc.textField.SetText(TopicListHolder.List_mc.selectedEntry.text);
		var textFieldyOffset: Number = TopicListHolder.TextCopy_mc._y - TopicListHolder.List_mc._y - TopicListHolder.List_mc.Entry4._y;
		TopicListHolder.TextCopy_mc.textField._y = 6.25 - textFieldyOffset;
		GameDelegate.call("TopicClicked", [TopicList.selectedEntry.topicIndex]);
	}

	function onFadeOutCompletion(): Void
	{
		GameDelegate.call("FadeDone", []);
	}

}
