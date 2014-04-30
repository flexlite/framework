package org.flexlite.domUI.skins.vector
{
	import flash.display.GradientType;
	
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * List默认皮肤
	 * @author DOM
	 */
	public class ListSkin extends VectorSkin
	{
		public function ListSkin()
		{
			super();
			minWidth = 70;
			minHeight = 70;
		}
		
		public var dataGroup:DataGroup;
		
		public var scroller:Scroller;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			dataGroup = new DataGroup();
			dataGroup.itemRenderer = ItemRenderer;
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
			dataGroup.layout = layout;
			
			scroller = new Scroller();
			scroller.left = 0;
			scroller.top = 0;
			scroller.right = 0;
			scroller.bottom = 0;
			scroller.minViewportInset = 1;
			scroller.viewport = dataGroup;
			addElement(scroller);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w,h);
			graphics.clear();
			drawRoundRect(
				x, y, w, h, 0,
				borderColors[0], 1,
				verticalGradientMatrix(x, y, w, h ),
				GradientType.LINEAR, null, 
				{ x: x+1, y: y+1, w: w - 2, h: h - 2, r: 0}); 
			this.alpha = currentState=="disabled"?0.5:1;
		}
		
	}
}