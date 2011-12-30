class MouseRotationInputCatcher extends MovieClip
{
	static var PROCESS_ROTATION_DELAY: Number = 150;
	var iProcessRotationDelayTimerID: Number;

	function MouseRotationInputCatcher()
	{
		super();
	}

	function onMouseDown(): Void
	{
		var topMostEntity: Boolean = Mouse.getTopMostEntity() == this;
		if (topMostEntity || this._parent.bFadedIn == false) 
		{
			this._parent.onMouseRotationStart();
		}
		if (topMostEntity && this.iProcessRotationDelayTimerID == undefined) 
		{
			this.iProcessRotationDelayTimerID = setInterval(this, "onProcessDelayElapsed", MouseRotationInputCatcher.PROCESS_ROTATION_DELAY);
		}
	}

	function onProcessDelayElapsed(): Void
	{
		clearInterval(this.iProcessRotationDelayTimerID);
		this.iProcessRotationDelayTimerID = undefined;
	}

	function onMouseUp(): Void
	{
		this._parent.onMouseRotationStop();
		clearInterval(this.iProcessRotationDelayTimerID);
		if (this.iProcessRotationDelayTimerID != undefined && this._parent.bFadedIn != false) 
		{
			this._parent.onMouseRotationFastClick(0);
		}
		this.iProcessRotationDelayTimerID = undefined;
	}

	function onPressAux(): Void
	{
		this._parent.onMouseRotationFastClick(1);
	}

}
