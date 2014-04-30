package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * ComboBox的下拉按钮默认皮肤
	 * @author DOM
	 */
	public class TreeDisclosureButtonSkin extends VectorSkin
	{
		public function TreeDisclosureButtonSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.height = 9;
			this.width = 9;
		}
		
		private var _overColor:uint = 0x666666;
		/**
		 * 鼠标经过时的箭头颜色,默认0x666666。
		 */
		public function get overColor():uint
		{
			return _overColor;
		}
		public function set overColor(value:uint):void
		{
			if(_overColor==value)
				return;
			_overColor = value;
			invalidateDisplayList();
		}
		
		private var _selectedColor:uint = 0x333333;
		/**
		 * 节点开启时的箭头颜色,默认0x333333。
		 */
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		public function set selectedColor(value:uint):void
		{
			if(_selectedColor==value)
				return;
			_selectedColor = value;
			invalidateDisplayList();
		}

		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0xFFFFFF,0);
			g.drawRect(0,0,9,9);
			g.endFill();
			var arrowColor:uint;
			var selected:Boolean = false;
			switch (currentState)
			{			
				case "up":
				case "disabled":
				case "over":
				case "down":
					arrowColor = _overColor;
					break;
				case "overAndSelected":
				case "upAndSelected":
				case "downAndSelected":
				case "disabledAndSelected":
					selected = true;
					arrowColor = _selectedColor;
					break;
			}
			this.alpha = currentState=="disabled"||currentState=="disabledAndSelected"?0.5:1;
			g.beginFill(arrowColor);
			if(selected)
			{
				g.lineStyle(0,0,0);
				g.moveTo(1, 7);
				g.lineTo(7, 7);
				g.lineTo(7, 0);
				g.lineTo(1, 7);
				g.endFill();
			}
			else
			{
				g.moveTo(2, 0);
				g.lineTo(2, 9);
				g.lineTo(7, 5);
				g.lineTo(2, 0);
				g.endFill();
			}
			
		}
	}
}