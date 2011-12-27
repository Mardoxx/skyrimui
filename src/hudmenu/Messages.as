class Messages extends MovieClip
{
	static var MAX_SHOWN: Number = 4;
	static var Y_SPACING: Number = 15;
	static var END_ANIM_FRAME: Number = 80;
	static var InstanceCounter: Number = 0;
	var MessageArray: Array;
	var ShownCount: Number;
	var ShownMessageArray: Array;
	var bAnimating: Boolean;
	var ySpacing: Number;

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
					var i = 0;
					while (i < this.ShownMessageArray.length - 1) 
					{
						this.ShownMessageArray[i]._y = this.ShownMessageArray[i]._y + 2;
						++i;
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
		var i = 0;
		while (i < this.ShownMessageArray.length) 
		{
			if (this.ShownMessageArray[i]._currentFrame >= Messages.END_ANIM_FRAME) 
			{
				var aShownMessageArray = this.ShownMessageArray.splice(i, 1);
				aShownMessageArray[0].removeMovieClip();
				--this.ShownCount;
				this.bAnimating = false;
			}
			++i;
		}
		if (!bqueuedMessage && !this.bAnimating && this.ShownMessageArray.length > 0) 
		{
			this.bAnimating = true;
			this.ShownMessageArray[0].gotoAndPlay("FadeOut");
		}
	}

}
