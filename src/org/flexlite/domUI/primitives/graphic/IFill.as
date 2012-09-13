package org.flexlite.domUI.primitives.graphic
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 定义执行填充的类必须实现的接口。
	 * @author DOM
	 */	
	public interface IFill
	{	
		/**
		 * 开始填充。 
		 * @param target 开始填充。
		 * @param targetBounds 定义 target 内填充大小的 Rectangle 对象。
		 * 		如果 Rectangle 的尺寸大于 target 的尺寸，则将剪裁填充。
		 * 		如果 Rectangle 的尺寸小于 target 的尺寸，则将扩展填充以填充整个 target。
		 * @param targetOrigin 在目标的坐标系中定义形状的原点 (0,0) 的点。
		 */		
		function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void;
		/**
		 * 结束填充。 
		 * @param target 要填充的 Graphics 对象。
		 */		
		function end(target:Graphics):void;
	}
	
}
