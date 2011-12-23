dynamic class LoadingMenu extends MovieClip
{
	var LevelMeterRect;
	var LevelMeter_mc;
	var LoadingText;
	var LoadingTextFader;
	var _parent;
	var bFadedIn;

	function LoadingMenu()
	{
		super();
		this.LoadingText = this.LoadingTextFader.LoadingText.textField;
		this.bFadedIn = false;
	}

	function InitExtensions()
	{
		Shared.GlobalFunc.SetLockFunction();
		this.LevelMeterRect.Lock("TR");
		this.LoadingTextFader.Lock("BR");
		this.LoadingText.textAutoSize = "shrink";
		this.LoadingText.verticalAlign = "bottom";
		this.LoadingText.SetText(" ");
		this.LevelMeter_mc = new Components.Meter(this.LevelMeterRect.LevelProgressBar);
	}

	function SetLevelProgress(afCurrentLevel, afLevelProgress)
	{
		this.LevelMeterRect.LevelNumberLabel.SetText(afCurrentLevel);
		this.LevelMeter_mc.SetPercent(afLevelProgress);
	}

	function SetLoadingText(astrText)
	{
		if (astrText != undefined) 
		{
			this.LoadingText.SetText(astrText);
			return;
		}
		this.LoadingText.SetText(" ");
	}

	function refreshLoadingText()
	{
		gfx.io.GameDelegate.call("RequestLoadingText", [], this, "SetLoadingText");
		this.LoadingTextFader.gotoAndPlay("fadeIn");
	}

	function FadeInMenu()
	{
		if (this.bFadedIn) 
		{
			return;
		}
		gfx.io.GameDelegate.call("RequestPlayerInfo", [], this, "SetLevelProgress");
		this.refreshLoadingText();
		this._parent.gotoAndPlay("fadeIn");
		this.bFadedIn = true;
	}

	function FadeOutMenu()
	{
		if (this.bFadedIn) 
		{
			this._parent.gotoAndPlay("fadeOut");
			this.bFadedIn = false;
		}
	}

}
