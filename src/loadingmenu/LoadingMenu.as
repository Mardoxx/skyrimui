import Components.Meter;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;

class LoadingMenu extends MovieClip
{
	var LevelMeterRect: MovieClip;
	var LevelMeter_mc: Meter;
	var LoadingText: TextField;
	var LoadingTextFader: MovieClip;
	var bFadedIn: Boolean;

	function LoadingMenu()
	{
		super();
		LoadingText = LoadingTextFader.LoadingText.textField;
		bFadedIn = false;
	}

	function InitExtensions()
	{
		GlobalFunc.SetLockFunction();
		LevelMeterRect.Lock("TR");
		LoadingTextFader.Lock("BR");
		LoadingText.textAutoSize = "shrink";
		LoadingText.verticalAlign = "bottom";
		LoadingText.SetText(" ");
		LevelMeter_mc = new Meter(LevelMeterRect.LevelProgressBar);
	}

	function SetLevelProgress(afCurrentLevel, afLevelProgress)
	{
		LevelMeterRect.LevelNumberLabel.SetText(afCurrentLevel);
		LevelMeter_mc.SetPercent(afLevelProgress);
	}

	function SetLoadingText(astrText: String): Void
	{
		if (astrText != undefined) {
			LoadingText.SetText(astrText);
			return;
		}
		LoadingText.SetText(" ");
	}

	function refreshLoadingText(): Void
	{
		GameDelegate.call("RequestLoadingText", [], this, "SetLoadingText");
		LoadingTextFader.gotoAndPlay("fadeIn");
	}

	function FadeInMenu(): Void
	{
		if (bFadedIn) {
			return;
		}
		GameDelegate.call("RequestPlayerInfo", [], this, "SetLevelProgress");
		refreshLoadingText();
		_parent.gotoAndPlay("fadeIn");
		bFadedIn = true;
	}

	function FadeOutMenu(): Void
	{
		if (bFadedIn) {
			_parent.gotoAndPlay("fadeOut");
			bFadedIn = false;
		}
	}

}
