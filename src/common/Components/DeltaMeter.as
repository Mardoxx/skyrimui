class Components.DeltaMeter extends Components.Meter
{
	var DeltaEmpty: Number;
	var DeltaFull: Number;
	var DeltaMeterMovieClip: MovieClip;

	function DeltaMeter(aMovieClip: MovieClip)
	{
		super(aMovieClip);
		this.DeltaMeterMovieClip = aMovieClip.DeltaIndicatorInstance;
		this.DeltaMeterMovieClip.gotoAndStop("Empty");
		this.DeltaEmpty = this.DeltaMeterMovieClip._currentframe;
		this.DeltaMeterMovieClip.gotoAndStop("Full");
		this.DeltaFull = this.DeltaMeterMovieClip._currentframe;
	}

	function SetDeltaPercent(aiPercent: Number): Void
	{
		var iPercent: Number = Math.min(100, Math.max(aiPercent, 0));
		var iMeterFrame: Number = Math.floor(Shared.GlobalFunc.Lerp(this.DeltaEmpty, this.DeltaFull, 0, 100, iPercent));
		this.DeltaMeterMovieClip.gotoAndStop(iMeterFrame);
	}

}
