//****************************************************************************
// ActionScript Standard Library
// Mouse object
//****************************************************************************

// See: 
//   Scaleform AS2 Extensions Reference.pdf
//   http://gameware.autodesk.com/documents/gfx_4.0_as2_extensions.pdf

intrinsic class Mouse
{
	static function addListener(listener:Object):Void;
	static function hide():Number;
	static function removeListener(listener:Object):Boolean;
	static function show():Number;
	
	// scaleform extensions
	// static function getTopMostEntity(obj1:Object,obj2:Number,obj3:Boolean):Object;
	static function getTopMostEntity():Object;

	/**
	 * This method returns coordinates of the corresponding mouse cursor, in _root
	 * coordinate space. The returned value is an instance of flash.geom.Point.
	 *
	 * Scaleform version: 2.2
	 */
	static function getPosition(mouseIndex:Number):flash.geom.Point;
}
