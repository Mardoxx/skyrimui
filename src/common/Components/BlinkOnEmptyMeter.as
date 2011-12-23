dynamic class Components.BlinkOnEmptyMeter extends Components.Meter
{
	var CurrentPercent;
	var Empty;
	var meterMovieClip;

	function BlinkOnEmptyMeter(aMeterClip)
	{
		super(aMeterClip);
	}

	function Update()
	{
		super.Update();
		var __reg3 = this.meterMovieClip._currentframe;
		if (this.CurrentPercent <= 0) 
		{
			if (__reg3 == this.Empty) 
			{
				this.meterMovieClip.gotoAndPlay(this.Empty + 1);
				var __reg4 = this.meterMovieClip._currentframe;
			}
		}
	}

}
