package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * CheckBox默认皮肤
	 * @author DOM
	 */
	public class CheckBoxSkin extends VectorSkin
	{
		public function CheckBoxSkin()
		{
			super();
			states = ["up","over","down","disabled","upAndSelected","overAndSelected"
				,"downAndSelected","disabledAndSelected"];
		}
		
		public var labelDisplay:Label;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextFormatAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 16;
			labelDisplay.right = 0;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			labelDisplay.verticalCenter = 0;
			addElement(labelDisplay);
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
			g.drawRect(0,0,w,h);
			g.endFill();
			
			var startY:Number = Math.round((h-14)*0.5);
			if(startY<0)
				startY = 0;
			w = 14;
			h = 14;
			
			var selected:Boolean = false;
			var selectedColor:uint = 0xFFFFFF;
			switch (currentState)
			{
				case "up":
				case "upAndSelected":
				case "disabled":
					drawCurrentState(0,startY,w,h,borderColors[0],bottomLineColors[0],
						[fillColors[0],fillColors[1]]);
					selectedColor = fillColors[4];
					selected = (currentState=="upAndSelected");
					break;
				case "over":
				case "overAndSelected":
					drawCurrentState(0,startY,w,h,borderColors[1],bottomLineColors[1],
						[fillColors[2],fillColors[3]]);
					selected = (currentState!="over");
					break;
				case "down":
				case "downAndSelected":
				case "disabledAndSelected":
					drawCurrentState(0,startY,w,h,borderColors[2],bottomLineColors[2],
						[fillColors[4],fillColors[5]]);
					selected = (currentState!="down");
					break;
			}
			
			if (selected)
			{
				g.lineStyle(0,0,0);
				g.beginFill(selectedColor);
				g.moveTo(3, startY+5);
				g.lineTo(5, startY+10);
				g.lineTo(7, startY+10);
				g.lineTo(12, startY+2);
				g.lineTo(13, startY+1);
				g.lineTo(11, startY+1);
				g.lineTo(6.5, startY+7);
				g.lineTo(5, startY+5);
				g.lineTo(3, startY+5);
				g.endFill();
			}
			
			this.alpha = currentState=="disabled"||currentState=="disabledAndSelected"?0.5:1;
		}
	}
}