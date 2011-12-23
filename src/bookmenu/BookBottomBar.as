dynamic class BookBottomBar extends MovieClip
{
	var ButtonRect;
	var PageTurnButton;
	var TakeButton;

	function BookBottomBar()
	{
		super();
		this.PageTurnButton = this.ButtonRect.TurnPageButtonInstance;
		this.TakeButton = this.ButtonRect.TakeButtonInstance;
	}

	function InitExtensions()
	{
		gfx.io.GameDelegate.addCallBack("ShowTakeButton", this, "ShowTakeButton");
		Shared.GlobalFunc.SetLockFunction();
		MovieClip(this).Lock("BL");
	}

	function ShowTakeButton(abShow, abSteal)
	{
		this.TakeButton.visible = abShow;
		this.TakeButton.label = abSteal ? "$Steal" : "$Take";
	}

	function SetPlatform(aiPlatformIndex, abPS3Switch)
	{
		this.PageTurnButton.SetPlatform(aiPlatformIndex, abPS3Switch);
		this.TakeButton.SetPlatform(aiPlatformIndex, abPS3Switch);
	}

}
