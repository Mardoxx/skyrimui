import gfx.io.GameDelegate;
import Components.Meter;

class BottomBar extends MovieClip
{
	var Buttons: Array;
	
	var HealthMeter: Meter;
	var MagickaMeter: Meter;
	var StaminaMeter: Meter;
	var LevelMeter: Meter;
	
	var PlayerInfoCard_mc: MovieClip;
	
	var PlayerInfoObj: Object;
	
	var iLastItemType: Number;
	var iLeftOffset: Number;

	function BottomBar()
	{
		super();
		iLastItemType = InventoryDefines.ICT_NONE;
		HealthMeter = new Meter(PlayerInfoCard_mc.HealthRect.MeterInstance.Meter_mc);
		MagickaMeter = new Meter(PlayerInfoCard_mc.MagickaRect.MeterInstance.Meter_mc);
		StaminaMeter = new Meter(PlayerInfoCard_mc.StaminaRect.MeterInstance.Meter_mc);
		LevelMeter = new Meter(PlayerInfoCard_mc.LevelMeterInstance.Meter_mc);
		Buttons = new Array();
		
		for (var i: Number = 0; this["Button" + i] != undefined; i++)
			Buttons.push(this["Button" + i]);
	}

	function PositionElements(aiLeftOffset: Number, aiRightOffset: Number): Void
	{
		iLeftOffset = aiLeftOffset;
		PositionButtons();
		PlayerInfoCard_mc._x = aiRightOffset - PlayerInfoCard_mc._width;
	}

	function ShowPlayerInfo(): Void
	{
		PlayerInfoCard_mc._alpha = 100;
	}

	function HidePlayerInfo(): Void
	{
		PlayerInfoCard_mc._alpha = 0;
	}

