class ItemCard extends MovieClip
{
	var ActiveEffectTimeValue: TextField;
	var ApparelArmorValue: TextField;
	var ApparelEnchantedLabel: TextField;
	var BookDescriptionLabel: TextField;
	var ButtonRect: MovieClip;
	var ButtonRect_mc: MovieClip;
	var CardList_mc: MovieClip;
	var ChargeMeter_Default: MovieClip;
	var ChargeMeter_Enchantment: MovieClip;
	var ChargeMeter_SoulGem: MovieClip;
	var ChargeMeter_Weapon: MovieClip;
	var EnchantingSlider_mc: MovieClip;
	var Enchanting_Background: MovieClip;
	var Enchanting_Slim_Background: MovieClip;
	var EnchantmentLabel: TextField;
	var InputHandler: Function;
	var ItemCardMeters: Object;
	var ItemList: MovieClip;
	var ItemName: TextField;
	var ItemText: TextField;
	var ItemValueText: TextField;
	var ItemWeightText: TextField;
	var LastUpdateObj: Object;
	var ListChargeMeter: MovieClip;
	var MagicCostLabel: TextField;
	var MagicCostPerSec: TextField;
	var MagicCostTimeLabel: TextField;
	var MagicCostTimeValue: TextField;
	var MagicCostValue: TextField;
	var MagicEffectsLabel: TextField;
	var MessageText: TextField;
	var PoisonInstance: MovieClip;
	var PotionsLabel: TextField;
	var PrevFocus: MovieClip;
	var QuantitySlider_mc: MovieClip;
	var SecsText: TextField;
	var ShoutCostValue: TextField;
	var ShoutEffectsLabel: TextField;
	var SkillLevelText: TextField;
	var SkillTextInstance: TextField;
	var SliderValueText: TextField;
	var SoulLevel: TextField;
	var StolenTextInstance: TextField;
	var TotalChargesValue: TextField;
	var WeaponChargeMeter: MovieClip;
	var WeaponDamageValue: TextField;
	var WeaponEnchantedLabel: TextField;
	var _bEditNameMode: Boolean;
	var bFadedIn: Boolean;
	var dispatchEvent: Function;

	function ItemCard()
	{
		super();
		Shared.GlobalFunc.MaintainTextFormat();
		Shared.GlobalFunc.AddReverseFunctions();
		gfx.events.EventDispatcher.initialize(this);
		this.QuantitySlider_mc = this.QuantitySlider_mc;
		this.ButtonRect_mc = this.ButtonRect;
		this.ItemList = this.CardList_mc.List_mc;
		this.SetupItemName();
		this.bFadedIn = false;
		this.InputHandler = undefined;
		this._bEditNameMode = false;
	}

	function get bEditNameMode(): Boolean
	{
		return this._bEditNameMode;
	}

	function GetItemName(): TextField
	{
		return this.ItemName;
	}

	function SetupItemName(aPrevName: String): Void
	{
		this.ItemName = this.ItemText.ItemTextField;
		if (this.ItemName != undefined) 
		{
			this.ItemName.textAutoSize = "shrink";
			this.ItemName.htmlText = aPrevName;
			this.ItemName.selectable = false;
		}
	}

	function onLoad(): Void
	{
		this.QuantitySlider_mc.addEventListener("change", this, "onSliderChange");
		this.ButtonRect_mc.AcceptMouseButton.addEventListener("click", this, "onAcceptMouseClick");
		this.ButtonRect_mc.CancelMouseButton.addEventListener("click", this, "onCancelMouseClick");
		this.ButtonRect_mc.AcceptMouseButton.SetPlatform(0, false);
		this.ButtonRect_mc.CancelMouseButton.SetPlatform(0, false);
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		this.ButtonRect_mc.AcceptGamepadButton._visible = aiPlatform != 0;
		this.ButtonRect_mc.CancelGamepadButton._visible = aiPlatform != 0;
		this.ButtonRect_mc.AcceptMouseButton._visible = aiPlatform == 0;
		this.ButtonRect_mc.CancelMouseButton._visible = aiPlatform == 0;
		if (aiPlatform != 0) 
		{
			this.ButtonRect_mc.AcceptGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
			this.ButtonRect_mc.CancelGamepadButton.SetPlatform(aiPlatform, abPS3Switch);
		}
		this.ItemList.SetPlatform(aiPlatform, abPS3Switch);
	}

