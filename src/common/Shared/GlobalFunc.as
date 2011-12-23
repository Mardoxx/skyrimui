dynamic class Shared.GlobalFunc
{
	static var RegisteredTextFields = new Object();
	static var RegisteredMovieClips = new Object();
	var _currentframe;
	var _name;
	var _parent;
	var _x;
	var _y;
	var getTextFormat;
	var gotoAndPlay;
	var gotoAndStop;
	var htmlText;
	var onEnterFrame;
	var setTextFormat;
	var text;

	function GlobalFunc()
	{
	}

	static function Lerp(aTargetMin, aTargetMax, aSourceMin, aSourceMax, aSource, abClamp)
	{
		var __reg1 = aTargetMin + (aSource - aSourceMin) / (aSourceMax - aSourceMin) * (aTargetMax - aTargetMin);
		if (abClamp) 
		{
			__reg1 = Math.min(Math.max(__reg1, aTargetMin), aTargetMax);
		}
		return __reg1;
	}

	static function IsKeyPressed(aInputInfo, abProcessKeyHeldDown)
	{
		if (abProcessKeyHeldDown == undefined) 
		{
			abProcessKeyHeldDown = true;
		}
		return aInputInfo.value == "keyDown" || (abProcessKeyHeldDown && aInputInfo.value == "keyHold");
	}

	static function RoundDecimal(aNumber, aPrecision)
	{
		var __reg1 = Math.pow(10, aPrecision);
		return Math.round(__reg1 * aNumber) / __reg1;
	}

	static function MaintainTextFormat()
	{
		TextField.prototype.SetText = function (aText, abHTMLText)
		{
			if (aText == undefined || aText == "") 
			{
				aText = " ";
			}
			if (abHTMLText) 
			{
				var __reg4 = this.getTextFormat();
				var __reg3 = __reg4.letterSpacing;
				var __reg5 = __reg4.kerning;
				this.htmlText = aText;
				__reg4 = this.getTextFormat();
				__reg4.letterSpacing = __reg3;
				__reg4.kerning = __reg5;
				this.setTextFormat(__reg4);
				return;
			}
			__reg4 = this.getTextFormat();
			this.text = aText;
			this.setTextFormat(__reg4);
		}
		;
	}

	static function SetLockFunction()
	{
		MovieClip.prototype.Lock = function (aPosition)
		{
			var __reg4 = {x: Stage.visibleRect.x + Stage.safeRect.x, y: Stage.visibleRect.y + Stage.safeRect.y};
			var __reg3 = {x: Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x, y: Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y};
			this._parent.globalToLocal(__reg4);
			this._parent.globalToLocal(__reg3);
			if (aPosition == "T" || aPosition == "TL" || aPosition == "TR") 
			{
				this._y = __reg4.y;
			}
			if (aPosition == "B" || aPosition == "BL" || aPosition == "BR") 
			{
				this._y = __reg3.y;
			}
			if (aPosition == "L" || aPosition == "TL" || aPosition == "BL") 
			{
				this._x = __reg4.x;
			}
			if (aPosition == "R" || aPosition == "TR" || aPosition == "BR") 
			{
				this._x = __reg3.x;
			}
		}
		;
	}

	static function AddMovieExploreFunctions()
	{
		MovieClip.prototype.getMovieClips = function ()
		{
			var __reg2 = new Array();
			for (var __reg3 in this) 
			{
				if (this[__reg3] instanceof MovieClip && this[__reg3] != this) 
				{
					__reg2.push(this[__reg3]);
				}
			}
			return __reg2;
		}
		;
		MovieClip.prototype.showMovieClips = function ()
		{
			for (var __reg2 in this) 
			{
				if (this[__reg2] instanceof MovieClip && this[__reg2] != this) 
				{
					trace(this[__reg2]);
					this[__reg2].showMovieClips();
				}
			}
		}
		;
	}

	static function AddReverseFunctions()
	{
		MovieClip.prototype.PlayReverse = function ()
		{
			if (this._currentframe > 1) 
			{
				this.gotoAndStop(this._currentframe - 1);
				this.onEnterFrame = function ()
				{
					if (this._currentframe > 1) 
					{
						this.gotoAndStop(this._currentframe - 1);
						return;
					}
					delete (this.onEnterFrame);
				}
				;
				return;
			}
			this.gotoAndStop(1);
		}
		;
		MovieClip.prototype.PlayForward = function (aFrameLabel)
		{
			delete (this.onEnterFrame);
			this.gotoAndPlay(aFrameLabel);
		}
		;
		MovieClip.prototype.PlayForward = function (aFrame)
		{
			delete (this.onEnterFrame);
			this.gotoAndPlay(aFrame);
		}
		;
	}

	static function GetTextField(aParentClip, aName)
	{
		if (Shared.GlobalFunc.RegisteredTextFields[aName + aParentClip._name] != undefined) 
		{
			return Shared.GlobalFunc.RegisteredTextFields[aName + aParentClip._name];
		}
		trace(aName + " is not registered a TextField name.");
	}

	static function GetMovieClip(aParentClip, aName)
	{
		if (Shared.GlobalFunc.RegisteredMovieClips[aName + aParentClip._name] != undefined) 
		{
			return Shared.GlobalFunc.RegisteredMovieClips[aName + aParentClip._name];
		}
		trace(aName + " is not registered a MovieClip name.");
	}

	static function AddRegisterTextFields()
	{
		TextField.prototype.RegisterTextField = function (aStartingClip)
		{
			if (Shared.GlobalFunc.RegisteredTextFields[this._name + aStartingClip._name] == undefined) 
			{
				Shared.GlobalFunc.RegisteredTextFields[this._name + aStartingClip._name] = this;
			}
		}
		;
	}

	static function RegisterTextFields(aStartingClip)
	{
		for (var __reg2 in aStartingClip) 
		{
			if (aStartingClip[__reg2] instanceof TextField) 
			{
				aStartingClip[__reg2].RegisterTextField(aStartingClip);
			}
		}
	}

	static function RegisterAllTextFieldsInTimeline(aStartingClip)
	{
		var __reg2 = 1;
		for (;;) 
		{
			if (!(aStartingClip._totalFrames && __reg2 <= aStartingClip._totalFrames)) 
			{
				return;
			}
			aStartingClip.gotoAndStop(__reg2);
			Shared.GlobalFunc.RegisterTextFields(aStartingClip);
			++__reg2;
		}
	}

	static function AddRegisterMovieClips()
	{
		MovieClip.prototype.RegisterMovieClip = function (aStartingClip)
		{
			if (Shared.GlobalFunc.RegisteredMovieClips[this._name + aStartingClip._name] == undefined) 
			{
				Shared.GlobalFunc.RegisteredMovieClips[this._name + aStartingClip._name] = this;
			}
		}
		;
	}

	static function RegisterMovieClips(aStartingClip)
	{
		for (var __reg2 in aStartingClip) 
		{
			if (aStartingClip[__reg2] instanceof MovieClip) 
			{
				aStartingClip[__reg2].RegisterMovieClip(aStartingClip);
			}
		}
	}

	static function RecursiveRegisterMovieClips(aStartingClip, aRootClip)
	{
		for (var __reg3 in aStartingClip) 
		{
			if (aStartingClip[__reg3] instanceof MovieClip) 
			{
				if (aStartingClip[__reg3] != aStartingClip) 
				{
					Shared.GlobalFunc.RecursiveRegisterMovieClips(aStartingClip[__reg3], aRootClip);
				}
				aStartingClip[__reg3].RegisterMovieClip(aRootClip);
			}
		}
	}

	static function RegisterAllMovieClipsInTimeline(aStartingClip)
	{
		var __reg2 = 1;
		for (;;) 
		{
			if (!(aStartingClip._totalFrames && __reg2 <= aStartingClip._totalFrames)) 
			{
				return;
			}
			aStartingClip.gotoAndStop(__reg2);
			Shared.GlobalFunc.RegisterMovieClips(aStartingClip);
			++__reg2;
		}
	}

	static function StringTrim(astrText)
	{
		var __reg2 = 0;
		var __reg1 = 0;
		var __reg5 = astrText.length;
		var __reg3 = undefined;
		while (astrText.charAt(__reg2) == " " || astrText.charAt(__reg2) == "\n" || astrText.charAt(__reg2) == "\r" || astrText.charAt(__reg2) == "\t") 
		{
			++__reg2;
		}
		__reg3 = astrText.substring(__reg2);
		__reg1 = __reg3.length - 1;
		while (__reg3.charAt(__reg1) == " " || __reg3.charAt(__reg1) == "\n" || __reg3.charAt(__reg1) == "\r" || __reg3.charAt(__reg1) == "\t") 
		{
			--__reg1;
		}
		__reg3 = __reg3.substring(0, __reg1 + 1);
		return __reg3;
	}

}
