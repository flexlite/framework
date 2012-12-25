package org.flexlite.domDisplay
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexlite.domCore.dx_internal;
	
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
		public function DxrData(key:String,codecKey:String="jpeg32")
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
		dx_internal var frameList:Vector.<BitmapData> = new Vector.<BitmapData>();

		/**
		 * 获取指定帧的位图数据,若不存在则返回null
		 * @param frame 帧序号，从0开始
		 */		
		public function getBitmapData(frame:int):BitmapData
		{
			if(frame>=frameList.length)
				return null;
			return frameList[frame];
		}

		/**
		 * 帧偏移列表
		 */
		dx_internal var frameOffsetList:Vector.<Point> = new Vector.<Point>();

		/**
		 * 获取指定帧的偏移量,若不存在则返回null
		 * @param frame 帧序号，从0开始
		 */		
		public function getFrameOffset(frame:int):Point
		{
			if(frame>=frameOffsetList.length)
				return null;
			return frameOffsetList[frame];
		}
		
		dx_internal var filterOffsetList:Array = [];

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


		dx_internal var _frameLabels:Array;
		
		/**
		 * 返回由FrameLabel对象组成的数组。数组包括整个Dxr动画实例的所有帧标签。
		 */		
		public function get frameLabels():Array
		{
			if(_frameLabels)
			{
				return _frameLabels.concat();
			}
			return [];
		}
		
		/**
		 * 与另一个DxrData比较，若帧数,每帧偏移量和每帧的像素都相同，返回true。
		 * @param otherDxrData 要比较的另一个DxrData。
		 */		
		public function compare(otherDxrData:DxrData):Boolean
		{
			if(otherDxrData==this)
				return true;
			if(otherDxrData.totalFrames!=this.totalFrames)
				return false;
			var index:int = 0;
			for each(var offsetPos:Point in frameOffsetList)
			{
				if(!offsetPos.equals(otherDxrData.frameOffsetList[index]))
					return false;
				index++;
			}
			index = 0;
			for each(var bd:BitmapData in frameList)
			{
				if(bd.compare(otherDxrData.frameList[index])!=0)
					return false;
				index++;
			}
			return true;
		}
	}
}