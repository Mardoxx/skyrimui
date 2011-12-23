dynamic class Shared.ButtonTextArtHolder extends MovieClip
{
	var strButtonName;

	function ButtonTextArtHolder()
	{
		super();
	}

	function SetButtonName(aText)
	{
		this.strButtonName = aText;
	}

	function CreateButtonArt(aInputText)
	{
		var __reg5 = aInputText.text.indexOf("[");
		var __reg2 = __reg5 == -1 ? -1 : aInputText.text.indexOf("]", __reg5);
		var __reg7 = undefined;
		if (__reg5 != -1 && __reg2 != -1) 
		{
			__reg7 = aInputText.text.substr(0, __reg5);
			while (__reg5 != -1 && __reg2 != -1) 
			{
				var __reg10 = aInputText.text.substring(__reg5 + 1, __reg2);
				gfx.io.GameDelegate.call("GetButtonFromUserEvent", [__reg10], this, "SetButtonName");
				if (this.strButtonName == undefined) 
				{
					__reg7 = __reg7 + aInputText.text.substring(__reg5, __reg2 + 1);
				}
				else 
				{
					var __reg6 = flash.display.BitmapData.loadBitmap(this.strButtonName + ".png");
					if (__reg6 != undefined && __reg6.height > 0) 
					{
						var __reg8 = 26;
						var __reg11 = Math.floor(__reg8 / __reg6.height * __reg6.width);
						__reg7 = __reg7 + ("<img src=\'" + this.strButtonName + ".png\' vspace=\'-5\' height=\'" + __reg8 + "\' width=\'" + __reg11 + "\'>");
					}
					else 
					{
						__reg7 = __reg7 + aInputText.text.substring(__reg5, __reg2 + 1);
					}
				}
				var __reg4 = aInputText.text.indexOf("[", __reg2);
				var __reg9 = __reg4 == -1 ? -1 : aInputText.text.indexOf("]", __reg4);
				if (__reg4 != -1 && __reg9 != -1) 
				{
					__reg7 = __reg7 + aInputText.text.substring(__reg2 + 1, __reg4);
				}
				else 
				{
					__reg7 = __reg7 + aInputText.text.substr(__reg2 + 1);
				}
				__reg5 = __reg4;
				__reg2 = __reg9;
			}
		}
		return __reg7;
	}

}
