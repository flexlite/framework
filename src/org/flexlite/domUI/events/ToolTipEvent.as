package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	import org.flexlite.domUI.core.IToolTip;
	
	/**
	 * 工具提示事件
	 * @author DOM
	 */	
	public class ToolTipEvent extends Event
	{
		/**
		 * 即将隐藏ToolTip
		 */		
		public static const TOOL_TIP_HIDE:String = "toolTipHide";
		/**
		 * 即将显示TooTip
		 */		
		public static const TOOL_TIP_SHOW:String = "toolTipShow";
		
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
		 * 关联的ToolTip显示对象
		 */		
		public var toolTip:IToolTip;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ToolTipEvent(type, bubbles, cancelable, toolTip);
		}
	}
	
}
