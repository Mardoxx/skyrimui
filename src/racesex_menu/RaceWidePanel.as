dynamic class RaceWidePanel extends FilteredList
{
	var EntriesA;
	var GetNextFilterMatch;
	var GetPrevFilterMatch;
	var SelectedEntry;
	var UpdateList;
	var callbackName;
	var dispatchEvent;
	var iSelectedIndex;
	var position;
	var sliderID;

	function RaceWidePanel()
	{
		super();
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var __reg5 = false;
		super.handleInput(details, pathToFocus);
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.LEFT || details.navEquivalent == gfx.ui.NavigationCode.RIGHT || details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_R1 || details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_L1) 
			{
				var __reg4 = false;
				if (details.navEquivalent == gfx.ui.NavigationCode.LEFT && this.SelectedEntry.SliderInstance.position != this.SelectedEntry.SliderInstance.minimum) 
				{
					__reg4 = true;
					this.SelectedEntry.SliderInstance.position = this.SelectedEntry.SliderInstance.position - this.EntriesA[this.iSelectedIndex].interval;
				}
				else if (details.navEquivalent == gfx.ui.NavigationCode.RIGHT && this.SelectedEntry.SliderInstance.position != this.SelectedEntry.SliderInstance.maximum) 
				{
					__reg4 = true;
					this.SelectedEntry.SliderInstance.position = this.SelectedEntry.SliderInstance.position + this.EntriesA[this.iSelectedIndex].interval;
				}
				else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_L1 && this.SelectedEntry.SliderInstance.position != this.SelectedEntry.SliderInstance.minimum) 
				{
					__reg4 = true;
					this.SelectedEntry.SliderInstance.position = this.SelectedEntry.SliderInstance.position - this.EntriesA[this.iSelectedIndex].interval * 5;
				}
				else if (details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_R1 && this.SelectedEntry.SliderInstance.position != this.SelectedEntry.SliderInstance.maximum) 
				{
					__reg4 = true;
					this.SelectedEntry.SliderInstance.position = this.SelectedEntry.SliderInstance.position + this.EntriesA[this.iSelectedIndex].interval * 5;
				}
				if (__reg4) 
				{
					gfx.io.GameDelegate.call(this.EntriesA[this.iSelectedIndex].callbackName, [this.SelectedEntry.SliderInstance.position, this.EntriesA[this.iSelectedIndex].sliderID]);
					gfx.io.GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
				}
				this.EntriesA[this.iSelectedIndex].position = this.SelectedEntry.SliderInstance.position;
				__reg5 = true;
			}
		}
		return __reg5;
	}

	function moveListUp()
	{
		var __reg2 = this.GetNextFilterMatch(this.iSelectedIndex);
		if (__reg2 != undefined) 
		{
			this.iSelectedIndex = __reg2;
			this.UpdateList();
			this.dispatchEvent({type: "listMovedUp"});
		}
	}

	function moveListDown()
	{
		var __reg2 = this.GetPrevFilterMatch(this.iSelectedIndex);
		if (__reg2 != undefined) 
		{
			this.iSelectedIndex = __reg2;
			this.UpdateList();
			this.dispatchEvent({type: "listMovedDown"});
		}
	}

	function SetEntry(aEntryClip, aEntryObject)
	{
		if (aEntryObject.text != undefined) 
		{
			aEntryClip.textField.SetText(aEntryObject.text);
			aEntryClip.SliderInstance._alpha = 100;
			aEntryClip.SliderInstance.minimum = aEntryObject.sliderMin;
			aEntryClip.SliderInstance.maximum = aEntryObject.sliderMax;
			aEntryClip.SliderInstance.position = aEntryObject.position;
			aEntryClip.SliderInstance.snapInterval = aEntryObject.interval;
			aEntryClip.SliderInstance.callbackName = aEntryObject.callbackName;
			aEntryClip.SliderInstance.sliderID = aEntryObject.sliderID;
			aEntryClip.SliderInstance.changedCallback = function ()
			{
				gfx.io.GameDelegate.call(this.callbackName, [this.position, this.sliderID]);
				aEntryObject.position = this.position;
			}
			;
			aEntryClip.SliderInstance.addEventListener("change", aEntryClip.SliderInstance, "changedCallback");
			return;
		}
		aEntryClip.textField.SetText(" ");
		aEntryClip.SliderInstance._alpha = 0;
	}

	function onLoad()
	{
		Mouse.addListener(this);
	}

	function onPress()
	{
		var __reg2 = Mouse.getTopMostEntity();
		if (__reg2._parent.onPress) 
		{
			__reg2._parent.onPress();
		}
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
	}

	function onRelease()
	{
		var __reg2 = Mouse.getTopMostEntity();
		if (__reg2._parent.onRelease) 
		{
			__reg2._parent.onRelease();
		}
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
	}

}
