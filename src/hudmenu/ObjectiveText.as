class ObjectiveText extends MovieClip
{
	static var ClipCount: Number = 0;
	static var ArraySize: Number = 0;
	static var ObjectiveLine_mc;
	var MovieClipsA: Array;

	function ObjectiveText()
	{
		super();
		this.MovieClipsA = new Array();
	}

	function UpdateObjectives(aObjectiveArrayA)
	{
		if (ObjectiveText.ArraySize > 0) 
		{
			delete eval(this.MovieClipsA.shift());
			this.DuplicateObjective(aObjectiveArrayA);
			this.MovieClipsA[2].gotoAndPlay("OutToPositionThreeNoPause");
			return true;
		}
		return false;
	}

	function DuplicateObjective(aObjectiveArrayA)
	{
		var aPrimaryObjective = String(aObjectiveArrayA.shift());
		var aSecondaryObjective = String(aObjectiveArrayA.shift());
		var aObjectiveText = undefined;
		if (aPrimaryObjective != "undefined") 
		{
			if (aSecondaryObjective.length > 0) 
			{
				var aTextField = new TextField();
				aTextField.SetText(aSecondaryObjective);
				aObjectiveText = aTextField.text + ": " + aPrimaryObjective;
			}
			else 
			{
				aObjectiveText = aPrimaryObjective;
			}
			ObjectiveText.ObjectiveLine_mc = this._parent.ObjectiveLineInstance;
			var aObjectiveLine_mc = ObjectiveText.ObjectiveLine_mc.duplicateMovieClip("objective" + ObjectiveText.ClipCount++, this._parent.GetDepth());
			++QuestNotification.AnimationCount;
			aObjectiveLine_mc.ObjectiveTextFieldInstance.TextFieldInstance.SetText(aObjectiveText);
			this.MovieClipsA.push(aObjectiveLine_mc);
		}
		--ObjectiveText.ArraySize;
		if (ObjectiveText.ArraySize == 0) 
		{
			QuestNotification.RestartAnimations();
		}
	}

	function ShowObjectives(aCount, aObjectiveArrayA)
	{
		if (aObjectiveArrayA.length > 0) 
		{
			gfx.io.GameDelegate.call("PlaySound", ["UIObjectiveNew"]);
		}
		while (this.MovieClipsA.length) 
		{
			delete eval(this.MovieClipsA.shift());
		}
		var aMaxObjectives = Math.min(aObjectiveArrayA.length, Math.min(aCount, 3)); // Shows a max of 3 objectives
		ObjectiveText.ArraySize = aCount;
		var aObjectivesShown = 0;
		while (aObjectivesShown < aMaxObjectives) 
		{
			this.DuplicateObjective(aObjectiveArrayA);
			++aObjectivesShown;
		}
		this.MovieClipsA[0].gotoAndPlay("OutToPositionOne");
		this.MovieClipsA[1].gotoAndPlay("OutToPositionTwo");
		this.MovieClipsA[2].gotoAndPlay("OutToPositionThree");
	}

}
