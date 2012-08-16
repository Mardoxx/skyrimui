import gfx.io.GameDelegate;
import Map.LocalMap;
import Shared.ButtonChange;
import Shared.GlobalFunc;

class Map.MapMenu
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
	
	var BottomBar: MovieClip;
	var LocalMapMenu: MovieClip;
	var MapHeight: Number;
	var MapMovie: MovieClip;
	var MapWidth: Number;
	var MarkerContainer: MovieClip;
	var MarkerData: Array;
	var MarkerDescriptionHolder: MovieClip;
	var MarkerDescriptionObj: MovieClip;
	var Markers: Array;
	var NextCreateIndex: Number;
	var PlayerLocationMarkerType: String;
	var SelectedMarker: MovieClip;
	var YouAreHereMarker: MovieClip;
	var iPlatform: Number;

	function MapMenu(aMapMovie: MovieClip)
	{
		MapMovie = aMapMovie == undefined ? _root : aMapMovie;
		MarkerContainer = MapMovie.createEmptyMovieClip("MarkerClips", 1);
		BottomBar = _root.Bottom;
		Markers = new Array();
		NextCreateIndex = -1;
		MapWidth = 0;
		MapHeight = 0;
		LocalMapMenu = MapMovie.LocalMapFader.MapClip;
		if (LocalMapMenu != undefined) {
			LocalMapMenu.SetBottomBar(BottomBar);
			Mouse.addListener(this);
		}
		MarkerDescriptionHolder = MapMovie.attachMovie("DescriptionHolder", "MarkerDescriptionHolder", MapMovie.getNextHighestDepth());
		MarkerDescriptionHolder._visible = false;
		MarkerDescriptionHolder.hitTestDisable = true;
		MarkerDescriptionObj = MarkerDescriptionHolder.Description;
		Stage.addListener(this);
		Init();
	}

	function onResize(): Void
	{
		MapWidth = Stage.visibleRect.right - Stage.visibleRect.left;
		MapHeight = Stage.visibleRect.bottom - Stage.visibleRect.top;
		if (MapMovie == _root) {
			MarkerContainer._x = Stage.visibleRect.left;
			MarkerContainer._y = Stage.visibleRect.top;
		} else {
			var localMap: LocalMap = LocalMap(MapMovie);
			if (localMap != undefined) {
				MapWidth = localMap.TextureWidth;
				MapHeight = localMap.TextureHeight;
			}
		}
		GlobalFunc.SetLockFunction();
		MovieClip(_root.Bottom).Lock("B");
	}

	function onMouseDown(): Void
	{
		if (BottomBar.hitTest(_root._xmouse, _root._ymouse)) {
			return;
		}
		GameDelegate.call("ClickCallback", []);
	}

	function SetNumMarkers(aNumMarkers: Number): Void
	{
		if (undefined != MarkerContainer) 
		{
			MarkerContainer.removeMovieClip();
			MarkerContainer = MapMovie.createEmptyMovieClip("MarkerClips", 1);
			onResize();
		}
		delete Markers;
		Markers = new Array(aNumMarkers);
		Map.MapMarker.TopDepth = aNumMarkers;
		NextCreateIndex = 0;
		SetSelectedMarker(-1);
	}

	function GetCreatingMarkers(): Boolean
	{
		return NextCreateIndex != -1;
	}

	function CreateMarkers(): Void
	{
		if (-1 != NextCreateIndex && MarkerContainer != undefined) {
			var i: Number = 0;
			var j: Number = NextCreateIndex * Map.MapMenu.CREATE_STRIDE;
			var markersLen: Number = Markers.length;
			var dataLen: Number = MarkerData.length;
			
			while (NextCreateIndex < markersLen && j < dataLen && i < Map.MapMenu.MARKER_CREATE_PER_FRAME) {
				var mapMarker: MovieClip = MarkerContainer.attachMovie(Map.MapMarker.IconTypes[MarkerData[j + Map.MapMenu.CREATE_ICONTYPE]], "Marker" + NextCreateIndex, NextCreateIndex);
				Markers[NextCreateIndex] = mapMarker;
				if (MarkerData[j + Map.MapMenu.CREATE_ICONTYPE] == PlayerLocationMarkerType) {
					YouAreHereMarker = mapMarker.Icon;
				}
				mapMarker.Index = NextCreateIndex;
				mapMarker.label = MarkerData[j + Map.MapMenu.CREATE_NAME];
				mapMarker.textField._visible = false;
				mapMarker.visible = false;
				if (MarkerData[j + Map.MapMenu.CREATE_UNDISCOVERED] && mapMarker.IconClip != undefined) {
					var depth: Number = mapMarker.IconClip.getNextHighestDepth();
					mapMarker.IconClip.attachMovie(Map.MapMarker.IconTypes[MarkerData[j + Map.MapMenu.CREATE_ICONTYPE]] + "Undiscovered", "UndiscoveredIcon", depth);
				}
				++i;
				++NextCreateIndex;
				j = j + Map.MapMenu.CREATE_STRIDE;
			}
			
			if (NextCreateIndex >= markersLen) {
				NextCreateIndex = -1;
			}
		}
	}

	function RefreshMarkers(): Void
	{
		var i: Number = 0;
		var j: Number = 0;
		var markersLen: Number = Markers.length;
		var dataLen: Number = MarkerData.length;
		while (i < markersLen && j < dataLen) {
			var marker: MovieClip = Markers[i];
			marker._visible = MarkerData[j + Map.MapMenu.REFRESH_SHOW];
			if (marker._visible) {
				marker._x = MarkerData[j + Map.MapMenu.REFRESH_X] * MapWidth;
				marker._y = MarkerData[j + Map.MapMenu.REFRESH_Y] * MapHeight;
				marker._rotation = MarkerData[j + Map.MapMenu.REFRESH_ROTATION];
			}
			++i;
			j = j + Map.MapMenu.REFRESH_STRIDE;
		}
		if (SelectedMarker != undefined) {
			MarkerDescriptionHolder._x = SelectedMarker._x + MarkerContainer._x;
			MarkerDescriptionHolder._y = SelectedMarker._y + MarkerContainer._y;
		}
	}

	function SetSelectedMarker(aiSelectedMarkerIndex: Number): Void
	{
		var marker: MovieClip = aiSelectedMarkerIndex < 0 ? undefined : Markers[aiSelectedMarkerIndex];
		if (marker != SelectedMarker) {
			if (SelectedMarker != undefined) {
				SelectedMarker.MarkerRollOut();
				SelectedMarker = undefined;
				MarkerDescriptionHolder.gotoAndPlay("Hide");
			}
			if (marker != undefined && !BottomBar.hitTest(_root._xmouse, _root._ymouse) && marker.visible && marker.MarkerRollOver()) {
				SelectedMarker = marker;
				MarkerDescriptionHolder._visible = true;
				MarkerDescriptionHolder.gotoAndPlay("Show");
				return;
			}
			SelectedMarker = undefined;
		}
	}

	function ClickSelectedMarker(): Void
	{
		if (SelectedMarker != undefined) {
			SelectedMarker.MarkerClick();
		}
	}

	function Init(): Void
	{
		onResize();
		if (BottomBar != undefined) {
			BottomBar.swapDepths(4);
		}
		if (MapMovie.LocalMapFader != undefined) {
			MapMovie.LocalMapFader.swapDepths(3);
			MapMovie.LocalMapFader.gotoAndStop("hide");
			BottomBar.LocalMapButton.addEventListener("click", this, "OnLocalButtonClick");
			BottomBar.JournalButton.addEventListener("click", this, "OnJournalButtonClick");
			BottomBar.PlayerLocButton.addEventListener("click", this, "OnPlayerLocButtonClick");
		}
		GameDelegate.addCallBack("RefreshMarkers", this, "RefreshMarkers");
		GameDelegate.addCallBack("SetSelectedMarker", this, "SetSelectedMarker");
		GameDelegate.addCallBack("ClickSelectedMarker", this, "ClickSelectedMarker");
		GameDelegate.addCallBack("SetDateString", this, "SetDateString");
		GameDelegate.addCallBack("ShowJournal", this, "ShowJournal");
	}

	function OnLocalButtonClick(): Void
	{
		GameDelegate.call("ToggleMapCallback", []);
	}

	function OnJournalButtonClick(): Void
	{
		GameDelegate.call("OpenJournalCallback", []);
	}

	function OnPlayerLocButtonClick(): Void
	{
		GameDelegate.call("CurrentLocationCallback", []);
	}

	function SetPlatform(aPlatformNum: Number, abPS3Switch: Boolean): Void
	{
		if (BottomBar != undefined) {
			BottomBar.LeftButton.SetPlatform(aPlatformNum, abPS3Switch);
			BottomBar.RightButton.SetPlatform(aPlatformNum, abPS3Switch);
			BottomBar.JournalButton.SetPlatform(aPlatformNum, abPS3Switch);
			BottomBar.PlayerLocButton.SetPlatform(aPlatformNum, abPS3Switch);
			BottomBar.LocalMapButton.SetPlatform(aPlatformNum, abPS3Switch);
			BottomBar.JournalButton.disabled = aPlatformNum != ButtonChange.PLATFORM_PC;
			BottomBar.PlayerLocButton.disabled = aPlatformNum != ButtonChange.PLATFORM_PC;
			BottomBar.LocalMapButton.disabled = aPlatformNum != ButtonChange.PLATFORM_PC;
		}
		iPlatform = aPlatformNum;
	}

	function SetDateString(astrDate: String): Void
	{
		BottomBar.DateText.SetText(astrDate);
	}

	function ShowJournal(abShow: Boolean): Void
	{
		if (BottomBar != undefined) {
			BottomBar._visible = !abShow;
		}
	}

	function SetCurrentLocationEnabled(abEnabled: Boolean): Void
	{
		if (BottomBar != undefined && iPlatform == ButtonChange.PLATFORM_PC) {
			BottomBar.PlayerLocButton.disabled = !abEnabled;
		}
	}

}
