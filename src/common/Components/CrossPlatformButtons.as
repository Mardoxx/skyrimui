dynamic class Components.CrossPlatformButtons extends gfx.controls.Button
{
	var ButtonArt;
	var ButtonArt_mc;
	var CurrentPlatform;
	var PCButton;
	var PS3Button;
	var PS3Swapped;
	var XBoxButton;
	var _height;
	var _parent;
	var attachMovie;
	var border;
	var getNextHighestDepth;

	function CrossPlatformButtons()
	{
		super();
	}

	function onLoad()
	{
		super.onLoad();
		if (this._parent.onButtonLoad != undefined) 
		{
			this._parent.onButtonLoad(this);
		}
	}

	function SetPlatform(aiPlatform, aSwapPS3)
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

	function RefreshArt()
	{
		if (undefined != this.ButtonArt) 
		{
			this.ButtonArt.removeMovieClip();
		}
		if ((__reg0 = this.CurrentPlatform) === Shared.ButtonChange.PLATFORM_PC) 
		{
			if (this.PCButton != "None") 
			{
				this.ButtonArt_mc = this.attachMovie(this.PCButton, "ButtonArt", this.getNextHighestDepth());
			}
		}
		else if (__reg0 === Shared.ButtonChange.PLATFORM_PC_GAMEPAD) 
		{
			this.ButtonArt_mc = this.attachMovie(this.XBoxButton, "ButtonArt", this.getNextHighestDepth());
		}
		else if (__reg0 === Shared.ButtonChange.PLATFORM_360) 
		{
			this.ButtonArt_mc = this.attachMovie(this.XBoxButton, "ButtonArt", this.getNextHighestDepth());
		}
		else if (__reg0 === Shared.ButtonChange.PLATFORM_PS3) 
		{
			var __reg2 = this.PS3Button;
			if (this.PS3Swapped) 
			{
				if (__reg2 == "PS3_A") 
				{
					__reg2 = "PS3_B";
				}
				else if (__reg2 == "PS3_B") 
				{
					__reg2 = "PS3_A";
				}
			}
			this.ButtonArt_mc = this.attachMovie(__reg2, "ButtonArt", this.getNextHighestDepth());
		}
		this.ButtonArt_mc._x = this.ButtonArt_mc._x - this.ButtonArt_mc._width;
		this.ButtonArt_mc._y = (this._height - this.ButtonArt_mc._height) / 2;
		this.border._visible = false;
	}

	function GetArt()
	{
		return {PCArt: this.PCButton, XBoxArt: this.XBoxButton, PS3Art: this.PS3Button};
	}

	function SetArt(aPlatformArt)
	{
		this.PCArt = aPlatformArt.PCArt;
		this.XBoxArt = aPlatformArt.XBoxArt;
		this.PS3Art = aPlatformArt.PS3Art;
		this.RefreshArt();
	}

	function get XBoxArt()
	{
		return null;
	}

	function set XBoxArt(aValue)
	{
		if (aValue != "") 
		{
			this.XBoxButton = aValue;
		}
	}

	function get PS3Art()
	{
		return null;
	}

	function set PS3Art(aValue)
	{
		if (aValue != "") 
		{
			this.PS3Button = aValue;
		}
	}

	function get PCArt()
	{
		return null;
	}

	function set PCArt(aValue)
	{
		if (aValue != "") 
		{
			this.PCButton = aValue;
		}
	}

}
