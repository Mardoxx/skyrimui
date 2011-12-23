dynamic class LevelUpMenu extends MovieClip
{
	var HealthButton;
	var MagickaButton;
	var StaminaButton;

	function LevelUpMenu()
	{
		super();
		this.HealthButton = this.HealthButton;
		this.MagickaButton = this.MagickaButton;
		this.StaminaButton = this.StaminaButton;
	}

	function InitExtensions()
	{
		this.HealthButton.addEventListener("press", this, "addHealth");
		this.HealthButton.addEventListener("focusOut", this, "playFocusSound");
		this.HealthButton.addEventListener("rollOver", this, "playFocusSound");
		this.MagickaButton.addEventListener("press", this, "addMagicka");
		this.MagickaButton.addEventListener("focusOut", this, "playFocusSound");
		this.MagickaButton.addEventListener("rollOver", this, "playFocusSound");
		this.StaminaButton.addEventListener("press", this, "addStamina");
		this.StaminaButton.addEventListener("focusOut", this, "playFocusSound");
		this.StaminaButton.addEventListener("rollOver", this, "playFocusSound");
	}

	function addHealth(event)
	{
		gfx.io.GameDelegate.call("addHealth", []);
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
	}

	function addMagicka(event)
	{
		gfx.io.GameDelegate.call("addMagicka", []);
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
	}

	function addStamina(event)
	{
		gfx.io.GameDelegate.call("addStamina", []);
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuOK"]);
	}

	function playFocusSound(event)
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
	}

}
