import gfx.io.GameDelegate;
import Components.CrossPlatformButtons;
import Components.Meter;

class TrainingMenu extends MovieClip
{
	var AcceptButton: CrossPlatformButtons;
	var CurrentGold: Number;
	var ExitButton: CrossPlatformButtons;
	var SkillMeter: Meter;
	var SkillName: TextField;
	var TimesTrained: TextField;
	var TrainCost: TextField;
	var TrainerSkill: TextField;
	var TrainingCard: MovieClip;

	function TrainingMenu()
	{
		super();
		TrainingCard = TrainingCard;
		SkillName = TrainingCard.SkillName;
		SkillMeter = new Meter(TrainingCard.SkillMeter);
		TrainerSkill = TrainingCard.TrainerSkill;
		TimesTrained = TrainingCard.TimesTrained;
		TrainCost = TrainingCard.TrainCost;
		CurrentGold = TrainingCard.CurrentGold;
		AcceptButton = TrainingCard.AcceptButton;
		ExitButton = TrainingCard.ExitButton;
		SkillMeter.SetPercent(0);
		SkillMeter.SetFillSpeed(4);
		SkillMeter.SetEmptySpeed(100);
	}

	function onLoad(): Void
	{
		AcceptButton.label = "$Train";
		AcceptButton.SetArt({PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"});
		ExitButton.label = "$Exit";
		ExitButton.SetArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"});
		AcceptButton.addEventListener("click", this, "OnAcceptClick");
		ExitButton.addEventListener("click", this, "OnExitClick");
	}

	function onEnterFrame(): Void
	{
		if (SkillMeter.CurrentPercent == 100) {
			SkillMeter.TargetPercent = 0;
		}
		SkillMeter.Update();
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		AcceptButton.SetPlatform(aiPlatform, abPS3Switch);
		ExitButton.SetPlatform(aiPlatform, abPS3Switch);
	}

	function OnAcceptClick(aEvent: Object): Void
	{
		GameDelegate.call("Train", []);
	}

	function OnExitClick(aEvent: Object): Void
	{
		GameDelegate.call("Exit", []);
	}

}
