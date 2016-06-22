package org.libra.utils.displayObject {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	

	/**
	 * <p>
	 * Description
	 * </p>
	 *
	 * @class Graphics
	 * @author Eddie
	 * @qq 32968210
	 * @date 08-31-2012
	 * @version 1.0
	 * @see
	 */
	public final class GraphicsUtil {
		
		public function GraphicsUtil() {
			throw new Error('Graphics工具类不能实例化');
		}
		
		/*-----------------------------------------------------------------------------------------
		Public methods
		-------------------------------------------------------------------------------------------*/
		
		/**
		 * 绘制矩形
		 * @param	g
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	color
		 * @param	alpha
		 * @param	clear
		 */
		public static function drawRect(g:Graphics, x:int, y:int, w:int, h:int, color:int = 0xff0000, alpha:Number = 1.0, clear:Boolean = true):void { 
			if(clear)
				g.clear();
			g.beginFill(color, alpha);
			g.drawRect(x, y, w, h);
			g.endFill();
		}
		
		static public function drawRectWithBmd(g:Graphics, x:int, y:int, w:int, h:int, bmd:BitmapData, clear:Boolean = true):void {
			if (clear) g.clear();
			g.beginBitmapFill(bmd);
			g.drawRect(x, y, w, h);
			g.endFill();
		}
		
		/**
		 * 填充一个菱形
		 * 其实就是从自上而下地画水平线
		 */
		public static function fillDiamond(g:Graphics, width:int, color:int = 0xff0000, alpha:Number = 1.0, clear:Boolean = true):void{
			if(clear) g.clear();
			g.lineStyle(1, color, alpha);
			
			var startX:int = (width >> 1) - 2;
			var startY:int = 1;
			var endX:int = (width >> 1) + 2;
			var endY:int = 1;
			var targetY:int = (width >> 2) - 1;
			while(endY <= targetY){
				g.moveTo(startX, startY++);
				g.lineTo(endX, endY++);
				startX -= 2;
				endX += 2;
			}
			targetY = (width >> 1) - 1;
			while(endY <= targetY){
				g.moveTo(startX, startY++);
				g.lineTo(endX, endY++);
				startX += 2;
				endX -= 2;
			}
		}
		
		/**
		 * 绘制菱形网格
		 * @param	g
		 * @param	topPoint 菱形最上方的点的坐标，这个点控制着整个菱形绘制的坐标
		 * @param	size 多少行多少列。
		 * @param	tileWidth 小菱形的宽度
		 * @param	color
		 */
		public static function drawDiamondNet(g:Graphics, topPoint:Point, row:int = 0, col:int = 0,  rows:int = 10, cols:int = 10, tileWidth:int = 32, color:int = 0xff0000, clear:Boolean = true, X:Boolean = false):void { 
			const tileHeight:int = tileWidth >> 1;
			const p:Point = new Point();
			const tmpTopPoint:Point = Display45Util.getItemPos(row, col);
			var endX:Number = cols * tileWidth / 2;
			var endY:Number = endX / 2;
			if(clear) g.clear();
			g.lineStyle(1, color);
			var XStartX:int, XStartY:int, XEndX:int, XEndY:int;
			for (var i:int = 0; i < rows + 1; i++ ) {
				p.x = topPoint.x - tileWidth / 2 * i + tmpTopPoint.x;
				p.y = topPoint.y + tileHeight / 2 * i + tmpTopPoint.y;
				g.moveTo(p.x, p.y);
				g.lineTo(endX + p.x, endY + p.y);
				if(i == 0){
					XStartX = p.x;
					XStartY = p.y;
				}else if(i == rows){
					XEndX = endX + p.x;
					XEndY = endY + p.y;
				}
			}
			if(X){
				g.moveTo(XStartX, XStartY);
				g.lineTo(XEndX, XEndY);	
			}
			
			endX = rows * tileWidth / 2;
			endY = endX / 2;
			for (i = 0; i < cols + 1; i += 1) {
				p.x = topPoint.x + tileWidth / 2 * i + tmpTopPoint.x;
				p.y = topPoint.y + tileHeight / 2 * i + tmpTopPoint.y;
				g.moveTo(p.x, p.y);
				g.lineTo(p.x - endX, p.y + endY);
				if(i == 0){
					XStartX = p.x - endX;
					XStartY = p.y + endY;
				}else if(i == cols){
					XEndX = p.x;
					XEndY = p.y;
				}
			}
			if(X){
				g.moveTo(XStartX, XStartY);
				g.lineTo(XEndX, XEndY);	
			}
		}
		
		/**
		 * 绘制墙面上的菱形格子
		 */
		public static function drawWallDiamondNet(g:Graphics, topPoint:Point, row:int, col:int, rows:int, cols:int, tileWidth:int, color:Number, clear:Boolean, symmetric:Boolean = true, X:Boolean = false):void
		{
			//地板的高度，也就是墙面菱形格子垂直和斜着的线条长度
			var tileHeight:int = tileWidth >> 1;
			var origionPoint:Point = new Point(topPoint.x, topPoint.y - tileHeight * rows);
			
			const tmpTopPoint:Point = Display45Util.getItemPosOnWall(row, col);
				
			if(clear) g.clear();
			g.lineStyle(1, color);
			//先绘制垂直的线
			var p:Point = new Point();
			var XStartX:int, XStartY:int, XEndX:int, XEndY:int;
			for(var i:int = 0; i <= cols;i++){
				//横坐标应该是列数个地板格子宽度的一半，也就是列数个地板高度
				p.x = origionPoint.x + i * tileHeight + tmpTopPoint.x;
				p.y = origionPoint.y + i * (tileHeight >> 1) + tmpTopPoint.y;
				g.moveTo(p.x, p.y);
				g.lineTo(p.x, p.y + tileHeight * rows);
				
				if(symmetric){
					p.x = origionPoint.x - i * tileHeight + tmpTopPoint.x;
					g.moveTo(p.x, p.y);
					g.lineTo(p.x, p.y + tileHeight * rows);	
				}
				if(i == 0){
					XStartX = p.x;
					XStartY = p.y;
				}else if(i == cols){
					XEndX = p.x;
					XEndY = p.y + tileHeight * rows;
				}
			}
			if(X){
				g.moveTo(XStartX, XStartY);
				g.lineTo(XEndX, XEndY);	
			}
			//再绘制斜线
			for(i = 0;i <= rows;i++){
				p.x = origionPoint.x + tmpTopPoint.x;
				p.y = origionPoint.y + tileHeight * i + tmpTopPoint.y;
				g.moveTo(p.x, p.y);
				g.lineTo(p.x + tileHeight * cols, p.y + (tileHeight >> 1) * cols);
				
				if(symmetric){
					g.moveTo(p.x, p.y);
					g.lineTo(p.x - tileHeight * cols, p.y + (tileHeight >> 1) * cols);	
				}
				
				if(i == 0){
					XStartX = p.x + tileHeight * cols;
					XStartY = p.y + (tileHeight >> 1) * cols;
				}else if(i == rows){
					XEndX = p.x;
					XEndY = p.y;
				}
			}
			if(X){
				g.moveTo(XStartX, XStartY);
				g.lineTo(XEndX, XEndY);	
			}
		}
		
		public static function lineRect(g:Graphics, x:int, y:int, width:int, height:int, color:int = 0xff0000, clear:Boolean = true):void {
			if(clear)
				g.clear();
			g.lineStyle(1, color);
			g.moveTo(x, y);
			g.lineTo(width + x, y);
			g.lineTo(width + x, height + y);
			g.lineTo(x, height + y);
			g.lineTo(x, y);
		}
		
		/**
		 * 绘制菱形
		 * @param	g
		 * @param	pointList
		 * @param	thickness
		 * @param	color
		 * @param	alpha
		 */
		/*public static function drawDiamond(g:Graphics, pointList:Vector.<Point>, thickness:Number = null, color:uint = 0, alpha:Number = 1):void { 
			//var _loc_2:* = this.buildingBaseVO.gridType * Constants.CELL_WIDTH;
            //var _loc_3:* = this.buildingBaseVO.gridType * Constants.CELL_HEIGHT;
            //var _loc_4:* = new Vector.<Point>(4, true);
            //new Vector.<Point>(4, true)[0] = new Point(_loc_2 >> 1, 0);
            //_loc_4[1] = new Point(0, _loc_3 >> 1);
            //_loc_4[2] = new Point(_loc_2 >> 1, _loc_3);
            //_loc_4[3] = new Point(_loc_2, _loc_3 >> 1);
			g.clear();
			g.lineStyle(thickness, color, alpha);
			g.moveTo(pointList[0].x, pointList[0].y);
			var l:int = pointList.length;
			for (var i:int = 1; i < l; i += 1) {
				g.lineTo(pointList[i].x, pointList[i].y);
			}
			g.lineTo(pointList[0].x, pointList[0].y);
        }*/
		
		/**
		 * 使用绘制圆角的半径大小来绘制圆角矩形。
		 * 必须在调用 drawRoundRectComplex() 方法之前通过调用 linestyle()、
		 * lineGradientStyle()、beginFill()、beginGradientFill() 
		 * 或 beginBitmapFill() 来设置 Graphics 对象上的线条样式、填充，或同时设置二者。
		 */		
		public static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, 
													width:Number, height:Number, 
													topLeftRadius:Number, topRightRadius:Number, 
													bottomLeftRadius:Number, bottomRightRadius:Number):void {
			var xw:Number = x + width;
			var yh:Number = y + height;
			var minSize:Number = width < height ? width * 2 : height * 2;
			topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
			topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
			bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
			bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;
			var a:Number = bottomRightRadius * 0.292893218813453;		
			var s:Number = bottomRightRadius * 0.585786437626905; 	
			graphics.moveTo(xw, yh - bottomRightRadius);
			graphics.curveTo(xw, yh - s, xw - a, yh - a);
			graphics.curveTo(xw - s, yh, xw - bottomRightRadius, yh);
			a = bottomLeftRadius * 0.292893218813453;
			s = bottomLeftRadius * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadius, yh);
			graphics.curveTo(x + s, yh, x + a, yh - a);
			graphics.curveTo(x, yh - s, x, yh - bottomLeftRadius);
			a = topLeftRadius * 0.292893218813453;
			s = topLeftRadius * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadius);
			graphics.curveTo(x, y + s, x + a, y + a);
			graphics.curveTo(x + s, y, x + topLeftRadius, y);
			a = topRightRadius * 0.292893218813453;
			s = topRightRadius * 0.585786437626905;
			graphics.lineTo(xw - topRightRadius, y);
			graphics.curveTo(xw - s, y, xw - a, y + a);
			graphics.curveTo(xw, y + s, xw, y + topRightRadius);
			graphics.lineTo(xw, yh - bottomRightRadius);
		}
		
		/**
		 * 通过使用单独的 x 和 y 半径的大小绘制圆角，来绘制圆角矩形。
		 * 必须在调用 drawRoundRectComplex2() 方法之前通过调用 linestyle()、
		 * lineGradientStyle()、beginFill()、beginGradientFill() 
		 * 或 beginBitmapFill() 方法来设置 Graphics 对象上的线条样式、填充，或同时设置二者。
		 */		
		public static function drawRoundRectComplex2(graphics:Graphics, x:Number, y:Number, 
													 width:Number, height:Number, 
													 radiusX:Number, radiusY:Number,
													 topLeftRadiusX:Number, topLeftRadiusY:Number,
													 topRightRadiusX:Number, topRightRadiusY:Number,
													 bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
													 bottomRightRadiusX:Number, bottomRightRadiusY:Number):void {
			var xw:Number = x + width;
			var yh:Number = y + height;
			var maxXRadius:Number = width / 2;
			var maxYRadius:Number = height / 2;
			if (radiusY == 0)
				radiusY = radiusX;
			if (isNaN(topLeftRadiusX))
				topLeftRadiusX = radiusX;
			if (isNaN(topLeftRadiusY))
				topLeftRadiusY = topLeftRadiusX;
			if (isNaN(topRightRadiusX))
				topRightRadiusX = radiusX;
			if (isNaN(topRightRadiusY))
				topRightRadiusY = topRightRadiusX;
			if (isNaN(bottomLeftRadiusX))
				bottomLeftRadiusX = radiusX;
			if (isNaN(bottomLeftRadiusY))
				bottomLeftRadiusY = bottomLeftRadiusX;
			if (isNaN(bottomRightRadiusX))
				bottomRightRadiusX = radiusX;
			if (isNaN(bottomRightRadiusY))
				bottomRightRadiusY = bottomRightRadiusX;
			if (topLeftRadiusX > maxXRadius)
				topLeftRadiusX = maxXRadius;
			if (topLeftRadiusY > maxYRadius)
				topLeftRadiusY = maxYRadius;
			if (topRightRadiusX > maxXRadius)
				topRightRadiusX = maxXRadius;
			if (topRightRadiusY > maxYRadius)
				topRightRadiusY = maxYRadius;
			if (bottomLeftRadiusX > maxXRadius)
				bottomLeftRadiusX = maxXRadius;
			if (bottomLeftRadiusY > maxYRadius)
				bottomLeftRadiusY = maxYRadius;
			if (bottomRightRadiusX > maxXRadius)
				bottomRightRadiusX = maxXRadius;
			if (bottomRightRadiusY > maxYRadius)
				bottomRightRadiusY = maxYRadius;
			var aX:Number = bottomRightRadiusX * 0.292893218813453;		
			var aY:Number = bottomRightRadiusY * 0.292893218813453;		
			var sX:Number = bottomRightRadiusX * 0.585786437626905; 	
			var sY:Number = bottomRightRadiusY * 0.585786437626905; 	
			graphics.moveTo(xw, yh - bottomRightRadiusY);
			graphics.curveTo(xw, yh - sY, xw - aX, yh - aY);
			graphics.curveTo(xw - sX, yh, xw - bottomRightRadiusX, yh);
			aX = bottomLeftRadiusX * 0.292893218813453;
			aY = bottomLeftRadiusY * 0.292893218813453;
			sX = bottomLeftRadiusX * 0.585786437626905;
			sY = bottomLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadiusX, yh);
			graphics.curveTo(x + sX, yh, x + aX, yh - aY);
			graphics.curveTo(x, yh - sY, x, yh - bottomLeftRadiusY);
			aX = topLeftRadiusX * 0.292893218813453;
			aY = topLeftRadiusY * 0.292893218813453;
			sX = topLeftRadiusX * 0.585786437626905;
			sY = topLeftRadiusY * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadiusY);
			graphics.curveTo(x, y + sY, x + aX, y + aY);
			graphics.curveTo(x + sX, y, x + topLeftRadiusX, y);
			aX = topRightRadiusX * 0.292893218813453;
			aY = topRightRadiusY * 0.292893218813453;
			sX = topRightRadiusX * 0.585786437626905;
			sY = topRightRadiusY * 0.585786437626905;
			graphics.lineTo(xw - topRightRadiusX, y);
			graphics.curveTo(xw - sX, y, xw - aX, y + aY);
			graphics.curveTo(xw, y + sY, xw, y + topRightRadiusY);
			graphics.lineTo(xw, yh - bottomRightRadiusY);
		}
		
		/*-----------------------------------------------------------------------------------------
		Private methods
		-------------------------------------------------------------------------------------------*/
		
		/*-----------------------------------------------------------------------------------------
		Event Handlers
		-------------------------------------------------------------------------------------------*/
	}

}