dynamic class WidgetOverlay.OverlayButtonBar extends gfx.controls.ButtonBar
{
	static var BUTTON_DEFINITION_STRIDE: Number = 2;
	var CallbackFunction;
	var addEventListener;
	var validateNow;

	function OverlayButtonBar()
	{
		super();
		this.itemRenderer = "OverlayButton";
		this.addEventListener("itemClick", this, "ButtonCallback");
	}

	function SetupButtons()
	{
		var __reg7 = arguments.length / WidgetOverlay.OverlayButtonBar.BUTTON_DEFINITION_STRIDE;
		var __reg8 = new Array(__reg7);
		var __reg3 = 0;
		while (__reg3 < __reg7) 
		{
			var __reg4 = {label: arguments[__reg3 * WidgetOverlay.OverlayButtonBar.BUTTON_DEFINITION_STRIDE], data: arguments[__reg3 * WidgetOverlay.OverlayButtonBar.BUTTON_DEFINITION_STRIDE + 1]};
			__reg8[__reg3] = __reg4;
			++__reg3;
		}
		this.dataProvider = __reg8;
		this.validateNow();
	}

	function SetCallbackFunction(aOverlay, aWidget)
	{
		this.CallbackFunction = aOverlay.concat(".", aWidget);
	}

	function ButtonCallback(aEvent)
	{
		gfx.io.GameDelegate.call(this.CallbackFunction, [aEvent.index, aEvent.data]);
	}

}
