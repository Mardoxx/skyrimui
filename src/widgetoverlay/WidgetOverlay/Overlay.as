dynamic class WidgetOverlay.Overlay
{
	var BackgroundClip;
	var Clip;
	var FocusClip;
	var _NumWidgets;

	function Overlay(aMovie)
	{
		this.Clip = aMovie;
		this.BackgroundClip = this.Clip.Background;
		this._NumWidgets = 0;
		this.FocusClip = this.Clip.Focus;
		this.FocusClip._visible = false;
	}

	function AddWidget(aWidgetName, aSymbol)
	{
		var __reg4 = this.Clip.getNextHighestDepth();
		var __reg2 = aWidgetName + __reg4.toString();
		var __reg3 = undefined;
		if (undefined != aSymbol && aSymbol.length > 0) 
		{
			__reg3 = this.Clip.attachMovie(aSymbol, __reg2, __reg4);
		}
		else 
		{
			__reg3 = this.Clip.createEmptyMovieClip(__reg2, __reg4);
		}
		if (undefined == __reg3) 
		{
			__reg2 = new String();
		}
		else 
		{
			++this._NumWidgets;
		}
		return __reg2;
	}

	function RemoveWidget(aWidgetName)
	{
		if (undefined != this.Clip[aWidgetName]) 
		{
			this.Clip[aWidgetName].removeMovieClip();
			--this._NumWidgets;
		}
	}

	function SetPosition(aX, aY)
	{
		this.Clip._x = aX;
		this.Clip._y = aY;
	}

	function SetDimensions(aWidth, aHeight)
	{
		this.BackgroundClip._width = aWidth;
		this.BackgroundClip._height = aHeight;
	}

	function SetFocus(abFocus)
	{
		this.FocusClip._visible = abFocus;
	}

	function get NumWidgets()
	{
		return this._NumWidgets;
	}

}
