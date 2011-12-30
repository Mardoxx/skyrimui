dynamic class MessageBox extends MovieClip
{
	static var WIDTH_MARGIN: Number = 20;
	static var HEIGHT_MARGIN: Number = 30;
	static var MESSAGE_TO_BUTTON_SPACER: Number = 10;
	static var SELECTION_INDICATOR_WIDTH: Number = 25;
	var Background_mc;
	var ButtonContainer;
	var DefaultTextFormat;
	var Divider;
	var Message;
	var MessageButtons;
	var MessageText;
	var _parent;
	var _yscale;
	var createEmptyMovieClip;
	var getBounds;
	var getNextHighestDepth;

	function MessageBox()
	{
		super();
		this.Message = this.MessageText;
		this.Divider = this.Divider;
		this.Message.noTranslate = true;
		this.MessageButtons = new Array();
		this.ButtonContainer = undefined;
		this.DefaultTextFormat = this.Message.getTextFormat();
		Key.addListener(this);
		gfx.io.GameDelegate.addCallBack("setMessageText", this, "SetMessage");
		gfx.io.GameDelegate.addCallBack("setButtons", this, "setupButtons");
	}

	function setupButtons()
	{
		if (undefined != this.ButtonContainer) 
		{
			this.ButtonContainer.removeMovieClip();
			this.ButtonContainer = undefined;
		}
		this.MessageButtons.length = 0;
		var __reg8 = arguments[0];
		if (arguments.length > 1) 
		{
			this.ButtonContainer = this.createEmptyMovieClip("Buttons", this.getNextHighestDepth());
			var __reg7 = 0;
			var __reg5 = 1;
			while (__reg5 < arguments.length) 
			{
				if (arguments[__reg5] != " ") 
				{
					var __reg6 = __reg5 - 1;
					var __reg4 = gfx.controls.Button(this.ButtonContainer.attachMovie("MessageBoxButton", "Button" + __reg6, this.ButtonContainer.getNextHighestDepth()));
					var __reg3 = __reg4.ButtonText;
					__reg3.autoSize = "center";
					__reg3.verticalAlign = "center";
					__reg3.verticalAutoSize = "center";
					__reg3.html = true;
					__reg3.SetText(arguments[__reg5], true);
					__reg4.SelectionIndicatorHolder.SelectionIndicator._width = __reg3._width + MessageBox.SELECTION_INDICATOR_WIDTH;
					__reg4.SelectionIndicatorHolder.SelectionIndicator._y = __reg3._y + __reg3._height / 2;
					__reg4._x = __reg7 + __reg4._width / 2;
					__reg7 = __reg7 + (__reg4._width + MessageBox.SELECTION_INDICATOR_WIDTH);
					this.MessageButtons.push(__reg4);
				}
				++__reg5;
			}
			this.InitButtons();
			this.ResetDimensions();
			if (__reg8) 
			{
				Selection.setFocus(this.MessageButtons[0]);
			}
		}
	}

	function InitButtons()
	{
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.MessageButtons.length) 
			{
				return;
			}
			this.MessageButtons[__reg2].handlePress = function ()
			{
			}
			;
			this.MessageButtons[__reg2].addEventListener("press", this.ClickCallback);
			this.MessageButtons[__reg2].addEventListener("focusIn", this.FocusCallback);
			this.MessageButtons[__reg2].ButtonText.noTranslate = true;
			++__reg2;
		}
	}

	function SetMessage(aText, abHTML)
	{
		this.Message.autoSize = "center";
		this.Message.setTextFormat(this.DefaultTextFormat);
		this.Message.setNewTextFormat(this.DefaultTextFormat);
		this.Message.html = abHTML;
		if (abHTML) 
		{
			this.Message.htmlText = aText;
		}
		else 
		{
			this.Message.SetText(aText);
		}
		this.ResetDimensions();
	}

	function ResetDimensions()
	{
		this.PositionElements();
		var __reg3 = this.getBounds(this._parent);
		var __reg2 = Stage.height * 0.85 - __reg3.yMax;
		if (0 > __reg2) 
		{
			this.Message.autoSize = false;
			var __reg4 = __reg2 * 100 / this._yscale;
			this.Message._height = this.Message._height + __reg4;
			this.PositionElements();
		}
	}

	function PositionElements()
	{
		var __reg4 = this.Background_mc;
		var __reg3 = 0;
		var __reg2 = 0;
		while (__reg2 < this.Message.numLines) 
		{
			__reg3 = Math.max(__reg3, this.Message.getLineMetrics(__reg2).width);
			++__reg2;
		}
		var __reg6 = 0;
		var __reg5 = 0;
		if (this.ButtonContainer != undefined) 
		{
			__reg6 = this.ButtonContainer._width;
			__reg5 = this.ButtonContainer._height;
		}
		__reg4._width = Math.max(__reg3 + 60, __reg6 + MessageBox.WIDTH_MARGIN * 2);
		__reg4._height = this.Message._height + __reg5 + MessageBox.HEIGHT_MARGIN * 2 + MessageBox.MESSAGE_TO_BUTTON_SPACER;
		this.Message._y = (0 - __reg4._height) / 2 + MessageBox.HEIGHT_MARGIN;
		this.ButtonContainer._y = __reg4._height / 2 - MessageBox.HEIGHT_MARGIN - this.ButtonContainer._height / 2;
		this.ButtonContainer._x = (0 - this.ButtonContainer._width) / 2;
		this.Divider._width = __reg4._width - MessageBox.WIDTH_MARGIN * 2;
		this.Divider._y = this.ButtonContainer._y - this.ButtonContainer._height / 2 - MessageBox.MESSAGE_TO_BUTTON_SPACER / 2;
	}

	function ClickCallback(aEvent)
	{
		gfx.io.GameDelegate.call("buttonPress", [Number(aEvent.target._name.substr(-1))]);
	}

	function FocusCallback(aEvent)
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
	}

	function onKeyDown()
	{
		if (Key.getCode() == 89 && this.MessageButtons[0].ButtonText.text == "Yes") 
		{
			gfx.io.GameDelegate.call("buttonPress", [0]);
			return;
		}
		if (Key.getCode() == 78 && this.MessageButtons[1].ButtonText.text == "No") 
		{
			gfx.io.GameDelegate.call("buttonPress", [1]);
			return;
		}
		if (Key.getCode() == 65 && this.MessageButtons[2].ButtonText.text == "Yes to All") 
		{
			gfx.io.GameDelegate.call("buttonPress", [2]);
		}
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean)
	{
		if (aiPlatform != 0 && this.MessageButtons.length > 0) 
		{
			Selection.setFocus(this.MessageButtons[0]);
		}
	}

}
