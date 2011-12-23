dynamic class AnimatedLetter extends MovieClip
{
	var LetterSpacing: Number = 0;
	var OldWidth: Number = 0;
	var QuestNameIndex: Number = 0;
	var Start: Number = 0;
	var EndPosition: Number = 104;
	static var SpaceWidth: Number = 15;
	var AnimationBase_mc;
	var QuestName;
	var _parent;
	var onEnterFrame;

	function AnimatedLetter()
	{
		super();
		Shared.GlobalFunc.MaintainTextFormat();
	}

	function ShowQuestUpdate(aQuestName, aQuestStatus)
	{
		if (aQuestName.length > 0 && aQuestStatus.length > 0) 
		{
			var __reg4 = new TextField();
			__reg4.text = aQuestStatus + ": ";
			this.QuestName = __reg4.text + aQuestName;
		}
		else 
		{
			this.QuestName = aQuestName;
		}
		this.Start = 0;
		var __reg2 = 0;
		while (__reg2 < this.QuestName.length) 
		{
			this.AnimationBase_mc.Letter_mc.LetterTextInstance.SetText(this.QuestName.substr(__reg2, 1));
			var __reg3 = this.AnimationBase_mc.Letter_mc.LetterTextInstance.getLineMetrics(0).width - 5;
			this.Start = this.Start + (__reg3 <= 0 ? AnimatedLetter.SpaceWidth : __reg3);
			++__reg2;
		}
		this.Start = this.Start * -0.5;
		this.Start = this.Start - this.EndPosition;
		this.QuestNameIndex = 0;
		this.LetterSpacing = 0;
		this.OldWidth = 0;
		this.AnimationBase_mc.onEnterFrame = this.AnimationBase_mc.ShowLetter;
	}

	function ShowLetter()
	{
		var __reg6 = this.QuestName.length;
		var __reg4 = this.QuestNameIndex++;
		if (__reg4 < __reg6) 
		{
			var __reg5 = this.QuestName.substr(__reg4, 1);
			var __reg3 = this.AnimationBase_mc.duplicateMovieClip("letter" + __reg4, this._parent.getNextHighestDepth());
			++QuestNotification.AnimationCount;
			__reg3.Letter_mc.LetterTextInstance.text = __reg5;
			var __reg2 = __reg3.Letter_mc.LetterTextInstance.getLineMetrics(0).width;
			if (__reg2 == 0) 
			{
				__reg2 = AnimatedLetter.SpaceWidth;
			}
			else 
			{
				__reg2 = __reg2 - 5;
			}
			__reg3._x = this.Start + this.LetterSpacing + this.OldWidth / 2 + (__reg4 < 0 ? 0 : __reg2 / 2);
			this.LetterSpacing = __reg3._x - this.Start;
			this.OldWidth = __reg2;
			__reg3.gotoAndPlay("StartAnim");
			return;
		}
		delete this.onEnterFrame;
	}

}
