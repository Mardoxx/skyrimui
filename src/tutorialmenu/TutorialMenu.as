import Shared.ButtonTextArtHolder;
import gfx.managers.FocusHandler;
import gfx.io.GameDelegate;

class TutorialMenu extends MovieClip
{
	var ButtonArtHolder: ButtonTextArtHolder;
	var ButtonHolder: ButtonTextArtHolder;
	var ButtonRect: MovieClip;
	var HelpScrollingText: TextField;
	var HelpText: TextField;
	var TitleText: TextField;

	function TutorialMenu()
	{
		super();
		HelpScrollingText = HelpText;
		ButtonHolder = ButtonArtHolder;
	}

	function InitExtensions(): Void
	{
		TitleText.textAutoSize = "shrink";
		ButtonRect.ExitMouseButton.addEventListener("press", this, "onExitPress");
		ButtonRect.ExitMouseButton.SetPlatform(0, false);
		FocusHandler.instance.setFocus(HelpScrollingText, 0);
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		ButtonRect.ExitGamepadButton._visible = aiPlatform != 0;
		ButtonRect.ExitMouseButton._visible = aiPlatform == 0;
		if (aiPlatform != 0) 
		{
			ButtonRect.ExitGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
		}
	}

	function ApplyButtonArt(): Void
	{
		var buttonStr: String = ButtonHolder.CreateButtonArt(HelpScrollingText.textField);
		if (buttonStr != undefined) 
		{
			HelpScrollingText.textField.html = true;
			HelpScrollingText.textField.htmlText = buttonStr;
		}
	}

	function onExitPress(): Void
	{
		GameDelegate.call("CloseMenu", []);
	}

}
