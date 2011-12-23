dynamic class Map.LocalMap extends MovieClip
{
	var BottomBar;
	var ClearedDescription;
	var ClearedText;
	var IconDisplay;
	var LocalMapHolder_mc;
	var LocationDescription;
	var LocationTextClip;
	var MapImageLoader;
	var TextureHolder;
	var _TextureHeight;
	var _TextureWidth;
	var _parent;
	var _x;
	var _y;
	var bUpdated;

	function LocalMap()
	{
		super();
		this.IconDisplay = new Map.MapMenu(this);
		this.MapImageLoader = new MovieClipLoader();
		this.MapImageLoader.addListener(this);
		this._TextureWidth = 800;
		this._TextureHeight = 450;
		this.LocationDescription = this.LocationTextClip.LocationText;
		this.LocationDescription.noTranslate = true;
		this.LocationTextClip.swapDepths(3);
		this.ClearedDescription = this.ClearedText;
		this.ClearedDescription.noTranslate = true;
		this.TextureHolder = this.LocalMapHolder_mc;
	}

	function get TextureWidth()
	{
		return this._TextureWidth;
	}

	function get TextureHeight()
	{
		return this._TextureHeight;
	}

	function onLoadInit(TargetClip)
	{
		TargetClip._width = this._TextureWidth;
		TargetClip._height = this._TextureHeight;
	}

	function InitMap()
	{
		if (!this.bUpdated) 
		{
			this.MapImageLoader.loadClip("img://Local_Map", this.TextureHolder);
			this.bUpdated = true;
		}
		var __reg3 = {x: this._x, y: this._y};
		var __reg2 = {x: this._x + this._TextureWidth, y: this._y + this._TextureHeight};
		this._parent.localToGlobal(__reg3);
		this._parent.localToGlobal(__reg2);
		gfx.io.GameDelegate.call("SetLocalMapExtents", [__reg3.x, __reg3.y, __reg2.x, __reg2.y]);
	}

	function Show(abShow)
	{
		this._parent.gotoAndPlay(abShow ? "fadeIn" : "fadeOut");
		this.BottomBar.RightButton.visible = !abShow;
		this.BottomBar.LocalMapButton.label = abShow ? "$World Map" : "$Local Map";
	}

	function SetBottomBar(aBottomBar)
	{
		this.BottomBar = aBottomBar;
	}

	function SetTitle(aName, aCleared)
	{
		this.LocationDescription.text = aName == undefined ? "" : aName;
		this.ClearedDescription.text = aCleared == undefined ? "" : "(" + aCleared + ")";
	}

}
