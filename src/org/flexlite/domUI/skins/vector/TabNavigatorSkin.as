package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.HScrollBar;
	import org.flexlite.domUI.components.TabBar;
	import org.flexlite.domUI.components.VScrollBar;
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
			this.states = ["normal","disabled"];
			this.currentState = "normal";
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
			
			tabBar = new TabBar();
			tabBar.height = 25;
			addElement(tabBar);
			
			contentGroup = new ViewStack();
			contentGroup.top = 28;
			contentGroup.left = 0;
			contentGroup.right = 0;
			contentGroup.bottom = 0;
			addElement(contentGroup);
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