import gfx.managers.FocusHandler;
import gfx.io.GameDelegate;
import gfx.ui.NavigationCode;

class SleepWaitMenu extends MovieClip
{
	var ButtonRect: MovieClip;
	var CurrentTime: TextField;
	var HoursSlider: MovieClip;
	var HoursText: TextField;
	var QuestionInstance: TextField;
	var bDisableControls: Boolean;

	function SleepWaitMenu()
	{
		super();
		HoursSlider = HoursSlider;
		HoursText = HoursText;
		CurrentTime = CurrentTime;
		bDisableControls = false;
	}

	function InitExtensions(): Void
	{
		Mouse.addListener(this);
		FocusHandler.instance.setFocus(HoursSlider, 0);
		HoursSlider.addEventListener("change", this, "sliderChange");
		HoursSlider.scrollWheel = function ()
		{
		};
		ButtonRect.AcceptMouseButton.addEventListener("click", this, "onOKPress");
		ButtonRect.CancelMouseButton.addEventListener("click", this, "onCancelPress");
		ButtonRect.AcceptMouseButton.SetPlatform(0, false);
		ButtonRect.CancelMouseButton.SetPlatform(0, false);
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var handledInput: Boolean = false;
		if (!disableControls && pathToFocus != undefined && pathToFocus.length > 0) {
			handledInput = pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		if (!handledInput && Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			switch(details.navEquivalent) {
				case NavigationCode.TAB:
					onCancelPress();
					break;
				case NavigationCode.ENTER:
					onOKPress();
					break;
				case NavigationCode.PAGE_UP:
				case NavigationCode.GAMEPAD_R1:
					if (!disableControls) {
						modifySliderValue(4);
					}
					break;
				case NavigationCode.PAGE_DOWN:
				case NavigationCode.GAMEPAD_L1:
					if (!disableControls) {
						modifySliderValue(-4);
					}
					break;
			}
		}
		return true;
	}

	function get disableControls(): Boolean
	{
		return bDisableControls;
	}

	function set disableControls(abFlag: Boolean): Void
	{
		bDisableControls = abFlag;
		if (abFlag) {
			HoursSlider.thumb.disabled = true;
			HoursSlider.track.disabled = true;
			ButtonRect.AcceptMouseButton.disabled = true;
		}
	}

	function modifySliderValue(aiDelta: Number): Void
	{
		HoursSlider.value = HoursSlider.value + aiDelta;
		sliderChange();
	}

	function onMouseWheel(aiWheelVal: Number): Void
	{
		if (disableControls) {
			return;
		}
		HoursSlider.value = HoursSlider.value + aiWheelVal;
		sliderChange();
	}

	function getSliderValue(): Number
	{
		return Math.floor(HoursSlider.value);
	}

	function sliderChange(event: Object): Void
	{
		var hours = Number(HoursText.text);
		HoursText.text = Math.floor(HoursSlider.value).toString();
		if (hours != Math.floor(HoursSlider.value)) 
		{
			GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
		}
	}

	function onOKPress(event: Object): Void
	{
		if (disableControls) {
			return;
		}
		disableControls = true;
		GameDelegate.call("OK", [getSliderValue()]);
	}

	function onCancelPress(event: Object): Void
	{
		GameDelegate.call("Cancel", []);
	}

	function SetCurrentTime(aTime: Number): Void
	{
		CurrentTime.SetText(aTime);
	}

	function SetSleeping(aSleeping: Boolean): Void
	{
		var waitText: String = aSleeping ? "$Rest how long?" : "$Wait how long?";
		QuestionInstance.SetText(waitText);
	}

	function SetPlatform(aiPlatformIndex: Number, abPS3Switch: Boolean): Void
	{
		ButtonRect.AcceptGamepadButton._visible = aiPlatformIndex != 0;
		ButtonRect.CancelGamepadButton._visible = aiPlatformIndex != 0;
		ButtonRect.AcceptMouseButton._visible = aiPlatformIndex == 0;
		ButtonRect.CancelMouseButton._visible = aiPlatformIndex == 0;
		if (aiPlatformIndex != 0) {
			ButtonRect.AcceptGamepadButton.SetPlatform(aiPlatformIndex, abPS3Switch);
			ButtonRect.CancelGamepadButton.SetPlatform(aiPlatformIndex, abPS3Switch);
		}
	}

}
