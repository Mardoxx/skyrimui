class BookBottomBar extends MovieClip
{
	var ButtonRect: Object;
	var PageTurnButton: Components.CrossPlatformButtons;
	var TakeButton: Components.CrossPlatformButtons;

	function BookBottomBar()
	{
		super();
		this.PageTurnButton = this.ButtonRect.TurnPageButtonInstance;
		this.TakeButton = this.ButtonRect.TakeButtonInstance;
	}

	function InitExtensions(): Void
	{
		gfx.io.GameDelegate.addCallBack("ShowTakeButton", this, "ShowTakeButton");
		Shared.GlobalFunc.SetLockFunction();
		MovieClip(this).Lock("BL");
	}

	function ShowTakeButton(abShow: Boolean, abSteal: Boolean): Void
	{
		this.TakeButton.visible = abShow;
		this.TakeButton.label = abSteal ? "$Steal" : "$Take";
	}

	function SetPlatform(aiPlatformIndex: Number, abPS3Switch: Boolean): Void
	{
		this.PageTurnButton.SetPlatform(aiPlatformIndex, abPS3Switch);
		this.TakeButton.SetPlatform(aiPlatformIndex, abPS3Switch);
	}
}
