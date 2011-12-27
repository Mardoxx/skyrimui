class AnimatedLetter extends MovieClip {
	
	static var SpaceWidth: Number = 15;
	static var EndPosition: Number = 104;
	
	var AnimationBase_mc: MovieClip;
	var QuestName: String;
	var QuestNameIndex: Number = 0;
	var Start: Number = 0;
	var LetterSpacing: Number = 0;
	var OldWidth: Number = 0;
	
	function AnimatedLetter() {
		super();
		Shared.GlobalFunc.MaintainTextFormat();
	}

	function ShowQuestUpdate(aQuestName, aQuestStatus) {
		if (aQuestName.length > 0 && aQuestStatus.length > 0) {
			var QuestStatus: Object = new TextField();
			QuestStatus.text = aQuestStatus + ": ";
			this.QuestName = QuestStatus.text + aQuestName;
		} else {
			this.QuestName = aQuestName;
		}
		
		var LetterIndex: Number = 0;
		this.Start = 0;
		
		while (LetterIndex < this.QuestName.length) {
			this.AnimationBase_mc.Letter_mc.LetterTextInstance.SetText(this.QuestName.substr(LetterIndex, 1));
			var LetterWidth: Number = this.AnimationBase_mc.Letter_mc.LetterTextInstance.getLineMetrics(0).width - 5;
			this.Start = this.Start + (LetterWidth <= 0 ? AnimatedLetter.SpaceWidth : LetterWidth);
			++LetterIndex;
		}
		this.Start = this.Start * -0.5;
		this.Start = this.Start - AnimatedLetter.EndPosition;
		
		this.QuestNameIndex = 0;
		this.LetterSpacing = 0;
		this.OldWidth = 0;
		
		this.AnimationBase_mc.onEnterFrame = this.AnimationBase_mc.ShowLetter;
	}

	function ShowLetter() {
		var LastLetterIndex: Number = this.QuestName.length;
		var LetterIndex: Number = this.QuestNameIndex++;
		
		if (LetterIndex < LastLetterIndex) {
			var Letter: String = this.QuestName.substr(LetterIndex, 1);
			var LetterInstance: MovieClip = this.AnimationBase_mc.duplicateMovieClip("letter" + LetterIndex, this._parent.getNextHighestDepth());
			++QuestNotification.AnimationCount;
			LetterInstance.Letter_mc.LetterTextInstance.text = Letter;
			var LetterWidth: Number = LetterInstance.Letter_mc.LetterTextInstance.getLineMetrics(0).width;
			if (LetterWidth == 0) {
				LetterWidth = AnimatedLetter.SpaceWidth;
			} else {
				LetterWidth = LetterWidth - 5;
			}
			LetterInstance._x = this.Start + this.LetterSpacing + this.OldWidth / 2 + (LetterIndex < 0 ? 0 : LetterWidth / 2);
			this.LetterSpacing = LetterInstance._x - this.Start;
			this.OldWidth = LetterWidth;
			LetterInstance.gotoAndPlay("StartAnim");
			return;
		}
		delete this.onEnterFrame;
	}
}
