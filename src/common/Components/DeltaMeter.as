dynamic class Components.DeltaMeter extends Components.Meter
{
	var DeltaEmpty;
	var DeltaFull;
	var DeltaMeterMovieClip;

	function DeltaMeter(aMovieClip)
	{
		super(aMovieClip);
		this.DeltaMeterMovieClip = aMovieClip.DeltaIndicatorInstance;
		this.DeltaMeterMovieClip.gotoAndStop("Empty");
		this.DeltaEmpty = this.DeltaMeterMovieClip._currentframe;
		this.DeltaMeterMovieClip.gotoAndStop("Full");
		this.DeltaFull = this.DeltaMeterMovieClip._currentframe;
	}

	function SetDeltaPercent(aPercent)
	{
		var __reg3 = Math.min(100, Math.max(aPercent, 0));
		var __reg2 = Math.floor(Shared.GlobalFunc.Lerp(this.DeltaEmpty, this.DeltaFull, 0, 100, __reg3));
		this.DeltaMeterMovieClip.gotoAndStop(__reg2);
	}

}
