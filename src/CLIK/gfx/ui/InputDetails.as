class gfx.ui.InputDetails
{
	var code;
	var controllerIdx: Number;
	var navEquivalent;
	var type;
	var value;

	function InputDetails(type, code, value, navEquivalent, controllerIdx)
	{
		type = type;
		code = code;
		value = value;
		navEquivalent = navEquivalent;
		controllerIdx = controllerIdx;
	}

	function toString()
	{
		return ["[InputDelegate", "code=" + code, "type=" + type, "value=" + value, "navEquivalent=" + navEquivalent, "controllerIdx=" + controllerIdx + "]"].toString();
	}

}
