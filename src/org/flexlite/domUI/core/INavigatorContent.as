package org.flexlite.domUI.core
{
	
	/**
	 * 导航容器子项接口。只有实现了此接口的组件，才能直接添加到导航容器里使用。
	 * @author DOM
	 */
	public interface INavigatorContent
	{
		/**
		 * 此组件作为导航器容器子项时，要在容器内显示的文本。例如TabNavigator容器的选项卡区域显示的文本。
		 */		
		function get navigatorLabel():String;
	}
}