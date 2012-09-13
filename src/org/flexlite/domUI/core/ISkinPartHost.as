package org.flexlite.domUI.core
{
	
	/**
	 * 含有子项注入列表的皮肤接口
	 * @author DOM
	 */
	public interface ISkinPartHost
	{
		/**
		 * 获取皮肤定义的公开属性名列表
		 */		
		function getSkinParts():Vector.<String>;
	}
}