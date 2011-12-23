dynamic class WidgetOverlay.Utils
{
	static var TextureLoader = new MovieClipLoader();
	static var OverlayMap = new Object();

	function Utils()
	{
	}

	static function EmptyFunc()
	{
	}

	static function ShowOverlay(aOverlay, aX, aY, aWidth, aHeight)
	{
		var __reg2 = WidgetOverlay.Utils.OverlayMap[aOverlay];
		if (undefined == __reg2) 
		{
			var __reg3 = _root.attachMovie("Overlay", aOverlay, _root.getNextHighestDepth());
			__reg2 = new WidgetOverlay.Overlay(__reg3);
			WidgetOverlay.Utils.OverlayMap[aOverlay] = __reg2;
		}
		__reg2.SetPosition(aX, aY);
		__reg2.SetDimensions(aWidth, aHeight);
	}

	static function HideOverlay(aOverlay)
	{
		_root[aOverlay].removeMovieClip();
		WidgetOverlay.Utils.OverlayMap[aOverlay] = undefined;
	}

	static function AddWidget(aOverlay, aWidget, aSymbol)
	{
		return WidgetOverlay.Utils.OverlayMap[aOverlay].AddWidget(aWidget, aSymbol);
	}

	static function RemoveWidget(aOverlay, aWidget)
	{
		WidgetOverlay.Utils.OverlayMap[aOverlay].RemoveWidget(aWidget);
	}

	static function SetTextFormatProp(aOverlay, aTextWidget, aProp, aValue)
	{
		var __reg3 = _root[aOverlay][aTextWidget].TextFieldClip;
		var __reg2 = __reg3.getTextFormat();
		__reg2[aProp] = aValue;
		__reg3.setTextFormat(__reg2);
		__reg3.setNewTextFormat(__reg2);
	}

	static function SetPosition(aOverlay, aWidget, aX, aY)
	{
		var __reg2 = _root[aOverlay][aWidget];
		__reg2._x = aX;
		__reg2._y = aY;
	}

	static function SetOverlayFocus(aOverlay, abHasFocus)
	{
		var __reg1 = WidgetOverlay.Utils.OverlayMap[aOverlay];
		if (undefined != __reg1) 
		{
			__reg1.SetFocus(abHasFocus);
		}
	}

}
