dynamic class RaceNarrowPanel extends Shared.CenteredList
{
	var moveListDown;
	var moveListUp;

	function RaceNarrowPanel()
	{
		super();
	}

	function SetEntry(aEntryClip, aEntryObject)
	{
		super.SetEntry(aEntryClip, aEntryObject);
		aEntryClip.EquipIcon_mc.gotoAndStop("None");
	}

	function onLoad()
	{
		Mouse.addListener(this);
	}

	function onPress()
	{
		var __reg3 = Mouse.getTopMostEntity();
		while (__reg3) 
		{
			if (__reg3 == _root.RaceSexMenuBaseInstance.RaceSexPanelsInstance.PanelTwoNarrowInstance.List_mc.BottomHalf) 
			{
				this.moveListUp();
				break;
			}
			else if (__reg3 == _root.RaceSexMenuBaseInstance.RaceSexPanelsInstance.PanelTwoNarrowInstance.List_mc.TopHalf) 
			{
				this.moveListDown();
				break;
			}
			__reg3 = __reg3._parent;
		}
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
	}

}
