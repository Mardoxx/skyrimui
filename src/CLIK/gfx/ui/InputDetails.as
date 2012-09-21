class gfx.ui.InputDetails
{
	public var code: Number;
	public var controllerIdx: Number;
	public var navEquivalent: String;
	public var type: String;
	public var value; //Can be any type

	public function InputDetails(a_type: String, a_code: Number, a_value, a_navEquivalent: String, a_controllerIdx: Number)
	{
		type = a_type;
		code = a_code;
		value = a_value;
		navEquivalent = a_navEquivalent;
		controllerIdx = a_controllerIdx;
	}

	public function toString()
	{
		return ["[InputDelegate", "code=" + code, "type=" + type, "value=" + value, "navEquivalent=" + navEquivalent, "controllerIdx=" + controllerIdx + "]"].toString();
	}

}
