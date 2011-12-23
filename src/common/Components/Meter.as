dynamic class Components.Meter
{
	var CurrentPercent;
	var Empty;
	var EmptySpeed;
	var FillSpeed;
	var Full;
	var TargetPercent;
	var meterMovieClip;

	function Meter(aMovieClip)
	{
		this.Empty = 0;
		this.Full = 0;
		this.CurrentPercent = 100;
		this.TargetPercent = 100;
		this.FillSpeed = 2;
		this.EmptySpeed = 3;
		this.meterMovieClip = aMovieClip;
		this.meterMovieClip.gotoAndStop("Empty");
		this.Empty = this.meterMovieClip._currentframe;
		this.meterMovieClip.gotoAndStop("Full");
		this.Full = this.meterMovieClip._currentframe;
	}

	function SetPercent(aPercent)
	{
		this.CurrentPercent = Math.min(100, Math.max(aPercent, 0));
		this.TargetPercent = this.CurrentPercent;
		var __reg2 = Math.floor(Shared.GlobalFunc.Lerp(this.Empty, this.Full, 0, 100, this.CurrentPercent));
		this.meterMovieClip.gotoAndStop(__reg2);
	}

	function SetTargetPercent(aPercent)
	{
		this.TargetPercent = Math.min(100, Math.max(aPercent, 0));
	}

	function SetFillSpeed(aSpeed)
	{
		this.FillSpeed = aSpeed;
	}

	function SetEmptySpeed(aSpeed)
	{
		this.EmptySpeed = aSpeed;
	}

	function Update()
	{
		if (this.TargetPercent > 0 && this.TargetPercent > this.CurrentPercent) 
		{
			if (this.TargetPercent - this.CurrentPercent > this.FillSpeed) 
			{
				this.CurrentPercent = this.CurrentPercent + this.FillSpeed;
				var __reg3 = Shared.GlobalFunc.Lerp(this.Empty, this.Full, 0, 100, this.CurrentPercent);
				this.meterMovieClip.gotoAndStop(__reg3);
			}
			else 
			{
				this.SetPercent(this.TargetPercent);
			}
			return;
		}
		if (this.TargetPercent <= this.CurrentPercent) 
		{
			var __reg2 = this.CurrentPercent - this.TargetPercent > this.EmptySpeed;
			if ((this.TargetPercent > 0 && __reg2) || this.CurrentPercent > this.EmptySpeed) 
			{
				if (__reg2) 
				{
					this.CurrentPercent = this.CurrentPercent - this.EmptySpeed;
				}
				else 
				{
					this.CurrentPercent = this.TargetPercent;
				}
				__reg3 = Shared.GlobalFunc.Lerp(this.Empty, this.Full, 0, 100, this.CurrentPercent);
				this.meterMovieClip.gotoAndStop(__reg3);
				return;
			}
			if (this.CurrentPercent >= 0) 
			{
				this.SetPercent(this.TargetPercent);
			}
		}
	}

}
