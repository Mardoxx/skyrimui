class Components.Meter
{
	var CurrentPercent: Number;
	var Empty: Number;
	var EmptySpeed: Number;
	var FillSpeed: Number;
	var Full: Number;
	var TargetPercent: Number;
	var meterMovieClip: MovieClip;

	function Meter(aMovieClip: MovieClip)
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

	function SetPercent(aPercent: Number): Void
	{
		this.CurrentPercent = Math.min(100, Math.max(aPercent, 0));
		this.TargetPercent = this.CurrentPercent;
		var iMeterFrame: Number = Math.floor(Shared.GlobalFunc.Lerp(this.Empty, this.Full, 0, 100, this.CurrentPercent));
		this.meterMovieClip.gotoAndStop(iMeterFrame);
	}

	function SetTargetPercent(aPercent: Number): Void
	{
		this.TargetPercent = Math.min(100, Math.max(aPercent, 0));
	}

	function SetFillSpeed(aSpeed: Number): Void
	{
		this.FillSpeed = aSpeed;
	}

	function SetEmptySpeed(aSpeed: Number): Void
	{
		this.EmptySpeed = aSpeed;
	}

	function Update(): Void
	{
		if (this.TargetPercent > 0 && this.TargetPercent > this.CurrentPercent) 
		{
			if (this.TargetPercent - this.CurrentPercent > this.FillSpeed) 
			{
				this.CurrentPercent = this.CurrentPercent + this.FillSpeed;
				var iMeterFrame: Number = Shared.GlobalFunc.Lerp(this.Empty, this.Full, 0, 100, this.CurrentPercent);
				this.meterMovieClip.gotoAndStop(iMeterFrame);
			}
			else 
			{
				this.SetPercent(this.TargetPercent);
			}
			return;
		}
		if (this.TargetPercent <= this.CurrentPercent) 
		{
			var bUnknown: Boolean = this.CurrentPercent - this.TargetPercent > this.EmptySpeed; // Unknown Boolean
			if ((this.TargetPercent > 0 && bUnknown) || this.CurrentPercent > this.EmptySpeed) 
			{
				if (bUnknown) 
				{
					this.CurrentPercent = this.CurrentPercent - this.EmptySpeed;
				}
				else 
				{
					this.CurrentPercent = this.TargetPercent;
				}
				var iMeterFrame: Number = Shared.GlobalFunc.Lerp(this.Empty, this.Full, 0, 100, this.CurrentPercent);
				this.meterMovieClip.gotoAndStop(iMeterFrame);
				return;
			}
			if (this.CurrentPercent >= 0) 
			{
				this.SetPercent(this.TargetPercent);
			}
		}
	}

}
