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
		 * 动画持续时间,单位毫秒，默认值500
		 */
		function get duration():Number;
		function set duration(value:Number):void;
		/**
		 * 是否正在播放动画，不包括延迟等待和暂停的阶段。
		 */
		function get isPlaying():Boolean;
		/**
		 * 动画已经开始的标志，包括延迟等待和暂停的阶段。
		 */		
		function get started():Boolean;
		/**
		 * 正在暂停中
		 */
		function get isPaused():Boolean;
		/**
		 * 正在反向播放。
		 */
		function get isReverse():Boolean;
		/**
		 * 开始正向播放动画,无论何时调用都重新从零时刻开始，若设置了延迟会首先进行等待。
		 */	
		function play(targets:Array=null):void;
		/**
		 * 仅当动画已经在播放中时有效，从当前位置开始沿motionPaths定义的路径反向播放。
		 */	
		function reverse():void;
		/**
		 * 直接跳到动画结尾
		 */		
		function end():void;
		/**
		 * 停止播放动画
		 */	
		function stop():void;
		/**
		 * 暂停播放
		 */		
		function pause():void;
		/**
		 * 继续播放
		 */		
		function resume():void;
		/**
		 * 重置所有属性为初始状态。若正在播放中，同时立即停止动画。
		 */
		function reset():void;
	}
}