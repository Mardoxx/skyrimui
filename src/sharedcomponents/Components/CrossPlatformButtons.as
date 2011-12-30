dynamic class Components.CrossPlatformButtons extends gfx.controls.Button
{
	static var ButtonArt = {A_360: "A xb360", B_360: "B xb360", X_360: "X xb360", Y_360: "Y xb360", LT_360: "LT xb360", RT_360: "RT xb360", LB_360: "LB xb360", RB_360: "RB xb360", X_PS3: "X ps3", O_PS3: "O ps3", SQUARE_PS3: "Square ps3", TRIANGLE_PS3: "Triangle ps3", L1_PS3: "L1 ps3", L2_PS3: "L2 ps3", R1_PS3: "R1 ps3", R2_PS3: "R2 ps3", E_PC: "E", SPACE_PC: "Space", ENTER_PC: "Enter", BACKSPACE_PC: "Backspace", UP_PC: "UP arrow", DOWN_PC: "Down arrow", LEFT_PC: "Left arrow", RIGHT_PC: "Right arrow", W_PC: "W", A_PC: "A", S_PC: "S", D_PC: "D", F_PC: "F", C_PC: "C", TAB_PC: "Tab", WHEEL_PC: "Wheel mouse"};
	var ButtonArt_mc;
	var PCButton;
	var PS3Button;
	var PS3ButtonSwapped;
	var XBoxButton;
	var attachMovie;
	var getNextHighestDepth;

	function CrossPlatformButtons()
	{
		super();
		this.SetPlatform({aPlatform: Shared.ButtonChange.PLATFORM_360, aSwapPS3: false});
	}

	function SetPlatform(aObj: Object, aSwapPS3: Boolean)
	{
		if (undefined != this.ButtonArt_mc) 
		{
			this.ButtonArt_mc.removeMovieClip();
		}
		if ((__reg0 = aObj.aPlatform) === Shared.ButtonChange.PLATFORM_PC) 
		{
			if (this.PCButton != "None") 
			{
				this.ButtonArt_mc = this.attachMovie(Components.CrossPlatformButtons.ButtonArt[this.PCButton], "ButtonArt", this.getNextHighestDepth());
			}
		}
		else if (__reg0 === Shared.ButtonChange.PLATFORM_360) 
		{
			this.ButtonArt_mc = this.attachMovie(Components.CrossPlatformButtons.ButtonArt[this.XBoxButton], "ButtonArt", this.getNextHighestDepth());
		}
		else if (__reg0 === Shared.ButtonChange.PLATFORM_PS3) 
		{
			this.ButtonArt_mc = this.attachMovie(Components.CrossPlatformButtons.ButtonArt[aSwapPS3 ? this.PS3ButtonSwapped : this.PS3Button], "ButtonArt", this.getNextHighestDepth());
		}
		this.ButtonArt_mc._x = this.ButtonArt_mc._x - this.ButtonArt_mc._width;
		this.ButtonArt_mc._y = this.ButtonArt_mc._y - this.ButtonArt_mc._height / 2;
	}

	function SetPS3Swap(aObj)
	{
		if (undefined != this.ButtonArt_mc) 
		{
			this.ButtonArt_mc.removeMovieClip();
		}
		this.ButtonArt_mc = this.attachMovie(Components.CrossPlatformButtons.ButtonArt[aObj.aSwap ? this.PS3Button : this.PS3ButtonSwapped], "ButtonArt", this.getNextHighestDepth());
		this.ButtonArt_mc._x = this.ButtonArt_mc._x - this.ButtonArt_mc._width;
		this.ButtonArt_mc._y = this.ButtonArt_mc._y - this.ButtonArt_mc._height / 2;
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

	function get PS3ArtSwapped()
	{
		return null;
	}

	function set PS3ArtSwapped(aValue)
	{
		if (aValue != "") 
		{
			this.PS3ButtonSwapped = aValue;
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
