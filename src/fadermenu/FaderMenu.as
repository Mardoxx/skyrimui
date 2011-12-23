dynamic class FaderMenu extends MovieClip
{
	var FadeRect;
	var fFadeDuration;
	var fFadeElapsedSecs;
	var fMinNumSeconds;
	var fTotalElapsedSecs;
	var iEndAlpha;
	var iStartAlpha;
	var mc_FadeRect;

	function FaderMenu()
	{
		super();
		this.FadeRect = this.mc_FadeRect;
		this.iStartAlpha = 100;
		this.iEndAlpha = 0;
		this.fFadeDuration = 0;
		this.fFadeElapsedSecs = 0;
		this.fTotalElapsedSecs = 0;
		this.fMinNumSeconds = 0;
	}

	function InitExtensions()
	{
		gfx.io.GameDelegate.addCallBack("InitFade", this, "initFade");
		gfx.io.GameDelegate.addCallBack("UpdateFade", this, "updateFade");
	}

	function initFade()
	{
		if (this.FadeRect._alpha > 0 && this.FadeRect._alpha < 100) 
		{
			if (arguments[0]) 
			{
				this.fFadeElapsedSecs = (100 - this.FadeRect._alpha) / 100 * arguments[2];
			}
			else 
			{
				this.fFadeElapsedSecs = this.FadeRect._alpha / 100 * arguments[2];
			}
		}
		else 
		{
			this.fFadeElapsedSecs = 0;
			this.fTotalElapsedSecs = 0;
		}
		if (arguments[0]) 
		{
			this.iStartAlpha = 100;
			this.iEndAlpha = 0;
			this.FadeRect._alpha = 100;
		}
		else 
		{
			this.iStartAlpha = 0;
			this.iEndAlpha = 100;
			this.FadeRect._alpha = 0;
		}
		if (arguments[1]) 
		{
			(new Color(this.FadeRect)).setRGB(0);
		}
		else 
		{
			(new Color(this.FadeRect)).setRGB(16777215);
		}
		this.fFadeDuration = arguments[2];
		this.fMinNumSeconds = arguments[3] == undefined ? 0 : arguments[3];
	}

	function updateFade(afElapsedSecs)
	{
		this.fTotalElapsedSecs = this.fTotalElapsedSecs + afElapsedSecs;
		if (this.fTotalElapsedSecs >= this.fMinNumSeconds) 
		{
			this.fFadeElapsedSecs = Math.min(this.fFadeElapsedSecs + afElapsedSecs, this.fFadeDuration);
			this.FadeRect._alpha = Shared.GlobalFunc.Lerp(this.iStartAlpha, this.iEndAlpha, 0, this.fFadeDuration, this.fFadeElapsedSecs);
			if (this.fFadeElapsedSecs == this.fFadeDuration) 
			{
				gfx.io.GameDelegate.call("FadeDone", []);
			}
		}
	}

}
