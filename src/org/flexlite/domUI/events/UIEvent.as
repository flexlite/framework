<<<<<<< HEAD
package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * UI事件
	 * @author DOM
	 */
	public class UIEvent extends Event
	{
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		/**
		 * 组件初始化开始 
		 */		
		public static const INITIALIZE:String = "initialize";
		/**
		 * 组件创建完成 
		 */		
		public static const CREATION_COMPLETE:String = "creationComplete";
		/**
		 * 组件的一次三个延迟验证渲染阶段全部完成 
		 */		
		public static const UPDATE_COMPLETE:String = "updateComplete";
		/**
		 * 此事件由BitmapImage和Image类分派以指示指定的图像源已完全加载。  
		 */		
		public static const READY:String = "ready";
		/**
		 * 当用户按下ButtonBase控件时分派。如果 autoRepeat属性为 true，则只要按钮处于按下状态，就将重复分派此事件。
		 */		
		public static const BUTTON_DOWN:String = "buttonDown";
		/**
		 * 进入视图状态后
		 */		
		public static const ENTER_STATE:String = "enterState";
		
		/**
		 * 即将退出视图状态之前
		 */		
		public static const EXIT_STATE:String = "exitState";
		
		/**
		 * 改变结束
		 */		
		public static const CHANGE_END:String = "changeEnd";
		
		/**
		 * 改变开始
		 */		
		public static const CHANGE_START:String = "changeStart";
		
		/**
		 * 正在改变中
		 */	
		public static const CHANGING:String = "changing";
		/**
		 * 值发生改变
		 */		
		public static const VALUE_COMMIT:String = "valueCommit";
		/**
		 * 皮肤发生改变
		 */		
		public static const SKIN_CHANGED:String = "skinChanged";
		
		/**
		 * 下拉框弹出事件
		 */		
		public static const OPEN:String = "open";
		/**
		 * 下拉框关闭事件
		 */		
		public static const CLOSE:String = "close";
		
	}
=======
package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * UI事件
	 * @author DOM
	 */
	public class UIEvent extends Event
	{
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		/**
		 * 组件初始化开始 
		 */		
		public static const INITIALIZE:String = "initialize";
		/**
		 * 组件创建完成 
		 */		
		public static const CREATION_COMPLETE:String = "creationComplete";
		/**
		 * 组件的一次三个延迟验证渲染阶段全部完成 
		 */		
		public static const UPDATE_COMPLETE:String = "updateComplete";
		/**
		 * 此事件由BitmapImage和Image类分派以指示指定的图像源已完全加载。  
		 */		
		public static const READY:String = "ready";
		/**
		 * 当用户按下ButtonBase控件时分派。如果 autoRepeat属性为 true，则只要按钮处于按下状态，就将重复分派此事件。
		 */		
		public static const BUTTON_DOWN:String = "buttonDown";
		/**
		 * 进入视图状态后
		 */		
		public static const ENTER_STATE:String = "enterState";
		
		/**
		 * 即将退出视图状态之前
		 */		
		public static const EXIT_STATE:String = "exitState";
		
		/**
		 * 改变结束
		 */		
		public static const CHANGE_END:String = "changeEnd";
		
		/**
		 * 改变开始
		 */		
		public static const CHANGE_START:String = "changeStart";
		
		/**
		 * 正在改变中
		 */	
		public static const CHANGING:String = "changing";
		/**
		 * 值发生改变
		 */		
		public static const VALUE_COMMIT:String = "valueCommit";
		/**
		 * 皮肤发生改变
		 */		
		public static const SKIN_CHANGED:String = "skinChanged";
		
		/**
		 * 下拉框弹出事件
		 */		
		public static const OPEN:String = "open";
		/**
		 * 下拉框关闭事件
		 */		
		public static const CLOSE:String = "close";
		
	}
>>>>>>> master
}