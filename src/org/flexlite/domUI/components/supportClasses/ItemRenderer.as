package org.flexlite.domUI.components.supportClasses
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.flexlite.domUI.components.IItemRenderer;
	
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
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		private var _selected:Boolean = false;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected==value)
				return;
			_selected = value;
			invalidateSkinState();
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
		
		override protected function getCurrentSkinState():String
		{
			if(_selected)
				return "down";
			return super.getCurrentSkinState();
		}
		
	}
}