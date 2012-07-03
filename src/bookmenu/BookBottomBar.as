import Components.CrossPlatformButtons;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;

class BookBottomBar extends MovieClip
{
	/* Stage Elements */
	var ButtonRect: MovieClip;
	
	var PageTurnButton: CrossPlatformButtons;
	var TakeButton: CrossPlatformButtons;

	function BookBottomBar()
	{
		super();
		PageTurnButton = ButtonRect.TurnPageButtonInstance;
		TakeButton = ButtonRect.TakeButtonInstance;
	}

	function InitExtensions(): Void
	{
		GameDelegate.addCallBack("ShowTakeButton", this, "ShowTakeButton");
		GlobalFunc.SetLockFunction();
		MovieClip(this).Lock("BL");
	}

	function ShowTakeButton(abShow: Boolean, abSteal: Boolean): Void
	{
		TakeButton.visible = abShow;
		TakeButton.label = abSteal ? "$Steal" : "$Take";
	}

	function SetPlatform(aiPlatformIndex: Number, abPS3Switch: Boolean): Void
	{
		PageTurnButton.SetPlatform(aiPlatformIndex, abPS3Switch);
		TakeButton.SetPlatform(aiPlatformIndex, abPS3Switch);
	}
}
