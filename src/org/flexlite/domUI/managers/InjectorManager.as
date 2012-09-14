<<<<<<< HEAD
package org.flexlite.domUI.managers
{
	import org.flexlite.domUI.managers.injectorClass.SingletonInjector;
	import org.flexlite.domUI.managers.injectorClass.SkinInjector;
	
	/**
	 * 注入配置管理器
	 * @author DOM
	 */
	public class InjectorManager
	{
		private static var _singletonInjector:SingletonInjector;
		
		/**
		 * 单例注入配置类
		 */		
		public static function get singletonInjector():SingletonInjector
		{
			if(!_singletonInjector)
			{
				_singletonInjector = new SingletonInjector();
			}
			return _singletonInjector;
		}
		
		private static var _skinInjector:SkinInjector;
		/**
		 * 皮肤注入配置类
		 */		
		public static function get skinInjector():SkinInjector
		{
			if(!_skinInjector)
			{
				_skinInjector = new SkinInjector();
			}
			return _skinInjector;
		}
			
	}
=======
package org.flexlite.domUI.managers
{
	import org.flexlite.domUI.managers.injectorClass.SingletonInjector;
	import org.flexlite.domUI.managers.injectorClass.SkinInjector;
	
	/**
	 * 注入配置管理器
	 * @author DOM
	 */
	public class InjectorManager
	{
		private static var _singletonInjector:SingletonInjector;
		
		/**
		 * 单例注入配置类
		 */		
		public static function get singletonInjector():SingletonInjector
		{
			if(!_singletonInjector)
			{
				_singletonInjector = new SingletonInjector();
			}
			return _singletonInjector;
		}
		
		private static var _skinInjector:SkinInjector;
		/**
		 * 皮肤注入配置类
		 */		
		public static function get skinInjector():SkinInjector
		{
			if(!_skinInjector)
			{
				_skinInjector = new SkinInjector();
			}
			return _skinInjector;
		}
			
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}