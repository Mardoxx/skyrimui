class HUDMenu extends Shared.PlatformChangeUser
{
	var SavedRolloverText: String = "";
	var ItemInfoArray: Array = new Array();
	var CompassMarkerList: Array = new Array();
	var METER_PAUSE_FRAME: Number = 40;
	
	
	var ActivateButton_tf;
	var ArrowInfoInstance;
	var BottomLeftLockInstance;
	var BottomRightLockInstance;
	var BottomRightRefInstance;
	var BottomRightRefX: Number;
	var BottomRightRefY: Number;
	var CompassMarkerEnemy: Number;
	var CompassMarkerLocations: Number;
	var CompassMarkerPlayerSet: Number;
	var CompassMarkerQuest: Number;
	var CompassMarkerQuestDoor: Number;
	var CompassMarkerUndiscovered: Number;
	var CompassRect;
	var CompassShoutMeterHolder;
	var CompassTargetDataA: Array;
	var CompassThreeSixtyX: Number;
	var CompassZeroX: Number;
	var Crosshair;
	var CrosshairAlert;
	var CrosshairInstance;
	var EnemyHealthMeter: Components.Meter;
	var EnemyHealth_mc;
	var FavorBackButtonBase;
	var FavorBackButton_mc;
	var FloatingQuestMarkerInstance;
	var FloatingQuestMarker_mc;
	var GrayBarInstance;
	var HUDModes: Array;
	var Health;
	var HealthMeterAnim;
	var HealthMeterLeft: Components.BlinkOnEmptyMeter;
	var HudElements: Array;
	var LeftChargeMeter: Components.Meter;
	var LeftChargeMeterAnim;
	var LocationLockBase;
	var Magica;
	var MagickaMeter: Components.BlinkOnDemandMeter;
	var MagickaMeterAnim;
	var MessagesBlock;
	var MessagesInstance;
	var QuestUpdateBaseInstance;
	var RightChargeMeter: Components.Meter;
	var RightChargeMeterAnim;
	var RolloverButton_tf;
	var RolloverGrayBar_mc;
	var RolloverInfoInstance: TextField;
	var RolloverInfoText: TextField;
	var RolloverNameInstance;
	var RolloverText;
	var ShoutMeter_mc;
	var Stamina;
	var StaminaMeter: Components.BlinkOnDemandMeter;
	var StaminaMeterAnim;
	var StealthMeterInstance;
	var SubtitleText: TextField;
	var SubtitleTextHolder: MovieClip;
	var TopLeftRefInstance: MovieClip;
	var TopLeftRefX: Number;
	var TopLeftRefY: Number;
	var TutorialHintsArtHolder;
	var TutorialHintsText;
	var TutorialLockInstance;
	var ValueTranslated;
	var WeightTranslated;
	var bCrosshairEnabled: Boolean;

	function HUDMenu()
	{
		super();
		Shared.GlobalFunc.MaintainTextFormat();
		Shared.GlobalFunc.AddReverseFunctions();
		Key.addListener(this);
		this.MagickaMeter = new Components.BlinkOnDemandMeter(this.Magica.MagickaMeter_mc, this.Magica.MagickaFlashInstance);
		this.HealthMeterLeft = new Components.BlinkOnEmptyMeter(this.Health.HealthMeter_mc.HealthLeft);
		this.StaminaMeter = new Components.BlinkOnDemandMeter(this.Stamina.StaminaMeter_mc, this.Stamina.StaminaFlashInstance);
		this.ShoutMeter_mc = new ShoutMeter(this.CompassShoutMeterHolder.ShoutMeterInstance, this.CompassShoutMeterHolder.ShoutWarningInstance);
		this.LeftChargeMeter = new Components.Meter(this.BottomLeftLockInstance.LeftHandChargeMeterInstance.ChargeMeter_mc);
		this.RightChargeMeter = new Components.Meter(this.BottomRightLockInstance.RightHandChargeMeterInstance.ChargeMeter_mc);
		this.MagickaMeterAnim = this.Magica;
		this.HealthMeterAnim = this.Health;
		this.StaminaMeterAnim = this.Stamina;
		this.LeftChargeMeterAnim = this.BottomLeftLockInstance.LeftHandChargeMeterInstance;
		this.RightChargeMeterAnim = this.BottomRightLockInstance.RightHandChargeMeterInstance;
		this.LeftChargeMeterAnim.gotoAndStop(1);
		this.RightChargeMeterAnim.gotoAndStop(1);
		this.MagickaMeterAnim.gotoAndStop(1);
		this.HealthMeterAnim.gotoAndStop(1);
		this.StaminaMeterAnim.gotoAndStop(1);
		this.ArrowInfoInstance.gotoAndStop(1);
		this.EnemyHealthMeter = new Components.Meter(this.EnemyHealth_mc);
		this.EnemyHealth_mc.BracketsInstance.RolloverNameInstance.textAutoSize = "shrink";
		this.EnemyHealthMeter.SetPercent(0);
		this.gotoAndStop("Alert");
		this.CrosshairAlert = this.Crosshair;
		this.CrosshairAlert.gotoAndStop("NoTarget");
		this.gotoAndStop("Normal");
		this.CrosshairInstance = this.Crosshair;
		this.CrosshairInstance.gotoAndStop("NoTarget");
		this.RolloverText = this.RolloverNameInstance;
		this.RolloverButton_tf = this.ActivateButton_tf;
		this.RolloverInfoText = this.RolloverInfoInstance;
		this.RolloverGrayBar_mc = this.GrayBarInstance;
		this.RolloverGrayBar_mc._alpha = 0;
		this.RolloverInfoText.html = true;
		this.FavorBackButton_mc = this.FavorBackButtonBase;
		this.CompassRect = this.CompassShoutMeterHolder.Compass.DirectionRect;
		this.InitCompass();
		this.FloatingQuestMarker_mc = this.FloatingQuestMarkerInstance;
		this.MessagesInstance = this.MessagesBlock;
		this.SetCrosshairTarget(false, "");
		this.bCrosshairEnabled = true;
		this.SubtitleText = this.SubtitleTextHolder.textField;
		this.TutorialHintsText = this.TutorialLockInstance.TutorialHintsInstance.FadeHolder.TutorialHintsTextInstance;
		this.TutorialHintsArtHolder = this.TutorialLockInstance.TutorialHintsInstance.FadeHolder.TutorialHintsArtInstance;
		this.TutorialLockInstance.TutorialHintsInstance.gotoAndStop("FadeIn");
		this.CompassTargetDataA = new Array();
		this.SetModes();
		this.StealthMeterInstance.gotoAndStop("FadedOut");
	}

	function RegisterComponents()
	{
		gfx.io.GameDelegate.call("RegisterHUDComponents", [this, this.HudElements, this.QuestUpdateBaseInstance, this.EnemyHealthMeter, this.StealthMeterInstance, this.StealthMeterInstance.SneakAnimInstance, this.EnemyHealth_mc.BracketsInstance, this.EnemyHealth_mc.BracketsInstance.RolloverNameInstance, this.StealthMeterInstance.SneakTextHolder, this.StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance]);
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		this.FavorBackButton_mc.FavorBackButtonInstance.SetPlatform(aiPlatform, abPS3Switch);
	}

	function SetModes()
	{
		this.HudElements = new Array();
		this.HUDModes = new Array();
		this.HudElements.push(this.Health);
		this.HudElements.push(this.Magica);
		this.HudElements.push(this.Stamina);
		this.HudElements.push(this.LeftChargeMeterAnim);
		this.HudElements.push(this.RightChargeMeterAnim);
		this.HudElements.push(this.CrosshairInstance);
		this.HudElements.push(this.CrosshairAlert);
		this.HudElements.push(this.RolloverText);
		this.HudElements.push(this.RolloverInfoText);
		this.HudElements.push(this.RolloverGrayBar_mc);
		this.HudElements.push(this.RolloverButton_tf);
		this.HudElements.push(this.CompassShoutMeterHolder);
		this.HudElements.push(this.MessagesBlock);
		this.HudElements.push(this.SubtitleTextHolder);
		this.HudElements.push(this.QuestUpdateBaseInstance);
		this.HudElements.push(this.EnemyHealth_mc);
		this.HudElements.push(this.StealthMeterInstance);
		this.HudElements.push(this.StealthMeterInstance.SneakTextHolder.SneakTextClip);
		this.HudElements.push(this.StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance);
		this.HudElements.push(this.ArrowInfoInstance);
		this.HudElements.push(this.FavorBackButton_mc);
		this.HudElements.push(this.FloatingQuestMarker_mc);
		this.HudElements.push(this.LocationLockBase);
		this.HudElements.push(this.TutorialLockInstance);
		this.Health.All = true;
		this.Magica.All = true;
		this.Stamina.All = true;
		this.LeftChargeMeterAnim.All = true;
		this.RightChargeMeterAnim.All = true;
		this.CrosshairInstance.All = true;
		this.CrosshairAlert.All = true;
		this.RolloverText.All = true;
		this.RolloverInfoText.All = true;
		this.RolloverGrayBar_mc.All = true;
		this.RolloverButton_tf.All = true;
		this.CompassShoutMeterHolder.All = true;
		this.MessagesBlock.All = true;
		this.SubtitleTextHolder.All = true;
		this.QuestUpdateBaseInstance.All = true;
		this.EnemyHealth_mc.All = true;
		this.StealthMeterInstance.All = true;
		this.ArrowInfoInstance.All = true;
		this.FloatingQuestMarker_mc.All = true;
		this.StealthMeterInstance.SneakTextHolder.SneakTextClip.All = true;
		this.StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance.All = true;
		this.LocationLockBase.All = true;
		this.TutorialLockInstance.All = true;
		this.CrosshairInstance.Favor = true;
		this.RolloverText.Favor = true;
		this.RolloverInfoText.Favor = true;
		this.RolloverGrayBar_mc.Favor = true;
		this.RolloverButton_tf.Favor = true;
		this.CompassShoutMeterHolder.Favor = true;
		this.MessagesBlock.Favor = true;
		this.SubtitleTextHolder.Favor = true;
		this.QuestUpdateBaseInstance.Favor = true;
		this.EnemyHealth_mc.Favor = true;
		this.StealthMeterInstance.Favor = true;
		this.FavorBackButton_mc.Favor = true;
		this.FavorBackButton_mc._visible = false;
		this.FloatingQuestMarker_mc.Favor = true;
		this.LocationLockBase.Favor = true;
		this.TutorialLockInstance.Favor = true;
		this.MessagesBlock.InventoryMode = true;
		this.QuestUpdateBaseInstance.InventoryMode = true;
		this.MessagesBlock.TweenMode = true;
		this.QuestUpdateBaseInstance.TweenMode = true;
		this.MessagesBlock.BookMode = true;
		this.QuestUpdateBaseInstance.BookMode = true;
		this.QuestUpdateBaseInstance.DialogueMode = true;
		this.CompassShoutMeterHolder.DialogueMode = true;
		this.MessagesBlock.DialogueMode = true;
		this.QuestUpdateBaseInstance.BarterMode = true;
		this.MessagesBlock.BarterMode = true;
		this.MessagesBlock.WorldMapMode = true;
		this.MessagesBlock.MovementDisabled = true;
		this.QuestUpdateBaseInstance.MovementDisabled = true;
		this.SubtitleTextHolder.MovementDisabled = true;
		this.TutorialLockInstance.MovementDisabled = true;
		this.Health.StealthMode = true;
		this.Magica.StealthMode = true;
		this.Stamina.StealthMode = true;
		this.LeftChargeMeterAnim.StealthMode = true;
		this.RightChargeMeterAnim.StealthMode = true;
		this.RolloverText.StealthMode = true;
		this.RolloverButton_tf.StealthMode = true;
		this.RolloverInfoText.StealthMode = true;
		this.RolloverGrayBar_mc.StealthMode = true;
		this.CompassShoutMeterHolder.StealthMode = true;
		this.MessagesBlock.StealthMode = true;
		this.SubtitleTextHolder.StealthMode = true;
		this.QuestUpdateBaseInstance.StealthMode = true;
		this.EnemyHealth_mc.StealthMode = true;
		this.StealthMeterInstance.StealthMode = true;
		this.StealthMeterInstance.SneakTextHolder.SneakTextClip.StealthMode = true;
		this.StealthMeterInstance.SneakTextHolder.SneakTextClip.SneakTextInstance.StealthMode = true;
		this.ArrowInfoInstance.StealthMode = true;
		this.FloatingQuestMarker_mc.StealthMode = true;
		this.LocationLockBase.StealthMode = true;
		this.TutorialLockInstance.StealthMode = true;
		this.Health.Swimming = true;
		this.Magica.Swimming = true;
		this.Stamina.Swimming = true;
		this.LeftChargeMeterAnim.Swimming = true;
		this.RightChargeMeterAnim.Swimming = true;
		this.CrosshairInstance.Swimming = true;
		this.RolloverText.Swimming = true;
		this.RolloverInfoText.Swimming = true;
		this.RolloverGrayBar_mc.Swimming = true;
		this.RolloverButton_tf.Swimming = true;
		this.CompassShoutMeterHolder.Swimming = true;
		this.MessagesBlock.Swimming = true;
		this.SubtitleTextHolder.Swimming = true;
		this.QuestUpdateBaseInstance.Swimming = true;
		this.EnemyHealth_mc.Swimming = true;
		this.ArrowInfoInstance.Swimming = true;
		this.FloatingQuestMarker_mc.Swimming = true;
		this.LocationLockBase.Swimming = true;
		this.TutorialLockInstance.Swimming = true;
		this.Health.HorseMode = true;
		this.CompassShoutMeterHolder.HorseMode = true;
		this.MessagesBlock.HorseMode = true;
		this.SubtitleTextHolder.HorseMode = true;
		this.QuestUpdateBaseInstance.HorseMode = true;
		this.EnemyHealth_mc.HorseMode = true;
		this.FloatingQuestMarker_mc.HorseMode = true;
		this.LocationLockBase.HorseMode = true;
		this.TutorialLockInstance.HorseMode = true;
		this.MessagesBlock.CartMode = true;
		this.SubtitleTextHolder.CartMode = true;
		this.TutorialLockInstance.CartMode = true;
	}

	function ShowElements(aMode, abShow)
	{
		var HUDMode = "All";
		if (abShow) 
		{
			var aHUDMode = this.HUDModes.length - 1;
			while (aHUDMode >= 0) 
			{
				if (this.HUDModes[aHUDMode] == aMode) 
				{
					this.HUDModes.splice(aHUDMode, 1);
				}
				--aHUDMode;
			}
			this.HUDModes.push(aMode);
			HUDMode = aMode;
		}
		else 
		{
			if (aMode.length > 0) 
			{
				var ModeFound = false;
				var aHUDMode = this.HUDModes.length - 1;
				while (aHUDMode >= 0 && !ModeFound) 
				{
					if (this.HUDModes[aHUDMode] == aMode) 
					{
						this.HUDModes.splice(aHUDMode, 1);
						ModeFound = true;
					}
					--aHUDMode;
				}
			}
			else 
			{
				this.HUDModes.pop();
			}
			if (this.HUDModes.length > 0) 
			{
				HUDMode = String(this.HUDModes[this.HUDModes.length - 1]);
			}
		}
		var i = 0;
		for (;;) 
		{
			if (i >= this.HudElements.length) 
			{
				return;
			}
			if (this.HudElements[i] != undefined) 
			{
				this.HudElements[i]._visible = this.HudElements[i].hasOwnProperty(HUDMode);
				if (this.HudElements[i].onModeChange != undefined) 
				{
					this.HudElements[i].onModeChange(HUDMode);
				}
			}
			++i;
		}
	}

	function SetLocationName(aLocation)
	{
		this.LocationLockBase.LocationNameBase.LocationTextBase.LocationTextInstance.SetText(aLocation);
		this.LocationLockBase.LocationNameBase.gotoAndPlay(1);
	}

	function CheckAgainstHudMode(aObj)
	{
		var HUDMode = "All";
		if (this.HUDModes.length > 0) 
		{
			HUDMode = String(this.HUDModes[this.HUDModes.length - 1]);
		}
		return HUDMode == "All" || (aObj != undefined && aObj.hasOwnProperty(HUDMode));
	}

	function InitExtensions()
	{
		var _yDelta = this.QuestUpdateBaseInstance._y - this.CompassShoutMeterHolder._y;
		Shared.GlobalFunc.SetLockFunction();
		this.HealthMeterAnim.Lock("B");
		this.MagickaMeterAnim.Lock("BL");
		this.StaminaMeterAnim.Lock("BR");
		this.TopLeftRefInstance.Lock("TL");
		this.BottomRightRefInstance.Lock("BR");
		this.BottomLeftLockInstance.Lock("BL");
		this.BottomRightLockInstance.Lock("BR");
		this.ArrowInfoInstance.Lock("BR");
		this.FavorBackButton_mc.Lock("BR");
		this.LocationLockBase.Lock("TR");
		this.LocationLockBase.LocationNameBase.gotoAndStop(1);
		var TopLeftRefCoords = {x: this.TopLeftRefInstance.LocationRefInstance._x, y: this.TopLeftRefInstance.LocationRefInstance._y};
		this.TopLeftRefInstance.localToGlobal(TopLeftRefCoords);
		this.TopLeftRefX = TopLeftRefCoords.x;
		this.TopLeftRefY = TopLeftRefCoords.y;
		var LocationRefCoords = {x: this.BottomRightRefInstance.LocationRefInstance._x, y: this.BottomRightRefInstance.LocationRefInstance._y};
		this.BottomRightRefInstance.localToGlobal(LocationRefCoords);
		this.BottomRightRefX = LocationRefCoords.x;
		this.BottomRightRefY = LocationRefCoords.y;
		this.CompassShoutMeterHolder.Lock("T");
		this.EnemyHealth_mc.Lock("T");
		this.MessagesBlock.Lock("TL");
		this.QuestUpdateBaseInstance._y = this.CompassShoutMeterHolder._y + _yDelta;
		this.SubtitleTextHolder.Lock("B");
		this.SubtitleText._visible = false;
		this.SubtitleText.enabled = true;
		this.SubtitleText.verticalAutoSize = "bottom";
		this.SubtitleText.SetText(" ", true);
		this.RolloverText.verticalAutoSize = "top";
		this.RolloverText.html = true;
		gfx.io.GameDelegate.addCallBack("SetCrosshairTarget", this, "SetCrosshairTarget");
		gfx.io.GameDelegate.addCallBack("SetLoadDoorInfo", this, "SetLoadDoorInfo");
		gfx.io.GameDelegate.addCallBack("ShowMessage", this, "ShowMessage");
		gfx.io.GameDelegate.addCallBack("ShowSubtitle", this, "ShowSubtitle");
		gfx.io.GameDelegate.addCallBack("HideSubtitle", this, "HideSubtitle");
		gfx.io.GameDelegate.addCallBack("SetCrosshairEnabled", this, "SetCrosshairEnabled");
		gfx.io.GameDelegate.addCallBack("SetSubtitlesEnabled", this, "SetSubtitlesEnabled");
		gfx.io.GameDelegate.addCallBack("SetHealthMeterPercent", this, "SetHealthMeterPercent");
		gfx.io.GameDelegate.addCallBack("SetMagickaMeterPercent", this, "SetMagickaMeterPercent");
		gfx.io.GameDelegate.addCallBack("SetStaminaMeterPercent", this, "SetStaminaMeterPercent");
		gfx.io.GameDelegate.addCallBack("SetShoutMeterPercent", this, "SetShoutMeterPercent");
		gfx.io.GameDelegate.addCallBack("FlashShoutMeter", this, "FlashShoutMeter");
		gfx.io.GameDelegate.addCallBack("SetChargeMeterPercent", this, "SetChargeMeterPercent");
		gfx.io.GameDelegate.addCallBack("StartMagickaMeterBlinking", this, "StartMagickaBlinking");
		gfx.io.GameDelegate.addCallBack("StartStaminaMeterBlinking", this, "StartStaminaBlinking");
		gfx.io.GameDelegate.addCallBack("FadeOutStamina", this, "FadeOutStamina");
		gfx.io.GameDelegate.addCallBack("FadeOutChargeMeters", this, "FadeOutChargeMeters");
		gfx.io.GameDelegate.addCallBack("SetCompassAngle", this, "SetCompassAngle");
		gfx.io.GameDelegate.addCallBack("SetCompassMarkers", this, "SetCompassMarkers");
		gfx.io.GameDelegate.addCallBack("SetEnemyHealthPercent", this.EnemyHealthMeter, "SetPercent");
		gfx.io.GameDelegate.addCallBack("SetEnemyHealthTargetPercent", this.EnemyHealthMeter, "SetTargetPercent");
		gfx.io.GameDelegate.addCallBack("ShowNotification", this.QuestUpdateBaseInstance, "ShowNotification");
		gfx.io.GameDelegate.addCallBack("ShowElements", this, "ShowElements");
		gfx.io.GameDelegate.addCallBack("SetLocationName", this, "SetLocationName");
		gfx.io.GameDelegate.addCallBack("ShowTutorialHintText", this, "ShowTutorialHintText");
		gfx.io.GameDelegate.addCallBack("ValidateCrosshair", this, "ValidateCrosshair");
	}

	function InitCompass()
	{
		this.CompassShoutMeterHolder.Compass.gotoAndStop("ThreeSixty");
		this.CompassThreeSixtyX = this.CompassRect._x;
		this.CompassShoutMeterHolder.Compass.gotoAndStop("Zero");
		this.CompassZeroX = this.CompassRect._x;
		var CompassMarkerTemp = this.CompassRect.attachMovie("Compass Marker", "temp", this.CompassRect.getNextHighestDepth());
		CompassMarkerTemp.gotoAndStop("Quest");
		this.CompassMarkerQuest = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("QuestDoor");
		this.CompassMarkerQuestDoor = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("PlayerSet");
		this.CompassMarkerPlayerSet = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("Enemy");
		this.CompassMarkerEnemy = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("LocationMarkers");
		this.CompassMarkerLocations = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.gotoAndStop("UndiscoveredMarkers");
		this.CompassMarkerUndiscovered = CompassMarkerTemp._currentframe == undefined ? 0 : CompassMarkerTemp._currentframe;
		CompassMarkerTemp.removeMovieClip();
	}

	function RunMeterAnim(aMeter)
	{
		aMeter.PlayForward(aMeter._currentframe);
	}

	function FadeOutMeter(aMeter)
	{
		if (aMeter._currentframe > this.METER_PAUSE_FRAME) 
		{
			aMeter.gotoAndStop("Pause");
		}
		aMeter.PlayReverse();
	}

	function FadeOutStamina(aPercent)
	{
		this.FadeOutMeter(this.Stamina);
		this.StaminaMeter.CurrentPercent = aPercent;
		this.StaminaMeter.TargetPercent = aPercent;
	}

	function FadeOutChargeMeters()
	{
		this.FadeOutMeter(this.LeftChargeMeterAnim);
		this.FadeOutMeter(this.RightChargeMeterAnim);
	}

	function SetChargeMeterPercent(aPercent, abForce, abLeftHand, abShow)
	{
		var ChargeMeter = abLeftHand ? this.LeftChargeMeter : this.RightChargeMeter;
		var ChargeMeterAnim = abLeftHand ? this.LeftChargeMeterAnim : this.RightChargeMeterAnim;
		if (!abShow) 
		{
			ChargeMeterAnim.gotoAndStop(1);
			return;
		}
		if (abForce) 
		{
			this.RunMeterAnim(ChargeMeterAnim);
			ChargeMeter.SetPercent(aPercent);
			ChargeMeter.SetPercent(aPercent);
			return;
		}
		this.RunMeterAnim(ChargeMeterAnim);
		ChargeMeter.SetTargetPercent(aPercent);
		ChargeMeter.SetTargetPercent(aPercent);
	}

	function SetHealthMeterPercent(aPercent, abForce)
	{
		if (abForce) 
		{
			this.HealthMeterLeft.SetPercent(aPercent);
			return;
		}
		this.RunMeterAnim(this.HealthMeterAnim);
		this.HealthMeterLeft.SetTargetPercent(aPercent);
	}

	function SetMagickaMeterPercent(aPercent, abForce)
	{
		if (abForce) 
		{
			this.MagickaMeter.SetPercent(aPercent);
			return;
		}
		this.RunMeterAnim(this.MagickaMeterAnim);
		this.MagickaMeter.SetTargetPercent(aPercent);
	}

	function SetStaminaMeterPercent(aPercent, abForce)
	{
		if (abForce) 
		{
			this.StaminaMeter.SetPercent(aPercent);
			return;
		}
		this.RunMeterAnim(this.StaminaMeterAnim);
		this.StaminaMeter.SetTargetPercent(aPercent);
	}

	function SetShoutMeterPercent(aPercent, abForce)
	{
		this.ShoutMeter_mc.SetPercent(aPercent);
	}

	function FlashShoutMeter()
	{
		this.ShoutMeter_mc.FlashMeter();
	}

	function StartMagickaBlinking()
	{
		this.MagickaMeter.StartBlinking();
	}

	function StartStaminaBlinking()
	{
		this.StaminaMeter.StartBlinking();
	}

	function SetCompassAngle(aPlayerAngle, aCompassAngle, abShowCompass)
	{
		this.CompassRect._parent._visible = abShowCompass;
		if (abShowCompass) 
		{
			var Compass_x = Shared.GlobalFunc.Lerp(this.CompassZeroX, this.CompassThreeSixtyX, 0, 360, aCompassAngle);
			this.CompassRect._x = Compass_x;
			this.UpdateCompassMarkers(aPlayerAngle);
		}
	}

	function SetCrosshairTarget(abActivate, aName, abShowButton, abTextOnly, abFavorMode, abShowCrosshair, aWeight, aCost, aFieldValue, aFieldText)
	{
		var FavorModeNoTarget = abFavorMode ? "Favor" : "NoTarget";
		var FavorModeTarget = abFavorMode ? "Favor" : "Target";
		var Crosshair_mc = this._currentframe == 1 ? this.CrosshairInstance : this.CrosshairAlert;
		Crosshair_mc._visible = this.CheckAgainstHudMode(Crosshair_mc) && abShowCrosshair != false;
		Crosshair_mc._alpha = this.bCrosshairEnabled ? 100 : 0;
		if (!abActivate && this.SavedRolloverText.length > 0) 
		{
			Crosshair_mc.gotoAndStop(FavorModeNoTarget);
			this.RolloverText.SetText(this.SavedRolloverText, true);
			this.RolloverText._alpha = 100;
			this.RolloverButton_tf._alpha = 0;
		}
		else if (abTextOnly || abActivate) 
		{
			if (!abTextOnly) 
			{
				Crosshair_mc.gotoAndStop(FavorModeTarget);
			}
			this.RolloverText.SetText(aName, true);
			this.RolloverText._alpha = 100;
			this.RolloverButton_tf._alpha = abShowButton ? 100 : 0;
			this.RolloverButton_tf._x = this.RolloverText._x + this.RolloverText.getLineMetrics(0).x - 103;
		}
		else 
		{
			Crosshair_mc.gotoAndStop(FavorModeNoTarget);
			this.RolloverText.SetText(" ", true);
			this.RolloverText._alpha = 0;
			this.RolloverButton_tf._alpha = 0;
		}
		var TranslateText = "";
		if (aCost != undefined) 
		{
			TranslateText = this.ValueTranslated.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Math.round(aCost) + "</font>" + TranslateText;
		}
		if (aWeight != undefined) 
		{
			TranslateText = this.WeightTranslated.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Shared.GlobalFunc.RoundDecimal(aWeight, 1) + "</font>	  " + TranslateText;
		}
		if (aFieldValue != undefined) 
		{
			var aTextField = new TextField();
			aTextField.text = aFieldText.toString();
			TranslateText = aTextField.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Math.round(aFieldValue) + "</font>	  " + TranslateText;
		}
		if (TranslateText.length > 0) 
		{
			this.RolloverGrayBar_mc._alpha = 100;
		}
		else 
		{
			this.RolloverGrayBar_mc._alpha = 0;
		}
		this.RolloverInfoText.htmlText = TranslateText;
	}

	function RefreshActivateButtonArt(astrButtonName)
	{
		if (astrButtonName == undefined) 
		{
			this.RolloverButton_tf.SetText(" ", true);
			return;
		}
		var ButtonImage = flash.display.BitmapData.loadBitmap(astrButtonName + ".png");
		if (ButtonImage != undefined && ButtonImage.height > 0) 
		{
			var MaxHeight = 26;
			var ScaledWidth = Math.floor(MaxHeight / ButtonImage.height * ButtonImage.width);
			this.RolloverButton_tf.SetText("<img src=\'" + astrButtonName + ".png\' height=\'" + MaxHeight + "\' width=\'" + ScaledWidth + "\'>", true);
			return;
		}
		this.RolloverButton_tf.SetText(" ", true);
	}

	function SetLoadDoorInfo(abShow, aDoorName)
	{
		if (abShow) 
		{
			this.SavedRolloverText = aDoorName;
			this.SetCrosshairTarget(true, this.SavedRolloverText, false, true, false);
			return;
		}
		this.SavedRolloverText = "";
		this.SetCrosshairTarget(false, this.SavedRolloverText, false, false, false);
	}

	function SetSubtitlesEnabled(abEnable)
	{
		this.SubtitleText.enabled = abEnable;
		if (!abEnable) 
		{
			this.SubtitleText._visible = false;
			return;
		}
		if (this.SubtitleText.htmlText != " ") 
		{
			this.SubtitleText._visible = true;
		}
	}

	function ShowMessage(asMessage)
	{
		this.MessagesInstance.MessageArray.push(asMessage);
	}

	function ShowSubtitle(astrText)
	{
		this.SubtitleText.SetText(astrText, true);
		if (this.SubtitleText.enabled) 
		{
			this.SubtitleText._visible = true;
		}
	}

	function HideSubtitle()
	{
		this.SubtitleText.SetText(" ", true);
		this.SubtitleText._visible = false;
	}

	function ShowArrowCount(aCount, abHide, aArrows)
	{
		var HideFrame = 15;
		if (abHide) 
		{
			if (this.ArrowInfoInstance._currentframe > HideFrame) 
			{
				this.ArrowInfoInstance.gotoAndStop(HideFrame);
			}
			this.ArrowInfoInstance.PlayReverse();
			return;
		}
		this.ArrowInfoInstance.PlayForward(this.ArrowInfoInstance._currentframe);
		this.ArrowInfoInstance.ArrowCountInstance.ArrowNumInstance.SetText(aArrows + " (" + aCount.toString() + ")");
	}

	function onEnterFrame()
	{
		this.MagickaMeter.Update();
		this.HealthMeterLeft.Update();
		this.StaminaMeter.Update();
		this.EnemyHealthMeter.Update();
		this.LeftChargeMeter.Update();
		this.RightChargeMeter.Update();
		this.MessagesInstance.Update();
	}

	function SetCompassMarkers()
	{
		var headingOffset = 0;
		var _alphaOffset = 1;
		var gotoAndStopOffset = 2;
		var x_scaleOffset = 3;
		var dataGroupLength = 4;
		while (this.CompassMarkerList.length > this.CompassTargetDataA.length / dataGroupLength) 
		{
			this.CompassMarkerList.pop().movie.removeMovieClip();
		}
		var i = 0;
		for (;;) 
		{
			if (i >= this.CompassTargetDataA.length / dataGroupLength) 
			{
				return;
			}
			var dataGroup = i * dataGroupLength;
			if (this.CompassMarkerList[i].movie == undefined) 
			{
				markerData = {movie: undefined, heading: 0};
				if (this.CompassTargetDataA[dataGroup + gotoAndStopOffset] == this.CompassMarkerQuest || this.CompassTargetDataA[dataGroup + gotoAndStopOffset] == this.CompassMarkerQuestDoor) 
				{
					markerData.movie = this.CompassRect.QuestHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.QuestHolder.getNextHighestDepth());
				}
				else 
				{
					markerData.movie = this.CompassRect.MarkerHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.MarkerHolder.getNextHighestDepth());
				}
				this.CompassMarkerList.push(markerData);
			}
			else 
			{
				var compassMarkerFrame = this.CompassMarkerList[i].movie._currentframe;
				if (compassMarkerFrame == this.CompassMarkerQuest || compassMarkerFrame == this.CompassMarkerQuestDoor) 
				{
					if (this.CompassMarkerList[i].movie._parent == this.CompassRect.MarkerHolder) 
					{
						markerData = {movie: undefined, heading: 0};
						markerData.movie = this.CompassRect.QuestHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.QuestHolder.getNextHighestDepth());
						aCompassMarkerList = this.CompassMarkerList.splice(i, 1, markerData);
						aCompassMarkerList[0].movie.removeMovieClip();
					}
				}
				else if (this.CompassMarkerList[i].movie._parent == this.CompassRect.QuestHolder) 
				{
					var markerData = {movie: undefined, heading: 0};
					markerData.movie = this.CompassRect.MarkerHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.MarkerHolder.getNextHighestDepth());
					var aCompassMarkerList = this.CompassMarkerList.splice(i, 1, markerData);
					aCompassMarkerList[0].movie.removeMovieClip();
				}
			}
			this.CompassMarkerList[i].heading = this.CompassTargetDataA[dataGroup + headingOffset];
			this.CompassMarkerList[i].movie._alpha = this.CompassTargetDataA[dataGroup + _alphaOffset];
			this.CompassMarkerList[i].movie.gotoAndStop(this.CompassTargetDataA[dataGroup + gotoAndStopOffset]);
			this.CompassMarkerList[i].movie._xscale = this.CompassTargetDataA[dataGroup + x_scaleOffset];
			this.CompassMarkerList[i].movie._yscale = this.CompassTargetDataA[dataGroup + x_scaleOffset];
			++i;
		}
	}

	function UpdateCompassMarkers(aiCenterAngle)
	{
		var compassMarkerWidth = this.CompassShoutMeterHolder.Compass.CompassMask_mc._width;
		var angleDelta = compassMarkerWidth * 180 / Math.abs(this.CompassThreeSixtyX - this.CompassZeroX);
		var angleDeltaLeft = aiCenterAngle - angleDelta;
		var angleDeltaRight = aiCenterAngle + angleDelta;
		var widthDeltaLeft = 0 - this.CompassRect._x - compassMarkerWidth / 2;
		var widthDeltaRight = 0 - this.CompassRect._x + compassMarkerWidth / 2;
		var i = 0;
		for (;;) 
		{
			if (i >= this.CompassMarkerList.length) 
			{
				return;
			}
			var heading = this.CompassMarkerList[i].heading;
			if (angleDeltaLeft < 0 && heading > 360 - aiCenterAngle - angleDelta) 
			{
				heading = heading - 360;
			}
			if (angleDeltaRight > 360 && heading < angleDelta - (360 - aiCenterAngle)) 
			{
				heading = heading + 360;
			}
			if (heading > angleDeltaLeft && heading < angleDeltaRight) 
			{
				this.CompassMarkerList[i].movie._x = Shared.GlobalFunc.Lerp(widthDeltaLeft, widthDeltaRight, angleDeltaLeft, angleDeltaRight, heading);
			}
			else 
			{
				var markerFrame = this.CompassMarkerList[i].movie._currentframe;
				if (markerFrame == this.CompassMarkerQuest || markerFrame == this.CompassMarkerQuestDoor) 
				{
					var angleRadians = Math.sin((heading - aiCenterAngle) * 3.14159265359 / 180);
					this.CompassMarkerList[i].movie._x = angleRadians <= 0 ? widthDeltaLeft + 2 : widthDeltaRight;
				}
				else 
				{
					this.CompassMarkerList[i].movie._x = 0;
				}
			}
			++i;
		}
	}

	function ShowTutorialHintText(astrHint, abShow)
	{
		if (abShow) 
		{
			this.TutorialHintsText.text = astrHint;
			var buttonHtmlText = this.TutorialHintsArtHolder.CreateButtonArt(this.TutorialHintsText);
			if (buttonHtmlText != undefined) 
			{
				this.TutorialHintsText.html = true;
				this.TutorialHintsText.htmlText = buttonHtmlText;
			}
		}
		if (abShow) 
		{
			this.TutorialLockInstance.TutorialHintsInstance.gotoAndPlay("FadeIn");
			return;
		}
		this.TutorialLockInstance.TutorialHintsInstance.gotoAndPlay("FadeOut");
	}

	function SetCrosshairEnabled(abFlag)
	{
		this.bCrosshairEnabled = abFlag;
		var crosshairMode = this._currentframe == 1 ? this.CrosshairInstance : this.CrosshairAlert;
		crosshairMode._alpha = this.bCrosshairEnabled ? 100 : 0;
	}

	function ValidateCrosshair()
	{
		var crosshairMode = this._currentframe == 1 ? this.CrosshairInstance : this.CrosshairAlert;
		crosshairMode._visible = this.CheckAgainstHudMode(crosshairMode);
		this.StealthMeterInstance._visible = this.CheckAgainstHudMode(this.StealthMeterInstance);
	}

}
