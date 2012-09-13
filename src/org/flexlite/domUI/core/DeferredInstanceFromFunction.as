package org.flexlite.domUI.core
{
	/**
	 * 延迟实例工厂类
	 * @author DOM
	 */	
	public class DeferredInstanceFromFunction implements IDeferredInstance
	{
		/**
		 * 构造函数
		 * @param generator 获取实例的函数引用
		 */
		public function DeferredInstanceFromFunction(generator:Function)
		{
			super();
			this.generator = generator;
		}
		
		/**
		 * 获取实例的函数引用 
		 */		
		private var generator:Function;
		/**
		 * 实例引用 
		 */		
		private var instance:Object = null;
		
		/**
		 * 获取实例
		 */		
		public function getInstance():Object
		{
			if (!instance)
				instance = generator();
			
			return instance;
		}
	}
}