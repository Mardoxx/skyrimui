class KinectMenu extends MovieClip
{
	var CommandText: MovieClip;
	var Command_tf: TextField;
	var ErrorStatus: MovieClip;
	var ErrorStatus_mc: MovieClip;
	var SpeakerIcon: MovieClip;
	var SpeakerIcon_mc: MovieClip;
	var SuccessIcon: MovieClip;
	var SuccessIcon_mc: MovieClip;
	var bDisabled: Boolean;

	function KinectMenu()
	{
		super();
		SpeakerIcon_mc = 	SpeakerIcon;
		SuccessIcon_mc = 	SuccessIcon;
		ErrorStatus_mc = 	ErrorStatus;
		Command_tf = 	CommandText.textField;
		Command_tf.textAutoSize = "shrink";
		ErrorStatus_mc.ErrorText.textAutoSize = "shrink";
	}

	function InitExtensions(): Void
	{
		Shared.GlobalFunc.SetLockFunction();
		MovieClip(this).Lock("TR");
	}

	function SetNormal(): Void
	{
		Command_tf.SetText(" ");
		gotoAndStop("Normal");
		SpeakerIcon_mc.gotoAndPlay("Normal");
		SuccessIcon_mc.gotoAndStop("None");
		bDisabled = false;
	}

	function SetShouting(abEnable: Boolean): Void
	{
		if (abEnable) {
			SpeakerIcon_mc.Speaker_mc.gotoAndStop("Shout");
		} else {
			SpeakerIcon_mc.Speaker_mc.gotoAndStop("Normal");
		}
		SpeakerIcon_mc.gotoAndPlay("Normal");
	}

	function SetDisabled(): Void
	{
		SpeakerIcon_mc.gotoAndStop("Disabled");
		bDisabled = true;
	}

	function SetNoisy(): Void
	{
	}

	function onErrorSuccessTooNoisy(): Void
	{
		ErrorStatus_mc.ErrorText.SetText("$TooNoisy");
	}

	function SetTooQuiet(): Void
	{
	}

	function onErrorSuccessTooQuiet(): Void
	{
		ErrorStatus_mc.ErrorText.SetText("$TooQuiet");
	}

	function SetTooLoud(): Void
	{
	}

	function onErrorSuccessTooLoud(): Void
	{
		ErrorStatus_mc.ErrorText.SetText("$TooLoud");
	}

	function SetTooFast(): Void
	{
	}

	function onErrorSuccessTooFast(): Void
	{
		ErrorStatus_mc.ErrorText.SetText("$TooFast");
	}

	function SetTooSlow(): Void
	{
	}

	function onErrorSuccessTooSlow(): Void
	{
		ErrorStatus_mc.ErrorText.SetText("$TooSlow");
	}

	function SetNotUnderstood(): Void
	{
		Command_tf.SetText("$TryAgain");
		gotoAndPlay("ShowText");
		SpeakerIcon_mc.gotoAndPlay("NotUnderstood");
	}

	function OnCommandSuccess(astrCommand: String): Void
	{
		Command_tf.SetText(astrCommand);
		gotoAndPlay("ShowText");
		SpeakerIcon_mc.gotoAndPlay("Normal");
		SuccessIcon_mc.gotoAndPlay("Success");
	}

	function OnCommandFail(astrCommand: String): Void
	{
		Command_tf.SetText(astrCommand);
		gotoAndPlay("ShowText");
		SpeakerIcon_mc.gotoAndPlay("Normal");
		SuccessIcon_mc.gotoAndPlay("Fail");
	}

	function HideTextAndSuccess(): Void
	{
		Command_tf.SetText(" ");
		SuccessIcon_mc.gotoAndStop("None");
	}

	function onFinishShowingText(): Void
	{
		if (bDisabled != true) {
			SpeakerIcon_mc.gotoAndPlay("Normal");
		}
		gotoAndStop("Normal");
	}

}
