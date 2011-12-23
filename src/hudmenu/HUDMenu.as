dynamic class HUDMenu extends Shared.PlatformChangeUser
{
	var SavedRolloverText: String = "";
	var ItemInfoArray = new Array();
	var CompassMarkerList = new Array();
	var METER_PAUSE_FRAME: Number = 40;
	var ActivateButton_tf;
	var ArrowInfoInstance;
	var BottomLeftLockInstance;
	var BottomRightLockInstance;
	var BottomRightRefInstance;
	var BottomRightRefX;
	var BottomRightRefY;
	var CompassMarkerEnemy;
	var CompassMarkerLocations;
	var CompassMarkerPlayerSet;
	var CompassMarkerQuest;
	var CompassMarkerQuestDoor;
	var CompassMarkerUndiscovered;
	var CompassRect;
	var CompassShoutMeterHolder;
	var CompassTargetDataA;
	var CompassThreeSixtyX;
	var CompassZeroX;
	var Crosshair;
	var CrosshairAlert;
	var CrosshairInstance;
	var EnemyHealthMeter;
	var EnemyHealth_mc;
	var FavorBackButtonBase;
	var FavorBackButton_mc;
	var FloatingQuestMarkerInstance;
	var FloatingQuestMarker_mc;
	var GrayBarInstance;
	var HUDModes;
	var Health;
	var HealthMeterAnim;
	var HealthMeterLeft;
	var HudElements;
	var LeftChargeMeter;
	var LeftChargeMeterAnim;
	var LocationLockBase;
	var Magica;
	var MagickaMeter;
	var MagickaMeterAnim;
	var MessagesBlock;
	var MessagesInstance;
	var QuestUpdateBaseInstance;
	var RightChargeMeter;
	var RightChargeMeterAnim;
	var RolloverButton_tf;
	var RolloverGrayBar_mc;
	var RolloverInfoInstance;
	var RolloverInfoText;
	var RolloverNameInstance;
	var RolloverText;
	var ShoutMeter_mc;
	var Stamina;
	var StaminaMeter;
	var StaminaMeterAnim;
	var StealthMeterInstance;
	var SubtitleText;
	var SubtitleTextHolder;
	var TopLeftRefInstance;
	var TopLeftRefX;
	var TopLeftRefY;
	var TutorialHintsArtHolder;
	var TutorialHintsText;
	var TutorialLockInstance;
	var ValueTranslated;
	var WeightTranslated;
	var _currentframe;
	var bCrosshairEnabled;
	var gotoAndStop;

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
		var __reg4 = "All";
		if (abShow) 
		{
			__reg3 = this.HUDModes.length - 1;
			while (__reg3 >= 0) 
			{
				if (this.HUDModes[__reg3] == aMode) 
				{
					this.HUDModes.splice(__reg3, 1);
				}
				--__reg3;
			}
			this.HUDModes.push(aMode);
			__reg4 = aMode;
		}
		else 
		{
			if (aMode.length > 0) 
			{
				var __reg6 = false;
				var __reg3 = this.HUDModes.length - 1;
				while (__reg3 >= 0 && !__reg6) 
				{
					if (this.HUDModes[__reg3] == aMode) 
					{
						this.HUDModes.splice(__reg3, 1);
						__reg6 = true;
					}
					--__reg3;
				}
			}
			else 
			{
				this.HUDModes.pop();
			}
			if (this.HUDModes.length > 0) 
			{
				__reg4 = String(this.HUDModes[this.HUDModes.length - 1]);
			}
		}
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.HudElements.length) 
			{
				return;
			}
			if (this.HudElements[__reg2] != undefined) 
			{
				this.HudElements[__reg2]._visible = this.HudElements[__reg2].hasOwnProperty(__reg4);
				if (this.HudElements[__reg2].onModeChange != undefined) 
				{
					this.HudElements[__reg2].onModeChange(__reg4);
				}
			}
			++__reg2;
		}
	}

	function SetLocationName(aLocation)
	{
		this.LocationLockBase.LocationNameBase.LocationTextBase.LocationTextInstance.SetText(aLocation);
		this.LocationLockBase.LocationNameBase.gotoAndPlay(1);
	}

	function CheckAgainstHudMode(aObj)
	{
		var __reg2 = "All";
		if (this.HUDModes.length > 0) 
		{
			__reg2 = String(this.HUDModes[this.HUDModes.length - 1]);
		}
		return __reg2 == "All" || (aObj != undefined && aObj.hasOwnProperty(__reg2));
	}

	function InitExtensions()
	{
		var __reg4 = this.QuestUpdateBaseInstance._y - this.CompassShoutMeterHolder._y;
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
		var __reg2 = {x: this.TopLeftRefInstance.LocationRefInstance._x, y: this.TopLeftRefInstance.LocationRefInstance._y};
		this.TopLeftRefInstance.localToGlobal(__reg2);
		this.TopLeftRefX = __reg2.x;
		this.TopLeftRefY = __reg2.y;
		var __reg3 = {x: this.BottomRightRefInstance.LocationRefInstance._x, y: this.BottomRightRefInstance.LocationRefInstance._y};
		this.BottomRightRefInstance.localToGlobal(__reg3);
		this.BottomRightRefX = __reg3.x;
		this.BottomRightRefY = __reg3.y;
		this.CompassShoutMeterHolder.Lock("T");
		this.EnemyHealth_mc.Lock("T");
		this.MessagesBlock.Lock("TL");
		this.QuestUpdateBaseInstance._y = this.CompassShoutMeterHolder._y + __reg4;
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
		var __reg2 = this.CompassRect.attachMovie("Compass Marker", "temp", this.CompassRect.getNextHighestDepth());
		__reg2.gotoAndStop("Quest");
		this.CompassMarkerQuest = __reg2._currentframe == undefined ? 0 : __reg2._currentframe;
		__reg2.gotoAndStop("QuestDoor");
		this.CompassMarkerQuestDoor = __reg2._currentframe == undefined ? 0 : __reg2._currentframe;
		__reg2.gotoAndStop("PlayerSet");
		this.CompassMarkerPlayerSet = __reg2._currentframe == undefined ? 0 : __reg2._currentframe;
		__reg2.gotoAndStop("Enemy");
		this.CompassMarkerEnemy = __reg2._currentframe == undefined ? 0 : __reg2._currentframe;
		__reg2.gotoAndStop("LocationMarkers");
		this.CompassMarkerLocations = __reg2._currentframe == undefined ? 0 : __reg2._currentframe;
		__reg2.gotoAndStop("UndiscoveredMarkers");
		this.CompassMarkerUndiscovered = __reg2._currentframe == undefined ? 0 : __reg2._currentframe;
		__reg2.removeMovieClip();
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
		var __reg2 = abLeftHand ? this.LeftChargeMeter : this.RightChargeMeter;
		var __reg3 = abLeftHand ? this.LeftChargeMeterAnim : this.RightChargeMeterAnim;
		if (!abShow) 
		{
			__reg3.gotoAndStop(1);
			return;
		}
		if (abForce) 
		{
			this.RunMeterAnim(__reg3);
			__reg2.SetPercent(aPercent);
			__reg2.SetPercent(aPercent);
			return;
		}
		this.RunMeterAnim(__reg3);
		__reg2.SetTargetPercent(aPercent);
		__reg2.SetTargetPercent(aPercent);
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
			var __reg2 = Shared.GlobalFunc.Lerp(this.CompassZeroX, this.CompassThreeSixtyX, 0, 360, aCompassAngle);
			this.CompassRect._x = __reg2;
			this.UpdateCompassMarkers(aPlayerAngle);
		}
	}

	function SetCrosshairTarget(abActivate, aName, abShowButton, abTextOnly, abFavorMode, abShowCrosshair, aWeight, aCost, aFieldValue, aFieldText)
	{
		var __reg4 = abFavorMode ? "Favor" : "NoTarget";
		var __reg6 = abFavorMode ? "Favor" : "Target";
		var __reg3 = this._currentframe == 1 ? this.CrosshairInstance : this.CrosshairAlert;
		__reg3._visible = this.CheckAgainstHudMode(__reg3) && abShowCrosshair != false;
		__reg3._alpha = this.bCrosshairEnabled ? 100 : 0;
		if (!abActivate && this.SavedRolloverText.length > 0) 
		{
			__reg3.gotoAndStop(__reg4);
			this.RolloverText.SetText(this.SavedRolloverText, true);
			this.RolloverText._alpha = 100;
			this.RolloverButton_tf._alpha = 0;
		}
		else if (abTextOnly || abActivate) 
		{
			if (!abTextOnly) 
			{
				__reg3.gotoAndStop(__reg6);
			}
			this.RolloverText.SetText(aName, true);
			this.RolloverText._alpha = 100;
			this.RolloverButton_tf._alpha = abShowButton ? 100 : 0;
			this.RolloverButton_tf._x = this.RolloverText._x + this.RolloverText.getLineMetrics(0).x - 103;
		}
		else 
		{
			__reg3.gotoAndStop(__reg4);
			this.RolloverText.SetText(" ", true);
			this.RolloverText._alpha = 0;
			this.RolloverButton_tf._alpha = 0;
		}
		var __reg2 = "";
		if (aCost != undefined) 
		{
			__reg2 = this.ValueTranslated.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Math.round(aCost) + "</font>" + __reg2;
		}
		if (aWeight != undefined) 
		{
			__reg2 = this.WeightTranslated.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Shared.GlobalFunc.RoundDecimal(aWeight, 1) + "</font>	  " + __reg2;
		}
		if (aFieldValue != undefined) 
		{
			var __reg5 = new TextField();
			__reg5.text = aFieldText.toString();
			__reg2 = __reg5.text + " <font face=\'$EverywhereBoldFont\' size=\'24\' color=\'#FFFFFF\'>" + Math.round(aFieldValue) + "</font>	  " + __reg2;
		}
		if (__reg2.length > 0) 
		{
			this.RolloverGrayBar_mc._alpha = 100;
		}
		else 
		{
			this.RolloverGrayBar_mc._alpha = 0;
		}
		this.RolloverInfoText.htmlText = __reg2;
	}

	function RefreshActivateButtonArt(astrButtonName)
	{
		if (astrButtonName == undefined) 
		{
			this.RolloverButton_tf.SetText(" ", true);
			return;
		}
		var __reg2 = flash.display.BitmapData.loadBitmap(astrButtonName + ".png");
		if (__reg2 != undefined && __reg2.height > 0) 
		{
			var __reg3 = 26;
			var __reg5 = Math.floor(__reg3 / __reg2.height * __reg2.width);
			this.RolloverButton_tf.SetText("<img src=\'" + astrButtonName + ".png\' height=\'" + __reg3 + "\' width=\'" + __reg5 + "\'>", true);
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
		var __reg2 = 15;
		if (abHide) 
		{
			if (this.ArrowInfoInstance._currentframe > __reg2) 
			{
				this.ArrowInfoInstance.gotoAndStop(__reg2);
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
		var __reg12 = 0;
		var __reg13 = 1;
		var __reg7 = 2;
		var __reg9 = 3;
		var __reg6 = 4;
		while (this.CompassMarkerList.length > this.CompassTargetDataA.length / __reg6) 
		{
			this.CompassMarkerList.pop().movie.removeMovieClip();
		}
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.CompassTargetDataA.length / __reg6) 
			{
				return;
			}
			var __reg3 = __reg2 * __reg6;
			if (this.CompassMarkerList[__reg2].movie == undefined) 
			{
				__reg5 = {movie: undefined, heading: 0};
				if (this.CompassTargetDataA[__reg3 + __reg7] == this.CompassMarkerQuest || this.CompassTargetDataA[__reg3 + __reg7] == this.CompassMarkerQuestDoor) 
				{
					__reg5.movie = this.CompassRect.QuestHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.QuestHolder.getNextHighestDepth());
				}
				else 
				{
					__reg5.movie = this.CompassRect.MarkerHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.MarkerHolder.getNextHighestDepth());
				}
				this.CompassMarkerList.push(__reg5);
			}
			else 
			{
				var __reg4 = this.CompassMarkerList[__reg2].movie._currentframe;
				if (__reg4 == this.CompassMarkerQuest || __reg4 == this.CompassMarkerQuestDoor) 
				{
					if (this.CompassMarkerList[__reg2].movie._parent == this.CompassRect.MarkerHolder) 
					{
						__reg5 = {movie: undefined, heading: 0};
						__reg5.movie = this.CompassRect.QuestHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.QuestHolder.getNextHighestDepth());
						__reg8 = this.CompassMarkerList.splice(__reg2, 1, __reg5);
						__reg8[0].movie.removeMovieClip();
					}
				}
				else if (this.CompassMarkerList[__reg2].movie._parent == this.CompassRect.QuestHolder) 
				{
					var __reg5 = {movie: undefined, heading: 0};
					__reg5.movie = this.CompassRect.MarkerHolder.attachMovie("Compass Marker", "CompassMarker" + this.CompassMarkerList.length, this.CompassRect.MarkerHolder.getNextHighestDepth());
					var __reg8 = this.CompassMarkerList.splice(__reg2, 1, __reg5);
					__reg8[0].movie.removeMovieClip();
				}
			}
			this.CompassMarkerList[__reg2].heading = this.CompassTargetDataA[__reg3 + __reg12];
			this.CompassMarkerList[__reg2].movie._alpha = this.CompassTargetDataA[__reg3 + __reg13];
			this.CompassMarkerList[__reg2].movie.gotoAndStop(this.CompassTargetDataA[__reg3 + __reg7]);
			this.CompassMarkerList[__reg2].movie._xscale = this.CompassTargetDataA[__reg3 + __reg9];
			this.CompassMarkerList[__reg2].movie._yscale = this.CompassTargetDataA[__reg3 + __reg9];
			++__reg2;
		}
	}

	function UpdateCompassMarkers(aiCenterAngle)
	{
		var __reg12 = this.CompassShoutMeterHolder.Compass.CompassMask_mc._width;
		var __reg9 = __reg12 * 180 / Math.abs(this.CompassThreeSixtyX - this.CompassZeroX);
		var __reg5 = aiCenterAngle - __reg9;
		var __reg7 = aiCenterAngle + __reg9;
		var __reg10 = 0 - this.CompassRect._x - __reg12 / 2;
		var __reg11 = 0 - this.CompassRect._x + __reg12 / 2;
		var __reg3 = 0;
		for (;;) 
		{
			if (__reg3 >= this.CompassMarkerList.length) 
			{
				return;
			}
			var __reg2 = this.CompassMarkerList[__reg3].heading;
			if (__reg5 < 0 && __reg2 > 360 - aiCenterAngle - __reg9) 
			{
				__reg2 = __reg2 - 360;
			}
			if (__reg7 > 360 && __reg2 < __reg9 - (360 - aiCenterAngle)) 
			{
				__reg2 = __reg2 + 360;
			}
			if (__reg2 > __reg5 && __reg2 < __reg7) 
			{
				this.CompassMarkerList[__reg3].movie._x = Shared.GlobalFunc.Lerp(__reg10, __reg11, __reg5, __reg7, __reg2);
			}
			else 
			{
				var __reg4 = this.CompassMarkerList[__reg3].movie._currentframe;
				if (__reg4 == this.CompassMarkerQuest || __reg4 == this.CompassMarkerQuestDoor) 
				{
					var __reg8 = Math.sin((__reg2 - aiCenterAngle) * 3.14159265359 / 180);
					this.CompassMarkerList[__reg3].movie._x = __reg8 <= 0 ? __reg10 + 2 : __reg11;
				}
				else 
				{
					this.CompassMarkerList[__reg3].movie._x = 0;
				}
			}
			++__reg3;
		}
	}

	function ShowTutorialHintText(astrHint, abShow)
	{
		if (abShow) 
		{
			this.TutorialHintsText.text = astrHint;
			var __reg2 = this.TutorialHintsArtHolder.CreateButtonArt(this.TutorialHintsText);
			if (__reg2 != undefined) 
			{
				this.TutorialHintsText.html = true;
				this.TutorialHintsText.htmlText = __reg2;
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
		var __reg2 = this._currentframe == 1 ? this.CrosshairInstance : this.CrosshairAlert;
		__reg2._alpha = this.bCrosshairEnabled ? 100 : 0;
	}

	function ValidateCrosshair()
	{
		var __reg2 = this._currentframe == 1 ? this.CrosshairInstance : this.CrosshairAlert;
		__reg2._visible = this.CheckAgainstHudMode(__reg2);
		this.StealthMeterInstance._visible = this.CheckAgainstHudMode(this.StealthMeterInstance);
	}

}
