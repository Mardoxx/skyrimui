import gfx.managers.FocusHandler;

class RaceNarrowPanel extends Shared.CenteredList
{
	var moveListDown;
	var moveListUp;

	function RaceNarrowPanel()
	{
		super();
	}

	function SetEntry(aEntryClip: MovieClip, aEntryObject: Object): Void
	{
		super.SetEntry(aEntryClip, aEntryObject);
		aEntryClip.EquipIcon_mc.gotoAndStop("None");
	}

	function onLoad(): Void
	{
		Mouse.addListener(this);
	}

	function onPress(): Void
	{
		var target: Object = Mouse.getTopMostEntity();
		
		for(var target: Object = Mouse.getTopMostEntity(); target != undefined; target = target._parent) {
			if (target == _root.RaceSexMenuBaseInstance.RaceSexPanelsInstance.PanelTwoNarrowInstance.List_mc.BottomHalf) {
				moveListUp();
				break;
			} else if (target == _root.RaceSexMenuBaseInstance.RaceSexPanelsInstance.PanelTwoNarrowInstance.List_mc.TopHalf) {
				moveListDown();
				break;
			}
		}
		FocusHandler.instance.setFocus(this, 0);
	}

}
