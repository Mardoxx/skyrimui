dynamic class ObjectiveText extends MovieClip
{
	static var ClipCount: Number = 0;
	static var ArraySize: Number = 0;
	var MovieClipsA;
	var _parent;

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
		var __reg2 = String(aObjectiveArrayA.shift());
		var __reg4 = String(aObjectiveArrayA.shift());
		var __reg5 = undefined;
		if (__reg2 != "undefined") 
		{
			if (__reg4.length > 0) 
			{
				var __reg6 = new TextField();
				__reg6.SetText(__reg4);
				__reg5 = __reg6.text + ": " + __reg2;
			}
			else 
			{
				__reg5 = __reg2;
			}
			ObjectiveText.ObjectiveLine_mc = this._parent.ObjectiveLineInstance;
			var __reg3 = ObjectiveText.ObjectiveLine_mc.duplicateMovieClip("objective" + ObjectiveText.ClipCount++, this._parent.GetDepth());
			++QuestNotification.AnimationCount;
			__reg3.ObjectiveTextFieldInstance.TextFieldInstance.SetText(__reg5);
			this.MovieClipsA.push(__reg3);
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
		var __reg3 = Math.min(aObjectiveArrayA.length, Math.min(aCount, 3));
		ObjectiveText.ArraySize = aCount;
		var __reg2 = 0;
		while (__reg2 < __reg3) 
		{
			this.DuplicateObjective(aObjectiveArrayA);
			++__reg2;
		}
		this.MovieClipsA[0].gotoAndPlay("OutToPositionOne");
		this.MovieClipsA[1].gotoAndPlay("OutToPositionTwo");
		this.MovieClipsA[2].gotoAndPlay("OutToPositionThree");
	}

}
