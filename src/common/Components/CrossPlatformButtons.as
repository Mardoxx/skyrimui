class Components.CrossPlatformButtons extends gfx.controls.Button
{
	var ButtonArt: MovieClip;
	var ButtonArt_mc: MovieClip;
	var CurrentPlatform: Number;
	var PCButton: String;
	var PS3Button: String;
	var PS3Swapped: Boolean;
	var XBoxButton: String;

	function CrossPlatformButtons()
	{
		super();
	}

	function onLoad(): Void
	{
		super.onLoad();
		if (this._parent.onButtonLoad != undefined) 
		{
			this._parent.onButtonLoad(this);
		}
	}

	function SetPlatform(aiPlatform: Number, aSwapPS3: Boolean): Void
	{
		if (aiPlatform != undefined) 
		{
			this.CurrentPlatform = aiPlatform;
		}
		if (aSwapPS3 != undefined) 
		{
			this.PS3Swapped = aSwapPS3;
		}
		this.RefreshArt();
	}

	function RefreshArt(): Void
	{
		if (undefined != this.ButtonArt) 
		{
			this.ButtonArt.removeMovieClip();
		}
		var iCurrentPlatform: Number = this.CurrentPlatform;
		if (iCurrentPlatform === Shared.ButtonChange.PLATFORM_PC) 
		{
			if (this.PCButton != "None") 
			{
				this.ButtonArt_mc = this.attachMovie(this.PCButton, "ButtonArt", this.getNextHighestDepth());
			}
		}
		else if (iCurrentPlatform === Shared.ButtonChange.PLATFORM_PC_GAMEPAD) 
		{
			this.ButtonArt_mc = this.attachMovie(this.XBoxButton, "ButtonArt", this.getNextHighestDepth());
		}
		else if (iCurrentPlatform === Shared.ButtonChange.PLATFORM_360) 
		{
			this.ButtonArt_mc = this.attachMovie(this.XBoxButton, "ButtonArt", this.getNextHighestDepth());
		}
		else if (iCurrentPlatform === Shared.ButtonChange.PLATFORM_PS3) 
		{
			var strPS3Button: String = this.PS3Button;
			if (this.PS3Swapped) 
			{
				if (strPS3Button == "PS3_A") 
				{
					strPS3Button = "PS3_B";
				}
				else if (strPS3Button == "PS3_B") 
				{
					strPS3Button = "PS3_A";
				}
			}
			this.ButtonArt_mc = this.attachMovie(strPS3Button, "ButtonArt", this.getNextHighestDepth());
		}
		this.ButtonArt_mc._x = this.ButtonArt_mc._x - this.ButtonArt_mc._width;
		this.ButtonArt_mc._y = (this._height - this.ButtonArt_mc._height) / 2;
		this.border._visible = false;
	}

	function GetArt(): Object
	{
		return {PCArt: this.PCButton, XBoxArt: this.XBoxButton, PS3Art: this.PS3Button};
	}

	function SetArt(aPlatformArt: Object): Void
	{
		this.PCArt = aPlatformArt.PCArt;
		this.XBoxArt = aPlatformArt.XBoxArt;
		this.PS3Art = aPlatformArt.PS3Art;
		this.RefreshArt();
	}

	function get XBoxArt(): String
	{
		return null;
	}

	function set XBoxArt(aValue: String): Void
	{
		if (aValue != "") 
		{
			this.XBoxButton = aValue;
		}
	}

	function get PS3Art(): String
	{
		return null;
	}

	function set PS3Art(aValue: String): Void
	{
		if (aValue != "") 
		{
			this.PS3Button = aValue;
		}
	}

	function get PCArt(): String
	{
		return null;
	}

	function set PCArt(aValue: String): Void
	{
		if (aValue != "") 
		{
			this.PCButton = aValue;
		}
	}

}