	function onAcceptMouseClick(): Void
	{
		if (this.ButtonRect_mc._alpha == 100 && this.ButtonRect_mc.AcceptMouseButton._visible == true && this.InputHandler != undefined) 
		{
			var inputEnterObj: Object = {value: "keyDown", navEquivalent: gfx.ui.NavigationCode.ENTER};
			this.InputHandler(inputEnterObj);
		}
	}

	function onCancelMouseClick(): Void
	{
		if (this.ButtonRect_mc._alpha == 100 && this.ButtonRect_mc.CancelMouseButton._visible == true && this.InputHandler != undefined) 
		{
			var inputTabObj: Object = {value: "keyDown", navEquivalent: gfx.ui.NavigationCode.TAB};
			this.InputHandler(inputTabObj);
		}
	}

	function FadeInCard(): Void
	{
		if (this.bFadedIn) 
		{
			return;
		}
		this._visible = true;
		this._parent.gotoAndPlay("fadeIn");
		this.bFadedIn = true;
	}

	function FadeOutCard(): Void
	{
		if (this.bFadedIn) 
		{
			this._parent.gotoAndPlay("fadeOut");
			this.bFadedIn = false;
		}
	}

	function get quantitySlider(): MovieClip
	{
		return this.QuantitySlider_mc;
	}

	function get weaponChargeMeter(): Components.DeltaMeter
	{
		return this.ItemCardMeters[InventoryDefines.ICT_WEAPON];
	}

	function get itemInfo(): Object
	{
		return this.LastUpdateObj;
	}

