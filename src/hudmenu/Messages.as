dynamic class Messages extends MovieClip
{
	static var MAX_SHOWN: Number = 4;
	static var Y_SPACING: Number = 15;
	static var END_ANIM_FRAME: Number = 80;
	static var InstanceCounter: Number = 0;
	var MessageArray;
	var ShownCount;
	var ShownMessageArray;
	var attachMovie;
	var bAnimating;
	var getNextHighestDepth;
	var onEnterFrame;
	var ySpacing;

	function Messages()
	{
		super();
		this.MessageArray = new Array();
		this.ShownMessageArray = new Array();
		this.ShownCount = 0;
		this.bAnimating = false;
	}

	function Update()
	{
		var bqueuedMessage = this.MessageArray.length > 0;
		if (bqueuedMessage && !this.bAnimating && this.ShownCount < Messages.MAX_SHOWN) 
		{
			this.ShownMessageArray.push(this.attachMovie("MessageText", "Text" + Messages.InstanceCounter++, this.getNextHighestDepth(), {_x: 0, _y: 0}));
			this.ShownMessageArray[this.ShownMessageArray.length - 1].TextFieldClip.tf1.html = true;
			this.ShownMessageArray[this.ShownMessageArray.length - 1].TextFieldClip.tf1.textAutoSize = "shrink";
			this.ShownMessageArray[this.ShownMessageArray.length - 1].TextFieldClip.tf1.htmlText = this.MessageArray.shift();
			this.bAnimating = true;
			this.ySpacing = 0;
			this.onEnterFrame = function ()
			{
				if (this.ySpacing < Messages.Y_SPACING) 
				{
					var __reg2 = 0;
					while (__reg2 < this.ShownMessageArray.length - 1) 
					{
						this.ShownMessageArray[__reg2]._y = this.ShownMessageArray[__reg2]._y + 2;
						++__reg2;
					}
					++this.ySpacing;
					return;
				}
				this.bAnimating = false;
				if (!bqueuedMessage || this.ShownCount == Messages.MAX_SHOWN) 
				{
					this.ShownMessageArray[0].gotoAndPlay("FadeOut");
				}
				delete this.onEnterFrame;
			}
			;
			++this.ShownCount;
		}
		var __reg2 = 0;
		while (__reg2 < this.ShownMessageArray.length) 
		{
			if (this.ShownMessageArray[__reg2]._currentFrame >= Messages.END_ANIM_FRAME) 
			{
				var __reg3 = this.ShownMessageArray.splice(__reg2, 1);
				__reg3[0].removeMovieClip();
				--this.ShownCount;
				this.bAnimating = false;
			}
			++__reg2;
		}
		if (!bqueuedMessage && !this.bAnimating && this.ShownMessageArray.length > 0) 
		{
			this.bAnimating = true;
			this.ShownMessageArray[0].gotoAndPlay("FadeOut");
		}
	}

}
