package org.flexlite.domUI.components.supportClasses
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.components.IItemRenderer;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.SkinnableComponent;
	
	[DXML(show="false")]
	
	/**
	 * 项呈示器基类
	 * @author DOM
	 */
	public class ItemRenderer extends ButtonBase implements IItemRenderer
	{
		public function ItemRenderer()
		{
			super();
		}
		
		override protected function get hostComponentKey():Object
		{
			return ItemRenderer;
		}
		
		private var _autoDrawBackground:Boolean = true;
		/**
		 * 是否自动绘制背景，默认false
		 */
		public function get autoDrawBackground():Boolean
		{
			return _autoDrawBackground;
		}

		public function set autoDrawBackground(value:Boolean):void
		{
			if(_autoDrawBackground == value)
				return;
			_autoDrawBackground = value;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
		}
		
		protected function onMouseRollOver(event:MouseEvent):void
		{
			if(_selected||!_autoDrawBackground)
				return;
			if(skin!=null&&skin is Sprite)
			{
				var g:Graphics = (skin as Sprite).graphics;
				g.clear();
				g.beginFill(0x009aff);
				g.drawRect(0,0,layoutBoundsWidth,layoutBoundsHeight);
				g.endFill();
			}
		}
		
		protected function onMouseRollOut(event:MouseEvent):void
		{
			if(_selected||!_autoDrawBackground)
				return;
			if(skin!=null&&skin is Sprite)
			{
				(skin as Sprite).graphics.clear();
			}
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(_autoDrawBackground&&_selected&&skin!=null&&skin is Sprite)
			{
				var g:Graphics = (skin as Sprite).graphics;
				g.clear();
				g.beginFill(0x036aad);
				g.drawRect(0,0,layoutBoundsWidth,layoutBoundsHeight);
				g.endFill();
			}
		}
		
		private var _selected:Boolean = false;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(!_autoDrawBackground)
				return;
			if(skin!=null&&skin is Sprite)
			{
				if(value)
				{
					var g:Graphics = (skin as Sprite).graphics;
					g.clear();
					g.beginFill(0x036aad);
					g.drawRect(0,0,layoutBoundsWidth,layoutBoundsHeight);
					g.endFill();
				}
				else
				{
					(skin as Sprite).graphics.clear();
				}
				
			}
		}
		
		private var _itemIndex:int = -1;
		
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
		
	}
}