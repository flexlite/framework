package org.flexlite.domDll.resolvers
{
	
	/**
	 * RSL文件解析器,通常是将共享代码库加载到当前程序域。
	 * @author DOM
	 */
	public class RslResolver extends SwfResolver
	{
		/**
		 * 构造函数
		 */		
		public function RslResolver()
		{
			super();
			loadInCurrentDomain = true;
		}
	}
}