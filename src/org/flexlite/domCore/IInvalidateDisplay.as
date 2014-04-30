package org.flexlite.domCore
{
	
	/**
	 * 具有延迟应用属性功能的显示对象接口
	 * @author DOM
	 */
	public interface IInvalidateDisplay
	{
		/**
		 * 立即应用所有标记为延迟验证的属性
		 */		
		function validateNow():void;
	}
}