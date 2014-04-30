package org.flexlite.domUI.core
{
	
	/**
	 * 多语言文本翻译接口。实现此接口并调用Injector注入后，可以截获并翻译所有文本控件的text属性。<br/>
	 * 提示：text属性可以用特殊标识符分隔开，例如："key||替换文本1||替换文本2"，
	 * 然后在translate()方法里自定义解析规则，重新组装文本并返回。
	 * @author DOM
	 */
	public interface ITranslator
	{
		/**
		 * 翻译指定的文本
		 * @param text 要翻译的文本
		 */		
		function translate(text:String):String;
	}
}