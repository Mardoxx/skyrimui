dynamic class Map.MapMarker extends gfx.controls.Button
{
	static var TopDepth: Number = 0;
	static var IconTypes = new Array("EmptyMarker", "CityMarker", "TownMarker", "SettlementMarker", "CaveMarker", "CampMarker", "FortMarker", "NordicRuinMarker", "DwemerMarker", "ShipwreckMarker", "GroveMarker", "LandmarkMarker", "DragonlairMarker", "FarmMarker", "WoodMillMarker", "MineMarker", "ImperialCampMarker", "StormcloakCampMarker", "DoomstoneMarker", "WheatMillMarker", "SmelterMarker", "StableMarker", "ImperialTowerMarker", "ClearingMarker", "PassMarker", "AltarMarker", "RockMarker", "LighthouseMarker", "OrcStrongholdMarker", "GiantCampMarker", "ShackMarker", "NordicTowerMarker", "NordicDwellingMarker", "DocksMarker", "ShrineMarker", "RiftenCastleMarker", "RiftenCapitolMarker", "WindhelmCastleMarker", "WindhelmCapitolMarker", "WhiterunCastleMarker", "WhiterunCapitolMarker", "SolitudeCastleMarker", "SolitudeCapitolMarker", "MarkarthCastleMarker", "MarkarthCapitolMarker", "WinterholdCastleMarker", "WinterholdCapitolMarker", "MorthalCastleMarker", "MorthalCapitolMarker", "FalkreathCastleMarker", "FalkreathCapitolMarker", "DawnstarCastleMarker", "DawnstarCapitolMarker", "", "DoorMarker", "QuestTargetMarker", "QuestTargetDoorMarker", "MultipleQuestTargetMarker", "PlayerSetMarker", "YouAreHereMarker");
	var HitAreaClip;
	var Index;
	var TextClip;
	var _FadingIn;
	var _FadingOut;
	var _parent;
	var _visible;
	var gotoAndPlay;
	var hitArea;
	var onRollOut;
	var onRollOver;
	var state;
	var stateMap;
	var swapDepths;
	var textField;

	function MapMarker()
	{
		super();
		this.hitArea = this.HitAreaClip;
		this.textField = this.TextClip.MarkerNameField;
		this.textField.autoSize = "left";
		this.Index = -1;
		this.disableFocus = true;
		this._FadingIn = false;
		this._FadingOut = false;
		this.stateMap.release = ["up"];
	}

	function configUI()
	{
		super.configUI();
		this.onRollOver = function ()
		{
		}
		;
		this.onRollOut = function ()
		{
		}
		;
	}

	function get FadingIn()
	{
		return this._FadingIn;
	}

	function set FadingIn(value)
	{
		if (value != this._FadingIn) 
		{
			this._FadingIn = value;
			if (this._FadingIn) 
			{
				this._visible = true;
				this.gotoAndPlay("fade_in");
			}
		}
	}

	function get FadingOut()
	{
		return this._FadingOut;
	}

	function set FadingOut(value)
	{
		if (value != this._FadingOut) 
		{
			this._FadingOut = value;
			if (this._FadingOut) 
			{
				this.gotoAndPlay("fade_out");
			}
		}
	}

	function setState(state)
	{
		if (!this._FadingOut && !this._FadingIn) 
		{
			super.setState(state);
		}
	}

	function MarkerRollOver()
	{
		var __reg2 = false;
		this.setState("over");
		__reg2 = this.state == "over";
		if (__reg2) 
		{
			var __reg3 = this._parent.getInstanceAtDepth(Map.MapMarker.TopDepth);
			if (undefined != __reg3) 
			{
				__reg3.swapDepths(Map.MapMarker(__reg3).Index);
			}
			this.swapDepths(Map.MapMarker.TopDepth);
			gfx.io.GameDelegate.call("PlaySound", ["UIMapRollover"]);
		}
		return __reg2;
	}

	function MarkerRollOut()
	{
		this.setState("out");
	}

	function MarkerClick()
	{
		gfx.io.GameDelegate.call("MarkerClick", [this.Index]);
	}

}