	function set itemInfo(aUpdateObj: Object): Void
	{
		this.ItemCardMeters = new Array();
		var strItemNameHtml: String = this.ItemName == undefined ? "" : this.ItemName.htmlText;
		var _iItemType: Number = aUpdateObj.type;
		if (_iItemType === InventoryDefines.ICT_ARMOR) 
		{
			if (aUpdateObj.effects.length == 0) 
			{
				this.gotoAndStop("Apparel_reg");
			}
			else 
			{
				this.gotoAndStop("Apparel_Enchanted");
			}
			this.ApparelArmorValue.textAutoSize = "shrink";
			this.ApparelArmorValue.SetText(aUpdateObj.armor);
			this.ApparelEnchantedLabel.htmlText = aUpdateObj.effects;
			this.SkillTextInstance.text = aUpdateObj.skillText;
		}
		else if (_iItemType === InventoryDefines.ICT_WEAPON) 
		{
			if (aUpdateObj.effects.length == 0) 
			{
				this.gotoAndStop("Weapons_reg");
			}
			else 
			{
				this.gotoAndStop("Weapons_Enchanted");
				if (this.ItemCardMeters[InventoryDefines.ICT_WEAPON] == undefined) 
				{
					this.ItemCardMeters[InventoryDefines.ICT_WEAPON] = new Components.DeltaMeter(this.WeaponChargeMeter.MeterInstance);
				}
				this.ItemCardMeters[InventoryDefines.ICT_WEAPON].SetPercent(aUpdateObj.usedCharge);
				this.ItemCardMeters[InventoryDefines.ICT_WEAPON].SetDeltaPercent(aUpdateObj.charge);
			}
			var strIsPoisoned: String = aUpdateObj.poisoned == true ? "On" : "Off";
			this.PoisonInstance.gotoAndStop(strIsPoisoned);
			this.WeaponDamageValue.SetText(aUpdateObj.damage);
			this.WeaponEnchantedLabel.textAutoSize = "shrink";
			this.WeaponEnchantedLabel.htmlText = aUpdateObj.effects;
		}
		else if (_iItemType === InventoryDefines.ICT_BOOK) 
		{
			if (aUpdateObj.description != undefined && aUpdateObj.description != "") 
			{
				this.gotoAndStop("Books_Description");
				this.BookDescriptionLabel.SetText(aUpdateObj.description);
			}
			else 
			{
				this.gotoAndStop("Books_reg");
			}
		}
		else if (_iItemType === InventoryDefines.ICT_POTION) 
		{
			this.gotoAndStop("Potions_reg");
			this.PotionsLabel.textAutoSize = "shrink";
			this.PotionsLabel.htmlText = aUpdateObj.effects;
			this.SkillTextInstance.text = aUpdateObj.skillName == undefined ? "" : aUpdateObj.skillName;
		}
		else if (_iItemType === InventoryDefines.ICT_FOOD) 
		{
			this.gotoAndStop("Potions_reg");
			this.PotionsLabel.textAutoSize = "shrink";
			this.PotionsLabel.htmlText = aUpdateObj.effects;
			this.SkillTextInstance.text = aUpdateObj.skillName == undefined ? "" : aUpdateObj.skillName;
		}
		else if (_iItemType === InventoryDefines.ICT_SPELL_DEFAULT) 
		{
			var bCastTime: Boolean = aUpdateObj.castTime == 0;
			if (bCastTime) 
			{
				this.gotoAndStop("Power_time_label");
			}
			else 
			{
				this.gotoAndStop("Power_reg");
			}
			this.MagicEffectsLabel.SetText(aUpdateObj.effects, true);
			this.MagicEffectsLabel.textAutoSize = "shrink";
			if (aUpdateObj.spellCost <= 0) 
			{
				this.MagicCostValue._alpha = 0;
				this.MagicCostTimeValue._alpha = 0;
				this.MagicCostLabel._alpha = 0;
				this.MagicCostTimeLabel._alpha = 0;
				this.MagicCostPerSec._alpha = 0;
			}
			else if (bCastTime) 
			{
				this.MagicCostTimeValue._alpha = 100;
				this.MagicCostTimeLabel._alpha = 100;
				this.MagicCostPerSec._alpha = 100;
				this.MagicCostTimeValue.text = aUpdateObj.spellCost.toString();
			}
			else 
			{
				this.MagicCostValue._alpha = 100;
				this.MagicCostLabel._alpha = 100;
				this.MagicCostValue.text = aUpdateObj.spellCost.toString();
			}
		}
		else if (_iItemType === InventoryDefines.ICT_SPELL) 
		{
			var bCastTime: Boolean = aUpdateObj.castTime == 0;
			if (bCastTime) 
			{
				this.gotoAndStop("Magic_time_label");
			}
			else 
			{
				this.gotoAndStop("Magic_reg");
			}
			this.SkillLevelText.text = aUpdateObj.castLevel.toString();
			this.MagicEffectsLabel.SetText(aUpdateObj.effects, true);
			this.MagicEffectsLabel.textAutoSize = "shrink";
			this.MagicCostValue.textAutoSize = "shrink";
			this.MagicCostTimeValue.textAutoSize = "shrink";
			if (bCastTime) 
			{
				this.MagicCostTimeValue.text = aUpdateObj.spellCost.toString();
			}
			else 
			{
				this.MagicCostValue.text = aUpdateObj.spellCost.toString();
			}
		}
		else if (_iItemType === InventoryDefines.ICT_INGREDIENT) 
		{
			this.gotoAndStop("Ingredients_reg");
			var i: Number = 0;
			while (i < 4) 
			{
				this["EffectLabel" + i].textAutoSize = "shrink";
				if (aUpdateObj["itemEffect" + i] != undefined && aUpdateObj["itemEffect" + i] != "") 
				{
					this["EffectLabel" + i].textColor = 0xFFFFFF;
					this["EffectLabel" + i].SetText(aUpdateObj["itemEffect" + i]);
				}
				else if (i < aUpdateObj.numItemEffects) 
				{
					this["EffectLabel" + i].textColor = 0x999999;
					this["EffectLabel" + i].SetText("$UNKNOWN");
				}
				else 
				{
					this["EffectLabel" + i].SetText("");
				}
				++i;
			}
		}
		else if (_iItemType === InventoryDefines.ICT_MISC) 
		{
			this.gotoAndStop("Misc_reg");
		}
		else if (_iItemType === InventoryDefines.ICT_SHOUT) 
		{
			this.gotoAndStop("Shouts_reg");
			var iLastWord: Number = 0;
			var i: Number = 0;
			while (i < 3) 
			{
				if (aUpdateObj["word" + i] != undefined && aUpdateObj["word" + i] != "" && aUpdateObj["unlocked" + i] == true) 
				{
					iLastWord = i;
				}
				++i;
			}
			i = 0;
			while (i < 3) 
			{
				var strDragonWord: String = aUpdateObj["dragonWord" + i] == undefined ? "" : aUpdateObj["dragonWord" + i];
				var strWord: String = aUpdateObj["word" + i] == undefined ? "" : aUpdateObj["word" + i];
				var bWordKnown: Boolean = aUpdateObj["unlocked" + i] == true;
				this["ShoutTextInstance" + i].DragonShoutLabelInstance.ShoutWordsLabel.textAutoSize = "shrink";
				this["ShoutTextInstance" + i].ShoutLabelInstance.ShoutWordsLabelTranslation.textAutoSize = "shrink";
				this["ShoutTextInstance" + i].DragonShoutLabelInstance.ShoutWordsLabel.SetText(strDragonWord.toUpperCase());
				this["ShoutTextInstance" + i].ShoutLabelInstance.ShoutWordsLabelTranslation.SetText(strWord);
				if (bWordKnown && i == iLastWord && this.LastUpdateObj.soulSpent == true) 
				{
					this["ShoutTextInstance" + i].gotoAndPlay("Learn");
				}
				else if (bWordKnown) 
				{
					this["ShoutTextInstance" + i].gotoAndStop("Known");
					this["ShoutTextInstance" + i].gotoAndStop("Known");
				}
				else 
				{
					this["ShoutTextInstance" + i].gotoAndStop("Unlocked");
					this["ShoutTextInstance" + i].gotoAndStop("Unlocked");
				}
				++i;
			}
			this.ShoutEffectsLabel.htmlText = aUpdateObj.effects;
			this.ShoutCostValue.text = aUpdateObj.spellCost.toString();
		}
		else if (_iItemType === InventoryDefines.ICT_ACTIVE_EFFECT) 
		{
			this.gotoAndStop("ActiveEffects");
			this.MagicEffectsLabel.html = true;
			this.MagicEffectsLabel.SetText(aUpdateObj.effects, true);
			this.MagicEffectsLabel.textAutoSize = "shrink";
			if (aUpdateObj.timeRemaining > 0) 
			{
				var iEffectTimeRemaining: Number = Math.floor(aUpdateObj.timeRemaining);
				this.ActiveEffectTimeValue._alpha = 100;
				this.SecsText._alpha = 100;
				if (iEffectTimeRemaining >= 3600) 
				{
					iEffectTimeRemaining = Math.floor(iEffectTimeRemaining / 3600);
					this.ActiveEffectTimeValue.text = iEffectTimeRemaining.toString();
					if (iEffectTimeRemaining == 1) 
					{
						this.SecsText.text = "$hour";
					}
					else 
					{
						this.SecsText.text = "$hours";
					}
				}
				else if (iEffectTimeRemaining >= 60) 
				{
					iEffectTimeRemaining = Math.floor(iEffectTimeRemaining / 60);
					this.ActiveEffectTimeValue.text = iEffectTimeRemaining.toString();
					if (iEffectTimeRemaining == 1) 
					{
						this.SecsText.text = "$min";
					}
					else 
					{
						this.SecsText.text = "$mins";
					}
				}
				else 
				{
					this.ActiveEffectTimeValue.text = iEffectTimeRemaining.toString();
					if (iEffectTimeRemaining == 1) 
					{
						this.SecsText.text = "$sec";
					}
					else 
					{
						this.SecsText.text = "$secs";
					}
				}
			}
			else 
			{
				this.ActiveEffectTimeValue._alpha = 0;
				this.SecsText._alpha = 0;
			}
		}
		else if (_iItemType === InventoryDefines.ICT_SOUL_GEMS) 
		{
			this.gotoAndStop("SoulGem");
			this.SoulLevel.text = aUpdateObj.soulLVL;
		}
		else if (_iItemType === InventoryDefines.ICT_LIST) 
		{
			this.gotoAndStop("Item_list");
			if (aUpdateObj.listItems != undefined) 
			{
				this.ItemList.entryList = aUpdateObj.listItems;
				this.ItemList.InvalidateData();
				this.ItemCardMeters[InventoryDefines.ICT_LIST] = new Components.DeltaMeter(this.ListChargeMeter.MeterInstance);
				this.ItemCardMeters[InventoryDefines.ICT_LIST].SetPercent(aUpdateObj.currentCharge);
				this.ItemCardMeters[InventoryDefines.ICT_LIST].SetDeltaPercent(aUpdateObj.currentCharge + this.ItemList.selectedEntry.chargeAdded);
				this.OpenListMenu();
			}
		}
		else if (_iItemType === InventoryDefines.ICT_CRAFT_ENCHANTING) 
		{
			if (aUpdateObj.sliderShown == true) 
			{
				this.gotoAndStop("Craft_Enchanting");
				this.ItemCardMeters[InventoryDefines.ICT_WEAPON] = new Components.DeltaMeter(this.ChargeMeter_Default.MeterInstance);
				if (aUpdateObj.totalCharges != undefined && aUpdateObj.totalCharges != 0) 
				{
					this.TotalChargesValue.text = aUpdateObj.totalCharges;
				}
			}
			else if (aUpdateObj.damage == undefined) 
			{
				if (aUpdateObj.armor == undefined) 
				{
					if (aUpdateObj.soulLVL == undefined) 
					{
						if (this.QuantitySlider_mc._alpha == 0) 
						{
							this.gotoAndStop("Craft_Enchanting_Enchantment");
							this.ItemCardMeters[InventoryDefines.ICT_WEAPON] = new Components.DeltaMeter(this.ChargeMeter_Enchantment.MeterInstance);
						}
					}
					else 
					{
						this.gotoAndStop("Craft_Enchanting_SoulGem");
						this.ItemCardMeters[InventoryDefines.ICT_WEAPON] = new Components.DeltaMeter(this.ChargeMeter_SoulGem.MeterInstance);
						this.SoulLevel.text = aUpdateObj.soulLVL;
					}
				}
				else 
				{
					this.gotoAndStop("Craft_Enchanting_Armor");
					this.ApparelArmorValue.SetText(aUpdateObj.armor);
					this.SkillTextInstance.text = aUpdateObj.skillText;
				}
			}
			else 
			{
				this.gotoAndStop("Craft_Enchanting_Weapon");
				this.ItemCardMeters[InventoryDefines.ICT_WEAPON] = new Components.DeltaMeter(this.ChargeMeter_Weapon.MeterInstance);
				this.WeaponDamageValue.SetText(aUpdateObj.damage);
			}
			if (aUpdateObj.usedCharge == 0 && aUpdateObj.totalCharges == 0) 
			{
				this.ItemCardMeters[InventoryDefines.ICT_WEAPON].DeltaMeterMovieClip._parent._parent._alpha = 0;
			}
			else if (aUpdateObj.usedCharge != undefined) 
			{
				this.ItemCardMeters[InventoryDefines.ICT_WEAPON].SetPercent(aUpdateObj.usedCharge);
			}
			if (aUpdateObj.effects != undefined && aUpdateObj.effects.length > 0) 
			{
				if (this.EnchantmentLabel != undefined) 
				{
					this.EnchantmentLabel.SetText(aUpdateObj.effects, true);
				}
				this.EnchantmentLabel.textAutoSize = "shrink";
				this.WeaponChargeMeter._alpha = 100;
				this.Enchanting_Background._alpha = 60;
				this.Enchanting_Slim_Background._alpha = 0;
			}
			else 
			{
				if (this.EnchantmentLabel != undefined) 
				{
					this.EnchantmentLabel.SetText("", true);
				}
				this.WeaponChargeMeter._alpha = 0;
				this.Enchanting_Slim_Background._alpha = 60;
				this.Enchanting_Background._alpha = 0;
			}
		}
		else 
		{
			if (_iItemType !== InventoryDefines.ICT_KEY) 
			{
				_iItemType === InventoryDefines.ICT_NONE;
			}
			this.gotoAndStop("Empty");
		}
		this.SetupItemName(strItemNameHtml);
		if (aUpdateObj.name != undefined) 
		{
			var strItemName: String = aUpdateObj.count != undefined && aUpdateObj.count > 1 ? aUpdateObj.name + " (" + aUpdateObj.count + ")" : aUpdateObj.name;
			this.ItemText.ItemTextField.SetText(this._bEditNameMode || aUpdateObj.upperCaseName == false ? strItemName : strItemName.toUpperCase(), false);
			this.ItemText.ItemTextField.textColor = aUpdateObj.negativeEffect == true ? 0xFF0000 : 0xFFFFFF;
		}
		this.ItemValueText.textAutoSize = "shrink";
		this.ItemWeightText.textAutoSize = "shrink";
		if (aUpdateObj.value != undefined && this.ItemValueText != undefined) 
		{
			this.ItemValueText.SetText(aUpdateObj.value.toString());
		}
		if (aUpdateObj.weight != undefined && this.ItemWeightText != undefined) 
		{
			this.ItemWeightText.SetText(this.RoundDecimal(aUpdateObj.weight, 1).toString());
		}
		this.StolenTextInstance._visible = aUpdateObj.stolen == true;
		this.LastUpdateObj = aUpdateObj;
	}

