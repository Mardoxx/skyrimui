import Shared.GlobalFunc;
import gfx.io.GameDelegate;
import Components.Meter;

class LockpickingMenu extends MovieClip
{
	var BottomBar_mc: MovieClip;
	var ButtonRect_mc: MovieClip;
	var DebugDisplay_mc: MovieClip;
	var InfoRect_mc: MovieClip;
	var LockAngleText: TextField;
	var PickAngleText: TextField;
	var PickIndicator_mc: MovieClip;
	var SkillMeter: Meter;
	var SweetSpotHolder_mc: MovieClip;
	var fPickMaxAngle: Number;
	var fPickMinAngle: Number;
	var iDebugRectBaseWidth: Number;

	function LockpickingMenu()
	{
		super();
		PickAngleText = DebugDisplay_mc.PickAngleText;
		LockAngleText = DebugDisplay_mc.LockAngleText;
		PickIndicator_mc = DebugDisplay_mc.PickIndicator_mc;
		SweetSpotHolder_mc = DebugDisplay_mc.SweetSpotRects_mc;
		iDebugRectBaseWidth = 1000;
		ButtonRect_mc = BottomBar_mc.ButtonRect_mc;
		InfoRect_mc = BottomBar_mc.InfoRect_mc;
		SkillMeter = new Meter(BottomBar_mc.InfoRect_mc.LevelMeterInstance.Meter_mc);
		fPickMinAngle = 0;
		fPickMaxAngle = 0;
	}

	function InitExtensions(): Void
	{
		GlobalFunc.SetLockFunction();
		BottomBar_mc.Lock("B");
		InfoRect_mc.Lock("R");
		ButtonRect_mc.Lock("L");
		GameDelegate.addCallBack("UpdatePickAngle", this, "UpdatePickAngle");
		GameDelegate.addCallBack("UpdateLockAngle", this, "UpdateLockAngle");
		GameDelegate.addCallBack("UpdateSweetSpot", this, "UpdateSweetSpot");
		GameDelegate.addCallBack("UpdatePickHealth", this, "UpdatePickHealth");
		GameDelegate.addCallBack("SetLockInfo", this, "SetLockInfo");
		GameDelegate.addCallBack("SetPickMinMax", this, "SetPickMinMax");
		GameDelegate.addCallBack("ToggleDebugMode", this, "ToggleDebugMode");
		DebugDisplay_mc._visible = false;
		BottomBar_mc._visible = false;
		InfoRect_mc.LockLevelText.textAutoSize = "shrink";
		InfoRect_mc.NumLockpicksText.textAutoSize = "shrink";
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		var xOffset: Number = 20;
		ButtonRect_mc.RotatePickButton.SetPlatform(aiPlatform, abPS3Switch);
		ButtonRect_mc.RotateLockButton.SetPlatform(aiPlatform, abPS3Switch);
		ButtonRect_mc.ExitButton.SetPlatform(aiPlatform, abPS3Switch);
		ButtonRect_mc.RotateLockButton._x = ButtonRect_mc.RotatePickButton._x + ButtonRect_mc.RotatePickButton.textField.getLineMetrics(0).width + xOffset + ButtonRect_mc.RotateLockButton.ButtonArt._width;
		ButtonRect_mc.ExitButton._x = ButtonRect_mc.RotateLockButton._x + ButtonRect_mc.RotateLockButton.textField.getLineMetrics(0).width + xOffset + ButtonRect_mc.ExitButton.ButtonArt._width;
	}

	function ToggleDebugMode(): Void
	{
		DebugDisplay_mc._visible = !DebugDisplay_mc._visible;
	}

	function UpdatePickAngle(afAngle): Void
	{
		PickAngleText.SetText("PICK ANGLE: " + Math.floor(afAngle) + "°");
		PickIndicator_mc._x = PickAngleToX(afAngle);
	}

	function PickAngleToX(afAngle: Number): Number
	{
		var __reg2 = (afAngle - fPickMinAngle) / (fPickMaxAngle - fPickMinAngle);
		return SweetSpotHolder_mc._x + iDebugRectBaseWidth * __reg2;
	}

	function UpdateLockAngle(afAngle: Number): Void
	{
		LockAngleText.SetText("LOCK ANGLE: " + Math.floor(afAngle) + "°");
	}

	function UpdatePickHealth(afHealth: Number): Void
	{
		DebugDisplay_mc.PickHealthText.SetText("PICK HEALTH: " + Math.floor(afHealth) + "%");
	}

	function UpdateSweetSpot(afSweetSpotCenter: Number, afSweetSpotLength: Number, afPartialPickLength: Number): Void
	{
		SweetSpotHolder_mc.SweetSpotRect._x = PickAngleToX(afSweetSpotCenter - afSweetSpotLength / 2);
		SweetSpotHolder_mc.SweetSpotRect._width = PickAngleToX(afSweetSpotCenter + afSweetSpotLength / 2) - SweetSpotHolder_mc.SweetSpotRect._x;
		SweetSpotHolder_mc.PartialPickRect._x = PickAngleToX(afSweetSpotCenter - afSweetSpotLength / 2 - afPartialPickLength);
		SweetSpotHolder_mc.PartialPickRect._width = PickAngleToX(afSweetSpotCenter + afSweetSpotLength / 2 + afPartialPickLength) - SweetSpotHolder_mc.PartialPickRect._x;
		DebugDisplay_mc.SweetSpotText.SetText("SWEET SPOT: " + afSweetSpotLength + "°");
		DebugDisplay_mc.PartialPickText.SetText("PARTIAL PICK: " + afPartialPickLength + "°");
	}

	function SetPickMinMax(afPickMinAngle: Number, afPickMaxAngle: Number): Void
	{
		fPickMinAngle = afPickMinAngle;
		fPickMaxAngle = afPickMaxAngle;
	}

	function SetLockInfo(): Void
	{
		InfoRect_mc.SkillLevelCurrent.SetText(arguments[0]);
		InfoRect_mc.SkillLevelNext.SetText(arguments[1]);
		InfoRect_mc.LevelMeterInstance.gotoAndStop("Pause");
		SkillMeter.SetPercent(arguments[2]);
		var lockLevelTextField: TextField = InfoRect_mc.LockLevelText;
		lockLevelTextField.SetText("$Lock Level");
		lockLevelTextField.SetText(lockLevelTextField.text + ": " + arguments[3]);
		var numLockPicksTextField: TextField = InfoRect_mc.NumLockpicksText;
		numLockPicksTextField.SetText("$Lockpicks Left");
		if (arguments[4] < 99) {
			numLockPicksTextField.SetText(numLockPicksTextField.text + ": " + arguments[4]);
		} else {
			numLockPicksTextField.SetText(numLockPicksTextField.text + ": 99+");
		}
		BottomBar_mc._visible = true;
	}

}
