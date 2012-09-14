package org.flexlite.domUI.core
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
	}
}