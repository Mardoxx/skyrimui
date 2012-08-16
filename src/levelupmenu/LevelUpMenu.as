import gfx.controls.Button;
import gfx.io.GameDelegate;

dynamic class LevelUpMenu extends MovieClip
{
	var HealthButton: Button;
	var MagickaButton: Button;
	var StaminaButton: Button;

	function LevelUpMenu()
	{
		super();
		HealthButton = HealthButton;
		MagickaButton = MagickaButton;
		StaminaButton = StaminaButton;
	}

	function InitExtensions(): Void
	{
		HealthButton.addEventListener("press", this, "addHealth");
		HealthButton.addEventListener("focusOut", this, "playFocusSound");
		HealthButton.addEventListener("rollOver", this, "playFocusSound");
		MagickaButton.addEventListener("press", this, "addMagicka");
		MagickaButton.addEventListener("focusOut", this, "playFocusSound");
		MagickaButton.addEventListener("rollOver", this, "playFocusSound");
		StaminaButton.addEventListener("press", this, "addStamina");
		StaminaButton.addEventListener("focusOut", this, "playFocusSound");
		StaminaButton.addEventListener("rollOver", this, "playFocusSound");
	}

	function addHealth(event: Object): Void
	{
		GameDelegate.call("addHealth", []);
		GameDelegate.call("PlaySound", ["UIMenuOK"]);
	}

	function addMagicka(event: Object): Void
	{
		GameDelegate.call("addMagicka", []);
		GameDelegate.call("PlaySound", ["UIMenuOK"]);
	}

	function addStamina(event: Object): Void
	{
		GameDelegate.call("addStamina", []);
		GameDelegate.call("PlaySound", ["UIMenuOK"]);
	}

	function playFocusSound(event: Object): Void
	{
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
	}

}
