package org.flexlite.domDll.fileLib
{
	/**
	 * 二进制文件解析库
	 * @author DOM
	 */
	public class BinFileLib extends FileLibBase
	{
		/**
		 * 构造函数
		 */		
		public function BinFileLib()
		{
			super();
		}
		
		override public function getRes(key:String,subKey:String):*
		{
			return bytesDic[key];
		}
	}
}