dynamic class MouseRotationInputCatcher extends MovieClip
{
	static var PROCESS_ROTATION_DELAY: Number = 150;
	var _parent;
	var iProcessRotationDelayTimerID;

	function MouseRotationInputCatcher()
	{
		super();
	}

	function onMouseDown()
	{
		var __reg2 = Mouse.getTopMostEntity() == this;
		if (__reg2 || this._parent.bFadedIn == false) 
		{
			this._parent.onMouseRotationStart();
		}
		if (__reg2 && this.iProcessRotationDelayTimerID == undefined) 
		{
			this.iProcessRotationDelayTimerID = setInterval(this, "onProcessDelayElapsed", MouseRotationInputCatcher.PROCESS_ROTATION_DELAY);
		}
	}

	function onProcessDelayElapsed()
	{
		clearInterval(this.iProcessRotationDelayTimerID);
		this.iProcessRotationDelayTimerID = undefined;
	}

	function onMouseUp()
	{
		this._parent.onMouseRotationStop();
		clearInterval(this.iProcessRotationDelayTimerID);
		if (this.iProcessRotationDelayTimerID != undefined && this._parent.bFadedIn != false) 
		{
			this._parent.onMouseRotationFastClick(0);
		}
		this.iProcessRotationDelayTimerID = undefined;
	}

	function onPressAux()
	{
		this._parent.onMouseRotationFastClick(1);
	}

}
