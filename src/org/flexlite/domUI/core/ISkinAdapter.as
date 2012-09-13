package org.flexlite.domUI.core
{
	/**
	 * 皮肤解析适配器注入接口
	 * @author DOM
	 */
	public interface ISkinAdapter
	{
		/**
		 * 获取皮肤显示对象
		 * @param skinName 皮肤标识符
		 * @param compFunc 解析完成回调函数，示例：compFunc(skin:Object,skinName:Object):void;
		 * 回调参数skin若为显示对象，将直接被添加到显示列表,其他对象根据项目自定义组件的具体规则解析。
		 */		
		function getSkin(skinName:Object,compFunc:Function):void;
	}
}