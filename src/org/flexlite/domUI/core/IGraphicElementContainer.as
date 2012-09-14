<<<<<<< HEAD
package org.flexlite.domUI.core
{
	public interface IGraphicElementContainer
	{
		/**
		 * 通知主机组件绘图元素的图层已经更改 
		 */		
		function invalidateGraphicElementSharing(element:IGraphicElement):void
		/**
		 *  通知主机组件绘图元素的属性已经更改 
		 */			
		function invalidateGraphicElementProperties(element:IGraphicElement):void;
		/**
		 *  通知主机组件绘图元素的尺寸需要重新测量
		 */		
		function invalidateGraphicElementSize(element:IGraphicElement):void;
		/**
		 *  通知主机组件绘图元素需要重新绘制
		 */		
		function invalidateGraphicElementDisplayList(element:IGraphicElement):void;
		
		
	}
=======
package org.flexlite.domUI.core
{
	public interface IGraphicElementContainer
	{
		/**
		 * 通知主机组件绘图元素的图层已经更改 
		 */		
		function invalidateGraphicElementSharing(element:IGraphicElement):void
		/**
		 *  通知主机组件绘图元素的属性已经更改 
		 */			
		function invalidateGraphicElementProperties(element:IGraphicElement):void;
		/**
		 *  通知主机组件绘图元素的尺寸需要重新测量
		 */		
		function invalidateGraphicElementSize(element:IGraphicElement):void;
		/**
		 *  通知主机组件绘图元素需要重新绘制
		 */		
		function invalidateGraphicElementDisplayList(element:IGraphicElement):void;
		
		
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}