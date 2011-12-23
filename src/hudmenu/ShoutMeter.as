dynamic class ShoutMeter
{
	var FlashClip;
	var MeterEmtpy;
	var MeterFull;
	var ProgressClip;

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
		var __reg2 = Math.min(100, Math.max(aPercent, 0));
		var __reg3 = Math.floor(Shared.GlobalFunc.Lerp(this.MeterEmtpy, this.MeterFull, 0, 100, __reg2));
		this.ProgressClip.gotoAndStop(__reg3);
	}

	function FlashMeter()
	{
		this.FlashClip.gotoAndPlay("StartFlash");
	}

}
