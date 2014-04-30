package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.TabBar;
	import org.flexlite.domUI.components.ViewStack;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * 垂直滚动条默认皮肤
	 * @author DOM
	 */
	public class TabNavigatorSkin extends VectorSkin
	{
		public function TabNavigatorSkin()
		{
			super();
		}

		public var contentGroup:Group;	
		/**
		 * [SkinPart]选项卡组件
		 */
		public var tabBar:TabBar;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			contentGroup = new ViewStack();
			contentGroup.top = 25;
			contentGroup.left = 1;
			contentGroup.right = 1;
			contentGroup.bottom = 1;
			contentGroup.clipAndEnableScrolling = true;
			addElement(contentGroup);
			
			tabBar = new TabBar();
			tabBar.height = 25;
			addElement(tabBar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w,h);
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0xFFFFFF);
			g.lineStyle(1,borderColors[0]);
			g.drawRect(0,24,w,h-24);
			this.alpha = currentState=="disabled"?0.5:1;
		}
		
	}
}