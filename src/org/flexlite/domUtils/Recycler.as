package org.flexlite.domUtils
{
	import flash.utils.Dictionary;
	
	/**
	 * 对象缓存复用工具类，可用于构建对象池。
	 * 利用了Dictionary弱引用特性。一段时间后会自动回收对象。
	 * @author DOM
	 */
	public class Recycler
	{
		/**
		 * 构造函数
		 */		
		public function Recycler()
		{
		}
		/**
		 * 缓存字典
		 */		
		private var cache:Dictionary = new Dictionary(true);
		/**
		 * 缓存一个对象以复用
		 * @param object
		 */		
		public function push(object:*):void
		{
			cache[object] = null;
		}
		/**
		 * 获取一个缓存的对象
		 */		
		public function get():*
		{
			for(var object:* in cache)
			{
				delete cache[object];
				return object;
			}
		}
		/**
		 * 立即清空所有缓存的对象。
		 */		
		public function reset():void
		{
			cache = new Dictionary(true);
		}
	}
}