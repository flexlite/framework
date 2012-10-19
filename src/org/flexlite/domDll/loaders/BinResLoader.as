package org.flexlite.domDll.loaders
{
	/**
	 * 二进制文件加载器
	 * @author DOM
	 */
	public class BinResLoader extends ResLoaderBase
	{
		/**
		 * 构造函数
		 */		
		public function BinResLoader()
		{
			super();
		}
		
		override public function getRes(key:String):*
		{
			return fileDic[key];
		}
	}
}