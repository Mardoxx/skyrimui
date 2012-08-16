import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

class CreditsMenu extends MovieClip
{
	static var EndY: Number = -100;
	static var TextYRate: Number = 1;
	
	var CreditsText_tf: TextField;
	var iUpTimerID: Number;
	var textField: TextField;

	function CreditsMenu()
	{
		super();
		CreditsText_tf = textField;
		CreditsText_tf.verticalAutoSize = "top";
		Mouse.addListener(this);
		FocusHandler.instance.setFocus(this, 0);
	}

	function onCodeObjectInit(): Void
	{
		CreditsText_tf.SetText(" ", true);
		_root.CodeObj.requestCredits(CreditsText_tf);
		CreditsMenu.TextYRate = _root.CodeObj.getScrollSpeed();
	}

	function onEnterFrame(): Void
	{
		if (iUpTimerID == undefined) {
			CreditsText_tf._y = CreditsText_tf._y - CreditsMenu.TextYRate;
		}
		if (CreditsText_tf._y + CreditsText_tf._height <= CreditsMenu.EndY) {
			_root.CodeObj.closeMenu();
		}
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (Shared.GlobalFunc.IsKeyPressed(details)) {
			switch (details.navEquivalent) {
				case NavigationCode.TAB:
				case NavigationCode.ESCAPE:
					_root.CodeObj.closeMenu();
					break;
				case NavigationCode.UP:
					moveCredits(40);
					break;
				case NavigationCode.DOWN:
					moveCredits(-40);
					break;
				case NavigationCode.PAGE_UP:
					moveCredits(80);
					break;
				case NavigationCode.PAGE_DOWN:
					moveCredits(-80);
					break;
			}
		}
		return true;
	}

	function onMouseDown(): Void
	{
		_root.CodeObj.closeMenu();
	}

	function onMouseWheel(delta: Number): Void
	{
		moveCredits(20 * delta);
	}

	function moveCredits(aiDelta: Number): Void
	{
		if (aiDelta < 0) {
			CreditsText_tf._y = CreditsText_tf._y + aiDelta;
			return;
		}
		if (aiDelta > 0 && CreditsText_tf._y < 140) {
			CreditsText_tf._y = CreditsText_tf._y + aiDelta;
			if (iUpTimerID != undefined) {
				clearInterval(iUpTimerID);
			}
			iUpTimerID = setInterval(this, "ClearUpTimer", 1000);
		}
	}

	function ClearUpTimer(): Void
	{
		clearInterval(iUpTimerID);
		iUpTimerID = undefined;
	}

}