	function RoundDecimal(aNumber: Number, aPrecision: Number): Number
	{
		var significantFigures = Math.pow(10, aPrecision);
		return Math.round(significantFigures * aNumber) / significantFigures;
	}

	function PrepareInputElements(aActiveClip: MovieClip): Void
	{
		var iQuantitySlider_yOffset = 92;
		var iCardList_yOffset = 98;
		var iEnchantingSlider_yOffset = 147.3;
		var iButtonRect_iOffset = 130;
		var iButtonRect_iOffsetEnchanting = 166;
		if (aActiveClip == this.EnchantingSlider_mc) 
		{
			this.QuantitySlider_mc._y = -100;
			this.ButtonRect._y = iButtonRect_iOffsetEnchanting;
			this.EnchantingSlider_mc._y = iEnchantingSlider_yOffset;
			this.CardList_mc._y = -100;
			this.QuantitySlider_mc._alpha = 0;
			this.ButtonRect._alpha = 100;
			this.EnchantingSlider_mc._alpha = 100;
			this.CardList_mc._alpha = 0;
			return;
		}
		if (aActiveClip == this.QuantitySlider_mc) 
		{
			this.QuantitySlider_mc._y = iQuantitySlider_yOffset;
			this.ButtonRect._y = iButtonRect_iOffset;
			this.EnchantingSlider_mc._y = -100;
			this.CardList_mc._y = -100;
			this.QuantitySlider_mc._alpha = 100;
			this.ButtonRect._alpha = 100;
			this.EnchantingSlider_mc._alpha = 0;
			this.CardList_mc._alpha = 0;
			return;
		}
		if (aActiveClip == this.CardList_mc) 
		{
			this.QuantitySlider_mc._y = -100;
			this.ButtonRect._y = -100;
			this.EnchantingSlider_mc._y = -100;
			this.CardList_mc._y = iCardList_yOffset;
			this.QuantitySlider_mc._alpha = 0;
			this.ButtonRect._alpha = 0;
			this.EnchantingSlider_mc._alpha = 0;
			this.CardList_mc._alpha = 100;
			return;
		}
		if (aActiveClip == this.ButtonRect) 
		{
			this.QuantitySlider_mc._y = -100;
			this.ButtonRect._y = iButtonRect_iOffset;
			this.EnchantingSlider_mc._y = -100;
			this.CardList_mc._y = -100;
			this.QuantitySlider_mc._alpha = 0;
			this.ButtonRect._alpha = 100;
			this.EnchantingSlider_mc._alpha = 0;
			this.CardList_mc._alpha = 0;
		}
	}

