dynamic class TextEntryField extends MovieClip
{
	var AcceptButton;
	var AcceptInstance;
	var CancelButton;
	var CancelInstance;
	var TextField_txt;
	var TextInputInstance;
	var dispatchEvent;

	function TextEntryField()
	{
		super();
		this.TextField_txt = this.TextInputInstance;
		this.AcceptButton = this.AcceptInstance;
		this.CancelButton = this.CancelInstance;
		gfx.events.EventDispatcher.initialize(this);
	}

	function SetupButtons()
	{
		this.AcceptButton.addEventListener("click", this, "onAccept");
		this.CancelButton.addEventListener("click", this, "onCancel");
	}

	function SetPlatform(aiPlatform, abPS3Switch)
	{
		this.AcceptButton.SetPlatform(aiPlatform, abPS3Switch);
		this.CancelButton.SetPlatform(aiPlatform, abPS3Switch);
	}

	function GetValidName()
	{
		return this.TextField_txt.text.length > 0;
	}

	function onAccept()
	{
		if (this.GetValidName()) 
		{
			this.dispatchEvent({type: "nameChange", nameChanged: true});
		}
	}

	function onCancel()
	{
		this.dispatchEvent({type: "nameChange", nameChanged: false});
	}

}
