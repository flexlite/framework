<<<<<<< HEAD
package org.flexlite.domUI.events
{
	import org.flexlite.domUI.core.IToolTip;
	
	import flash.events.Event;
	
	/**
	 * 工具提示事件
	 * @author DOM
	 */	
	public class ToolTipEvent extends Event
	{
		public static const TOOL_TIP_END:String = "toolTipEnd";
		/**
		 * 隐藏工具提示
		 */		
		public static const TOOL_TIP_HIDE:String = "toolTipHide";
		/**
		 * 显示工具提示
		 */		
		public static const TOOL_TIP_SHOW:String = "toolTipShow";
		
		public static const TOOL_TIP_SHOWN:String = "toolTipShown";
		
		public static const TOOL_TIP_START:String = "toolTipStart";
		
		/**
		 * 构造函数
		 */		
		public function ToolTipEvent(type:String, bubbles:Boolean = false,
									 cancelable:Boolean = false,
									 toolTip:IToolTip = null)
		{
			super(type, bubbles, cancelable);
			
			this.toolTip = toolTip;
		}
		/**
		 * 应用此事件的 ToolTip 对象。
		 */		
		public var toolTip:IToolTip;
		
		override public function clone():Event
		{
			return new ToolTipEvent(type, bubbles, cancelable, toolTip);
		}
	}
	
}
=======
package org.flexlite.domUI.events
{
	import org.flexlite.domUI.core.IToolTip;
	
	import flash.events.Event;
	
	/**
	 * 工具提示事件
	 * @author DOM
	 */	
	public class ToolTipEvent extends Event
	{
		public static const TOOL_TIP_END:String = "toolTipEnd";
		/**
		 * 隐藏工具提示
		 */		
		public static const TOOL_TIP_HIDE:String = "toolTipHide";
		/**
		 * 显示工具提示
		 */		
		public static const TOOL_TIP_SHOW:String = "toolTipShow";
		
		public static const TOOL_TIP_SHOWN:String = "toolTipShown";
		
		public static const TOOL_TIP_START:String = "toolTipStart";
		
		/**
		 * 构造函数
		 */		
		public function ToolTipEvent(type:String, bubbles:Boolean = false,
									 cancelable:Boolean = false,
									 toolTip:IToolTip = null)
		{
			super(type, bubbles, cancelable);
			
			this.toolTip = toolTip;
		}
		/**
		 * 应用此事件的 ToolTip 对象。
		 */		
		public var toolTip:IToolTip;
		
		override public function clone():Event
		{
			return new ToolTipEvent(type, bubbles, cancelable, toolTip);
		}
	}
	
}
>>>>>>> master
