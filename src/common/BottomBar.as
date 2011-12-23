dynamic class BottomBar extends MovieClip
{
	var Buttons;
	var HealthMeter;
	var LevelMeter;
	var MagickaMeter;
	var PlayerInfoCard_mc;
	var PlayerInfoObj;
	var StaminaMeter;
	var iLastItemType;
	var iLeftOffset;

	function BottomBar()
	{
		super();
		this.PlayerInfoCard_mc = this.PlayerInfoCard_mc;
		this.iLastItemType = InventoryDefines.ICT_NONE;
		this.HealthMeter = new Components.Meter(this.PlayerInfoCard_mc.HealthRect.MeterInstance.Meter_mc);
		this.MagickaMeter = new Components.Meter(this.PlayerInfoCard_mc.MagickaRect.MeterInstance.Meter_mc);
		this.StaminaMeter = new Components.Meter(this.PlayerInfoCard_mc.StaminaRect.MeterInstance.Meter_mc);
		this.LevelMeter = new Components.Meter(this.PlayerInfoCard_mc.LevelMeterInstance.Meter_mc);
		var __reg3 = 0;
		this.Buttons = new Array();
		for (;;) 
		{
			if (this["Button" + __reg3] == undefined) 
			{
				return;
			}
			this.Buttons.push(this["Button" + __reg3]);
			++__reg3;
		}
	}

	function PositionElements(aiLeftOffset, aiRightOffset)
	{
		this.iLeftOffset = aiLeftOffset;
		this.PositionButtons();
		this.PlayerInfoCard_mc._x = aiRightOffset - this.PlayerInfoCard_mc._width;
	}

	function ShowPlayerInfo()
	{
		this.PlayerInfoCard_mc._alpha = 100;
	}

	function HidePlayerInfo()
	{
		this.PlayerInfoCard_mc._alpha = 0;
	}

	function UpdatePerItemInfo(aItemUpdateObj)
	{
		var __reg3 = aItemUpdateObj.type;
		var __reg5 = true;
		if (__reg3 == undefined) 
		{
			__reg3 = this.iLastItemType;
			if (aItemUpdateObj == undefined) 
			{
				aItemUpdateObj = {type: this.iLastItemType};
			}
		}
		else 
		{
			this.iLastItemType = __reg3;
		}
		if (this.PlayerInfoObj != undefined && aItemUpdateObj != undefined) 
		{
			if ((__reg0 = __reg3) === InventoryDefines.ICT_ARMOR) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Armor");
				var __reg4 = Math.floor(this.PlayerInfoObj.armor).toString();
				if (aItemUpdateObj.armorChange != undefined) 
				{
					var __reg7 = Math.round(aItemUpdateObj.armorChange);
					if (__reg7 > 0) 
					{
						__reg4 = __reg4 + " <font color=\'#189515\'>(+" + __reg7.toString() + ")</font>";
					}
					else if (__reg7 < 0) 
					{
						__reg4 = __reg4 + " <font color=\'#FF0000\'>(" + __reg7.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.ArmorRatingValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.ArmorRatingValue.html = true;
				this.PlayerInfoCard_mc.ArmorRatingValue.SetText(__reg4, true);
			}
			else if (__reg0 === InventoryDefines.ICT_WEAPON) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Weapon");
				__reg4 = Math.floor(this.PlayerInfoObj.damage).toString();
				if (aItemUpdateObj.damageChange != undefined) 
				{
					var __reg6 = Math.round(aItemUpdateObj.damageChange);
					if (__reg6 > 0) 
					{
						__reg4 = __reg4 + " <font color=\'#189515\'>(+" + __reg6.toString() + ")</font>";
					}
					else if (__reg6 < 0) 
					{
						__reg4 = __reg4 + " <font color=\'#FF0000\'>(" + __reg6.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.DamageValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.DamageValue.html = true;
				this.PlayerInfoCard_mc.DamageValue.SetText(__reg4, true);
			}
			else if (__reg0 === InventoryDefines.ICT_POTION) 
			{
				var __reg9 = 0;
				var __reg8 = 1;
				var __reg10 = 2;
				if (aItemUpdateObj.potionType == __reg8) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("MagickaPotion");
				}
				else if (aItemUpdateObj.potionType == __reg10) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("StaminaPotion");
				}
				else if (aItemUpdateObj.potionType == __reg9) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("HealthPotion");
				}
			}
			else if (__reg0 === InventoryDefines.ICT_FOOD) 
			{
				__reg9 = 0;
				__reg8 = 1;
				__reg10 = 2;
				if (aItemUpdateObj.potionType == __reg8) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("MagickaPotion");
				}
				else if (aItemUpdateObj.potionType == __reg10) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("StaminaPotion");
				}
				else if (aItemUpdateObj.potionType == __reg9) 
				{
					this.PlayerInfoCard_mc.gotoAndStop("HealthPotion");
				}
			}
			else if (__reg0 === InventoryDefines.ICT_BOOK) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (__reg0 === InventoryDefines.ICT_INGREDIENT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (__reg0 === InventoryDefines.ICT_MISC) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (__reg0 === InventoryDefines.ICT_KEY) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			else if (__reg0 === InventoryDefines.ICT_SPELL_DEFAULT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Magic");
				__reg5 = false;
			}
			else if (__reg0 === InventoryDefines.ICT_ACTIVE_EFFECT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Magic");
				__reg5 = false;
			}
			else if (__reg0 === InventoryDefines.ICT_SPELL) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("MagicSkill");
				if (aItemUpdateObj.magicSchoolName != undefined) 
				{
					this.UpdateSkillBar(aItemUpdateObj.magicSchoolName, aItemUpdateObj.magicSchoolLevel, aItemUpdateObj.magicSchoolPct);
				}
				__reg5 = false;
			}
			else if (__reg0 === InventoryDefines.ICT_SHOUT) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Shout");
				this.PlayerInfoCard_mc.DragonSoulTextInstance.SetText(this.PlayerInfoObj.dragonSoulText);
				__reg5 = false;
			}
			else 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Default");
			}
			if (__reg5) 
			{
				this.PlayerInfoCard_mc.CarryWeightValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.CarryWeightValue.SetText(Math.ceil(this.PlayerInfoObj.encumbrance) + "/" + Math.floor(this.PlayerInfoObj.maxEncumbrance));
				this.PlayerInfoCard_mc.PlayerGoldValue.SetText(this.PlayerInfoObj.gold.toString());
				this.PlayerInfoCard_mc.PlayerGoldLabel._x = this.PlayerInfoCard_mc.PlayerGoldValue._x + this.PlayerInfoCard_mc.PlayerGoldValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.PlayerGoldLabel._width;
				this.PlayerInfoCard_mc.CarryWeightValue._x = this.PlayerInfoCard_mc.PlayerGoldLabel._x + this.PlayerInfoCard_mc.PlayerGoldLabel.getLineMetrics(0).x - this.PlayerInfoCard_mc.CarryWeightValue._width - 5;
				this.PlayerInfoCard_mc.CarryWeightLabel._x = this.PlayerInfoCard_mc.CarryWeightValue._x + this.PlayerInfoCard_mc.CarryWeightValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.CarryWeightLabel._width;
				if ((__reg0 = __reg3) === InventoryDefines.ICT_ARMOR) 
				{
					this.PlayerInfoCard_mc.ArmorRatingValue._x = this.PlayerInfoCard_mc.CarryWeightLabel._x + this.PlayerInfoCard_mc.CarryWeightLabel.getLineMetrics(0).x - this.PlayerInfoCard_mc.ArmorRatingValue._width - 5;
					this.PlayerInfoCard_mc.ArmorRatingLabel._x = this.PlayerInfoCard_mc.ArmorRatingValue._x + this.PlayerInfoCard_mc.ArmorRatingValue.getLineMetrics(0).x - this.PlayerInfoCard_mc.ArmorRatingLabel._width;
				}
				else if (__reg0 === InventoryDefines.ICT_WEAPON) 
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

	function UpdatePlayerInfo(aPlayerUpdateObj, aItemUpdateObj)
	{
		this.PlayerInfoObj = aPlayerUpdateObj;
		this.UpdatePerItemInfo(aItemUpdateObj);
	}

	function UpdateSkillBar(aSkillName, aiLevelStart, afLevelPercent)
	{
		this.PlayerInfoCard_mc.SkillLevelLabel.SetText(aSkillName);
		this.PlayerInfoCard_mc.SkillLevelCurrent.SetText(aiLevelStart);
		this.PlayerInfoCard_mc.SkillLevelNext.SetText(aiLevelStart + 1);
		this.PlayerInfoCard_mc.LevelMeterInstance.gotoAndStop("Pause");
		this.LevelMeter.SetPercent(afLevelPercent);
	}

	function UpdateCraftingInfo(aSkillName, aiLevelStart, afLevelPercent)
	{
		this.PlayerInfoCard_mc.gotoAndStop("Crafting");
		this.UpdateSkillBar(aSkillName, aiLevelStart, afLevelPercent);
	}

	function UpdateStatMeter(aMeterRect, aMeterObj, aiCurrValue, aiMaxValue, aColor)
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

	function SetBarterInfo(aiPlayerGold, aiVendorGold, aiGoldDelta, astrVendorName)
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

	function SetBarterPerItemInfo(aItemUpdateObj, aPlayerInfoObj)
	{
		if (aItemUpdateObj != undefined) 
		{
			if ((__reg0 = aItemUpdateObj.type) === InventoryDefines.ICT_ARMOR) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Barter_Armor");
				var __reg2 = Math.floor(aPlayerInfoObj.armor).toString();
				if (aItemUpdateObj.armorChange != undefined) 
				{
					var __reg4 = Math.round(aItemUpdateObj.armorChange);
					if (__reg4 > 0) 
					{
						__reg2 = __reg2 + " <font color=\'#189515\'>(+" + __reg4.toString() + ")</font>";
					}
					else if (__reg4 < 0) 
					{
						__reg2 = __reg2 + " <font color=\'#FF0000\'>(" + __reg4.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.ArmorRatingValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.ArmorRatingValue.html = true;
				this.PlayerInfoCard_mc.ArmorRatingValue.SetText(__reg2, true);
				return;
			}
			else if (__reg0 === InventoryDefines.ICT_WEAPON) 
			{
				this.PlayerInfoCard_mc.gotoAndStop("Barter_Weapon");
				__reg2 = Math.floor(aPlayerInfoObj.damage).toString();
				if (aItemUpdateObj.damageChange != undefined) 
				{
					var __reg3 = Math.round(aItemUpdateObj.damageChange);
					if (__reg3 > 0) 
					{
						__reg2 = __reg2 + " <font color=\'#189515\'>(+" + __reg3.toString() + ")</font>";
					}
					else if (__reg3 < 0) 
					{
						__reg2 = __reg2 + " <font color=\'#FF0000\'>(" + __reg3.toString() + ")</font>";
					}
				}
				this.PlayerInfoCard_mc.DamageValue.textAutoSize = "shrink";
				this.PlayerInfoCard_mc.DamageValue.html = true;
				this.PlayerInfoCard_mc.DamageValue.SetText(__reg2, true);
				return;
			}
			this.PlayerInfoCard_mc.gotoAndStop("Barter");
			return;
		}
	}

	function SetGiftInfo(aiFavorPoints)
	{
		this.PlayerInfoCard_mc.gotoAndStop("Gift");
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.Buttons.length) 
			{
				return;
			}
			this.Buttons[__reg2].SetPlatform(aiPlatform, abPS3Switch);
			++__reg2;
		}
	}

	function ShowButtons()
	{
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.Buttons.length) 
			{
				return;
			}
			this.Buttons[__reg2]._visible = this.Buttons[__reg2].label.length > 0;
			++__reg2;
		}
	}

	function HideButtons()
	{
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.Buttons.length) 
			{
				return;
			}
			this.Buttons[__reg2]._visible = false;
			++__reg2;
		}
	}

	function SetButtonsText()
	{
		var __reg3 = 0;
		while (__reg3 < this.Buttons.length) 
		{
			this.Buttons[__reg3].label = __reg3 >= arguments.length ? "" : arguments[__reg3];
			this.Buttons[__reg3]._visible = this.Buttons[__reg3].label.length > 0;
			++__reg3;
		}
		this.PositionButtons();
	}

	function SetButtonText(aText, aIndex)
	{
		if (aIndex < this.Buttons.length) 
		{
			this.Buttons[aIndex].label = aText;
			this.Buttons[aIndex]._visible = aText.length > 0;
			this.PositionButtons();
		}
	}

	function SetButtonsArt(aButtonArt)
	{
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= aButtonArt.length) 
			{
				return;
			}
			this.SetButtonArt(aButtonArt[__reg2], __reg2);
			++__reg2;
		}
	}

	function AttachDualButton(aButtonArtObj, aiIndex)
	{
		if (aiIndex < this.Buttons.length) 
		{
			this.Buttons[aiIndex].AttachDualButton(aButtonArtObj);
		}
	}

	function GetButtonsArt()
	{
		var __reg3 = new Array(this.Buttons.length);
		var __reg2 = 0;
		while (__reg2 < this.Buttons.length) 
		{
			__reg3[__reg2] = this.Buttons[__reg2].GetArt();
			++__reg2;
		}
		return __reg3;
	}

	function GetButtonArt(aiIndex)
	{
		if (aiIndex < this.Buttons.length) 
		{
			return this.Buttons[aiIndex].GetArt();
		}
		return undefined;
	}

	function SetButtonArt(aPlatformArt, aIndex)
	{
		if (aIndex < this.Buttons.length) 
		{
			var __reg2 = this.Buttons[aIndex];
			__reg2.PCArt = aPlatformArt.PCArt;
			__reg2.XBoxArt = aPlatformArt.XBoxArt;
			__reg2.PS3Art = aPlatformArt.PS3Art;
			__reg2.RefreshArt();
		}
	}

	function PositionButtons()
	{
		var __reg4 = 10;
		var __reg3 = this.iLeftOffset;
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.Buttons.length) 
			{
				return;
			}
			if (this.Buttons[__reg2].label.length > 0) 
			{
				this.Buttons[__reg2]._x = __reg3 + this.Buttons[__reg2].ButtonArt._width;
				if (this.Buttons[__reg2].ButtonArt2 != undefined) 
				{
					this.Buttons[__reg2]._x = this.Buttons[__reg2]._x + this.Buttons[__reg2].ButtonArt2._width;
				}
				__reg3 = this.Buttons[__reg2]._x + this.Buttons[__reg2].textField.getLineMetrics(0).width + __reg4;
			}
			++__reg2;
		}
	}

}
