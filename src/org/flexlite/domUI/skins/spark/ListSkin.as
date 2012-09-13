package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.components.supportClasses.ItemRenderer;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.primitives.Rect;
	import org.flexlite.domUI.primitives.graphic.SolidColor;
	import org.flexlite.domUI.primitives.graphic.SolidColorStroke;
	import org.flexlite.domUI.skins.SparkSkin;
	import org.flexlite.domUI.states.SetProperty;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class ListSkin extends SparkSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var dataGroup:DataGroup;

		public var scroller:Scroller;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function ListSkin()
		{
			super();
			
			this.minWidth = 112;
			this.elementsContent = [scroller_i()];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __ListSkin_VerticalLayout1_i():VerticalLayout
		{
			var temp:VerticalLayout = new VerticalLayout();
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
			return temp;
		}

		private function dataGroup_i():DataGroup
		{
			var temp:DataGroup = new DataGroup();
			dataGroup = temp;
			temp.itemRenderer = ItemRenderer;
			temp.layout = __ListSkin_VerticalLayout1_i();
			return temp;
		}

		private function scroller_i():Scroller
		{
			var temp:Scroller = new Scroller();
			scroller = temp;
			temp.left = 0;
			temp.top = 0;
			temp.right = 0;
			temp.bottom = 0;
			temp.minViewportInset = 1;
			temp.viewport = dataGroup_i();
			return temp;
		}

	}
}