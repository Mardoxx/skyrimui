class ShoutMeter
{
	var FlashClip: MovieClip;
	var MeterEmtpy: Number;
	var MeterFull: Number;
	var ProgressClip: MovieClip;

	function ShoutMeter(aProgressClip: MovieClip, aFlashClip: MovieClip)
	{
		this.ProgressClip = aProgressClip;
		this.FlashClip = aFlashClip;
		this.ProgressClip.gotoAndStop("Empty");
		this.MeterEmtpy = this.ProgressClip._currentframe;
		this.ProgressClip.gotoAndStop("Full");
		this.MeterFull = this.ProgressClip._currentframe;
		this.ProgressClip.gotoAndStop("Normal");
		this.FlashClip.gotoAndStop("InitFlash"); //
	}

	function SetPercent(aPercent: Number): Void
	{
		if (aPercent >= 100) 
		{
			this.ProgressClip.gotoAndStop("Normal");
			return;
		}
		var aPercent: Number = Math.min(100, Math.max(aPercent, 0));
		var aPercentFrame: Number = Math.floor(Shared.GlobalFunc.Lerp(this.MeterEmtpy, this.MeterFull, 0, 100, aPercent));
		this.ProgressClip.gotoAndStop(aPercentFrame);
	}

	function FlashMeter(): Void
	{
		this.FlashClip.gotoAndPlay("StartFlash");
	}

}
