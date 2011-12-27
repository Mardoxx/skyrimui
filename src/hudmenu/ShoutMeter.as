class ShoutMeter
{
	var FlashClip: MovieClip;
	var MeterEmtpy: Number;
	var MeterFull: Number;
	var ProgressClip: MovieClip;

	function ShoutMeter(aProgressClip, aFlashClip)
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

	function SetPercent(aPercent)
	{
		if (aPercent >= 100) 
		{
			this.ProgressClip.gotoAndStop("Normal");
			return;
		}
		var aPercent = Math.min(100, Math.max(aPercent, 0));
		var aPercentFrame = Math.floor(Shared.GlobalFunc.Lerp(this.MeterEmtpy, this.MeterFull, 0, 100, aPercent));
		this.ProgressClip.gotoAndStop(aPercentFrame);
	}

	function FlashMeter()
	{
		this.FlashClip.gotoAndPlay("StartFlash");
	}

}
