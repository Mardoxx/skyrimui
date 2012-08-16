import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import Shared.GlobalFunc;

class RaceWidePanel extends FilteredList
{
	var EntriesA: Array;
	var SelectedEntry: MovieClip;
	var dispatchEvent: Function;
	var iSelectedIndex: Number;
	var position: Number;
	var sliderID: Number;

	function RaceWidePanel()
	{
		super();
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var handledInput: Boolean = false;
		super.handleInput(details, pathToFocus);
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.LEFT || details.navEquivalent == NavigationCode.RIGHT || details.navEquivalent == NavigationCode.GAMEPAD_R1 || details.navEquivalent == NavigationCode.GAMEPAD_L1) {
				var changeCat: Boolean = false;
				if (details.navEquivalent == NavigationCode.LEFT && SelectedEntry.SliderInstance.position != SelectedEntry.SliderInstance.minimum) {
					changeCat = true;
					SelectedEntry.SliderInstance.position = SelectedEntry.SliderInstance.position - EntriesA[iSelectedIndex].interval;
				} else if (details.navEquivalent == NavigationCode.RIGHT && SelectedEntry.SliderInstance.position != SelectedEntry.SliderInstance.maximum) {
					changeCat = true;
					SelectedEntry.SliderInstance.position = SelectedEntry.SliderInstance.position + EntriesA[iSelectedIndex].interval;
				} else if (details.navEquivalent == NavigationCode.GAMEPAD_L1 && SelectedEntry.SliderInstance.position != SelectedEntry.SliderInstance.minimum) {
					changeCat = true;
					SelectedEntry.SliderInstance.position = SelectedEntry.SliderInstance.position - EntriesA[iSelectedIndex].interval * 5;
				} else if (details.navEquivalent == NavigationCode.GAMEPAD_R1 && SelectedEntry.SliderInstance.position != SelectedEntry.SliderInstance.maximum) {
					changeCat = true;
					SelectedEntry.SliderInstance.position = SelectedEntry.SliderInstance.position + EntriesA[iSelectedIndex].interval * 5;
				}
				if (changeCat) {
					GameDelegate.call(EntriesA[iSelectedIndex].callbackName, [SelectedEntry.SliderInstance.position, EntriesA[iSelectedIndex].sliderID]);
					GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
				}
				EntriesA[iSelectedIndex].position = SelectedEntry.SliderInstance.position;
				handledInput = true;
			}
		}
		return handledInput;
	}

	function moveListUp(): Void
	{
		var nextIdx: Number = GetNextFilterMatch(iSelectedIndex);
		if (nextIdx != undefined) {
			iSelectedIndex = nextIdx;
			UpdateList();
			dispatchEvent({type: "listMovedUp"});
		}
	}

	function moveListDown(): Void
	{
		var prevIdx: Number = GetPrevFilterMatch(iSelectedIndex);
		if (prevIdx != undefined) {
			iSelectedIndex = prevIdx;
			UpdateList();
			dispatchEvent({type: "listMovedDown"});
		}
	}

	function SetEntry(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		if (aEntryObject.text != undefined) {
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
				GameDelegate.call(aEntryClip.SliderInstance.callbackName, [position, sliderID]);
				aEntryObject.position = position;
			};
			aEntryClip.SliderInstance.addEventListener("change", aEntryClip.SliderInstance, "changedCallback");
			return;
		}
		aEntryClip.textField.SetText(" ");
		aEntryClip.SliderInstance._alpha = 0;
	}

	function onLoad(): Void
	{
		Mouse.addListener(this);
	}

	function onPress(): Void
	{
		var target: Object = Mouse.getTopMostEntity();
		if (target._parent.onPress) {
			target._parent.onPress();
		}
		FocusHandler.instance.setFocus(this, 0);
	}

	function onRelease(): Void
	{
		var target: Object = Mouse.getTopMostEntity();
		if (target._parent.onRelease) {
			target._parent.onRelease();
		}
		FocusHandler.instance.setFocus(this, 0);
	}

}
