package org.flexlite.domUI.skins.vector
{
	import flash.display.CapsStyle;
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
					arrowColor = themeColors[1];
					break;
				case "overAndSelected":
				case "upAndSelected":
				case "downAndSelected":
				case "disabledAndSelected":
					selected = true;
					arrowColor = themeColors[0];
					break;
			}
			trace(currentState);
			this.alpha = currentState=="disabled"||currentState=="disabledAndSelected"?0.5:1;
			g.beginFill(arrowColor);
			g.lineStyle(1,0xa6a6a6,1,true,"normal",CapsStyle.SQUARE);
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
				g.moveTo(3, 0);
				g.lineTo(3, 9);
				g.lineTo(7, 5);
				g.lineTo(3, 0);
				g.endFill();
			}
			
		}
	}
}