	function ShowEnchantingSlider(aiMaxValue: Number, aiMinValue: Number, aiCurrentValue: Number): Void
	{
		this.gotoAndStop("Craft_Enchanting");
		this.QuantitySlider_mc = this.EnchantingSlider_mc;
		this.QuantitySlider_mc.addEventListener("change", this, "onSliderChange");
		this.PrepareInputElements(this.EnchantingSlider_mc);
		this.QuantitySlider_mc.maximum = aiMaxValue;
		this.QuantitySlider_mc.minimum = aiMinValue;
		this.QuantitySlider_mc.value = aiCurrentValue;
		this.PrevFocus = gfx.managers.FocusHandler.instance.getFocus(0);
		gfx.managers.FocusHandler.instance.setFocus(this.QuantitySlider_mc, 0);
		this.InputHandler = this.HandleQuantityMenuInput;
		this.dispatchEvent({type: "subMenuAction", opening: true, menu: "quantity"});
	}

	function ShowQuantityMenu(aiMaxAmount: Number): Void
	{
		this.gotoAndStop("Quantity");
		this.PrepareInputElements(this.QuantitySlider_mc);
		this.QuantitySlider_mc.maximum = aiMaxAmount;
		this.QuantitySlider_mc.value = aiMaxAmount;
		this.SliderValueText.textAutoSize = "shrink";
		this.SliderValueText.SetText(Math.floor(this.QuantitySlider_mc.value).toString());
		this.PrevFocus = gfx.managers.FocusHandler.instance.getFocus(0);
		gfx.managers.FocusHandler.instance.setFocus(this.QuantitySlider_mc, 0);
		this.InputHandler = this.HandleQuantityMenuInput;
		this.dispatchEvent({type: "subMenuAction", opening: true, menu: "quantity"});
	}

