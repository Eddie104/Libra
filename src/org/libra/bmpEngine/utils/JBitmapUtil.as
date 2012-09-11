package org.libra.bmpEngine.utils {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.libra.bmpEngine.BitmapFrame;
	import org.libra.bmpEngine.JBitmap;
	import org.libra.utils.BitmapDataUtil;
	import org.libra.utils.HashMap;
	/**
	 * <p>
	 * Description
	 * </p>
	 *
	 * @class JBitmapUtil
	 * @author Eddie
	 * @qq 32968210
	 * @date 09/09/2012
	 * @version 1.0
	 * @see
	 */
	public final class JBitmapUtil {
		
		private static var instance:JBitmapUtil;
		
		private var bitmapFramePool:HashMap;
		
		public function JBitmapUtil(singleton:Singleton) {
			bitmapFramePool = new HashMap();
		}
		
		/*-----------------------------------------------------------------------------------------
		Public methods
		-------------------------------------------------------------------------------------------*/
		
		public function getBitmapFrameList(key:*):Vector.<BitmapFrame> {
			return this.bitmapFramePool.get(key);
		}
		
		public function putBitmapFrameList(key:*, bitmapFrameList:Vector.<BitmapFrame>):void {
			this.bitmapFramePool.put(key, bitmapFrameList);
		}
		
		/**
		 * 从序列图创建
		 * @param	width 一帧图片的宽度
		 * @param	source 图片源
		 * @param	autoPlay 是否自动播放
		 * @return JBitmap
		 */
		public static function createFromBitmap(width:int, source:BitmapData, frameRate:int = 10, autoPlay:Boolean = true):JBitmap { 
			var bitmap:JBitmap = new JBitmap(frameRate);
			var frameList:Vector.<BitmapFrame> = JBitmapUtil.getInstance().getBitmapFrameList(source);
			if (!frameList) {
				frameList = new Vector.<BitmapFrame>();
				var bmdList:Vector.<BitmapData> = BitmapDataUtil.separateBitmapData(width, 130, source)[0];
				for (var i:* in bmdList) {
					frameList[i] = new BitmapFrame(i, bmdList[i]);
				}
				JBitmapUtil.getInstance().putBitmapFrameList(source, frameList);
				trace('createFromBitmap');
			}
			bitmap.setFrameList(frameList);
			if (autoPlay) bitmap.play();
			return bitmap;
		}
		
		/**
		 * 从影片剪辑创建
		 * @param	mc 原始影片,不能为null
		 * @param   autoPlay 是否创建后就处于播放状态
		 */
		public static function createFromMC(mc:MovieClip, frameRate:int = 10, autoPlay:Boolean = true):JBitmap { 
			var bitmap:JBitmap = new JBitmap(frameRate);
			bitmap.name = mc.name;
			var frameList:Vector.<BitmapFrame> = JBitmapUtil.getInstance().getBitmapFrameList(mc);
			if (!frameList) {
				frameList = new Vector.<BitmapFrame>();
				var i:int = 0;
				var rect:Rectangle;
				var bmd:BitmapData;
				var frame:BitmapFrame;
				var lb:String;
				var matrix:Matrix = new Matrix();
				var l:int = mc.totalFrames;
				while (i++ < l) { 
					mc.gotoAndStop(i);
					rect = mc.getBounds(mc);
					bmd = null;
					if (int(rect.width) > 0 && int(rect.height) > 0) { 
						bmd = new BitmapData(rect.width, rect.height, true, 0);
						matrix.tx = -rect.x; matrix.ty = -rect.y;
						bmd.draw(mc, matrix, null, null, null, true);
					}
					//标签
					lb = mc.currentFrameLabel;
					if (frame && frame.getBmd() && bmd) { 
						//和上一帧的位图比较，如果相同就用同一个位图
						if (!frame.getBmd().compare(bmd)) { 
							bmd.dispose();
							bmd = frame.getBmd();
						}
					}
					frame = new BitmapFrame(i, bmd, rect.x, rect.y, lb);
					frameList[i - 1] = frame;
				}
				JBitmapUtil.getInstance().putBitmapFrameList(mc, frameList);
			}
			bitmap.setFrameList(frameList);
			if (autoPlay) bitmap.play();
			return bitmap;
		}
		
		public static function getInstance():JBitmapUtil {
			return instance ||= new JBitmapUtil(new Singleton());
		}
		
		/*-----------------------------------------------------------------------------------------
		Private methods
		-------------------------------------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------------------------
		Event Handlers
		-------------------------------------------------------------------------------------------*/
		
	}

}
class Singleton{}