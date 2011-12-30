dynamic class Map.MapMenu
{
	static var REFRESH_SHOW: Number = 0;
	static var REFRESH_X: Number = 1;
	static var REFRESH_Y: Number = 2;
	static var REFRESH_ROTATION: Number = 3;
	static var REFRESH_STRIDE: Number = 4;
	static var CREATE_NAME: Number = 0;
	static var CREATE_ICONTYPE: Number = 1;
	static var CREATE_UNDISCOVERED: Number = 2;
	static var CREATE_STRIDE: Number = 3;
	static var MARKER_CREATE_PER_FRAME: Number = 10;
	var BottomBar;
	var LocalMapMenu;
	var MapHeight;
	var MapMovie;
	var MapWidth;
	var MarkerContainer;
	var MarkerData;
	var MarkerDescriptionHolder;
	var MarkerDescriptionObj;
	var Markers;
	var NextCreateIndex;
	var PlayerLocationMarkerType;
	var SelectedMarker;
	var YouAreHereMarker;
	var iPlatform;

	function MapMenu(aMapMovie)
	{
		this.MapMovie = aMapMovie == undefined ? _root : aMapMovie;
		this.MarkerContainer = this.MapMovie.createEmptyMovieClip("MarkerClips", 1);
		this.BottomBar = _root.Bottom;
		this.Markers = new Array();
		this.NextCreateIndex = -1;
		this.MapWidth = 0;
		this.MapHeight = 0;
		this.LocalMapMenu = this.MapMovie.LocalMapFader.MapClip;
		if (this.LocalMapMenu != undefined) 
		{
			this.LocalMapMenu.SetBottomBar(this.BottomBar);
			Mouse.addListener(this);
		}
		this.MarkerDescriptionHolder = this.MapMovie.attachMovie("DescriptionHolder", "MarkerDescriptionHolder", this.MapMovie.getNextHighestDepth());
		this.MarkerDescriptionHolder._visible = false;
		this.MarkerDescriptionHolder.hitTestDisable = true;
		this.MarkerDescriptionObj = this.MarkerDescriptionHolder.Description;
		Stage.addListener(this);
		this.Init();
	}

	function onResize()
	{
		this.MapWidth = Stage.visibleRect.right - Stage.visibleRect.left;
		this.MapHeight = Stage.visibleRect.bottom - Stage.visibleRect.top;
		if (this.MapMovie == _root) 
		{
			this.MarkerContainer._x = Stage.visibleRect.left;
			this.MarkerContainer._y = Stage.visibleRect.top;
		}
		else 
		{
			var __reg3 = Map.LocalMap(this.MapMovie);
			if (__reg3 != undefined) 
			{
				this.MapWidth = __reg3.TextureWidth;
				this.MapHeight = __reg3.TextureHeight;
			}
		}
		Shared.GlobalFunc.SetLockFunction();
		MovieClip(_root.Bottom).Lock("B");
	}

	function onMouseDown()
	{
		if (this.BottomBar.hitTest(_root._xmouse, _root._ymouse)) 
		{
			return;
		}
		gfx.io.GameDelegate.call("ClickCallback", []);
	}

	function SetNumMarkers(aNumMarkers)
	{
		if (undefined != this.MarkerContainer) 
		{
			this.MarkerContainer.removeMovieClip();
			this.MarkerContainer = this.MapMovie.createEmptyMovieClip("MarkerClips", 1);
			this.onResize();
		}
		delete this.Markers;
		this.Markers = new Array(aNumMarkers);
		Map.MapMarker.TopDepth = aNumMarkers;
		this.NextCreateIndex = 0;
		this.SetSelectedMarker(-1);
	}

	function GetCreatingMarkers()
	{
		return this.NextCreateIndex != -1;
	}

	function CreateMarkers()
	{
		if (-1 != this.NextCreateIndex && this.MarkerContainer != undefined) 
		{
			var __reg5 = 0;
			var __reg3 = this.NextCreateIndex * Map.MapMenu.CREATE_STRIDE;
			var __reg6 = this.Markers.length;
			var __reg7 = this.MarkerData.length;
			while (this.NextCreateIndex < __reg6 && __reg3 < __reg7 && __reg5 < Map.MapMenu.MARKER_CREATE_PER_FRAME) 
			{
				var __reg2 = this.MarkerContainer.attachMovie(Map.MapMarker.IconTypes[this.MarkerData[__reg3 + Map.MapMenu.CREATE_ICONTYPE]], "Marker" + this.NextCreateIndex, this.NextCreateIndex);
				this.Markers[this.NextCreateIndex] = __reg2;
				if (this.MarkerData[__reg3 + Map.MapMenu.CREATE_ICONTYPE] == this.PlayerLocationMarkerType) 
				{
					this.YouAreHereMarker = __reg2.Icon;
				}
				__reg2.Index = this.NextCreateIndex;
				__reg2.label = this.MarkerData[__reg3 + Map.MapMenu.CREATE_NAME];
				__reg2.textField._visible = false;
				__reg2.visible = false;
				if (this.MarkerData[__reg3 + Map.MapMenu.CREATE_UNDISCOVERED] && __reg2.IconClip != undefined) 
				{
					var __reg4 = __reg2.IconClip.getNextHighestDepth();
					__reg2.IconClip.attachMovie(Map.MapMarker.IconTypes[this.MarkerData[__reg3 + Map.MapMenu.CREATE_ICONTYPE]] + "Undiscovered", "UndiscoveredIcon", __reg4);
				}
				++__reg5;
				++this.NextCreateIndex;
				__reg3 = __reg3 + Map.MapMenu.CREATE_STRIDE;
			}
			if (this.NextCreateIndex >= __reg6) 
			{
				this.NextCreateIndex = -1;
			}
		}
	}

	function RefreshMarkers()
	{
		var __reg4 = 0;
		var __reg3 = 0;
		var __reg6 = this.Markers.length;
		var __reg5 = this.MarkerData.length;
		while (__reg4 < __reg6 && __reg3 < __reg5) 
		{
			var __reg2 = this.Markers[__reg4];
			__reg2._visible = this.MarkerData[__reg3 + Map.MapMenu.REFRESH_SHOW];
			if (__reg2._visible) 
			{
				__reg2._x = this.MarkerData[__reg3 + Map.MapMenu.REFRESH_X] * this.MapWidth;
				__reg2._y = this.MarkerData[__reg3 + Map.MapMenu.REFRESH_Y] * this.MapHeight;
				__reg2._rotation = this.MarkerData[__reg3 + Map.MapMenu.REFRESH_ROTATION];
			}
			++__reg4;
			__reg3 = __reg3 + Map.MapMenu.REFRESH_STRIDE;
		}
		if (this.SelectedMarker != undefined) 
		{
			this.MarkerDescriptionHolder._x = this.SelectedMarker._x + this.MarkerContainer._x;
			this.MarkerDescriptionHolder._y = this.SelectedMarker._y + this.MarkerContainer._y;
		}
	}

	function SetSelectedMarker(aiSelectedMarkerIndex)
	{
		var __reg3 = aiSelectedMarkerIndex < 0 ? undefined : this.Markers[aiSelectedMarkerIndex];
		if (__reg3 != this.SelectedMarker) 
		{
			if (this.SelectedMarker != undefined) 
			{
				this.SelectedMarker.MarkerRollOut();
				this.SelectedMarker = undefined;
				this.MarkerDescriptionHolder.gotoAndPlay("Hide");
			}
			if (__reg3 != undefined && !this.BottomBar.hitTest(_root._xmouse, _root._ymouse) && __reg3.visible && __reg3.MarkerRollOver()) 
			{
				this.SelectedMarker = __reg3;
				this.MarkerDescriptionHolder._visible = true;
				this.MarkerDescriptionHolder.gotoAndPlay("Show");
				return;
			}
			this.SelectedMarker = undefined;
		}
	}

	function ClickSelectedMarker()
	{
		if (this.SelectedMarker != undefined) 
		{
			this.SelectedMarker.MarkerClick();
		}
	}

	function Init()
	{
		this.onResize();
		if (this.BottomBar != undefined) 
		{
			this.BottomBar.swapDepths(4);
		}
		if (this.MapMovie.LocalMapFader != undefined) 
		{
			this.MapMovie.LocalMapFader.swapDepths(3);
			this.MapMovie.LocalMapFader.gotoAndStop("hide");
			this.BottomBar.LocalMapButton.addEventListener("click", this, "OnLocalButtonClick");
			this.BottomBar.JournalButton.addEventListener("click", this, "OnJournalButtonClick");
			this.BottomBar.PlayerLocButton.addEventListener("click", this, "OnPlayerLocButtonClick");
		}
		gfx.io.GameDelegate.addCallBack("RefreshMarkers", this, "RefreshMarkers");
		gfx.io.GameDelegate.addCallBack("SetSelectedMarker", this, "SetSelectedMarker");
		gfx.io.GameDelegate.addCallBack("ClickSelectedMarker", this, "ClickSelectedMarker");
		gfx.io.GameDelegate.addCallBack("SetDateString", this, "SetDateString");
		gfx.io.GameDelegate.addCallBack("ShowJournal", this, "ShowJournal");
	}

	function OnLocalButtonClick()
	{
		gfx.io.GameDelegate.call("ToggleMapCallback", []);
	}

	function OnJournalButtonClick()
	{
		gfx.io.GameDelegate.call("OpenJournalCallback", []);
	}

	function OnPlayerLocButtonClick()
	{
		gfx.io.GameDelegate.call("CurrentLocationCallback", []);
	}

	function SetPlatform(aPlatformNum: Number, abPS3Switch: Boolean)
	{
		if (this.BottomBar != undefined) 
		{
			this.BottomBar.LeftButton.SetPlatform(aPlatformNum, abPS3Switch);
			this.BottomBar.RightButton.SetPlatform(aPlatformNum, abPS3Switch);
			this.BottomBar.JournalButton.SetPlatform(aPlatformNum, abPS3Switch);
			this.BottomBar.PlayerLocButton.SetPlatform(aPlatformNum, abPS3Switch);
			this.BottomBar.LocalMapButton.SetPlatform(aPlatformNum, abPS3Switch);
			this.BottomBar.JournalButton.disabled = aPlatformNum != Shared.ButtonChange.PLATFORM_PC;
			this.BottomBar.PlayerLocButton.disabled = aPlatformNum != Shared.ButtonChange.PLATFORM_PC;
			this.BottomBar.LocalMapButton.disabled = aPlatformNum != Shared.ButtonChange.PLATFORM_PC;
		}
		this.iPlatform = aPlatformNum;
	}

	function SetDateString(astrDate)
	{
		this.BottomBar.DateText.SetText(astrDate);
	}

	function ShowJournal(abShow)
	{
		if (this.BottomBar != undefined) 
		{
			this.BottomBar._visible = !abShow;
		}
	}

	function SetCurrentLocationEnabled(abEnabled)
	{
		if (this.BottomBar != undefined && this.iPlatform == Shared.ButtonChange.PLATFORM_PC) 
		{
			this.BottomBar.PlayerLocButton.disabled = !abEnabled;
		}
	}

}
