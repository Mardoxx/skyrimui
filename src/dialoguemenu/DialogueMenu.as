dynamic class DialogueMenu extends MovieClip
{
	static var ALLOW_PROGRESS_DELAY: Number = 750;
	static var SHOW_GREETING: Number = 0;
	static var TOPIC_LIST_SHOWN: Number = 1;
	static var TOPIC_CLICKED: Number = 2;
	static var TRANSITIONING: Number = 3;
	static var iMouseDownExecutionCount: Number = 0;
	var ExitButton;
	var SpeakerName;
	var SubtitleText;
	var TopicList;
	var TopicListHolder;
	var _parent;
	var bAllowProgress;
	var bFadedIn;
	var eMenuState;
	var iAllowProgressTimerID;

	function DialogueMenu()
	{
		super();
		this.TopicListHolder = this.TopicListHolder;
		this.TopicList = this.TopicListHolder.List_mc;
		this.SubtitleText = this.SubtitleText;
		this.ExitButton = this.ExitButton;
		this.eMenuState = DialogueMenu.SHOW_GREETING;
		this.bFadedIn = true;
		this.bAllowProgress = false;
	}

	function InitExtensions()
	{
		Mouse.addListener(this);
		gfx.io.GameDelegate.addCallBack("Cancel", this, "onCancelPress");
		gfx.io.GameDelegate.addCallBack("ShowDialogueText", this, "ShowDialogueText");
		gfx.io.GameDelegate.addCallBack("HideDialogueText", this, "HideDialogueText");
		gfx.io.GameDelegate.addCallBack("PopulateDialogueList", this, "PopulateDialogueLists");
		gfx.io.GameDelegate.addCallBack("ShowDialogueList", this, "DoShowDialogueList");
		gfx.io.GameDelegate.addCallBack("StartHideMenu", this, "StartHideMenu");
		gfx.io.GameDelegate.addCallBack("SetSpeakerName", this, "SetSpeakerName");
		gfx.io.GameDelegate.addCallBack("NotifyVoiceReady", this, "OnVoiceReady");
		gfx.io.GameDelegate.addCallBack("AdjustForPALSD", this, "AdjustForPALSD");
		this.TopicList.addEventListener("listMovedUp", this, "playListUpAnim");
		this.TopicList.addEventListener("listMovedDown", this, "playListDownAnim");
		this.TopicList.addEventListener("itemPress", this, "onItemSelect");
		Shared.GlobalFunc.SetLockFunction();
		this.ExitButton.Lock("BR");
		this.ExitButton._x = this.ExitButton._x - 50;
		this.ExitButton._y = this.ExitButton._y - 30;
		this.ExitButton.addEventListener("click", this, "onCancelPress");
		this.TopicListHolder._visible = false;
		this.TopicListHolder.TextCopy_mc._visible = false;
		this.TopicListHolder.TextCopy_mc.textField.textColor = 6316128;
		this.TopicListHolder.TextCopy_mc.textField.verticalAutoSize = "top";
		this.TopicListHolder.PanelCopy_mc._visible = false;
		gfx.managers.FocusHandler.instance.setFocus(this.TopicList, 0);
		this.SubtitleText.verticalAutoSize = "top";
		this.SubtitleText.SetText(" ");
		this.SpeakerName.verticalAutoSize = "top";
		this.SpeakerName.SetText(" ");
	}

	function AdjustForPALSD()
	{
		_root.DialogueMenu_mc._x = _root.DialogueMenu_mc._x - 35;
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		this.ExitButton.SetPlatform(aiPlatform, abPS3Switch);
		this.TopicList.SetPlatform(aiPlatform, abPS3Switch);
	}

	function SetSpeakerName(strName)
	{
		this.SpeakerName.SetText(strName);
	}

	function handleInput(details, pathToFocus)
	{
		if (this.bFadedIn && Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				this.onCancelPress();
			}
			else if ((details.navEquivalent != gfx.ui.NavigationCode.UP && details.navEquivalent != gfx.ui.NavigationCode.DOWN) || this.eMenuState == DialogueMenu.TOPIC_LIST_SHOWN) 
			{
				pathToFocus[0].handleInput(details, pathToFocus.slice(1));
			}
		}
		return true;
	}

	function get menuState()
	{
		return this.eMenuState;
	}

	function set menuState(aNewState)
	{
		this.eMenuState = aNewState;
	}

	function ShowDialogueText(astrText)
	{
		this.SubtitleText.SetText(astrText);
	}

	function OnVoiceReady()
	{
		this.StartProgressTimer();
	}

	function StartProgressTimer()
	{
		this.bAllowProgress = false;
		clearInterval(this.iAllowProgressTimerID);
		this.iAllowProgressTimerID = setInterval(this, "SetAllowProgress", DialogueMenu.ALLOW_PROGRESS_DELAY);
	}

	function HideDialogueText()
	{
		this.SubtitleText.SetText(" ");
	}

	function SetAllowProgress()
	{
		clearInterval(this.iAllowProgressTimerID);
		this.bAllowProgress = true;
	}

	function PopulateDialogueLists()
	{
		var __reg9 = 0;
		var __reg11 = 1;
		var __reg8 = 2;
		var __reg10 = 3;
		this.TopicList.ClearList();
		var __reg3 = 0;
		while (__reg3 < arguments.length - 1) 
		{
			var __reg4 = {text: arguments[__reg3 + __reg9], topicIsNew: arguments[__reg3 + __reg11], topicIndex: arguments[__reg3 + __reg8]};
			this.TopicList.entryList.push(__reg4);
			__reg3 = __reg3 + __reg10;
		}
		if (arguments[arguments.length - 1] != -1) 
		{
			this.TopicList.SetSelectedTopic(arguments[arguments.length - 1]);
		}
		this.TopicList.InvalidateData();
	}

	function DoShowDialogueList(abNewList, abHideExitButton)
	{
		if (this.eMenuState == DialogueMenu.TOPIC_CLICKED || (this.eMenuState == DialogueMenu.SHOW_GREETING && this.TopicList.entryList.length > 0)) 
		{
			this.ShowDialogueList(abNewList, abNewList && this.eMenuState == DialogueMenu.TOPIC_CLICKED);
		}
		this.ExitButton._visible = !abHideExitButton;
	}

	function ShowDialogueList(abSlideAnim, abCopyVisible)
	{
		this.TopicListHolder._visible = true;
		this.TopicListHolder.gotoAndPlay(abSlideAnim ? "slideListIn" : "fadeListIn");
		this.eMenuState = DialogueMenu.TRANSITIONING;
		this.TopicListHolder.TextCopy_mc._visible = abCopyVisible;
		this.TopicListHolder.PanelCopy_mc._visible = abCopyVisible;
	}

	function onItemSelect(event)
	{
		if (this.bAllowProgress && event.keyboardOrMouse != 0) 
		{
			if (this.eMenuState == DialogueMenu.TOPIC_LIST_SHOWN) 
			{
				this.onSelectionClick();
			}
			else if (this.eMenuState == DialogueMenu.TOPIC_CLICKED || this.eMenuState == DialogueMenu.SHOW_GREETING) 
			{
				this.SkipText();
			}
			this.bAllowProgress = false;
		}
	}

	function SkipText()
	{
		if (this.bAllowProgress) 
		{
			gfx.io.GameDelegate.call("SkipText", []);
			this.bAllowProgress = false;
		}
	}

	function onMouseDown()
	{
		++DialogueMenu.iMouseDownExecutionCount;
		if (DialogueMenu.iMouseDownExecutionCount % 2 != 0) 
		{
			this.onItemSelect();
		}
	}

	function onCancelPress()
	{
		if (this.eMenuState == DialogueMenu.SHOW_GREETING) 
		{
			this.SkipText();
			return;
		}
		this.StartHideMenu();
	}

	function StartHideMenu()
	{
		this.SubtitleText._visible = false;
		this.bFadedIn = false;
		this.SpeakerName.SetText(" ");
		this.ExitButton._visible = false;
		this._parent.gotoAndPlay("startFadeOut");
		gfx.io.GameDelegate.call("CloseMenu", []);
	}

	function playListUpAnim(aEvent)
	{
		if (aEvent.scrollChanged == true) 
		{
			aEvent.target._parent.gotoAndPlay("moveUp");
		}
	}

	function playListDownAnim(aEvent)
	{
		if (aEvent.scrollChanged == true) 
		{
			aEvent.target._parent.gotoAndPlay("moveDown");
		}
	}

	function onSelectionClick()
	{
		if (this.eMenuState == DialogueMenu.TOPIC_LIST_SHOWN) 
		{
			this.eMenuState = DialogueMenu.TOPIC_CLICKED;
		}
		if (this.TopicList.scrollPosition != this.TopicList.selectedIndex) 
		{
			this.TopicList.RestoreScrollPosition(this.TopicList.selectedIndex, true);
			this.TopicList.UpdateList();
		}
		this.TopicListHolder.gotoAndPlay("topicClicked");
		this.TopicListHolder.TextCopy_mc._visible = true;
		this.TopicListHolder.TextCopy_mc.textField.SetText(this.TopicListHolder.List_mc.selectedEntry.text);
		var __reg2 = this.TopicListHolder.TextCopy_mc._y - this.TopicListHolder.List_mc._y - this.TopicListHolder.List_mc.Entry4._y;
		this.TopicListHolder.TextCopy_mc.textField._y = 6.25 - __reg2;
		gfx.io.GameDelegate.call("TopicClicked", [this.TopicList.selectedEntry.topicIndex]);
	}

	function onFadeOutCompletion()
	{
		gfx.io.GameDelegate.call("FadeDone", []);
	}

}
