package org.flexlite.domUI.managers
{
	
	import org.flexlite.domUI.core.IToolTip;
	import org.flexlite.domUI.core.dx_internal;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	use namespace dx_internal;
	
	
	/**
	 * 工具提示管理器
	 * @author DOM
	 */	
	public class ToolTipManager extends EventDispatcher
	{
		
		public function ToolTipManager()
		{
			super();
		}

		private static var _impl:ToolTipManagerImpl;
		
		/**
		 * 获取单例
		 */
		private static function get impl():ToolTipManagerImpl
		{
			if (!_impl)
			{
				_impl = new ToolTipManagerImpl();
			}
			return _impl;
		}
		
		/**
		 * 是否复用ToolTip实例,若为true,则每个ToolTipClass只创建一个实例缓存于管理器，
		 * 回收时需要手动调用destroyToolTip(toolTipClass)方法。
		 * 若为false，则每次都重新创建新的ToolTip实例。 默认为true。
		 */
		public function get reuseToolTip():Boolean
		{
			return impl.reuseToolTip;
		}
		
		public function set reuseToolTip(value:Boolean):void
		{
			impl.reuseToolTip = value;
		}
		
		/**
		 * 销毁指定类对应的ToolTip实例。
		 * @param toolTipClass 要移除的ToolTip类定义
		 * @return 是否移除成功,若不存在该实例，返回false。
		 */		
		public function destroyToolTip(toolTipClass:Class):Boolean
		{
			return impl.destroyToolTip(toolTipClass);
		}
		/**
		 * 当前的IToolTipManagerClient组件
		 */			
		public static function get currentTarget():IToolTipManagerClient
		{
			return impl.currentTarget;
		}
		
		public static function set currentTarget(value:IToolTipManagerClient):void
		{
			impl.currentTarget = value;
		}
		
		/**
		 * 当前可见的ToolTip显示对象；如果未显示ToolTip，则为 null。
		 */		
		public static function get currentToolTip():IToolTip
		{
			return impl.currentToolTip;
		}
		
		public static function set currentToolTip(value:IToolTip):void
		{
			impl.currentToolTip = value;
		}
		
		/**
		 * 如果为 true，则当用户将鼠标指针移至组件上方时，ToolTipManager 会自动显示工具提示。
		 * 如果为 false，则不会显示任何工具提示。
		 */		
		public static function get enabled():Boolean 
		{
			return impl.enabled;
		}
		
		public static function set enabled(value:Boolean):void
		{
			impl.enabled = value;
		}
		
		/**
		 * 自工具提示出现时起，ToolTipManager要隐藏此提示前所需等待的时间量（以毫秒为单位）。默认值：10000。
		 */		
		public static function get hideDelay():Number 
		{
			return impl.hideDelay;
		}
		
		public static function set hideDelay(value:Number):void
		{
			impl.hideDelay = value;
		}
		
		/**
		 * 当第一个ToolTip显示完毕后，若在此时间间隔内快速移动到下一个组件上，就直接显示ToolTip而不延迟showDelay。默认值：100。
		 */		
		public static function get scrubDelay():Number 
		{
			return impl.scrubDelay;
		}
		
		public static function set scrubDelay(value:Number):void
		{
			impl.scrubDelay = value;
		}

		/**
		 * 全局默认的创建工具提示要用到的类。
		 */		
		public static function get toolTipClass():Class 
		{
			return impl.toolTipClass;
		}
		
		public static function set toolTipClass(value:Class):void
		{
			impl.toolTipClass = value;
		}

		/**
		 * 注册需要显示ToolTip的组件
		 * @param target 目标组件
		 * @param oldToolTip 之前的ToolTip数据
		 * @param newToolTip 现在的ToolTip数据
		 */		
		dx_internal static function registerToolTip(target:DisplayObject,
										oldToolTip:Object,
										newToolTip:Object):void
		{
			impl.registerToolTip(target,oldToolTip,newToolTip);
		}
		
		/**
		 * 使用指定的ToolTip数据,创建默认的ToolTip类的实例，然后在舞台坐标中的指定位置显示此实例。
		 * @param toolTipData ToolTip数据
		 * @param x 舞台坐标x
		 * @param y 舞台坐标y
		 * @return 创建的ToolTip实例引用
		 */		
		public static function createToolTip(toolTipData:String, x:Number, y:Number):IToolTip
		{
			return impl.createToolTip(toolTipData,x,y);
		}
	}
	
}
