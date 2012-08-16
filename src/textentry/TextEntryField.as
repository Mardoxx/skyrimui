import gfx.events.EventDispatcher;
import Components.CrossPlatformButtons;

class TextEntryField extends MovieClip
{
	var AcceptButton: CrossPlatformButtons;
	var AcceptInstance: CrossPlatformButtons;
	var CancelButton: CrossPlatformButtons;
	var CancelInstance: CrossPlatformButtons;
	var TextField_txt: TextField;
	var TextInputInstance: TextField;
	var dispatchEvent: Function;

	function TextEntryField()
	{
		super();
		TextField_txt = TextInputInstance;
		AcceptButton = AcceptInstance;
		CancelButton = CancelInstance;
		EventDispatcher.initialize(this);
	}

	function SetupButtons(): Void
	{
		AcceptButton.addEventListener("click", this, "onAccept");
		CancelButton.addEventListener("click", this, "onCancel");
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void
	{
		AcceptButton.SetPlatform(aiPlatform, abPS3Switch);
		CancelButton.SetPlatform(aiPlatform, abPS3Switch);
	}

	function GetValidName(): Boolean
	{
		return TextField_txt.text.length > 0;
	}

	function onAccept(): Void
	{
		if (GetValidName()) {
			dispatchEvent({type: "nameChange", nameChanged: true});
		}
	}

	function onCancel(): Void
	{
		dispatchEvent({type: "nameChange", nameChanged: false});
	}

}
