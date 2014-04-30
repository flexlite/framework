package org.flexlite.domCore
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 影片剪辑接口
	 * @author DOM
	 */
	public interface IMovieClip extends IEventDispatcher
	{
		/**
		 * 当前播放到的帧索引,从0开始
		 */
		function get currentFrame():int;
		/**
		 * 动画总帧数
		 */
		function get totalFrames():int;
		/**
		 * 返回由FrameLabel对象组成的数组。数组包括整个Dxr动画实例的所有帧标签。
		 */		
		function get frameLabels():Array;
		/**
		 * 是否循环播放,默认为true。
		 */		
		function get repeatPlay():Boolean;
		function set repeatPlay(value:Boolean):void;
		/**
		 * 跳到指定帧并播放
		 * @param frame 可以是帧索引或者帧标签，帧索引从0开始。
		 */
		function gotoAndPlay(frame:Object):void;
		/**
		 * 跳到指定帧并停止
		 * @param frame 可以是帧索引或者帧标签，帧索引从0开始。
		 */
		function gotoAndStop(frame:Object):void;
		/**
		 * 从当期帧开始播放
		 */		
		function play():void;
		/**
		 * 在当前帧停止播放
		 */		
		function stop():void;
		/**
		 * 为指定帧添加回调函数。注意：同一帧只能添加一个回调函数。后添加的回调函数将会覆盖之前的。
		 * @param frame 要添加回调的帧索引，从0开始。
		 * @param callBack 回调函数。设置为null，将取消之前添加的回调函数。
		 */		
		function addFrameScript(frame:int,callBack:Function):void;
	}
}