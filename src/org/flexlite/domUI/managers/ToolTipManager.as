package org.flexlite.domUI.managers
{
	
	import flash.display.DisplayObject;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IToolTip;
	import org.flexlite.domUI.managers.impl.ToolTipManagerImpl;
	
	use namespace dx_internal;
	
	
	/**
	 * 工具提示管理器<p/>
	 * 若项目需要自定义工具提示管理器，请实现IToolTipManager接口，
	 * 并在项目初始化前调用Injector.mapClass(IToolTipManager,YourToolTipManager)，
	 * 注入自定义的工具提示管理器类。
	 * @author DOM
	 */	
	public class ToolTipManager
	{
		/**
		 * 构造函数
		 */		
		public function ToolTipManager()
		{
			super();
		}

		private static var _impl:IToolTipManager;
		
		/**
		 * 获取单例
		 */
		private static function get impl():IToolTipManager
		{
			if (!_impl)
			{
				try
				{
					_impl = Injector.getInstance(IToolTipManager);
				}
				catch(e:Error)
				{
					_impl = new ToolTipManagerImpl();
				}
			}
			return _impl;
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
		 * 如果为 true，则当用户将鼠标指针移至组件上方时，ToolTipManager会自动显示工具提示。
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
		 * 当第一个ToolTip显示完毕后，若在此时间间隔内快速移动到下一个组件上，
		 * 就直接显示ToolTip而不延迟showDelay。默认值：100。
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
		 * 当用户将鼠标移至具有工具提示的组件上方时，等待 ToolTip框出现所需的时间（以毫秒为单位）。
		 * 若要立即显示ToolTip框，请将toolTipShowDelay设为0。默认值：200。
		 */			
		public static function get showDelay():Number 
		{
			return impl.showDelay;
		}
		public static function set showDelay(value:Number):void
		{
			impl.showDelay = value;
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
		 * 保存此方法返回的对 ToolTip 的引用，以便将其传递给destroyToolTip()方法销毁实例。
		 * @param toolTipData ToolTip数据
		 * @param x 舞台坐标x
		 * @param y 舞台坐标y
		 * @return 创建的ToolTip实例引用
		 */		
		public static function createToolTip(toolTipData:String, x:Number, y:Number):IToolTip
		{
			return impl.createToolTip(toolTipData,x,y);
		}
		/**
		 * 销毁由createToolTip()方法创建的ToolTip实例。 
		 * @param toolTip 要销毁的ToolTip实例
		 */		
		public static function destroyToolTip(toolTip:IToolTip):void
		{
			return impl.destroyToolTip(toolTip);
		}
	}
	
}
