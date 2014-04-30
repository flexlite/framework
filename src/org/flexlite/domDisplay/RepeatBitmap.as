package org.flexlite.domDisplay
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	
	import org.flexlite.domCore.IInvalidateDisplay;
	
	
	/**
	 * 具有平铺功能的位图显示对象
	 * 注意：此类不具有鼠标事件
	 * @author DOM
	 */
	public class RepeatBitmap extends Shape implements IInvalidateDisplay
	{
		/**
		 * 构造函数
		 * @param bitmapData 被引用的BitmapData对象。
		 * @param target 要绘制到的目标Graphics对象，若不传入，则绘制到自身。
		 */		
		public function RepeatBitmap(bitmapData:BitmapData=null,target:Graphics=null)
		{
			super();
			if(target)
				this.target = target;
			else 
				this.target = graphics;
			if(bitmapData)
				this.bitmapData = bitmapData;
		}
		/**
		 * 要绘制到的目标Graphics对象。
		 */		
		private var target:Graphics;
		/**
		 * bitmapData发生改变
		 */		
		private var bitmapDataChanged:Boolean = false;
		
		private var _bitmapData:BitmapData;
		/**
		 * 被引用的BitmapData对象。
		 */
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			if(_bitmapData==value)
				return;
			_bitmapData = value;
			if(value)
			{
				if(!widthExplicitSet)
					_width = _bitmapData.width;
				if(!heightExplicitSet)
					_height = _bitmapData.height;
				bitmapDataChanged = true;
				invalidateProperties();
			}
			else
			{
				target.clear();
				if(!widthExplicitSet)
					_width = 0;
				if(!heightExplicitSet)
					_height = 0;
			}
		}
		
		private var widthChanged:Boolean = false;
		/**
		 * 宽度显式设置标记
		 */		
		private var widthExplicitSet:Boolean = false;
		
		private var _width:Number = 0;
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if(value==_width)
				return;
			if(isNaN(value))
			{
				widthExplicitSet = false;
				_width = _bitmapData?_bitmapData.width:0;
			}
			else
			{
				widthExplicitSet = true;
				_width = value;
			}
			widthChanged = true;
			invalidateProperties();
		}
		
		private var heightChanged:Boolean = false;
		/**
		 * 高度显式设置标志
		 */		
		private var heightExplicitSet:Boolean = false;
		
		private var _height:Number;
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if(_height==value)
				return;
			if(isNaN(value))
			{
				heightExplicitSet = false;
				_height = _bitmapData?_bitmapData.height:0;
			}
			else
			{
				heightExplicitSet = true;
				_height = value;
			}
			widthChanged = true;
			invalidateProperties();
		}
		
		private var invalidateFlag:Boolean = false;
		/**
		 * 标记有属性变化需要延迟应用
		 */		
		protected function invalidateProperties():void
		{
			if(!invalidateFlag)
			{
				invalidateFlag = true;
				addEventListener(Event.ENTER_FRAME,validateProperties);
				if(stage)
				{
					addEventListener(Event.RENDER,validateProperties);
					stage.invalidate();
				}
			}
		}
		/**
		 * 延迟应用属性事件
		 */		
		private function validateProperties(event:Event=null):void
		{
			removeEventListener(Event.ENTER_FRAME,validateProperties);
			removeEventListener(Event.RENDER,validateProperties);
			commitProperties();
			invalidateFlag = false;
		}	
		
		/**
		 * 立即应用所有标记为延迟验证的属性
		 */		
		public function validateNow():void
		{
			if(invalidateFlag)
				validateProperties();
		}
		
		/**
		 * 延迟应用属性
		 */
		protected function commitProperties():void
		{
			if(bitmapDataChanged||widthChanged||heightChanged)
			{
				var g:Graphics = target;
				g.clear();
				if(_bitmapData)
				{
					g.beginBitmapFill(_bitmapData,null,true);
					g.drawRect(0,0,_width,_height);
					g.endFill();
				}
				bitmapDataChanged = false;
				widthChanged = false;
				heightChanged = false;
			}
		}
	}
}