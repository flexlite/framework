package org.flexlite.domDll.resolvers
{
	/**
	 * 二进制文件解析器
	 * @author DOM
	 */
	public class BinResolver extends ResolverBase
	{
		/**
		 * 构造函数
		 */		
		public function BinResolver()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getRes(key:String):*
		{
			return fileDic[key];
		}
	}
}