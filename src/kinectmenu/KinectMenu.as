dynamic class KinectMenu extends MovieClip
{
    var CommandText;
    var Command_tf;
    var ErrorStatus;
    var ErrorStatus_mc;
    var SpeakerIcon;
    var SpeakerIcon_mc;
    var SuccessIcon;
    var SuccessIcon_mc;
    var bDisabled;
    var gotoAndPlay;
    var gotoAndStop;

    function KinectMenu()
    {
        super();
        this.SpeakerIcon_mc = this.SpeakerIcon;
        this.SuccessIcon_mc = this.SuccessIcon;
        this.ErrorStatus_mc = this.ErrorStatus;
        this.Command_tf = this.CommandText.textField;
        this.Command_tf.textAutoSize = "shrink";
        this.ErrorStatus_mc.ErrorText.textAutoSize = "shrink";
    }

    function InitExtensions()
    {
        Shared.GlobalFunc.SetLockFunction();
        MovieClip(this).Lock("TR");
    }

    function SetNormal()
    {
        this.Command_tf.SetText(" ");
        this.gotoAndStop("Normal");
        this.SpeakerIcon_mc.gotoAndPlay("Normal");
        this.SuccessIcon_mc.gotoAndStop("None");
        this.bDisabled = false;
    }

    function SetShouting(abEnable)
    {
        if (abEnable) 
        {
            this.SpeakerIcon_mc.Speaker_mc.gotoAndStop("Shout");
        }
        else 
        {
            this.SpeakerIcon_mc.Speaker_mc.gotoAndStop("Normal");
        }
        this.SpeakerIcon_mc.gotoAndPlay("Normal");
    }

    function SetDisabled()
    {
        this.SpeakerIcon_mc.gotoAndStop("Disabled");
        this.bDisabled = true;
    }

    function SetNoisy()
    {
    }

    function onErrorSuccessTooNoisy()
    {
        this.ErrorStatus_mc.ErrorText.SetText("$TooNoisy");
    }

    function SetTooQuiet()
    {
    }

    function onErrorSuccessTooQuiet()
    {
        this.ErrorStatus_mc.ErrorText.SetText("$TooQuiet");
    }

    function SetTooLoud()
    {
    }

    function onErrorSuccessTooLoud()
    {
        this.ErrorStatus_mc.ErrorText.SetText("$TooLoud");
    }

    function SetTooFast()
    {
    }

    function onErrorSuccessTooFast()
    {
        this.ErrorStatus_mc.ErrorText.SetText("$TooFast");
    }

    function SetTooSlow()
    {
    }

    function onErrorSuccessTooSlow()
    {
        this.ErrorStatus_mc.ErrorText.SetText("$TooSlow");
    }

    function SetNotUnderstood()
    {
        this.Command_tf.SetText("$TryAgain");
        this.gotoAndPlay("ShowText");
        this.SpeakerIcon_mc.gotoAndPlay("NotUnderstood");
    }

    function OnCommandSuccess(astrCommand)
    {
        this.Command_tf.SetText(astrCommand);
        this.gotoAndPlay("ShowText");
        this.SpeakerIcon_mc.gotoAndPlay("Normal");
        this.SuccessIcon_mc.gotoAndPlay("Success");
    }

    function OnCommandFail(astrCommand)
    {
        this.Command_tf.SetText(astrCommand);
        this.gotoAndPlay("ShowText");
        this.SpeakerIcon_mc.gotoAndPlay("Normal");
        this.SuccessIcon_mc.gotoAndPlay("Fail");
    }

    function HideTextAndSuccess()
    {
        this.Command_tf.SetText(" ");
        this.SuccessIcon_mc.gotoAndStop("None");
    }

    function onFinishShowingText()
    {
        if (this.bDisabled != true) 
        {
            this.SpeakerIcon_mc.gotoAndPlay("Normal");
        }
        this.gotoAndStop("Normal");
    }

}
