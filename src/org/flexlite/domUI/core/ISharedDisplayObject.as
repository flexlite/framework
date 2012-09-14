<<<<<<< HEAD
package org.flexlite.domUI.core
{
	/**
	 * ISharedDisplayObject 接口定义要在 IGraphicElement 对象之间共享 DisplayObject 必须实现的最低要求。
	 * @author DOM
	 */	
	public interface ISharedDisplayObject
	{
		/**
		 * 需要重新绘制共享此 DisplayObject 的任何 IGraphicElement 对象时为true。
		 */		
		function get redrawRequested():Boolean;
		function set redrawRequested(value:Boolean):void;
	}
=======
package org.flexlite.domUI.core
{
	/**
	 * ISharedDisplayObject 接口定义要在 IGraphicElement 对象之间共享 DisplayObject 必须实现的最低要求。
	 * @author DOM
	 */	
	public interface ISharedDisplayObject
	{
		/**
		 * 需要重新绘制共享此 DisplayObject 的任何 IGraphicElement 对象时为true。
		 */		
		function get redrawRequested():Boolean;
		function set redrawRequested(value:Boolean):void;
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}