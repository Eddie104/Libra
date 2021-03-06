package org.libra.ui {
	/**
	 * <p>
	 * 常量类
	 * </p>
	 *
	 * @class Constants
	 * @author Eddie
	 * @qq 32968210
	 * @date 09/01/2012
	 * @version 1.0
	 * @see
	 */
	public final class Constants {
		
		//{ region 水平垂直
		
		/** 
         * 水平
         */
        public static const HORIZONTAL:int = 0;
		
        /** 
         * 垂直
         */
        public static const VERTICAL:int = 1;
		
		//} endregion
		
		//{ region 八个方向
		
		public static const UP:int = 0;
		
		public static const RIGHT_UP:int = 1;
		
		public static const RIGHT:int = 2;
		
		public static const RIGHT_DOWN:int = 3;
		
		public static const DOWN:int = 4;
		
		public static const LEFT_DOWN:int = 5;
		
		public static const LEFT:int = 6;
		
		public static const LEFT_UP:int = 7;
		
		//} endregion
		
		public static const CENTER:int = 8;
		
		//{ region 上中下
		
		public static const TOP:int = 0;
		
		public static const MIDDLE:int = 1;
		
		public static const BOTTOM:int = 2;
		
		//} endregion
		
		public function Constants() {
			throw new Error('Constants类不允许被实例化');
		}
		
		/*-----------------------------------------------------------------------------------------
		Public methods
		-------------------------------------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------------------------
		Private methods
		-------------------------------------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------------------------
		Event Handlers
		-------------------------------------------------------------------------------------------*/
		
	}

}