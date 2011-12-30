dynamic class SleepWaitMenu extends MovieClip
{
	var ButtonRect;
	var CurrentTime;
	var HoursSlider;
	var HoursText;
	var QuestionInstance;
	var bDisableControls;

	function SleepWaitMenu()
	{
		super();
		this.HoursSlider = this.HoursSlider;
		this.HoursText = this.HoursText;
		this.CurrentTime = this.CurrentTime;
		this.bDisableControls = false;
	}

	function InitExtensions()
	{
		Mouse.addListener(this);
		gfx.managers.FocusHandler.instance.setFocus(this.HoursSlider, 0);
		this.HoursSlider.addEventListener("change", this, "sliderChange");
		this.HoursSlider.scrollWheel = function ()
		{
		}
		;
		this.ButtonRect.AcceptMouseButton.addEventListener("click", this, "onOKPress");
		this.ButtonRect.CancelMouseButton.addEventListener("click", this, "onCancelPress");
		this.ButtonRect.AcceptMouseButton.SetPlatform(0, false);
		this.ButtonRect.CancelMouseButton.SetPlatform(0, false);
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var __reg3 = false;
		if (!this.disableControls && pathToFocus != undefined && pathToFocus.length > 0) 
		{
			__reg3 = pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		if (!__reg3 && Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if ((__reg0 = details.navEquivalent) === gfx.ui.NavigationCode.TAB) 
			{
				this.onCancelPress();
			}
			else if (__reg0 === gfx.ui.NavigationCode.ENTER) 
			{
				this.onOKPress();
			}
			else if (__reg0 === gfx.ui.NavigationCode.PAGE_UP) 
			{
				if (!this.disableControls) 
				{
					this.modifySliderValue(4);
				}
			}
			else if (__reg0 === gfx.ui.NavigationCode.GAMEPAD_R1) 
			{
				if (!this.disableControls) 
				{
					this.modifySliderValue(4);
				}
			}
			else if (__reg0 === gfx.ui.NavigationCode.PAGE_DOWN) 
			{
				if (!this.disableControls) 
				{
					this.modifySliderValue(-4);
				}
			}
			else if (__reg0 === gfx.ui.NavigationCode.GAMEPAD_L1) 
			{
				if (!this.disableControls) 
				{
					this.modifySliderValue(-4);
				}
			}
		}
		return true;
	}

	function get disableControls()
	{
		return this.bDisableControls;
	}

	function set disableControls(abFlag)
	{
		this.bDisableControls = abFlag;
		if (abFlag) 
		{
			this.HoursSlider.thumb.disabled = true;
			this.HoursSlider.track.disabled = true;
			this.ButtonRect.AcceptMouseButton.disabled = true;
		}
	}

	function modifySliderValue(aiDelta)
	{
		this.HoursSlider.value = this.HoursSlider.value + aiDelta;
		this.sliderChange();
	}

	function onMouseWheel(aiWheelVal)
	{
		if (this.disableControls) 
		{
			return;
		}
		this.HoursSlider.value = this.HoursSlider.value + aiWheelVal;
		this.sliderChange();
	}

	function getSliderValue()
	{
		return Math.floor(this.HoursSlider.value);
	}

	function sliderChange(event)
	{
		var __reg2 = Number(this.HoursText.text);
		this.HoursText.text = Math.floor(this.HoursSlider.value).toString();
		if (__reg2 != Math.floor(this.HoursSlider.value)) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
		}
	}

	function onOKPress(event)
	{
		if (this.disableControls) 
		{
			return;
		}
		this.disableControls = true;
		gfx.io.GameDelegate.call("OK", [this.getSliderValue()]);
	}

	function onCancelPress(event)
	{
		gfx.io.GameDelegate.call("Cancel", []);
	}

	function SetCurrentTime(aTime)
	{
		this.CurrentTime.SetText(aTime);
	}

	function SetSleeping(aSleeping)
	{
		var __reg2 = aSleeping ? "$Rest how long?" : "$Wait how long?";
		this.QuestionInstance.SetText(__reg2);
	}

	function SetPlatform(aiPlatformIndex: Number, abPS3Switch: Boolean)
	{
		this.ButtonRect.AcceptGamepadButton._visible = aiPlatformIndex != 0;
		this.ButtonRect.CancelGamepadButton._visible = aiPlatformIndex != 0;
		this.ButtonRect.AcceptMouseButton._visible = aiPlatformIndex == 0;
		this.ButtonRect.CancelMouseButton._visible = aiPlatformIndex == 0;
		if (aiPlatformIndex != 0) 
		{
			this.ButtonRect.AcceptGamepadButton.SetPlatform(aiPlatformIndex, abPS3Switch);
			this.ButtonRect.CancelGamepadButton.SetPlatform(aiPlatformIndex, abPS3Switch);
		}
	}

}
