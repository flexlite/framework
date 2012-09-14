package org.flexlite.domUI.primitives.graphic
{
	import flash.display.Graphics;
	import flash.display.GraphicsStroke;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 定义用于定义线条的类必须实现的接口。
	 * @author DOM
	 */	
	public interface IStroke
	{
		/**
		 * 线条粗细（以像素为单位）。对于许多图表线，默认值都为 1 个像素。
		 */		
		function get weight():Number;		
		function set weight(value:Number):void;
		
		/**
		 * LineScaleMode 类中的一个值，指定要使用的缩放模式。有效值为： <br/>
		 * LineScaleMode.NORMAL始终在缩放对象时缩放线条的粗细（默认值）。<br/>
		 * LineScaleMode.NONE从不缩放线条粗细。 <br/>
		 * LineScaleMode.VERTICAL如果仅垂直缩放对象，则不缩放线条粗细。 <br/>
		 * LineScaleMode.HORIZONTAL如果仅水平缩放对象，则不缩放线条粗细。 <br/>
		 */		
		function get scaleMode():String;
		
		/**
		 * 表示将在哪个限制位置切断尖角。有效值范围是 0 到 255。
		 */		
		function get miterLimit():Number;
		
		/**
		 * 指定角度所用的直线相交处的外观。有效值为：JointStyle.ROUND、JointStyle.MITER 和 JointStyle.BEVEL。
		 */		
		function get joints():String;
		
		/**
		 * 对指定的 Graphics 对象应用属性。 
		 * @param graphics 对指定的 Graphics 对象应用属性。
		 * @param targetBounds 笔触所应用到的形状的边界。
		 * @param targetOrigin 在目标的坐标系中定义形状的原点 (0,0) 的点。
		 */		
		function apply(graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point):void;
		
		/**
		 * 生成表示此笔触的 GraphicsStroke 对象。 
		 * @param targetBounds 笔触的定界框。
		 * @param targetOrigin 在目标的坐标系中定义形状的原点 (0,0) 的点。
		 */		
		function createGraphicsStroke(targetBounds:Rectangle, targetOrigin:Point):GraphicsStroke; 
	}
	
}