	function HideQuantityMenu(abCanceled: Boolean): Void
	{
		gfx.managers.FocusHandler.instance.setFocus(this.PrevFocus, 0);
		this.QuantitySlider_mc._alpha = 0;
		this.ButtonRect_mc._alpha = 0;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, canceled: abCanceled, menu: "quantity"});
	}

	function OpenListMenu(): Void
	{
		this.PrevFocus = gfx.managers.FocusHandler.instance.getFocus(0);
		gfx.managers.FocusHandler.instance.setFocus(this.ItemList, 0);
		this.ItemList.addEventListener("itemPress", this, "onListItemPress");
		this.ItemList.addEventListener("listMovedUp", this, "onListSelectionChange");
		this.ItemList.addEventListener("listMovedDown", this, "onListSelectionChange");
		this.ItemList.addEventListener("selectionChange", this, "onListMouseSelectionChange");
		this.PrepareInputElements(this.CardList_mc);
		this.ListChargeMeter._alpha = 100;
		this.InputHandler = this.HandleListMenuInput;
		this.dispatchEvent({type: "subMenuAction", opening: true, menu: "list"});
	}

	function HideListMenu(): Void
	{
		gfx.managers.FocusHandler.instance.setFocus(this.PrevFocus, 0);
		this.ListChargeMeter._alpha = 0;
		this.CardList_mc._alpha = 0;
		this.ItemCardMeters[InventoryDefines.ICT_LIST] = undefined;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, menu: "list"});
	}

	function ShowConfirmMessage(astrMessage: String): Void
	{
		this.gotoAndStop("ConfirmMessage");
		this.PrepareInputElements(this.ButtonRect_mc);
		var messageArray: Array = astrMessage.split("\r\n");
		var strMessageText = messageArray.join("\n");
		this.MessageText.SetText(strMessageText);
		this.PrevFocus = gfx.managers.FocusHandler.instance.getFocus(0);
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
		this.InputHandler = this.HandleConfirmMessageInput;
		this.dispatchEvent({type: "subMenuAction", opening: true, menu: "message"});
	}

	function HideConfirmMessage(): Void
	{
		gfx.managers.FocusHandler.instance.setFocus(this.PrevFocus, 0);
		this.ButtonRect_mc._alpha = 0;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, menu: "message"});
	}

	function StartEditName(aInitialText: String, aiMaxChars: Number): Void
	{
		if (Selection.getFocus() != this.ItemName) 
		{
			this.PrevFocus = gfx.managers.FocusHandler.instance.getFocus(0);
			if (aInitialText != undefined) 
			{
				this.ItemName.text = aInitialText;
			}
			this.ItemName.type = "input";
			this.ItemName.noTranslate = true;
			this.ItemName.selectable = true;
			this.ItemName.maxChars = aiMaxChars == undefined ? null : aiMaxChars;
			Selection.setFocus(this.ItemName, 0);
			Selection.setSelection(0, 0);
			this.InputHandler = this.HandleEditNameInput;
			this.dispatchEvent({type: "subMenuAction", opening: true, menu: "editName"});
			this._bEditNameMode = true;
		}
	}

	function EndEditName(): Void
	{
		this.ItemName.type = "dynamic";
		this.ItemName.noTranslate = false;
		this.ItemName.selectable = false;
		this.ItemName.maxChars = null;
		var bPreviousFocusEnabled: Boolean = this.PrevFocus.focusEnabled;
		this.PrevFocus.focusEnabled = true;
		Selection.setFocus(this.PrevFocus, 0);
		this.PrevFocus.focusEnabled = bPreviousFocusEnabled;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, menu: "editName"});
		this._bEditNameMode = false;
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (pathToFocus.length > 0 && pathToFocus[0].handleInput != undefined) 
		{
			pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		if (this.InputHandler != undefined) 
		{
			bHandledInput = this.InputHandler(details);
		}
		return bHandledInput;
	}

	function HandleQuantityMenuInput(details: Object): Boolean
	{
		var bValidKeyPressed: Boolean = false;
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.ENTER) 
			{
				this.HideQuantityMenu(false);
				if (this.QuantitySlider_mc.value > 0) 
				{
					this.dispatchEvent({type: "quantitySelect", amount: Math.floor(this.QuantitySlider_mc.value)});
				}
				else 
				{
					this.itemInfo = this.LastUpdateObj;
				}
				bValidKeyPressed = true;
			}
			else if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				this.HideQuantityMenu(true);
				this.itemInfo = this.LastUpdateObj;
				bValidKeyPressed = true;
			}
		}
		return bValidKeyPressed;
	}

	function HandleListMenuInput(details: Object): Boolean
	{
		var bValidKeyPressed: Boolean = false;
		if (Shared.GlobalFunc.IsKeyPressed(details) && details.navEquivalent == gfx.ui.NavigationCode.TAB) 
		{
			this.HideListMenu();
			bValidKeyPressed = true;
		}
		return bValidKeyPressed;
	}

	function HandleConfirmMessageInput(details: Object): Boolean
	{
		var bValidKeyPressed: Boolean = false;
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.ENTER) 
			{
				this.HideConfirmMessage();
				this.dispatchEvent({type: "messageConfirm"});
				bValidKeyPressed = true;
			}
			else if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				this.HideConfirmMessage();
				this.dispatchEvent({type: "messageCancel"});
				this.itemInfo = this.LastUpdateObj;
				bValidKeyPressed = true;
			}
		}
		return bValidKeyPressed;
	}

	function HandleEditNameInput(details: Object): Boolean
	{
		Selection.setFocus(this.ItemName, 0);
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.ENTER && details.code != 32) 
			{
				this.dispatchEvent({type: "endEditItemName", useNewName: true, newName: this.ItemName.text});
			}
			else if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				this.dispatchEvent({type: "endEditItemName", useNewName: false, newName: ""});
			}
		}
		return true;
	}

	function onSliderChange(): Void
	{
		var currentValue_tf: TextField = this.EnchantingSlider_mc._alpha <= 0 ? this.SliderValueText : this.TotalChargesValue;
		var iCurrentValue: Number = Number(currentValue_tf.text);
		var iNewValue: Number = Math.floor(this.QuantitySlider_mc.value);
		if (iCurrentValue != iNewValue) 
		{
			currentValue_tf.SetText(iNewValue.toString());
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
			this.dispatchEvent({type: "sliderChange", value: iNewValue});
		}
	}

	function onListItemPress(event: Object): Void
	{
		this.dispatchEvent(event);
		this.HideListMenu();
	}

	function onListMouseSelectionChange(event: Object): Void
	{
		if (event.keyboardOrMouse == 0) 
		{
			this.onListSelectionChange(event);
		}
	}

	function onListSelectionChange(event: Object): Void
	{
		this.ItemCardMeters[InventoryDefines.ICT_LIST].SetDeltaPercent(this.ItemList.selectedEntry.chargeAdded + this.LastUpdateObj.currentCharge);
	}

}
