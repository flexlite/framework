package org.flexlite.domUI.core
{
	import flash.display.DisplayObject;
	
	/**
	 * 非显示对象皮肤接口。
	 * @author DOM
	 */
	public interface IInvisibleSkin
	{
		/**
		 * 获取指定视图状态的皮肤显示对象
		 * @param state 状态名
		 * @param compFunc 回调函数，示例：compFunc(skin:DisplayObject):void;
		 * @param oldSkin 旧的皮肤显示对象
		 */		
		function getSkin(state:String,compFunc:Function,oldSkin:DisplayObject):void;
	}
}