dynamic class TutorialMenu extends MovieClip
{
	var ButtonArtHolder;
	var ButtonHolder;
	var ButtonRect;
	var HelpScrollingText;
	var HelpText;
	var TitleText;

	function TutorialMenu()
	{
		super();
		this.HelpScrollingText = this.HelpText;
		this.ButtonHolder = this.ButtonArtHolder;
	}

	function InitExtensions()
	{
		this.TitleText.textAutoSize = "shrink";
		this.ButtonRect.ExitMouseButton.addEventListener("press", this, "onExitPress");
		this.ButtonRect.ExitMouseButton.SetPlatform(0, false);
		gfx.managers.FocusHandler.instance.setFocus(this.HelpScrollingText, 0);
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		this.ButtonRect.ExitGamepadButton._visible = aiPlatform != 0;
		this.ButtonRect.ExitMouseButton._visible = aiPlatform == 0;
		if (aiPlatform != 0) 
		{
			this.ButtonRect.ExitGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
		}
	}

	function ApplyButtonArt()
	{
		var __reg2 = this.ButtonHolder.CreateButtonArt(this.HelpScrollingText.textField);
		if (__reg2 != undefined) 
		{
			this.HelpScrollingText.textField.html = true;
			this.HelpScrollingText.textField.htmlText = __reg2;
		}
	}

	function onExitPress()
	{
		gfx.io.GameDelegate.call("CloseMenu", []);
	}

}
