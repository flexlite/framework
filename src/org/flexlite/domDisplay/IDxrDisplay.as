package org.flexlite.domDisplay
{
	
	/**
	 * 能够解析DxrData的显示对象接口
	 * @author DOM
	 */
	public interface IDxrDisplay
	{
		/**
		 * 被引用的DxrData对象
		 */
		function get dxrData():DxrData;
		function set dxrData(value:DxrData):void;
	}
}