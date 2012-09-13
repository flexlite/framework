package org.flexlite.domUI.core
{
	/**
	 * 滚动条显示策略常量
	 * @author DOM
	 */
	public class ScrollPolicy
	{
		/**
		 * 如果子项超出所有者的尺寸，则显示滚动栏。在显示滚动条时并不会因滚动条尺寸而调整所有者的尺寸，因此这可能会导致 scrollbar 遮蔽控件或容器的内容。
		 */		
		public static const AUTO:String = "auto";
		
		/**
		 * 从不显示滚动栏。 
		 */		
		public static const OFF:String = "off";
		
		/**
		 * 总是显示滚动栏。scrollbar 的尺寸将自动添加至所有者内容的尺寸，以便在未显式指定所有者尺寸时确定该尺寸。
		 */		
		public static const ON:String = "on";
	}
}