class BottomBar extends MovieClip
{
	var Buttons: Array;
	var HealthMeter: Components.Meter;
	var LevelMeter: Components.Meter;
	var MagickaMeter: Components.Meter;
	var PlayerInfoCard_mc: MovieClip;
	var PlayerInfoObj: Object;
	var StaminaMeter: Components.Meter;
	var iLastItemType: Number;
	var iLeftOffset: Number;

	function BottomBar()
	{
		super();
		this.iLastItemType = InventoryDefines.ICT_NONE;
		this.HealthMeter = new Components.Meter(this.PlayerInfoCard_mc.HealthRect.MeterInstance.Meter_mc);
		this.MagickaMeter = new Components.Meter(this.PlayerInfoCard_mc.MagickaRect.MeterInstance.Meter_mc);
		this.StaminaMeter = new Components.Meter(this.PlayerInfoCard_mc.StaminaRect.MeterInstance.Meter_mc);
		this.LevelMeter = new Components.Meter(this.PlayerInfoCard_mc.LevelMeterInstance.Meter_mc);
		this.Buttons = new Array();
		var i: Number = 0;
		for (;;) 
		{
			if (this["Button" + i] == undefined) 
			{
				return;
			}
			this.Buttons.push(this["Button" + i]);
			++i;
		}
	}

	function PositionElements(aiLeftOffset: Number, aiRightOffset: Number): Void
	{
		this.iLeftOffset = aiLeftOffset;
		this.PositionButtons();
		this.PlayerInfoCard_mc._x = aiRightOffset - this.PlayerInfoCard_mc._width;
	}

	function ShowPlayerInfo(): Void
	{
		this.PlayerInfoCard_mc._alpha = 100;
	}

	function HidePlayerInfo(): Void
	{
		this.PlayerInfoCard_mc._alpha = 0;
	}

