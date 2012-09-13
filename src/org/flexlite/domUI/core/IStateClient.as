package org.flexlite.domUI.core
{
	import flash.events.IEventDispatcher;

	/**
	 * 具有视图状态的组件接口
	 * @author DOM
	 */
	public interface IStateClient extends IEventDispatcher
	{
		/**
		 * 组件的当前视图状态。将其设置为 "" 或 null 可将组件重置回其基本状态。 
		 */		
		function get currentState():String;
		
		function set currentState(value:String):void;
		
		/**
		 * 为此组件定义的视图状态。
		 */		
		function get states():Array;
		
		function set states(value:Array):void;
		
		/**
		 * 返回是否含有指定名称的视图状态
		 * @param stateName 要检测的视图状态名称
		 */			
		function hasState(stateName:String):Boolean
	}
}