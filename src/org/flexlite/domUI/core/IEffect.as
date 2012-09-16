package org.flexlite.domUI.core
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 动画特效接口
	 * @author DOM
	 */
	public interface IEffect extends IEventDispatcher
	{
		/**
		 * 要应用此动画特效的对象。若要将特效同时应用到多个对象，请使用targets属性。
		 */		
		function get target():Object;
		function set target(value:Object):void;
		/**
		 * 要应用此动画特效的多个对象列表。
		 */
		function get targets():Array;
		function set targets(value:Array):void;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#duration
		 */
		function get duration():Number;
		function set duration(value:Number):void;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#isPlaying
		 */
		function get isPlaying():Boolean;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#isPaused
		 */
		function get isPaused():Boolean;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#isReverse
		 */
		function get isReverse():Boolean;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#play()
		 */	
		function play(targets:Array=null):void;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#reverse()
		 */	
		function reverse():void;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#end()
		 */		
		function end():void;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#stop()
		 */	
		function stop():void;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#pause()
		 */		
		function pause():void;
		/**
		 * @copy org.flexlite.domUI.effects.animation.Animation#resume()
		 */		
		function resume():void;
	}
}