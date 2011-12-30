class Components.BlinkOnEmptyMeter extends Components.Meter
{
	var iCurrentPercent: Number;
	var iEmpty: Number;
	var meterMovieClip: MovieClip;

	function BlinkOnEmptyMeter(aMeterClip: MovieClip)
	{
		super(aMeterClip);
	}

	function Update(): Void
	{
		super.Update();
		var iCurrentFrame = this.meterMovieClip._currentframe;
		if (this.iCurrentPercent <= 0) 
		{
			if (iCurrentFrame == this.iEmpty) 
			{
				this.meterMovieClip.gotoAndPlay(this.iEmpty + 1);
				var iCurrentFrame1: Number = this.meterMovieClip._currentframe;
			}
		}
	}

}
