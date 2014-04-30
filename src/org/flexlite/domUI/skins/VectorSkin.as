package org.flexlite.domUI.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.supportClasses.Skin;
	import org.flexlite.domUI.utils.GraphicsUtil;
	
	/**
	 * Vector主题皮肤基类
	 * @author DOM
	 */
	public class VectorSkin extends Skin
	{
		public function VectorSkin()
		{
			super();
			this.states = ["normal","disabled"];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			invalidateDisplayList();
		}
		
		private static var tempMatrix:Matrix = new Matrix();
		
		/**
		 * 创建垂直渐变矩阵。
		 * @param x 渐变的左边缘。
		 * @param y 渐变的上边缘。
		 * @param width 渐变的宽度。
		 * @param height 渐变的高度。
		 */		
		protected function verticalGradientMatrix(x:Number, y:Number,
												  width:Number,
												  height:Number):Matrix
		{
			tempMatrix.createGradientBox(width,height,
				0.5 * Math.PI,x,y);
			return tempMatrix;
		}
		/**
		 * 创建水平渐变矩阵。
		 * @param x 渐变的左边缘。
		 * @param y 渐变的上边缘。
		 * @param width 渐变的宽度。
		 * @param height 渐变的高度。
		 */	
		protected function horizontalGradientMatrix(x:Number, y:Number,
													width:Number,
													height:Number):Matrix
		{
			tempMatrix.createGradientBox(width, height,0, x, y);
			return tempMatrix;
		}
		
		/**
		 * 文本投影滤镜
		 */		
		dx_internal static var textOverFilter:Array = [new DropShadowFilter(1,270,0,0.3,1,1)];
		/**
		 * 边框线条颜色
		 */		
		dx_internal static var borderColors:Array = [0xD4D4D4,0x518CC6,0x686868];
		/**
		 * 底线颜色
		 */		
		dx_internal static var bottomLineColors:Array = [0xBCBCBC,0x2A65A0,0x656565];
		/**
		 * 边框圆角
		 */		
		dx_internal static var cornerRadius:Number = 3;
		/**
		 * 填充颜色 
		 */		
		dx_internal static var fillColors:Array = [0xFAFAFA,0xEAEAEA,0x589ADB,0x3173B4,0x777777,0x9B9B9B];
		/**
		 * 主题颜色，应用到文本或者图标上
		 */		
		dx_internal static var themeColors:Array = [0x333333,0xFFFFFF];
		/**
		 * 绘制当前的视图状态
		 */		
		dx_internal function drawCurrentState(x:Number,y:Number,w:Number,h:Number,borderColor:uint,
											bottomLineColor:uint,fillColors:Object,cornerRadius:Object=null,g:Graphics=null):void
		{
			var crr:Object = cornerRadius;
			var crr1:Object;
			if(cornerRadius==null||cornerRadius is Number)
			{
				crr1 = cornerRadius==null?0:Number(cornerRadius)-1;
				if(crr1<0)
					crr1 = 0;
				crr1 = {tl:crr1,tr:crr1,
					bl:crr1,br:crr1};
			}
			else
			{
				crr1 = {tl:Math.max(0,crr.tl-1),tr:Math.max(0,crr.tr-1),
					bl:Math.max(0,crr.bl-1),br:Math.max(0,crr.br-1)};
			}
			//绘制边框
			drawRoundRect(
				x, y, w, h, cornerRadius,
				borderColor, 1,
				verticalGradientMatrix(x, y, w, h ),
				GradientType.LINEAR, null, 
				{ x: x+1, y: y+1, w: w - 2, h: h - 2, r: crr1},g); 
			//绘制填充
			drawRoundRect(
				x+1, y+1, w - 2, h - 2, crr1,
				fillColors, 1,
				verticalGradientMatrix(x+1, y+1, w - 2, h - 2),GradientType.LINEAR,null,null,g); 
			//绘制底线
			if(w>(crr1.bl+crr1.br+2)&&h>1)
			{
				drawLine(x+crr1.bl,y+h-1,x+w-crr1.br,y+h-1,bottomLineColor,g);
			}
		}
		/**
		 * 绘制一条直线
		 * @param startX 起始点坐标x
		 * @param startY 起始点坐标y
		 * @param endX 结束点坐标x
		 * @param endY 结束点坐标y
		 * @param color 线条颜色
		 * @param g 要绘制到的目标Graphics，留空则绘制到自身。
		 */		
		protected function drawLine(startX:Number,startY:Number,endX:Number,endY:Number,color:uint,g:Graphics=null):void
		{
			if(g==null)
				g = graphics;
			g.lineStyle(1,color);
			g.moveTo(startX,startY);
			g.lineTo(endX,endY);
			g.endFill();
		}
		
		/**
		 * 绘制一个圆角矩形
		 * @param x 此外观中矩形左上角的水平位置。
		 * @param y 此外观中矩形左上角的垂直位置。
		 * @param width 矩形的宽度（以像素为单位）。
		 * @param height 矩形的高度（以像素为单位）。
		 * @param cornerRadius 矩形的角半径。可以是 null、Number 或 Object。如果为 null，则表示该角应为方形而不是弧形。如果为 Number，则为所有四个角指定相同半径（以像素为单位）。如果为 Object，则应具有 tl、tr、bl 和 br 属性，这些属性值是用于指定左上角、右上角、左下角、右下角的半径的 Number（以像素为单位）。例如，您可以传递简单 Object，如 { tl: 5, tr: 5, bl: 0, br: 0 }。默认值为 null（方形角）。
		 * @param color 填充的 RGB 颜色。可以是 null、uint 或 Array。如果为 null，则不为矩形填充颜色。如果为 uint，则会指定一个 RGB 填充色。例如，传递 0xFF0000 可填充红色。如果为 Array，则应包含用于指定渐变颜色的 uint。例如，传递 [ 0xFF0000, 0xFFFF00, 0x0000FF ] 可填充红-黄-蓝渐变。在渐变中最多可以指定 15 种颜色。默认值为 null（无填充颜色）。
		 * @param alpha 用于填充的 Alpha 值。可以是 null、Number 或 Array。如果 color 为空，则忽略此参数。如果 color 是用于指定 RGB 填充颜色的 uint，则 alpha 应该是用于指定填充透明度的 Number，其中 0.0 表示完全透明，1.0 表示完全不透明。在本例中，您还可以通过传递空值而不是 1.0 来指定完全不透明。如果 color 是用于指定渐变颜色的 Array，则 alpha 应该是长度相同的数字 Array，用于为渐变指定相应的 alpha 值。在本例中，默认值为 null（完全不透明）。
		 * @param gradientMatrix 用于渐变填充的 Matrix 对象。可使用实用程序方法 horizontalGradientMatrix()、verticalGradientMatrix() 和 rotatedGradientMatrix() 来创建此参数的值。
		 * @param gradientType 渐变填充的类型。可能的值为 GradientType.LINEAR 或 GradientType.RADIAL。（GradientType 类位于 flash.display 包中。）
		 * @param gradientRatios （可选默认值为 [0,255]）指定颜色分布。条目数必须与在 color 参数中定义的颜色数匹配。各值均定义 100% 采样的颜色所在位置的宽度百分比。值 0 表示渐变框中的左侧位置，255 表示渐变框中的右侧位置。
		 * @param hole （可选）应从另一个实心填充的圆角矩形 { x: #, y: #, w: #, h: #, r: # 或 { br: #, bl: #, tl: #, tr: # } } 中央凸出的圆角矩形孔
		 * @param g 要绘制到的目标Graphics，留空则绘制到自身。
		 */		
		protected function drawRoundRect(
			x:Number, y:Number, width:Number, height:Number,
			cornerRadius:Object = null,
			color:Object = null,
			alpha:Object = null,
			gradientMatrix:Matrix = null,
			gradientType:String = "linear",
			gradientRatios:Array = null,
			hole:Object = null,g:Graphics=null):void
		{
			if(g==null)
				g = graphics;
			
			if (width == 0 || height == 0)
				return;
			
			if (color !== null)
			{
				if (color is uint)
				{
					g.beginFill(uint(color), Number(alpha));
				}
				else if (color is Array)
				{
					var alphas:Array = alpha is Array ?
						alpha as Array :
						[ alpha, alpha ];
					
					if (!gradientRatios)
						gradientRatios = [ 0, 0xFF ];
					
					g.beginGradientFill(gradientType,
						color as Array, alphas,
						gradientRatios, gradientMatrix);
				}
			}
			
			var ellipseSize:Number;
			
			if (!cornerRadius)
			{
				g.drawRect(x, y, width, height);
			}
			else if (cornerRadius is Number)
			{
				ellipseSize = Number(cornerRadius) * 2;
				g.drawRoundRect(x, y, width, height, 
					ellipseSize, ellipseSize);
			}
			else
			{
				GraphicsUtil.drawRoundRectComplex(g,
					x, y, width, height,
					cornerRadius.tl, cornerRadius.tr,
					cornerRadius.bl, cornerRadius.br);
			}
			
			if (hole)
			{
				var holeR:Object = hole.r;
				if (holeR is Number)
				{
					ellipseSize = Number(holeR) * 2;
					g.drawRoundRect(hole.x, hole.y, hole.w, hole.h, 
						ellipseSize, ellipseSize);
				}
				else
				{
					GraphicsUtil.drawRoundRectComplex(g,
						hole.x, hole.y, hole.w, hole.h,
						holeR.tl, holeR.tr, holeR.bl, holeR.br);
				}	
			}
			
			if (color !== null)
				g.endFill();
		}
		
	}
}