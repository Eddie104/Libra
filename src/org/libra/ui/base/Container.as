package org.libra.ui.base {
	import flash.display.DisplayObject;
	import org.libra.ui.interfaces.IDragable;
	import org.libra.ui.interfaces.IDropable;
	import org.libra.ui.utils.GraphicsUtil;
	
	/**
	 * <p>
	 * 容器
	 * </p>
	 *
	 * @class Container
	 * @author Eddie
	 * @qq 32968210
	 * @date 08-31-2012
	 * @version 1.0
	 * @see
	 */
	public class Container extends Component implements IDropable {
		
		protected var componentList:Vector.<Component>;
		
		protected var numComponent:int;
		
		private var dropAcceptableList:Vector.<IDragable>;
		
		public function Container(x:int = 0, y:int = 0) { 
			super(x, y);
			componentList = new Vector.<Component>();
			numComponent = 0;
		}
		
		/*-----------------------------------------------------------------------------------------
		Public methods
		-------------------------------------------------------------------------------------------*/
		
		public function hasComponent(child:Component):Boolean {
			return this.componentList.indexOf(child) != -1;
		}
		
		public function append(child:Component):Component {
			if (this.componentList.indexOf(child) == -1) {
				this.componentList[numComponent++] = child;
				this.addChild(child);
				return child;
			}
			return null;
		}
		
		public function appendAll(...rest):void {
			for (var i:* in rest) {
				this.append(rest[i]);
			}
		}
		
		public function remove(child:Component, dispose:Boolean = false):Component {
			var index:int = this.componentList.indexOf(child);
			if (index == -1) return null;
			this.componentList.splice(index, 1);
			numComponent--;
			this.removeChild(child);
			if(dispose)
				child.dispose();
			return child;
		}
		
		public function removeAll(dispose:Boolean, ...rest):void { 
			for (var i:* in rest) {
				this.remove(rest[i], dispose);
			}
		}
		
		public function clear(dispose:Boolean = false):void {
			for (var i:* in this.componentList) {
				if (dispose) componentList[i].dispose();
				this.removeChild(componentList[i]);
			}
			componentList.length = 0;
			this.numComponent = 0;
		}
		
		public function getNumComponent():int {
			return this.numComponent;
		}
		
		/**
		 * 将显示对象置于顶层显示
		 * @param	child 显示对象
		 */
		public function bringToTop(child:DisplayObject):void {
			if (this.contains(child)) {
				setChildIndex(child, this.numChildren - 1);	
			}
		}
		
		/**
		 * 将显示对象置于底层显示，如果设置了背景，
		 * 那么将显示对象置于背景的上一层，背景层永远在最底层
		 * @param	child 显示对象
		 */
		public function bringToBottom(child:DisplayObject):void {
			if (this.contains(child)) {
				var index:int = 0;
				if(background){
					if(background != child){
						index = 1;
					}
				}
				setChildIndex(child, index);
			}
		}
		
		override public function setSize(w:int, h:int):void {
			super.setSize(w, h);
			GraphicsUtil.drawRect(this.graphics, 0, 0, w, h, 0xff0000, .0);
		}
		
		override public function dispose():void {
			super.dispose();
			for (var i:* in this.componentList) {
				this.componentList[i].dispose();
			}
			this.componentList = null;
			numComponent = 0;
		}
		
		override public function toString():String {
			return 'container';
		}
		
		/* INTERFACE org.libra.ui.interfaces.IDropable */
		
		public function addDropAcceptable(dragable:IDragable):void {
			if (!dropAcceptableList) dropAcceptableList = new Vector.<IDragable>();
			if(this.dropAcceptableList.indexOf(dragable) == -1)
				dropAcceptableList.push(dragable);
		}
		
		public function removeDropAcceptable(dragable:IDragable):void {
			if (this.dropAcceptableList) {
				var index:int = this.dropAcceptableList.indexOf(dragable);
				if (index != -1) this.dropAcceptableList.splice(index, 1);
			}
		}
		
		public function isDropAcceptable(dragable:IDragable):Boolean {
			return this.dropAcceptableList ? this.dropAcceptableList.indexOf(dragable) != -1 : false;
		}
		
		public function addDragable(dragable:IDragable):void {
			dragable.removeFromParent();
			this.append(dragable as Component);
		}
		
		/*-----------------------------------------------------------------------------------------
		Private methods
		-------------------------------------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------------------------
		Event Handlers
		-------------------------------------------------------------------------------------------*/
		
	}

}