package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 动画特效事件
	 * @author DOM
	 */	
	public class EffectEvent extends Event
	{
		/**
		 * 动画播放结束
		 */		
		public static const EFFECT_END:String = "effectEnd";
		/**
		 * 动画播放被停止
		 */		
		public static const EFFECT_STOP:String = "effectStop";
		/**
		 * 动画播放开始
		 */		
		public static const EFFECT_START:String = "effectStart";
		/**
		 * 动画开始重复播放
		 */		
		public static const EFFECT_REPEAT:String = "effectRepeat";
		/**
		 * 动画播放更新
		 */		
		public static const EFFECT_UPDATE:String = "effectUpdate";
		
		/**
		 * 构造函数
		 */		
		public function EffectEvent(eventType:String, bubbles:Boolean = false,
									cancelable:Boolean = false)
		{
			super(eventType, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new EffectEvent(type, bubbles, cancelable);
		}
	}
	
}
