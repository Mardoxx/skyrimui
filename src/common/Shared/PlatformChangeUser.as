class Shared.PlatformChangeUser extends MovieClip
{
	static var PlatformChange: Shared.ButtonChange;
	function PlatformChangeUser()
	{
		super();
		Shared.PlatformChangeUser.PlatformChange = new Shared.ButtonChange();
	}

	function RegisterPlatformChangeListener(aCrossPlatformButton)
	{
		Shared.PlatformChangeUser.PlatformChange.addEventListener("platformChange", aCrossPlatformButton, "SetPlatform");
		Shared.PlatformChangeUser.PlatformChange.addEventListener("SwapPS3Button", aCrossPlatformButton, "SetPS3Swap");
	}

}