	function UpdatePerItemInfo(aItemUpdateObj: Object): Void
	{
		var iItemType: Number = aItemUpdateObj.type;
		var bHasWeightandValue = true;
		if (iItemType == undefined) 
		{
			iItemType = this.iLastItemType;
			if (aItemUpdateObj == undefined) 
			{
				aItemUpdateObj = {type: this.iLastItemType};
			}
		}
		else 
		{
			this.iLastItemType = iItemType;
		}
		if (this.PlayerInfoObj != undefined && aItemUpdateObj != undefined) 
		{
			if (iItemType === InventoryDefines.ICT_ARMOR) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Armor");
				var strArmor: String = Math.floor(this.PlayerInfoObj.armor).toString();
				if (aItemUpdateObj.armorChange != undefined) 
				{
					var iArmorDelta = Math.round(aItemUpdateObj.armorChange);
					if (iArmorDelta > 0) 
					{
						strArmor = strArmor + " <font color=\'#189515\'>(+" + iArmorDelta.toString() + ")</font>";
					}
					else if (iArmorDelta < 0) 
					{
						strArmor = strArmor + " <font color=\'#FF0000\'>(" + iArmorDelta.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.ArmorRatingValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.ArmorRatingValue.html = true;
				this.PlayerInfoCard_mc.ArmorRatingValue.SetText(strArmor, true);
			}
			else if (iItemType === InventoryDefines.ICT_WEAPON) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Weapon");
				var strDamage: String = Math.floor(this.PlayerInfoObj.damage).toString();
				if (aItemUpdateObj.damageChange != undefined) 
				{
					var iDamageDelta = Math.round(aItemUpdateObj.damageChange);
					if (iDamageDelta > 0) 
					{
						strDamage = strDamage + " <font color=\'#189515\'>(+" + iDamageDelta.toString() + ")</font>";
					}
					else if (iDamageDelta < 0) 
					{
						strDamage = strDamage + " <font color=\'#FF0000\'>(" + iDamageDelta.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.DamageValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.DamageValue.html = true;
				this.PlayerInfoCard_mc.DamageValue.SetText(strDamage, true);
			}
			else if (iItemType === InventoryDefines.ICT_POTION) 
			{
				var EF_HEALTH: Number = 0;
				var EF_MAGICKA: Number = 1;
				var EF_STAMINA: Number = 2;
				if (aItemUpdateObj.potionType == EF_MAGICKA) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("MagickaPotion");
				}
				else if (aItemUpdateObj.potionType == EF_STAMINA) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("StaminaPotion");
				}
				else if (aItemUpdateObj.potionType == EF_HEALTH) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("HealthPotion");
				}
			}
			else if (iItemType === InventoryDefines.ICT_FOOD) 
			{
				var EF_HEALTH: Number = 0;
				var EF_MAGICKA: Number = 1;
				var EF_STAMINA: Number = 2;
				if (aItemUpdateObj.potionType == EF_MAGICKA) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("MagickaPotion");
				}
				else if (aItemUpdateObj.potionType == EF_STAMINA) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("StaminaPotion");
				}
				else if (aItemUpdateObj.potionType == EF_HEALTH) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("HealthPotion");
				}
			}
			else if (iItemType === InventoryDefines.ICT_BOOK) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (iItemType === InventoryDefines.ICT_INGREDIENT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (iItemType === InventoryDefines.ICT_MISC) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (iItemType === InventoryDefines.ICT_KEY) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (iItemType === InventoryDefines.ICT_SPELL_DEFAULT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Magic");
				bHasWeightandValue = false;
			}
			else if (iItemType === InventoryDefines.ICT_ACTIVE_EFFECT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Magic");
				bHasWeightandValue = false;
			}
			else if (iItemType === InventoryDefines.ICT_SPELL) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("MagicSkill");
				if (aItemUpdateObj.magicSchoolName != undefined) 
				{
					this.UpdateSkillBar(aItemUpdateObj.magicSchoolName, aItemUpdateObj.magicSchoolLevel, aItemUpdateObj.magicSchoolPct);
				}
				bHasWeightandValue = false;
			}
			else if (iItemType === InventoryDefines.ICT_SHOUT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Shout");
				this.PlayerInfoCard_mc.DragonSoulTextInstance.SetText(this.PlayerInfoObj.dragonSoulText);
				bHasWeightandValue = false;
			}
			else 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			if (bHasWeightandValue) 
			{
				this.PlayerInfoCard_mc.CarryWeightValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.CarryWeightValue.SetText(Math.ceil(this.PlayerInfoObj.encumbrance) + "/" + Math.floor(this.PlayerInfoObj.maxEncumbrance));
				this.PlayerInfoCard_mc.PlayerGoldValue.SetText(this.PlayerInfoObj.gold.toString());
				this.PlayerInfoCard_mc.PlayerGoldLabel._x = this.PlayerInfoCard_mc.PlayerGoldValue._x + this.PlayerInfoCard_mc.PlayerGoldValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.PlayerGoldLabel._width;
				this.PlayerInfoCard_mc.CarryWeightValue._x = this.PlayerInfoCard_mc.PlayerGoldLabel._x + this.PlayerInfoCard_mc.PlayerGoldLabel.getLineMetrics(0).x - this.PlayerInfoCard_mc.CarryWeightValue._width - 5;
				this.PlayerInfoCard_mc.CarryWeightLabel._x = this.PlayerInfoCard_mc.CarryWeightValue._x + this.PlayerInfoCard_mc.CarryWeightValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.CarryWeightLabel._width;
				if (iItemType === InventoryDefines.ICT_ARMOR) 
				{
					this.PlayerInfoCard_mc.ArmorRatingValue._x = this.PlayerInfoCard_mc.CarryWeightLabel._x + this.PlayerInfoCard_mc.CarryWeightLabel.getLineMetrics(0).x - this.PlayerInfoCard_mc.ArmorRatingValue._width - 5;
					this.PlayerInfoCard_mc.ArmorRatingLabel._x = this.PlayerInfoCard_mc.ArmorRatingValue._x + this.PlayerInfoCard_mc.ArmorRatingValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.ArmorRatingLabel._width;
				}
				else if (iItemType === InventoryDefines.ICT_WEAPON) 
				{
					this.PlayerInfoCard_mc.DamageValue._x = this.PlayerInfoCard_mc.CarryWeightLabel._x + this.PlayerInfoCard_mc.CarryWeightLabel.getLineMetrics(0).x - this.PlayerInfoCard_mc.DamageValue._width - 5;
					this.PlayerInfoCard_mc.DamageLabel._x = this.PlayerInfoCard_mc.DamageValue._x + this.PlayerInfoCard_mc.DamageValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.DamageLabel._width;
				}
			}
			this.UpdateStatMeter(this.PlayerInfoCard_mc.HealthRect, this.HealthMeter, this.PlayerInfoObj.health, this.PlayerInfoObj.maxHealth, this.PlayerInfoObj.healthColor);
			this.UpdateStatMeter(this.PlayerInfoCard_mc.MagickaRect, this.MagickaMeter, this.PlayerInfoObj.magicka, this.PlayerInfoObj.maxMagicka, this.PlayerInfoObj.magickaColor);
			this.UpdateStatMeter(this.PlayerInfoCard_mc.StaminaRect, this.StaminaMeter, this.PlayerInfoObj.stamina, this.PlayerInfoObj.maxStamina, this.PlayerInfoObj.staminaColor);
		}
	}

	function UpdatePlayerInfo(aPlayerUpdateObj: Object, aItemUpdateObj: Object): Void
	{
		this.PlayerInfoObj = aPlayerUpdateObj;
		this.UpdatePerItemInfo(aItemUpdateObj);
	}

	function UpdateSkillBar(aSkillName: String, aiLevelStart: Number, afLevelPercent: Number): Void
	{
		this.PlayerInfoCard_mc.SkillLevelLabel.SetText(aSkillName);
		this.PlayerInfoCard_mc.SkillLevelCurrent.SetText(aiLevelStart);
		this.PlayerInfoCard_mc.SkillLevelNext.SetText(aiLevelStart + 1);
		this.PlayerInfoCard_mc.LevelMeterInstance.gotoAndStop("Pause");
		this.LevelMeter.SetPercent(afLevelPercent);
	}

	function UpdateCraftingInfo(aSkillName: String, aiLevelStart: Number, afLevelPercent: Number): Void
	{
		this.PlayerInfoCard_mc.gotoAndStop("Crafting");
		this.UpdateSkillBar(aSkillName, aiLevelStart, afLevelPercent);
	}

	function UpdateStatMeter(aMeterRect: MovieClip, aMeterObj: Components.Meter, aiCurrValue: Number, aiMaxValue: Number, aColor: String): Void
	{
		if (aColor == undefined) 
		{
			aColor = "#FFFFFF";
		}
		if (aMeterRect._alpha > 0) 
		{
			if (aMeterRect.MeterText != undefined) 
			{
				aMeterRect.MeterText.textAutoSize = "shrink";
				aMeterRect.MeterText.html = true;
				aMeterRect.MeterText.SetText("<font color=\'" + aColor + "\'>" + Math.floor(aiCurrValue) + "/" + Math.floor(aiMaxValue) + "</font>", true);
			}
			aMeterRect.MeterInstance.gotoAndStop("Pause");
			aMeterObj.SetPercent(aiCurrValue / aiMaxValue * 100);
		}
	}

	function SetBarterInfo(aiPlayerGold: Number, aiVendorGold: Number, aiGoldDelta: Number, astrVendorName: String): Void
	{
		if (this.PlayerInfoCard_mc._currentframe == 1) 
		{
			this.PlayerInfoCard_mc.gotoAndStop("Barter");
		}
		this.PlayerInfoCard_mc.PlayerGoldValue.textAutoSize = "shrink";
		this.PlayerInfoCard_mc.VendorGoldValue.textAutoSize = "shrink";
		if (aiGoldDelta == undefined) 
		{
			this.PlayerInfoCard_mc.PlayerGoldValue.SetText(aiPlayerGold.toString(), true);
		}
		else if (aiGoldDelta >= 0) 
		{
			this.PlayerInfoCard_mc.PlayerGoldValue.SetText(aiPlayerGold.toString() + " <font color=\'#189515\'>(+" + aiGoldDelta.toString() + ")</font>", true);
		}
		else 
		{
			this.PlayerInfoCard_mc.PlayerGoldValue.SetText(aiPlayerGold.toString() + " <font color=\'#FF0000\'>(" + aiGoldDelta.toString() + ")</font>", true);
		}
		this.PlayerInfoCard_mc.VendorGoldValue.SetText(aiVendorGold.toString());
		if (astrVendorName != undefined) 
		{
			this.PlayerInfoCard_mc.VendorGoldLabel.SetText("$Gold");
			this.PlayerInfoCard_mc.VendorGoldLabel.SetText(astrVendorName + " " + this.PlayerInfoCard_mc.VendorGoldLabel.text);
		}
		this.PlayerInfoCard_mc.VendorGoldLabel._x = this.PlayerInfoCard_mc.VendorGoldValue._x + this.PlayerInfoCard_mc.VendorGoldValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.VendorGoldLabel._width - 5;
		this.PlayerInfoCard_mc.PlayerGoldValue._x = this.PlayerInfoCard_mc.VendorGoldLabel._x + this.PlayerInfoCard_mc.VendorGoldLabel.getLineMetrics(0).x - this.PlayerInfoCard_mc.PlayerGoldValue._width - 20;
		this.PlayerInfoCard_mc.PlayerGoldLabel._x = this.PlayerInfoCard_mc.PlayerGoldValue._x + this.PlayerInfoCard_mc.PlayerGoldValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.PlayerGoldLabel._width - 5;
	}

	function SetBarterPerItemInfo(aItemUpdateObj: Object, aPlayerInfoObj: Object): Void
	{
		if (aItemUpdateObj != undefined) 
		{
			var iItemType: Number = aItemUpdateObj.type;
			if (iItemType === InventoryDefines.ICT_ARMOR) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Barter_Armor");
				var strArmor: String = Math.floor(aPlayerInfoObj.armor).toString();
				if (aItemUpdateObj.armorChange != undefined) 
				{
					var iArmorDelta: Number = Math.round(aItemUpdateObj.armorChange);
					if (iArmorDelta > 0) 
					{
						strArmor = strArmor + " <font color=\'#189515\'>(+" + iArmorDelta.toString() + ")</font>";
					}
					else if (iArmorDelta < 0) 
					{
						strArmor = strArmor + " <font color=\'#FF0000\'>(" + iArmorDelta.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.ArmorRatingValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.ArmorRatingValue.html = true;
				this.PlayerInfoCard_mc.ArmorRatingValue.SetText(strArmor, true);
				return;
			}
			else if (iItemType === InventoryDefines.ICT_WEAPON) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Barter_Weapon");
				var strDamage: String = Math.floor(aPlayerInfoObj.damage).toString();
				if (aItemUpdateObj.damageChange != undefined) 
				{
					var iDamageDelta: Number = Math.round(aItemUpdateObj.damageChange);
					if (iDamageDelta > 0) 
					{
						strDamage = strDamage + " <font color=\'#189515\'>(+" + iDamageDelta.toString() + ")</font>";
					}
					else if (iDamageDelta < 0) 
					{
						strDamage = strDamage + " <font color=\'#FF0000\'>(" + iDamageDelta.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.DamageValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.DamageValue.html = true;
				this.PlayerInfoCard_mc.DamageValue.SetText(strDamage, true);
				return;
			}
			this.PlayerInfoCard_mc.gotoAndStop("Barter");
			return;
		}
	}

	function SetGiftInfo(aiFavorPoints: Number): Void
	{
		this.PlayerInfoCard_mc.gotoAndStop("Gift");
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		var i: Number = 0;
		for (;;) 
		{
			if (i >= this.Buttons.length) 
			{
				return;
			}
			this.Buttons[i].SetPlatform(aiPlatform, abPS3Switch);
			++i;
		}
	}

	function ShowButtons(): Void
	{
		var i: Number = 0;
		for (;;) 
		{
			if (i >= this.Buttons.length) 
			{
				return;
			}
			this.Buttons[i]._visible = this.Buttons[i].label.length > 0;
			++i;
		}
	}

	function HideButtons(): Void
	{
		var i: Number = 0;
		for (;;) 
		{
			if (i >= this.Buttons.length) 
			{
				return;
			}
			this.Buttons[i]._visible = false;
			++i;
		}
	}

	function SetButtonsText(): Void
	{
		var i: Number = 0;
		while (i < this.Buttons.length) 
		{
			this.Buttons[i].label = i >= arguments.length ? "" : arguments[i];
			this.Buttons[i]._visible = this.Buttons[i].label.length > 0;
			++i;
		}
		this.PositionButtons();
	}

	function SetButtonText(aText: String, aIndex: Number): Void
	{
		if (aIndex < this.Buttons.length) 
		{
			this.Buttons[aIndex].label = aText;
			this.Buttons[aIndex]._visible = aText.length > 0;
			this.PositionButtons();
		}
	}

	function SetButtonsArt(aButtonArt: Object): Void
	{
		var i: Number = 0;
		for (;;) 
		{
			if (i >= aButtonArt.length) 
			{
				return;
			}
			this.SetButtonArt(aButtonArt[i], i);
			++i;
		}
	}

	function AttachDualButton(aButtonArtObj: Object, aiIndex: Number): Void
	{
		if (aiIndex < this.Buttons.length) 
		{
			this.Buttons[aiIndex].AttachDualButton(aButtonArtObj);
		}
	}

	function GetButtonsArt(): Array
	{
		var ButtonsArt = new Array(this.Buttons.length);
		var i: Number = 0;
		while (i < this.Buttons.length) 
		{
			ButtonsArt[i] = this.Buttons[i].GetArt();
			++i;
		}
		return ButtonsArt;
	}

	function GetButtonArt(aiIndex: Number): Object
	{
		if (aiIndex < this.Buttons.length) 
		{
			return this.Buttons[aiIndex].GetArt();
		}
		return undefined;
	}

	function SetButtonArt(aPlatformArt: Object, aIndex: Number): Void
	{
		if (aIndex < this.Buttons.length) 
		{
			var aButton = this.Buttons[aIndex];
			aButton.PCArt = aPlatformArt.PCArt;
			aButton.XBoxArt = aPlatformArt.XBoxArt;
			aButton.PS3Art = aPlatformArt.PS3Art;
			aButton.RefreshArt();
		}
	}

	function PositionButtons(): Void
	{
		var RightOffset: Number = 10;
		var LeftOffset: Number = this.iLeftOffset;
		var i: Number = 0;
		for (;;) 
		{
			if (i >= this.Buttons.length) 
			{
				return;
			}
			if (this.Buttons[i].label.length > 0) 
			{
				this.Buttons[i]._x = LeftOffset + this.Buttons[i].ButtonArt._width;
				if (this.Buttons[i].ButtonArt2 != undefined) 
				{
					this.Buttons[i]._x = this.Buttons[i]._x + this.Buttons[i].ButtonArt2._width;
				}
				LeftOffset = this.Buttons[i]._x + this.Buttons[i].textField.getLineMetrics(0).width + RightOffset;
			}
			++i;
		}
	}

}
