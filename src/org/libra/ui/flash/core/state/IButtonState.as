package org.libra.ui.flash.core.state {
	import flash.display.DisplayObject;
	
	/**
	 * <p>
	 * Description
	 * </p>
	 *
	 * @class IState
	 * @author Eddie
	 * @qq 32968210
	 * @date 08-31-2012
	 * @version 1.0
	 * @see
	 */
	public interface IButtonState {
		
		function setSize(w:int, h:int):void;
		
		function set skin(val:String):void;
		
		function get displayObject():DisplayObject;
		
		function toNormal():void;
		
		function toMouseOver():void;
		
		//function toMouseOut():void;
		
		function toMouseDown():void;
		
		//function toMouseUp():void;
		
		function dispose():void;
	}
	
}