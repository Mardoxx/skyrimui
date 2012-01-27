import gfx.events.EventDispatcher;

class Shared.ButtonChange extends gfx.events.EventDispatcher
{
	static var PLATFORM_PC: Number = 0;
	static var PLATFORM_PC_GAMEPAD: Number = 1;
	static var PLATFORM_360: Number = 2;
	static var PLATFORM_PS3: Number = 3;
	var iCurrPlatform = Shared.ButtonChange.PLATFORM_360;
	var dispatchEvent;

	function ButtonChange()
	{
		super();
		EventDispatcher.initialize(this);
	}

	function get Platform()
	{
		return iCurrPlatform;
	}

	function IsGamepadConnected()
	{
		return iCurrPlatform == Shared.ButtonChange.PLATFORM_PC_GAMEPAD || iCurrPlatform == Shared.ButtonChange.PLATFORM_360 || iCurrPlatform == Shared.ButtonChange.PLATFORM_PS3;
	}

	function SetPlatform(aSetPlatform: Number, aSetSwapPS3: Boolean)
	{
		iCurrPlatform = aSetPlatform;
		dispatchEvent({target: this, type: "platformChange", aPlatform: aSetPlatform, aSwapPS3: aSetSwapPS3});
	}

	function SetPS3Swap(aSwap)
	{
		dispatchEvent({target: this, type: "SwapPS3Button", Boolean: aSwap});
	}

}
