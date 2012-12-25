package org.flexlite.domUI.core
{
	import flash.display.DisplayObject;

	/**
	 * 皮肤适配器接口。<br/>
	 * 若项目需要自定义可设置外观组件的skinName属性的解析规则，需要实现这个接口，然后调用Injector.mapClass()注入到框架即可。
	 * @author DOM
	 */
	public interface ISkinAdapter
	{
		/**
		 * 获取皮肤显示对象
		 * @param skinName 待解析的新皮肤标识符
		 * @param compFunc 解析完成回调函数，示例：compFunc(skin:Object,skinName:Object):void;
		 * 回调参数skin若为显示对象，将直接被添加到显示列表,其他对象根据项目自定义组件的具体规则解析。
		 * @oldSkin 旧的皮肤显示对象,传入值有可能为null。对于某些类型素材，例如Bitmap，可以重用传入的显示对象,只修改其数据再返回。
		 */		
		function getSkin(skinName:Object,compFunc:Function,oldSkin:DisplayObject=null):void;
	}
}