package org.flexlite.domDisplay.codec
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDisplay.DxrData;
	
	use namespace dx_internal;
	
	/**
	 * 影片剪辑位图化工具
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
		 * 绘制一个显示对象，转换为DxrData对象。<br/>
		 * 注意：绘制的结果是其原始显示对象，不包含alpha,scale,rotation,或matrix值。但包含滤镜和除去alpha的colorTransfrom。
		 * @param dp 要绘制的显示对象，可以是MovieClip
		 * @param key DxrData对象的导出键名
		 * @param codec 位图编解码器标识符,"jpegxr"|"jpeg32"|"png",留空默认值为"jpeg32"
		 */	
		public function drawDxrData(dp:DisplayObject,key:String=""):DxrData
		{
			var dxrData:DxrData = new DxrData(key);
			if(dp is MovieClip)
			{
				var mc:MovieClip = dp as MovieClip;
				var oldFrame:int = mc.currentFrame;
				var isPlaying:Boolean = mc.isPlaying;
				var totalFrames:int = mc.totalFrames;
				for(var frame:int=0;frame<totalFrames;frame++)
				{
					mc.gotoAndStop(frame+1);
					drawDisplayObject(mc,dxrData,frame);
				}
				if(isPlaying)
					mc.gotoAndPlay(oldFrame);
				else
					mc.gotoAndStop(oldFrame);
				dxrData._frameLabels = mc.currentLabels;
			}
			else
			{
				drawDisplayObject(dp,dxrData,0);
			}
			if(dp.scale9Grid)
				dxrData._scale9Grid = dp.scale9Grid.clone();
			return dxrData;
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
			var matrix:Matrix = new Matrix(1,0,0,1,offsetX-dpRect.left,offsetY-dpRect.top);
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