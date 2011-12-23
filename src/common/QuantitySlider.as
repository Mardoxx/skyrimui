dynamic class QuantitySlider extends gfx.controls.Slider
{
	var dispatchEvent;

	function QuantitySlider()
	{
		super();
	}

	function handleInput(details, pathToFocus)
	{
		var __reg4 = super.handleInput(details, pathToFocus);
		if (!__reg4) 
		{
			if (Shared.GlobalFunc.IsKeyPressed(details)) 
			{
				if (details.navEquivalent == gfx.ui.NavigationCode.PAGE_DOWN || details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_L1) 
				{
					this.value = Math.floor(this.value - this.maximum / 4);
					this.dispatchEvent({type: "change"});
					__reg4 = true;
				}
				else if (details.navEquivalent == gfx.ui.NavigationCode.PAGE_UP || details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_R1) 
				{
					this.value = Math.ceil(this.value + this.maximum / 4);
					this.dispatchEvent({type: "change"});
					__reg4 = true;
				}
			}
		}
		return __reg4;
	}

}
