package org.flexlite.domDisplay
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDisplay.codec.DxrDrawer;
	
	use namespace dx_internal;

	/**
	 * DXR动画数据
	 * @author DOM
	 */	
	public class DxrData
	{
		/**
		 * 构造函数
		 * @param key 动画在文件中的导出键名。
		 */		
		public function DxrData(key:String="",codecKey:String="jpeg32")
		{
			this._key = key;
			this._codecKey = codecKey;
		}
		
		dx_internal var _key:String;
		/**
		 * 动画在文件中的导出键名。
		 */
		public function get key():String
		{
			return _key;
		}
		
		dx_internal var _codecKey:String;
		/**
		 * 位图编解码器标识符
		 */		
		public function get codecKey():String
		{
			return _codecKey;
		}

		
		/**
		 * 动画帧列表
		 */
		dx_internal var frameList:Array = [];

		/**
		 * 获取指定帧的位图数据,若不存在则返回null
		 * @param frame 帧序号，从0开始
		 */		
		public function getBitmapData(frame:int):BitmapData
		{
			if(drawTarget)
				checkFrame(frame);
			return frameList[frame];
		}

		/**
		 * 帧偏移列表
		 */
		dx_internal var frameOffsetList:Array = [];

		/**
		 * 获取指定帧的偏移量,若不存在则返回null
		 * @param frame 帧序号，从0开始
		 */		
		public function getFrameOffset(frame:int):Point
		{
			if(drawTarget)
				checkFrame(frame);
			return frameOffsetList[frame];
		}
		
		dx_internal var filterOffsetList:Array = [];
		/**
		 * 获取指定帧的滤镜尺寸,若不存在则返回null
		 * @param frame 帧序号，从0开始
		 */
		public function getFilterOffset(frame:int):Point
		{
			if(drawTarget)
				checkFrame(frame);
			return filterOffsetList[frame];
		}
		/**
		 * 动画的总帧数
		 */		
		public function get totalFrames():int
		{
			return frameList.length;
		}
		
		dx_internal var _scale9Grid:Rectangle;

		/**
		 * 九宫格缩放数据,若不存在则返回null。
		 */
		public function get scale9Grid():Rectangle
		{
			if(_scale9Grid)
			{
				return _scale9Grid.clone();
			}
			return null;
		}

		dx_internal var _frameLabels:Array = [];
		/**
		 * 返回由FrameLabel对象组成的数组。数组包括整个Dxr动画实例的所有帧标签。
		 */		
		public function get frameLabels():Array
		{
			return _frameLabels.concat();
		}
		/**
		 * 要绘制的目标显示对象
		 */		
		private var drawTarget:DisplayObject;
		
		/**
		 * 位图化一个显示对象或多帧的影片剪辑。<br/>
		 * 出于性能优化考虑，此方法并不会立即执行绘制操作，而是等待外部第一次访问其某一帧位图数据时才绘制该帧。
		 */		
		public function draw(dp:DisplayObject):void
		{
			if(drawTarget==dp)
				return;
			drawCount = 0;
			frameList = [];
			frameOffsetList = [];
			filterOffsetList = [];
			drawTarget = dp;
			if(dp)
			{
				_scale9Grid = dp.scale9Grid;
				var mc:MovieClip = dp as MovieClip;
				if(mc)
				{
					_frameLabels = mc.currentLabels;
					frameList.length = mc.totalFrames;
				}
				else
				{
					_frameLabels = [];
					frameList.length = 1;
				}
			}
			else
			{
				_scale9Grid = null;
				_frameLabels = [];
			}
		}
		/**
		 * dxr绘制工具实例
		 */		
		private var dxrDrawer:DxrDrawer;
		/**
		 * 已经绘制过的帧数
		 */		
		private var drawCount:int = 0;
		/**
		 * 检查指定帧是否还未绘制。
		 */		
		private function checkFrame(frame:int):void
		{
			if(frameList[frame]||frame<0||frame>=frameList.length)
				return;
			if(!dxrDrawer)
				dxrDrawer = new DxrDrawer();
			var mc:MovieClip = drawTarget as MovieClip;
			if(mc)
			{
				mc.gotoAndStop(frame+1);
				dxrDrawer.drawDisplayObject(mc,this,frame);
			}
			else
			{
				dxrDrawer.drawDisplayObject(drawTarget,this,0);
			}
			drawCount++;
			if(drawCount==frameList.length)
			{
				dxrDrawer = null;
				drawTarget = null;
			}
		}
		
	}
}