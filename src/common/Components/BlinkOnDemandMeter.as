dynamic class Components.BlinkOnDemandMeter extends Components.Meter
{
	var BlinkMovieClip;
	var meterMovieClip;

	function BlinkOnDemandMeter(aMeterMovieClip, aBlinkMovieClip)
	{
		super(aMeterMovieClip);
		this.BlinkMovieClip = aBlinkMovieClip;
		this.BlinkMovieClip.gotoAndStop("InitFlash");
	}

	function StartBlinking()
	{
		this.meterMovieClip._parent.PlayForward(this.meterMovieClip._parent._currentframe);
		this.BlinkMovieClip.gotoAndPlay("StartFlash");
	}

}
