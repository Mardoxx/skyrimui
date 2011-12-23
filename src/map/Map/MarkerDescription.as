dynamic class Map.MarkerDescription extends MovieClip
{
	var DescriptionList;
	var LineItem0;
	var Title;
	var attachMovie;
	var getNextHighestDepth;

	function MarkerDescription()
	{
		super();
		this.Title = this.Title;
		this.Title.autoSize = "left";
		this.DescriptionList = new Array();
		this.DescriptionList.push(this.LineItem0);
		this.DescriptionList[0]._visible = false;
	}

	function SetDescription(aTitle, aLineItems)
	{
		this.Title.text = aTitle == undefined ? "" : aTitle;
		var __reg8 = this.Title.text.length <= 0 ? 0 : this.Title._height;
		var __reg2 = 0;
		while (__reg2 < aLineItems.length) 
		{
			if (__reg2 >= this.DescriptionList.length) 
			{
				this.DescriptionList.push(this.attachMovie("DescriptionLineItem", "LineItem" + __reg2, this.getNextHighestDepth()));
				this.DescriptionList[__reg2]._x = this.DescriptionList[0]._x;
				this.DescriptionList[__reg2]._y = this.DescriptionList[0]._y;
			}
			this.DescriptionList[__reg2]._visible = true;
			var __reg3 = this.DescriptionList[__reg2].Item;
			var __reg5 = this.DescriptionList[__reg2].Value;
			var __reg4 = aLineItems[__reg2].Item;
			__reg3.autoSize = "left";
			__reg3.text = __reg4 != undefined && __reg4.length > 0 ? __reg4 + ": " : "";
			__reg5.autoSize = "left";
			__reg5.text = aLineItems[__reg2].Value == undefined ? "" : aLineItems[__reg2].Value;
			__reg5._x = __reg3._x + __reg3._width;
			__reg8 = __reg8 + this.DescriptionList[__reg2]._height;
			++__reg2;
		}
		while (__reg2 < this.DescriptionList.length) 
		{
			this.DescriptionList[__reg2]._visible = false;
			++__reg2;
		}
		var __reg7 = (0 - __reg8) / 2;
		__reg2 = 0;
		this.Title._y = __reg7;
		__reg7 = __reg7 + (this.Title.text.length <= 0 ? 0 : this.Title._height);
		for (;;) 
		{
			if (__reg2 >= this.DescriptionList.length) 
			{
				return;
			}
			this.DescriptionList[__reg2]._y = __reg7;
			__reg7 = __reg7 + this.DescriptionList[__reg2]._height;
			++__reg2;
		}
	}

	function OnShowFinish()
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMapRolloverFlyout"]);
	}

}
