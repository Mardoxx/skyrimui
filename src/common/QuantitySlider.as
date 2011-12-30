class QuantitySlider extends gfx.controls.Slider
{
	var dispatchEvent: Function;

	function QuantitySlider()
	{
		super();
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = super.handleInput(details, pathToFocus);
		if (!bHandledInput) 
		{
			if (Shared.GlobalFunc.IsKeyPressed(details)) 
			{
				if (details.navEquivalent == gfx.ui.NavigationCode.PAGE_DOWN || details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_L1) 
				{
					this.value = Math.floor(this.value - this.maximum / 4);
					this.dispatchEvent({type: "change"});
					bHandledInput = true;
				}
				else if (details.navEquivalent == gfx.ui.NavigationCode.PAGE_UP || details.navEquivalent == gfx.ui.NavigationCode.GAMEPAD_R1) 
				{
					this.value = Math.ceil(this.value + this.maximum / 4);
					this.dispatchEvent({type: "change"});
					bHandledInput = true;
				}
			}
		}
		return bHandledInput;
	}

}
