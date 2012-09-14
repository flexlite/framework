<<<<<<< HEAD
package org.flexlite.domCompile.events
{
	import flash.events.Event;
	
	/**
	 * 编译器事件
	 * @author DOM
	 */
	public class CompileEvent extends Event
	{
		/**
		 * 编译完成 
		 */		
		public static const COMPILE_COMPLETE:String = "compileComplete";
		/**
		 * 编译失败 
		 */		
		public static const COMPILE_ERROR:String = "compileError";
		
		/**
		 * 编译失败的信息 
		 */		
		public var message:String;
		/**
		 * 要编译的xml文件路径
		 */		
		public var xmlPath:String;
		/**
		 * 编译生成的as文件路径
		 */		
		public var asPath:String;
		/**
		 * 工程的src路径
		 */		
		public var srcPath:String;
		
		public function CompileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:CompileEvent = new CompileEvent(type,bubbles,cancelable);
			e.message = message;
			return e;
		}
	}
=======
package org.flexlite.domCompile.events
{
	import flash.events.Event;
	
	/**
	 * 编译器事件
	 * @author DOM
	 */
	public class CompileEvent extends Event
	{
		/**
		 * 编译完成 
		 */		
		public static const COMPILE_COMPLETE:String = "compileComplete";
		/**
		 * 编译失败 
		 */		
		public static const COMPILE_ERROR:String = "compileError";
		
		/**
		 * 编译失败的信息 
		 */		
		public var message:String;
		/**
		 * 要编译的xml文件路径
		 */		
		public var xmlPath:String;
		/**
		 * 编译生成的as文件路径
		 */		
		public var asPath:String;
		/**
		 * 工程的src路径
		 */		
		public var srcPath:String;
		
		public function CompileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:CompileEvent = new CompileEvent(type,bubbles,cancelable);
			e.message = message;
			return e;
		}
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}