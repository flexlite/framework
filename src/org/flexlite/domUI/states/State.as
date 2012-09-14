<<<<<<< HEAD
package org.flexlite.domUI.states
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.events.EventDispatcher;
	
	use namespace dx_internal;
	
	
	/**
	 * 进入视图状态后
	 */	
	[Event(name="enterState", type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 即将退出视图状态之前 
	 */	
	[Event(name="exitState", type="org.flexlite.domUI.events.UIEvent")]
	
	[DXML(show="false")]
	
	[DefaultProperty(name="overrides",array="true")]
	
	/**
	 * State 类定义视图状态，即组件的特定视图。
	 * @author DOM
	 */
	public class State extends EventDispatcher
	{
		public function State(properties:Object=null)
		{
			super();
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
		}
		/**
		 * 已经初始化标志 
		 */		
		private var initialized:Boolean = false;
		/**
		 * 该视图状态所基于的视图状态的名称；
		 * 如果该视图状态不是基于已命名的视图状态，则为 null。
		 * 如果该值为 null，则该视图状态基于根状态（包括不是使用 State 类为组件定义的属性、样式、事件处理函数和子项）。 
		 */		
		public var basedOn:String;
		
		/**
		 * 视图状态的名称。给定组件的状态名称必须唯一。必须设置此属性。
		 */		
		public var name:String;
		
		/**
		 * 该视图状态的覆盖，表现为实现 IOverride 接口的对象的数组。
		 * 这些覆盖在进入状态时按顺序应用，在退出状态时按相反的顺序删除。 
		 */		
		public var overrides:Array  = [];
		/**
		 * 此视图状态作为 String 数组所属的状态组。 
		 */		
		public var stateGroups:Array  = [];
		/**
		 * 初始化视图
		 */		
		dx_internal function initialize():void
		{
			if (!initialized)
			{
				initialized = true;
				for (var i:int = 0; i < overrides.length; i++)
				{
					IOverride(overrides[i]).initialize();
				}
			}
		}
		/**
		 * 抛出进入视图状态事件
		 */		
		dx_internal function dispatchEnterState():void
		{
			if (hasEventListener(UIEvent.ENTER_STATE))
				dispatchEvent(new UIEvent(UIEvent.ENTER_STATE));
		}
		/**
		 * 抛出即将退出视图状态事件
		 */		
		dx_internal function dispatchExitState():void
		{
			if (hasEventListener(UIEvent.EXIT_STATE))
				dispatchEvent(new UIEvent(UIEvent.EXIT_STATE));
		}
	}
	
}
=======
package org.flexlite.domUI.states
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.events.EventDispatcher;
	
	use namespace dx_internal;
	
	
	/**
	 * 进入视图状态后
	 */	
	[Event(name="enterState", type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 即将退出视图状态之前 
	 */	
	[Event(name="exitState", type="org.flexlite.domUI.events.UIEvent")]
	
	[DXML(show="false")]
	
	[DefaultProperty(name="overrides",array="true")]
	
	/**
	 * State 类定义视图状态，即组件的特定视图。
	 * @author DOM
	 */
	public class State extends EventDispatcher
	{
		public function State(properties:Object=null)
		{
			super();
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
		}
		/**
		 * 已经初始化标志 
		 */		
		private var initialized:Boolean = false;
		/**
		 * 该视图状态所基于的视图状态的名称；
		 * 如果该视图状态不是基于已命名的视图状态，则为 null。
		 * 如果该值为 null，则该视图状态基于根状态（包括不是使用 State 类为组件定义的属性、样式、事件处理函数和子项）。 
		 */		
		public var basedOn:String;
		
		/**
		 * 视图状态的名称。给定组件的状态名称必须唯一。必须设置此属性。
		 */		
		public var name:String;
		
		/**
		 * 该视图状态的覆盖，表现为实现 IOverride 接口的对象的数组。
		 * 这些覆盖在进入状态时按顺序应用，在退出状态时按相反的顺序删除。 
		 */		
		public var overrides:Array  = [];
		/**
		 * 此视图状态作为 String 数组所属的状态组。 
		 */		
		public var stateGroups:Array  = [];
		/**
		 * 初始化视图
		 */		
		dx_internal function initialize():void
		{
			if (!initialized)
			{
				initialized = true;
				for (var i:int = 0; i < overrides.length; i++)
				{
					IOverride(overrides[i]).initialize();
				}
			}
		}
		/**
		 * 抛出进入视图状态事件
		 */		
		dx_internal function dispatchEnterState():void
		{
			if (hasEventListener(UIEvent.ENTER_STATE))
				dispatchEvent(new UIEvent(UIEvent.ENTER_STATE));
		}
		/**
		 * 抛出即将退出视图状态事件
		 */		
		dx_internal function dispatchExitState():void
		{
			if (hasEventListener(UIEvent.EXIT_STATE))
				dispatchEvent(new UIEvent(UIEvent.EXIT_STATE));
		}
	}
	
}
>>>>>>> master
