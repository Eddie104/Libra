package org.libra.ui.flash.components {
	import org.libra.ui.flash.core.BaseText;
	import org.libra.ui.flash.core.Component;
	import org.libra.ui.flash.managers.UIManager;
	import org.libra.ui.flash.theme.DefaultTextTheme;
	
	/**
	 * <p>
	 * Description
	 * </p>
	 *
	 * @class JLabel
	 * @author Eddie
	 * @qq 32968210
	 * @date 08-31-2012
	 * @version 1.0
	 * @see
	 */
	public class JLabel extends BaseText {
		
		public function JLabel(theme:DefaultTextTheme = null, x:int = 0, y:int = 0, text:String = '') { 
			super(theme ? theme : UIManager.getInstance().theme.labelTheme, x, y, text);
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		/*-----------------------------------------------------------------------------------------
		Public methods
		-------------------------------------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------------------------
		Private methods
		-------------------------------------------------------------------------------------------*/
		
		override protected function initTextField(text:String = ''):void {
			super.initTextField(text);
			this.textAlign = 'left';
			this.text = text;
		}
		
		override public function clone():Component {
			return new JLabel($theme, x, y, $text);
		}
		
		/*-----------------------------------------------------------------------------------------
		Event Handlers
		-------------------------------------------------------------------------------------------*/
		
	}

}