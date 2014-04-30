package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.HScrollBar;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * 垂直滚动条默认皮肤
	 * @author DOM
	 */
	public class ScrollerSkin extends VectorSkin
	{
		public function ScrollerSkin()
		{
			super();
		}
		
		public var horizontalScrollBar:HScrollBar;
		
		public var verticalScrollBar:VScrollBar;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			horizontalScrollBar = new HScrollBar();
			horizontalScrollBar.visible = false;
			addElement(horizontalScrollBar);
			
			verticalScrollBar = new VScrollBar();
			verticalScrollBar.visible = false;
			addElement(verticalScrollBar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w,h);
			this.alpha = currentState=="disabled"?0.5:1;
		}
		
	}
}