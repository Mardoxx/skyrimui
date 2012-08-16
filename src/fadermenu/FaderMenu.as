import gfx.io.GameDelegate;
import Shared.GlobalFunc;

class FaderMenu extends MovieClip
{
	var FadeRect: MovieClip;
	var mc_FadeRect: MovieClip;
	
	var fFadeDuration: Number;
	var fFadeElapsedSecs: Number;
	var fMinNumSeconds: Number;
	var fTotalElapsedSecs: Number;
	var iEndAlpha: Number;
	var iStartAlpha: Number;
	

	function FaderMenu()
	{
		super();
		FadeRect = mc_FadeRect;
		iStartAlpha = 100;
		iEndAlpha = 0;
		fFadeDuration = 0;
		fFadeElapsedSecs = 0;
		fTotalElapsedSecs = 0;
		fMinNumSeconds = 0;
	}

	function InitExtensions(): Void
	{
		GameDelegate.addCallBack("InitFade", this, "initFade");
		GameDelegate.addCallBack("UpdateFade", this, "updateFade");
	}

	function initFade(): Void
	{
		if (FadeRect._alpha > 0 && FadeRect._alpha < 100) {
			if (arguments[0]) {
				fFadeElapsedSecs = (100 - FadeRect._alpha) / 100 * arguments[2];
			} else {
				fFadeElapsedSecs = FadeRect._alpha / 100 * arguments[2];
			}
		} else {
			fFadeElapsedSecs = 0;
			fTotalElapsedSecs = 0;
		}
		
		if (arguments[0]) {
			iStartAlpha = 100;
			iEndAlpha = 0;
			FadeRect._alpha = 100;
		} else {
			iStartAlpha = 0;
			iEndAlpha = 100;
			FadeRect._alpha = 0;
		}
		
		if (arguments[1]) {
			(new Color(FadeRect)).setRGB(0x000000);
		} else {
			(new Color(FadeRect)).setRGB(0xFFFFFF);
		}
		
		fFadeDuration = arguments[2];
		fMinNumSeconds = arguments[3] == undefined ? 0 : arguments[3];
	}

	function updateFade(afElapsedSecs: Number): Void
	{
		fTotalElapsedSecs = fTotalElapsedSecs + afElapsedSecs;
		if (fTotalElapsedSecs >= fMinNumSeconds) {
			fFadeElapsedSecs = Math.min(fFadeElapsedSecs + afElapsedSecs, fFadeDuration);
			FadeRect._alpha = GlobalFunc.Lerp(iStartAlpha, iEndAlpha, 0, fFadeDuration, fFadeElapsedSecs);
			if (fFadeElapsedSecs == fFadeDuration) {
				GameDelegate.call("FadeDone", []);
			}
		}
	}

}
