package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.HScrollBar;
	import org.flexlite.domUI.components.VScrollBar;
<<<<<<< HEAD
	import org.flexlite.domUI.skins.SparkSkin;
=======
	import org.flexlite.domUI.skins.SparkSkin;
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
	
	/**
	 * 滚动条组件默认皮肤
	 * @author DOM
	 */
	public class ScrollerSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var horizontalScrollBar:HScrollBar;
		
		public var verticalScrollBar:VScrollBar;
		
		
		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function ScrollerSkin()
		{
			super();
			
			this.elementsContent = [verticalScrollBar_i(),horizontalScrollBar_i()];
			
		}
		
		
		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function horizontalScrollBar_i():HScrollBar
		{
			var temp:HScrollBar = new HScrollBar();
			horizontalScrollBar = temp;
			temp.visible = false;
			return temp;
		}
		
		private function verticalScrollBar_i():VScrollBar
		{
			var temp:VScrollBar = new VScrollBar();
			verticalScrollBar = temp;
			temp.visible = false;
			return temp;
		}
		
	}
}