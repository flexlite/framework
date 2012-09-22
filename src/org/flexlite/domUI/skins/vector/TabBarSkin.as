package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.TabBarButton;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * TabBar默认皮肤
	 * @author DOM
	 */
	public class TabBarSkin extends VectorSkin
	{
		public function TabBarSkin()
		{
			super();
		}
		
		public var dataGroup:DataGroup;
		
		override protected function createChildren():void
		{
			super.createChildren();
			dataGroup = new DataGroup();
			dataGroup.percentWidth = 100;
			dataGroup.percentHeight = 100;
			dataGroup.itemRenderer = TabBarButton;
			addElement(dataGroup);
		}
		
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w,h);
			this.alpha = currentState=="disabled"?0.5:1;
		}
		
	}
}