	function UpdatePerItemInfo(aItemUpdateObj: Object): Void
	{
		var iItemType: Number = aItemUpdateObj.type;
		var bHasWeightandValue = true;
		if (iItemType == undefined) {
			iItemType = iLastItemType;
			if (aItemUpdateObj == undefined)
				aItemUpdateObj = {type: iLastItemType};
		} else {
			iLastItemType = iItemType;
		}
		if (PlayerInfoObj != undefined && aItemUpdateObj != undefined) {
			switch(iItemType) {
				case InventoryDefines.ICT_ARMOR:
					PlayerInfoCard_mc.gotoAndStop("Armor");
					var strArmor: String = Math.floor(PlayerInfoObj.armor).toString();
					if (aItemUpdateObj.armorChange != undefined) {
						var iArmorDelta = Math.round(aItemUpdateObj.armorChange);
						if (iArmorDelta > 0) 
							strArmor = strArmor + " <font color=\'#189515\'>(+" + iArmorDelta.toString() + ")</font>";
						else if (iArmorDelta < 0) 
							strArmor = strArmor + " <font color=\'#FF0000\'>(" + iArmorDelta.toString() + ")</font>";
					}
					PlayerInfoCard_mc.ArmorRatingValue.textAutoSize = "shrink";
					PlayerInfoCard_mc.ArmorRatingValue.html = true;
					PlayerInfoCard_mc.ArmorRatingValue.SetText(strArmor, true);
					break;
					
				case InventoryDefines.ICT_WEAPON:
					PlayerInfoCard_mc.gotoAndStop("Weapon");
					var strDamage: String = Math.floor(PlayerInfoObj.damage).toString();
					if (aItemUpdateObj.damageChange != undefined) {
						var iDamageDelta = Math.round(aItemUpdateObj.damageChange);
						if (iDamageDelta > 0) 
							strDamage = strDamage + " <font color=\'#189515\'>(+" + iDamageDelta.toString() + ")</font>";
						else if (iDamageDelta < 0) 
							strDamage = strDamage + " <font color=\'#FF0000\'>(" + iDamageDelta.toString() + ")</font>";
					}
					PlayerInfoCard_mc.DamageValue.textAutoSize = "shrink";
					PlayerInfoCard_mc.DamageValue.html = true;
					PlayerInfoCard_mc.DamageValue.SetText(strDamage, true);
					break;
					
				case InventoryDefines.ICT_POTION:
				case InventoryDefines.ICT_FOOD:
					var EF_HEALTH: Number = 0;
					var EF_MAGICKA: Number = 1;
					var EF_STAMINA: Number = 2;
					if (aItemUpdateObj.potionType == EF_MAGICKA) 
						PlayerInfoCard_mc.gotoAndStop("MagickaPotion");
					else if (aItemUpdateObj.potionType == EF_STAMINA) 
						PlayerInfoCard_mc.gotoAndStop("StaminaPotion");
					else if (aItemUpdateObj.potionType == EF_HEALTH) 
						PlayerInfoCard_mc.gotoAndStop("HealthPotion");
					break;
					
				case InventoryDefines.ICT_SPELL_DEFAULT:
				case InventoryDefines.ICT_ACTIVE_EFFECT:
					PlayerInfoCard_mc.gotoAndStop("Magic");
					bHasWeightandValue = false;
					break;
					
				case InventoryDefines.ICT_SPELL:
					PlayerInfoCard_mc.gotoAndStop("MagicSkill");
					if (aItemUpdateObj.magicSchoolName != undefined) 
						UpdateSkillBar(aItemUpdateObj.magicSchoolName, aItemUpdateObj.magicSchoolLevel, aItemUpdateObj.magicSchoolPct);
					bHasWeightandValue = false;
					break;
					
				case InventoryDefines.ICT_SHOUT:
					PlayerInfoCard_mc.gotoAndStop("Shout");
					PlayerInfoCard_mc.DragonSoulTextInstance.SetText(PlayerInfoObj.dragonSoulText);
					bHasWeightandValue = false;
					break;
					
				case InventoryDefines.ICT_BOOK:
				case InventoryDefines.ICT_INGREDIENT:
				case InventoryDefines.ICT_MISC:
				case InventoryDefines.ICT_KEY:
				default:
					PlayerInfoCard_mc.gotoAndStop("Default");
			}
			
			if (bHasWeightandValue) {
				PlayerInfoCard_mc.CarryWeightValue.textAutoSize = "shrink";
				PlayerInfoCard_mc.CarryWeightValue.SetText(Math.ceil(PlayerInfoObj.encumbrance) + "/" + Math.floor(PlayerInfoObj.maxEncumbrance));
				PlayerInfoCard_mc.PlayerGoldValue.SetText(PlayerInfoObj.gold.toString());
				PlayerInfoCard_mc.PlayerGoldLabel._x = PlayerInfoCard_mc.PlayerGoldValue._x + PlayerInfoCard_mc.PlayerGoldValue.getLineMetrics(0).x - PlayerInfoCard_mc.PlayerGoldLabel._width;
				PlayerInfoCard_mc.CarryWeightValue._x = PlayerInfoCard_mc.PlayerGoldLabel._x + PlayerInfoCard_mc.PlayerGoldLabel.getLineMetrics(0).x - PlayerInfoCard_mc.CarryWeightValue._width - 5;
				PlayerInfoCard_mc.CarryWeightLabel._x = PlayerInfoCard_mc.CarryWeightValue._x + PlayerInfoCard_mc.CarryWeightValue.getLineMetrics(0).x - PlayerInfoCard_mc.CarryWeightLabel._width;
				if (iItemType === InventoryDefines.ICT_ARMOR) {
					PlayerInfoCard_mc.ArmorRatingValue._x = PlayerInfoCard_mc.CarryWeightLabel._x + PlayerInfoCard_mc.CarryWeightLabel.getLineMetrics(0).x - PlayerInfoCard_mc.ArmorRatingValue._width - 5;
					PlayerInfoCard_mc.ArmorRatingLabel._x = PlayerInfoCard_mc.ArmorRatingValue._x + PlayerInfoCard_mc.ArmorRatingValue.getLineMetrics(0).x - PlayerInfoCard_mc.ArmorRatingLabel._width;
				} else if (iItemType === InventoryDefines.ICT_WEAPON) {
					PlayerInfoCard_mc.DamageValue._x = PlayerInfoCard_mc.CarryWeightLabel._x + PlayerInfoCard_mc.CarryWeightLabel.getLineMetrics(0).x - PlayerInfoCard_mc.DamageValue._width - 5;
					PlayerInfoCard_mc.DamageLabel._x = PlayerInfoCard_mc.DamageValue._x + PlayerInfoCard_mc.DamageValue.getLineMetrics(0).x - PlayerInfoCard_mc.DamageLabel._width;
				}
			}
			UpdateStatMeter(PlayerInfoCard_mc.HealthRect, HealthMeter, PlayerInfoObj.health, PlayerInfoObj.maxHealth, PlayerInfoObj.healthColor);
			UpdateStatMeter(PlayerInfoCard_mc.MagickaRect, MagickaMeter, PlayerInfoObj.magicka, PlayerInfoObj.maxMagicka, PlayerInfoObj.magickaColor);
			UpdateStatMeter(PlayerInfoCard_mc.StaminaRect, StaminaMeter, PlayerInfoObj.stamina, PlayerInfoObj.maxStamina, PlayerInfoObj.staminaColor);
		}
	}

