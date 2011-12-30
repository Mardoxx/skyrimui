class Components.BlinkOnDemandMeter extends Components.Meter
{
	var BlinkMovieClip: MovieClip;
	var meterMovieClip: MovieClip;

	function BlinkOnDemandMeter(aMeterMovieClip: MovieClip, aBlinkMovieClip: MovieClip)
	{
		super(aMeterMovieClip);
		this.BlinkMovieClip = aBlinkMovieClip;
		this.BlinkMovieClip.gotoAndStop("InitFlash");
	}

	function StartBlinking(): Void
	{
		this.meterMovieClip._parent.PlayForward(this.meterMovieClip._parent._currentframe);
		this.BlinkMovieClip.gotoAndPlay("StartFlash");
	}

}
