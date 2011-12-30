dynamic class TrainingMenu extends MovieClip
{
	var AcceptButton: Components.CrossPlatformButtons;
	var CurrentGold;
	var ExitButton: Components.CrossPlatformButtons;
	var SkillMeter;
	var SkillName;
	var TimesTrained;
	var TrainCost;
	var TrainerSkill;
	var TrainingCard;

	function TrainingMenu()
	{
		super();
		this.TrainingCard = this.TrainingCard;
		this.SkillName = this.TrainingCard.SkillName;
		this.SkillMeter = new Components.Meter(this.TrainingCard.SkillMeter);
		this.TrainerSkill = this.TrainingCard.TrainerSkill;
		this.TimesTrained = this.TrainingCard.TimesTrained;
		this.TrainCost = this.TrainingCard.TrainCost;
		this.CurrentGold = this.TrainingCard.CurrentGold;
		this.AcceptButton = this.TrainingCard.AcceptButton;
		this.ExitButton = this.TrainingCard.ExitButton;
		this.SkillMeter.SetPercent(0);
		this.SkillMeter.SetFillSpeed(4);
		this.SkillMeter.SetEmptySpeed(100);
	}

	function onLoad()
	{
		this.AcceptButton.label = "$Train";
		this.AcceptButton.SetArt({PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"});
		this.ExitButton.label = "$Exit";
		this.ExitButton.SetArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"});
		this.AcceptButton.addEventListener("click", this, "OnAcceptClick");
		this.ExitButton.addEventListener("click", this, "OnExitClick");
	}

	function onEnterFrame()
	{
		if (this.SkillMeter.CurrentPercent == 100) 
		{
			this.SkillMeter.TargetPercent = 0;
		}
		this.SkillMeter.Update();
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean)
	{
		this.AcceptButton.SetPlatform(aiPlatform, abPS3Switch);
		this.ExitButton.SetPlatform(aiPlatform, abPS3Switch);
	}

	function OnAcceptClick(aEvent)
	{
		gfx.io.GameDelegate.call("Train", []);
	}

	function OnExitClick(aEvent)
	{
		gfx.io.GameDelegate.call("Exit", []);
	}

}