	function UpdatePlayerInfo(aPlayerUpdateObj: Object, aItemUpdateObj: Object): Void
	{
		PlayerInfoObj = aPlayerUpdateObj;
		UpdatePerItemInfo(aItemUpdateObj);
	}

	function UpdateSkillBar(aSkillName: String, aiLevelStart: Number, afLevelPercent: Number): Void
	{
		PlayerInfoCard_mc.SkillLevelLabel.SetText(aSkillName);
		PlayerInfoCard_mc.SkillLevelCurrent.SetText(aiLevelStart);
		PlayerInfoCard_mc.SkillLevelNext.SetText(aiLevelStart + 1);
		PlayerInfoCard_mc.LevelMeterInstance.gotoAndStop("Pause");
		LevelMeter.SetPercent(afLevelPercent);
	}

	function UpdateCraftingInfo(aSkillName: String, aiLevelStart: Number, afLevelPercent: Number): Void
	{
		PlayerInfoCard_mc.gotoAndStop("Crafting");
		UpdateSkillBar(aSkillName, aiLevelStart, afLevelPercent);
	}

	function UpdateStatMeter(aMeterRect: MovieClip, aMeterObj: Components.Meter, aiCurrValue: Number, aiMaxValue: Number, aColor: String): Void
	{
		if (aColor == undefined) 
			aColor = "#FFFFFF";
		if (aMeterRect._alpha > 0) {
			if (aMeterRect.MeterText != undefined) {
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
		if (PlayerInfoCard_mc._currentframe == 1) 
			PlayerInfoCard_mc.gotoAndStop("Barter");
		PlayerInfoCard_mc.PlayerGoldValue.textAutoSize = "shrink";
		PlayerInfoCard_mc.VendorGoldValue.textAutoSize = "shrink";
		if (aiGoldDelta == undefined) 
			PlayerInfoCard_mc.PlayerGoldValue.SetText(aiPlayerGold.toString(), true);
		else if (aiGoldDelta >= 0) 
			PlayerInfoCard_mc.PlayerGoldValue.SetText(aiPlayerGold.toString() + " <font color=\'#189515\'>(+" + aiGoldDelta.toString() + ")</font>", true);
		else 
			PlayerInfoCard_mc.PlayerGoldValue.SetText(aiPlayerGold.toString() + " <font color=\'#FF0000\'>(" + aiGoldDelta.toString() + ")</font>", true);
		PlayerInfoCard_mc.VendorGoldValue.SetText(aiVendorGold.toString());
		if (astrVendorName != undefined) {
			PlayerInfoCard_mc.VendorGoldLabel.SetText("$Gold");
			PlayerInfoCard_mc.VendorGoldLabel.SetText(astrVendorName + " " + PlayerInfoCard_mc.VendorGoldLabel.text);
		}
		PlayerInfoCard_mc.VendorGoldLabel._x = PlayerInfoCard_mc.VendorGoldValue._x + PlayerInfoCard_mc.VendorGoldValue.getLineMetrics(0).x - PlayerInfoCard_mc.VendorGoldLabel._width - 5;
		PlayerInfoCard_mc.PlayerGoldValue._x = PlayerInfoCard_mc.VendorGoldLabel._x + PlayerInfoCard_mc.VendorGoldLabel.getLineMetrics(0).x - PlayerInfoCard_mc.PlayerGoldValue._width - 20;
		PlayerInfoCard_mc.PlayerGoldLabel._x = PlayerInfoCard_mc.PlayerGoldValue._x + PlayerInfoCard_mc.PlayerGoldValue.getLineMetrics(0).x - PlayerInfoCard_mc.PlayerGoldLabel._width - 5;
	}

	function SetBarterPerItemInfo(aItemUpdateObj: Object, aPlayerInfoObj: Object): Void
	{
		if (aItemUpdateObj != undefined) {
			var iItemType: Number = aItemUpdateObj.type;
			
			switch(iItemType) {
				case InventoryDefines.ICT_ARMOR:
					PlayerInfoCard_mc.gotoAndStop("Barter_Armor");
					var strArmor: String = Math.floor(aPlayerInfoObj.armor).toString();
					if (aItemUpdateObj.armorChange != undefined) {
						var iArmorDelta: Number = Math.round(aItemUpdateObj.armorChange);
						if (iArmorDelta > 0) 
							strArmor = strArmor + " <font color=\'#189515\'>(+" + iArmorDelta.toString() + ")</font>";
						else if (iArmorDelta < 0) 
							strArmor = strArmor + " <font color=\'#FF0000\'>(" + iArmorDelta.toString() + ")</font>";
					}
					PlayerInfoCard_mc.ArmorRatingValue.textAutoSize = "shrink";
					PlayerInfoCard_mc.ArmorRatingValue.html = true;
					PlayerInfoCard_mc.ArmorRatingValue.SetText(strArmor, true);
					break;
					
				case InventoryDefines.ICT_WEAPON:
					PlayerInfoCard_mc.gotoAndStop("Barter_Weapon");
					var strDamage: String = Math.floor(aPlayerInfoObj.damage).toString();
					if (aItemUpdateObj.damageChange != undefined) {
						var iDamageDelta: Number = Math.round(aItemUpdateObj.damageChange);
						if (iDamageDelta > 0) 
							strDamage = strDamage + " <font color=\'#189515\'>(+" + iDamageDelta.toString() + ")</font>";
						else if (iDamageDelta < 0) 
							strDamage = strDamage + " <font color=\'#FF0000\'>(" + iDamageDelta.toString() + ")</font>";
					}
					PlayerInfoCard_mc.DamageValue.textAutoSize = "shrink";
					PlayerInfoCard_mc.DamageValue.html = true;
					PlayerInfoCard_mc.DamageValue.SetText(strDamage, true);
					break;
					
				default:
					PlayerInfoCard_mc.gotoAndStop("Barter");
			}
		}
	}

	function SetGiftInfo(aiFavorPoints: Number): Void
	{
		PlayerInfoCard_mc.gotoAndStop("Gift");
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		for (var i: Number = 0; i < Buttons.length; i++)
			Buttons[i].SetPlatform(aiPlatform, abPS3Switch);
	}

	function ShowButtons(): Void
	{
		for (var i: Number = 0; i < Buttons.length; i++)
			Buttons[i]._visible = Buttons[i].label.length > 0;
	}

	function HideButtons(): Void
	{
		for (var i: Number = 0; i < Buttons.length; i++)
			Buttons[i]._visible = false;
	}

	function SetButtonsText(): Void
	{
		for (var i: Number = 0; i < Buttons.length; i++) {
			Buttons[i].label = i >= arguments.length ? "" : arguments[i];
			Buttons[i]._visible = Buttons[i].label.length > 0;
		}
		PositionButtons();
	}

	function SetButtonText(aText: String, aIndex: Number): Void
	{
		if (aIndex < Buttons.length) {
			Buttons[aIndex].label = aText;
			Buttons[aIndex]._visible = aText.length > 0;
			PositionButtons();
		}
	}

	function SetButtonsArt(aButtonArt: Object): Void
	{
		for (var i: Number = 0; i < aButtonArt.length; i++)
			SetButtonArt(aButtonArt[i], i);
	}

	function AttachDualButton(aButtonArtObj: Object, aiIndex: Number): Void
	{
		if (aiIndex < Buttons.length) 
			Buttons[aiIndex].AttachDualButton(aButtonArtObj);
	}

	function GetButtonsArt(): Array
	{
		var ButtonsArt = new Array(Buttons.length);
		for (var i: Number = 0; i < Buttons.length; i++)
			ButtonsArt[i] = Buttons[i].GetArt();
		return ButtonsArt;
	}

	function GetButtonArt(aiIndex: Number): Object
	{
		if (aiIndex < Buttons.length) 
			return Buttons[aiIndex].GetArt();
		return undefined;
	}

	function SetButtonArt(aPlatformArt: Object, aIndex: Number): Void
	{
		if (aIndex < Buttons.length) {
			var aButton = Buttons[aIndex];
			aButton.PCArt = aPlatformArt.PCArt;
			aButton.XBoxArt = aPlatformArt.XBoxArt;
			aButton.PS3Art = aPlatformArt.PS3Art;
			aButton.RefreshArt();
		}
	}

	function PositionButtons(): Void
	{
		var RightOffset: Number = 10;
		var LeftOffset: Number = iLeftOffset;
		for (var i: Number = 0; i < Buttons.length; i++) {
			if (Buttons[i].label.length > 0) {
				Buttons[i]._x = LeftOffset + Buttons[i].ButtonArt._width;
				if (Buttons[i].ButtonArt2 != undefined) 
					Buttons[i]._x = Buttons[i]._x + Buttons[i].ButtonArt2._width;
				LeftOffset = Buttons[i]._x + Buttons[i].textField.getLineMetrics(0).width + RightOffset;
			}
		}
	}

}
