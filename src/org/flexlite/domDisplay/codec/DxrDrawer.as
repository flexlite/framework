package org.flexlite.domDisplay.codec
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDisplay.DxrData;
	
	use namespace dx_internal;
	
	[ExcludeClass]
	
	/**
	 * 影片剪辑位图化工具，通常不需要关心此类，直接调用DxrData.draw()方法即可。
	 * 注意：在AIR里，影片剪辑若不在显示列表，切换帧时会有残影的bug，转换前请先将MC都加到显示列表里。FP里没有这个问题。
	 * @author DOM
	 */
	public class DxrDrawer
	{
		/**
		 * 构造函数
		 */		
		public function DxrDrawer()
		{
		}
		
		/**
		 * 绘制一个显示对象的当前外观，存储其一帧位图信息到dxrData内
		 */		
		dx_internal function drawDisplayObject(dp:DisplayObject,dxrData:DxrData,frame:int):void
		{
			var dpRect:Rectangle = dp.getBounds(dp);
			if(dpRect.width<1)
				dpRect.width = 1;
			if(dpRect.height<1)
				dpRect.height = 1;
			var offsetX:Number = 100;
			var offsetY:Number = 100;
			var matrix:Matrix = new Matrix(1,0,0,1,offsetX-Math.round(dpRect.left),offsetY-Math.round(dpRect.top));
			var tempBmData:BitmapData = new BitmapData(dpRect.width+offsetX*2,dpRect.height+offsetY*2,true,0); 
			var ct:ColorTransform = drawColorTransfrom(dp);
			tempBmData.draw(dp,matrix,ct,null,null,true);
			
			var colorRect:Rectangle = getColorRect(tempBmData);
			var frameData:BitmapData = new BitmapData(colorRect.width,colorRect.height,true,0);
			frameData.copyPixels(tempBmData,colorRect,new Point(),null,null,true);
			dxrData.frameList[frame] = frameData;
			var offsetPoint:Point = new Point(Math.round(dpRect.left)+colorRect.x-offsetX,
				Math.round(dpRect.top)+colorRect.y-offsetY);
			dxrData.frameOffsetList[frame] = offsetPoint;
			var filterOffset:Point = new Point(Math.round(colorRect.width-dpRect.width),
				Math.round(colorRect.height-dpRect.height));
			if(filterOffset.x>1&&filterOffset.y>1)
			{
				dxrData.filterOffsetList[frame] = filterOffset;
			}
		}
		/**
		 * 绘制一个显示对象的当前外观，存储其一帧位图信息到dxrData内
		 */		
		dx_internal function drawWithoutFilter(dp:DisplayObject,dxrData:DxrData,frame:int):void
		{
			var dpRect:Rectangle = dp.getBounds(dp);
			
			if(Math.abs(dpRect.left%1)>0)
				dpRect.width += 1;
			if(Math.abs(dpRect.top%1)>0)
				dpRect.height += 1;
			if(dpRect.width<1)
				dpRect.width = 1;
			if(dpRect.height<1)
				dpRect.height = 1;
			var matrix:Matrix = new Matrix(1,0,0,1,Math.round(-dpRect.left),Math.round(-dpRect.top));
			var frameData:BitmapData = new BitmapData(dpRect.width,dpRect.height,true,0); 
			var ct:ColorTransform = drawColorTransfrom(dp);
			frameData.draw(dp,matrix,ct,null,null,true);
			dxrData.frameList[frame] = frameData;
			dxrData.frameOffsetList[frame] = new Point(Math.round(dpRect.left),Math.round(dpRect.top));
		}
		
		/**
		 * 获取指定显示对象的除去alpha值的colorTransform对象。若对象各个属性都是初始状态，则返回null。
		 */		
		private function drawColorTransfrom(dp:DisplayObject):ColorTransform
		{
			var ct:ColorTransform = dp.transform.colorTransform;
			if(ct.redMultiplier==1&&ct.greenMultiplier==1&&ct.blueMultiplier==1&&
				ct.redOffset==0&&ct.greenOffset==0&&ct.blueOffset==0&&ct.alphaOffset==0)
			{
				return null;
			}
			var newCT:ColorTransform = new ColorTransform();
			newCT.concat(ct);
			newCT.alphaMultiplier = 1;
			return newCT;
		}
		
		/**
		 * 获取指定BitmapData中包含像素的最大矩形区域。
		 */		
		dx_internal function getColorRect(bitmapData:BitmapData):Rectangle
		{
			var rect:Rectangle =  bitmapData.getColorBoundsRect(0xff000000,0,false);
			if(rect.width<1)
				rect.width = 1;
			if(rect.height<1)
				rect.height = 1;
			return rect;
		}
	}
}
