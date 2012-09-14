package org.flexlite.domUI.managers
{
	/**
	 * 多语言管理器接口
	 * @author DOM
	 */
	public interface ILanguageManager
	{
		/**
		 * 取得一个文本
		 * @param resourceName 文字索引，如果库中找不到这个索引则直接使用resourceName
		 * @param parameters 替换的参数，用于替换{}中的内容
		 */	
		function getText(resourceName:String,parameters:Array=null):String;
	}
}