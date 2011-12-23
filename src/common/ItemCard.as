dynamic class ItemCard extends MovieClip
{
	var ActiveEffectTimeValue;
	var ApparelArmorValue;
	var ApparelEnchantedLabel;
	var BookDescriptionLabel;
	var ButtonRect;
	var ButtonRect_mc;
	var CardList_mc;
	var ChargeMeter_Default;
	var ChargeMeter_Enchantment;
	var ChargeMeter_SoulGem;
	var ChargeMeter_Weapon;
	var EnchantingSlider_mc;
	var Enchanting_Background;
	var Enchanting_Slim_Background;
	var EnchantmentLabel;
	var InputHandler;
	var ItemCardMeters;
	var ItemList;
	var ItemName;
	var ItemText;
	var ItemValueText;
	var ItemWeightText;
	var LastUpdateObj;
	var ListChargeMeter;
	var MagicCostLabel;
	var MagicCostPerSec;
	var MagicCostTimeLabel;
	var MagicCostTimeValue;
	var MagicCostValue;
	var MagicEffectsLabel;
	var MessageText;
	var PoisonInstance;
	var PotionsLabel;
	var PrevFocus;
	var QuantitySlider_mc;
	var SecsText;
	var ShoutCostValue;
	var ShoutEffectsLabel;
	var SkillLevelText;
	var SkillTextInstance;
	var SliderValueText;
	var SoulLevel;
	var StolenTextInstance;
	var TotalChargesValue;
	var WeaponChargeMeter;
	var WeaponDamageValue;
	var WeaponEnchantedLabel;
	var _bEditNameMode;
	var _parent;
	var _visible;
	var bFadedIn;
	var dispatchEvent;
	var gotoAndStop;

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

	function get bEditNameMode()
	{
		return this._bEditNameMode;
	}

	function GetItemName()
	{
		return this.ItemName;
	}

	function SetupItemName(aPrevName)
	{
		this.ItemName = this.ItemText.ItemTextField;
		if (this.ItemName != undefined) 
		{
			this.ItemName.textAutoSize = "shrink";
			this.ItemName.htmlText = aPrevName;
			this.ItemName.selectable = false;
		}
	}

	function onLoad()
	{
		this.QuantitySlider_mc.addEventListener("change", this, "onSliderChange");
		this.ButtonRect_mc.AcceptMouseButton.addEventListener("click", this, "onAcceptMouseClick");
		this.ButtonRect_mc.CancelMouseButton.addEventListener("click", this, "onCancelMouseClick");
		this.ButtonRect_mc.AcceptMouseButton.SetPlatform(0, false);
		this.ButtonRect_mc.CancelMouseButton.SetPlatform(0, false);
	}

	function SetPlatform(aiPlatform, abPS3Switch)
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

	function onAcceptMouseClick()
	{
		if (this.ButtonRect_mc._alpha == 100 && this.ButtonRect_mc.AcceptMouseButton._visible == true && this.InputHandler != undefined) 
		{
			var __reg2 = {value: "keyDown", navEquivalent: gfx.ui.NavigationCode.ENTER};
			this.InputHandler(__reg2);
		}
	}

	function onCancelMouseClick()
	{
		if (this.ButtonRect_mc._alpha == 100 && this.ButtonRect_mc.CancelMouseButton._visible == true && this.InputHandler != undefined) 
		{
			var __reg2 = {value: "keyDown", navEquivalent: gfx.ui.NavigationCode.TAB};
			this.InputHandler(__reg2);
		}
	}

	function FadeInCard()
	{
		if (this.bFadedIn) 
		{
			return;
		}
		this._visible = true;
		this._parent.gotoAndPlay("fadeIn");
		this.bFadedIn = true;
	}

	function FadeOutCard()
	{
		if (this.bFadedIn) 
		{
			this._parent.gotoAndPlay("fadeOut");
			this.bFadedIn = false;
		}
	}

	function get quantitySlider()
	{
		return this.QuantitySlider_mc;
	}

	function get weaponChargeMeter()
	{
		return this.ItemCardMeters[InventoryDefines.ICT_WEAPON];
	}

	function get itemInfo()
	{
		return this.LastUpdateObj;
	}

	function set itemInfo(aUpdateObj)
	{
		this.ItemCardMeters = new Array();
		var __reg12 = this.ItemName == undefined ? "" : this.ItemName.htmlText;
		if ((__reg0 = aUpdateObj.type) === InventoryDefines.ICT_ARMOR) 
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
		else if (__reg0 === InventoryDefines.ICT_WEAPON) 
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
			var __reg13 = aUpdateObj.poisoned == true ? "On" : "Off";
			this.PoisonInstance.gotoAndStop(__reg13);
			this.WeaponDamageValue.SetText(aUpdateObj.damage);
			this.WeaponEnchantedLabel.textAutoSize = "shrink";
			this.WeaponEnchantedLabel.htmlText = aUpdateObj.effects;
		}
		else if (__reg0 === InventoryDefines.ICT_BOOK) 
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
		else if (__reg0 === InventoryDefines.ICT_POTION) 
		{
			this.gotoAndStop("Potions_reg");
			this.PotionsLabel.textAutoSize = "shrink";
			this.PotionsLabel.htmlText = aUpdateObj.effects;
			this.SkillTextInstance.text = aUpdateObj.skillName == undefined ? "" : aUpdateObj.skillName;
		}
		else if (__reg0 === InventoryDefines.ICT_FOOD) 
		{
			this.gotoAndStop("Potions_reg");
			this.PotionsLabel.textAutoSize = "shrink";
			this.PotionsLabel.htmlText = aUpdateObj.effects;
			this.SkillTextInstance.text = aUpdateObj.skillName == undefined ? "" : aUpdateObj.skillName;
		}
		else if (__reg0 === InventoryDefines.ICT_SPELL_DEFAULT) 
		{
			var __reg11 = aUpdateObj.castTime == 0;
			if (__reg11) 
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
			else if (__reg11) 
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
		else if (__reg0 === InventoryDefines.ICT_SPELL) 
		{
			__reg11 = aUpdateObj.castTime == 0;
			if (__reg11) 
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
			if (__reg11) 
			{
				this.MagicCostTimeValue.text = aUpdateObj.spellCost.toString();
			}
			else 
			{
				this.MagicCostValue.text = aUpdateObj.spellCost.toString();
			}
		}
		else if (__reg0 === InventoryDefines.ICT_INGREDIENT) 
		{
			this.gotoAndStop("Ingredients_reg");
			var __reg4 = 0;
			while (__reg4 < 4) 
			{
				this["EffectLabel" + __reg4].textAutoSize = "shrink";
				if (aUpdateObj["itemEffect" + __reg4] != undefined && aUpdateObj["itemEffect" + __reg4] != "") 
				{
					this["EffectLabel" + __reg4].textColor = 16777215;
					this["EffectLabel" + __reg4].SetText(aUpdateObj["itemEffect" + __reg4]);
				}
				else if (__reg4 < aUpdateObj.numItemEffects) 
				{
					this["EffectLabel" + __reg4].textColor = 10066329;
					this["EffectLabel" + __reg4].SetText("$UNKNOWN");
				}
				else 
				{
					this["EffectLabel" + __reg4].SetText("");
				}
				++__reg4;
			}
		}
		else if (__reg0 === InventoryDefines.ICT_MISC) 
		{
			this.gotoAndStop("Misc_reg");
		}
		else if (__reg0 === InventoryDefines.ICT_SHOUT) 
		{
			this.gotoAndStop("Shouts_reg");
			var __reg9 = 0;
			var __reg3 = 0;
			while (__reg3 < 3) 
			{
				if (aUpdateObj["word" + __reg3] != undefined && aUpdateObj["word" + __reg3] != "" && aUpdateObj["unlocked" + __reg3] == true) 
				{
					__reg9 = __reg3;
				}
				++__reg3;
			}
			__reg3 = 0;
			while (__reg3 < 3) 
			{
				var __reg7 = aUpdateObj["dragonWord" + __reg3] == undefined ? "" : aUpdateObj["dragonWord" + __reg3];
				var __reg6 = aUpdateObj["word" + __reg3] == undefined ? "" : aUpdateObj["word" + __reg3];
				var __reg5 = aUpdateObj["unlocked" + __reg3] == true;
				this["ShoutTextInstance" + __reg3].DragonShoutLabelInstance.ShoutWordsLabel.textAutoSize = "shrink";
				this["ShoutTextInstance" + __reg3].ShoutLabelInstance.ShoutWordsLabelTranslation.textAutoSize = "shrink";
				this["ShoutTextInstance" + __reg3].DragonShoutLabelInstance.ShoutWordsLabel.SetText(__reg7.toUpperCase());
				this["ShoutTextInstance" + __reg3].ShoutLabelInstance.ShoutWordsLabelTranslation.SetText(__reg6);
				if (__reg5 && __reg3 == __reg9 && this.LastUpdateObj.soulSpent == true) 
				{
					this["ShoutTextInstance" + __reg3].gotoAndPlay("Learn");
				}
				else if (__reg5) 
				{
					this["ShoutTextInstance" + __reg3].gotoAndStop("Known");
					this["ShoutTextInstance" + __reg3].gotoAndStop("Known");
				}
				else 
				{
					this["ShoutTextInstance" + __reg3].gotoAndStop("Unlocked");
					this["ShoutTextInstance" + __reg3].gotoAndStop("Unlocked");
				}
				++__reg3;
			}
			this.ShoutEffectsLabel.htmlText = aUpdateObj.effects;
			this.ShoutCostValue.text = aUpdateObj.spellCost.toString();
		}
		else if (__reg0 === InventoryDefines.ICT_ACTIVE_EFFECT) 
		{
			this.gotoAndStop("ActiveEffects");
			this.MagicEffectsLabel.html = true;
			this.MagicEffectsLabel.SetText(aUpdateObj.effects, true);
			this.MagicEffectsLabel.textAutoSize = "shrink";
			if (aUpdateObj.timeRemaining > 0) 
			{
				var __reg8 = Math.floor(aUpdateObj.timeRemaining);
				this.ActiveEffectTimeValue._alpha = 100;
				this.SecsText._alpha = 100;
				if (__reg8 >= 3600) 
				{
					__reg8 = Math.floor(__reg8 / 3600);
					this.ActiveEffectTimeValue.text = __reg8.toString();
					if (__reg8 == 1) 
					{
						this.SecsText.text = "$hour";
					}
					else 
					{
						this.SecsText.text = "$hours";
					}
				}
				else if (__reg8 >= 60) 
				{
					__reg8 = Math.floor(__reg8 / 60);
					this.ActiveEffectTimeValue.text = __reg8.toString();
					if (__reg8 == 1) 
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
					this.ActiveEffectTimeValue.text = __reg8.toString();
					if (__reg8 == 1) 
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
		else if (__reg0 === InventoryDefines.ICT_SOUL_GEMS) 
		{
			this.gotoAndStop("SoulGem");
			this.SoulLevel.text = aUpdateObj.soulLVL;
		}
		else if (__reg0 === InventoryDefines.ICT_LIST) 
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
		else if (__reg0 === InventoryDefines.ICT_CRAFT_ENCHANTING) 
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
			if (__reg0 !== InventoryDefines.ICT_KEY) 
			{
				__reg0 === InventoryDefines.ICT_NONE;
			}
			this.gotoAndStop("Empty");
		}
		this.SetupItemName(__reg12);
		if (aUpdateObj.name != undefined) 
		{
			var __reg10 = aUpdateObj.count != undefined && aUpdateObj.count > 1 ? aUpdateObj.name + " (" + aUpdateObj.count + ")" : aUpdateObj.name;
			this.ItemText.ItemTextField.SetText(this._bEditNameMode || aUpdateObj.upperCaseName == false ? __reg10 : __reg10.toUpperCase(), false);
			this.ItemText.ItemTextField.textColor = aUpdateObj.negativeEffect == true ? 16711680 : 16777215;
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

	function RoundDecimal(aNumber, aPrecision)
	{
		var __reg1 = Math.pow(10, aPrecision);
		return Math.round(__reg1 * aNumber) / __reg1;
	}

	function PrepareInputElements(aActiveClip)
	{
		var __reg4 = 92;
		var __reg6 = 98;
		var __reg5 = 147.3;
		var __reg2 = 130;
		var __reg7 = 166;
		if (aActiveClip == this.EnchantingSlider_mc) 
		{
			this.QuantitySlider_mc._y = -100;
			this.ButtonRect._y = __reg7;
			this.EnchantingSlider_mc._y = __reg5;
			this.CardList_mc._y = -100;
			this.QuantitySlider_mc._alpha = 0;
			this.ButtonRect._alpha = 100;
			this.EnchantingSlider_mc._alpha = 100;
			this.CardList_mc._alpha = 0;
			return;
		}
		if (aActiveClip == this.QuantitySlider_mc) 
		{
			this.QuantitySlider_mc._y = __reg4;
			this.ButtonRect._y = __reg2;
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
			this.CardList_mc._y = __reg6;
			this.QuantitySlider_mc._alpha = 0;
			this.ButtonRect._alpha = 0;
			this.EnchantingSlider_mc._alpha = 0;
			this.CardList_mc._alpha = 100;
			return;
		}
		if (aActiveClip == this.ButtonRect) 
		{
			this.QuantitySlider_mc._y = -100;
			this.ButtonRect._y = __reg2;
			this.EnchantingSlider_mc._y = -100;
			this.CardList_mc._y = -100;
			this.QuantitySlider_mc._alpha = 0;
			this.ButtonRect._alpha = 100;
			this.EnchantingSlider_mc._alpha = 0;
			this.CardList_mc._alpha = 0;
		}
	}

	function ShowEnchantingSlider(aiMaxValue, aiMinValue, aiCurrentValue)
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

	function ShowQuantityMenu(aiMaxAmount)
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

	function HideQuantityMenu(aCanceled)
	{
		gfx.managers.FocusHandler.instance.setFocus(this.PrevFocus, 0);
		this.QuantitySlider_mc._alpha = 0;
		this.ButtonRect_mc._alpha = 0;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, canceled: aCanceled, menu: "quantity"});
	}

	function OpenListMenu()
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

	function HideListMenu()
	{
		gfx.managers.FocusHandler.instance.setFocus(this.PrevFocus, 0);
		this.ListChargeMeter._alpha = 0;
		this.CardList_mc._alpha = 0;
		this.ItemCardMeters[InventoryDefines.ICT_LIST] = undefined;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, menu: "list"});
	}

	function ShowConfirmMessage(strMessage)
	{
		this.gotoAndStop("ConfirmMessage");
		this.PrepareInputElements(this.ButtonRect_mc);
		var __reg2 = strMessage.split("\r\n");
		var __reg3 = __reg2.join("\n");
		this.MessageText.SetText(__reg3);
		this.PrevFocus = gfx.managers.FocusHandler.instance.getFocus(0);
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
		this.InputHandler = this.HandleConfirmMessageInput;
		this.dispatchEvent({type: "subMenuAction", opening: true, menu: "message"});
	}

	function HideConfirmMessage()
	{
		gfx.managers.FocusHandler.instance.setFocus(this.PrevFocus, 0);
		this.ButtonRect_mc._alpha = 0;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, menu: "message"});
	}

	function StartEditName(aInitialText, aMaxChars)
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
			this.ItemName.maxChars = aMaxChars == undefined ? null : aMaxChars;
			Selection.setFocus(this.ItemName, 0);
			Selection.setSelection(0, 0);
			this.InputHandler = this.HandleEditNameInput;
			this.dispatchEvent({type: "subMenuAction", opening: true, menu: "editName"});
			this._bEditNameMode = true;
		}
	}

	function EndEditName()
	{
		this.ItemName.type = "dynamic";
		this.ItemName.noTranslate = false;
		this.ItemName.selectable = false;
		this.ItemName.maxChars = null;
		var __reg2 = this.PrevFocus.focusEnabled;
		this.PrevFocus.focusEnabled = true;
		Selection.setFocus(this.PrevFocus, 0);
		this.PrevFocus.focusEnabled = __reg2;
		this.InputHandler = undefined;
		this.dispatchEvent({type: "subMenuAction", opening: false, menu: "editName"});
		this._bEditNameMode = false;
	}

	function handleInput(details, pathToFocus)
	{
		var __reg2 = false;
		if (pathToFocus.length > 0 && pathToFocus[0].handleInput != undefined) 
		{
			pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		if (!__reg2 && this.InputHandler != undefined) 
		{
			__reg2 = this.InputHandler(details);
		}
		return __reg2;
	}

	function HandleQuantityMenuInput(details)
	{
		var __reg2 = false;
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
				__reg2 = true;
			}
			else if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				this.HideQuantityMenu(true);
				this.itemInfo = this.LastUpdateObj;
				__reg2 = true;
			}
		}
		return __reg2;
	}

	function HandleListMenuInput(details)
	{
		var __reg2 = false;
		if (Shared.GlobalFunc.IsKeyPressed(details) && details.navEquivalent == gfx.ui.NavigationCode.TAB) 
		{
			this.HideListMenu();
			__reg2 = true;
		}
		return __reg2;
	}

	function HandleConfirmMessageInput(details)
	{
		var __reg2 = false;
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.ENTER) 
			{
				this.HideConfirmMessage();
				this.dispatchEvent({type: "messageConfirm"});
				__reg2 = true;
			}
			else if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				this.HideConfirmMessage();
				this.dispatchEvent({type: "messageCancel"});
				this.itemInfo = this.LastUpdateObj;
				__reg2 = true;
			}
		}
		return __reg2;
	}

	function HandleEditNameInput(details)
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

	function onSliderChange()
	{
		var __reg3 = this.EnchantingSlider_mc._alpha <= 0 ? this.SliderValueText : this.TotalChargesValue;
		var __reg4 = Number(__reg3.text);
		var __reg2 = Math.floor(this.QuantitySlider_mc.value);
		if (__reg4 != __reg2) 
		{
			__reg3.SetText(__reg2.toString());
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
			this.dispatchEvent({type: "sliderChange", value: __reg2});
		}
	}

	function onListItemPress(event)
	{
		this.dispatchEvent(event);
		this.HideListMenu();
	}

	function onListMouseSelectionChange(event)
	{
		if (event.keyboardOrMouse == 0) 
		{
			this.onListSelectionChange(event);
		}
	}

	function onListSelectionChange(event)
	{
		this.ItemCardMeters[InventoryDefines.ICT_LIST].SetDeltaPercent(this.ItemList.selectedEntry.chargeAdded + this.LastUpdateObj.currentCharge);
	}

}
