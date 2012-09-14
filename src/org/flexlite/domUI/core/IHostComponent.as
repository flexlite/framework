package org.flexlite.domUI.core
{
	
	/**
	 * 可设置外观组件接口
	 * @author DOM
	 */
	public interface IHostComponent extends IStyleClient
	{
		/**
		 * 匹配皮肤和主机组件的公共变量，并完成实例的注入。
		 */		
		function findSkinParts():void;
	}
}