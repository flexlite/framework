package org.flexlite.domUI.core
{
	import flash.events.IEventDispatcher;

	/**
	 * 可布局元素接口
	 * @author DOM
	 */
	public interface ILayoutElement extends IEventDispatcher
	{
		/**
		 * 指定此组件是否包含在父容器的布局中。若为false，则父级容器在测量和布局阶段都忽略此组件。默认值为true。
		 * 注意，visible属性与此属性不同，设置visible为false，父级容器仍会对其布局。
		 */		
		function get includeInLayout():Boolean;
		
		function set includeInLayout(value:Boolean):void;
		/**
		 * 距父级容器离左边距离
		 */		
		function get left():Number;
		
		function set left(value:Number):void;
		/**
		 * 距父级容器右边距离
		 */
		function get right():Number;
		
		function set right(value:Number):void;
		/**
		 * 距父级容器顶部距离
		 */
		function get top():Number;
		
		function set top(value:Number):void;
		/**
		 * 距父级容器底部距离
		 */		
		function get bottom():Number;
		
		function set bottom(value:Number):void;
		/**
		 * 在父级容器中距水平中心位置的距离
		 */		
		function get horizontalCenter():Number;
			
		function set horizontalCenter(value:Number):void;
		/**
		 * 在父级容器中距竖直中心位置的距离
		 */	
		function get verticalCenter():Number;
		
		function set verticalCenter(value:Number):void;
		/**
		 * 相对父级容器宽度的百分比
		 */		
		function get percentWidth():Number;
		
		function set percentWidth(value:Number):void;
		/**
		 * 相对父级容器高度的百分比
		 */		
		function get percentHeight():Number;
		
		function set percentHeight(value:Number):void;
		
		/**
		 * 组件的首选x坐标,常用于父级的measure()方法中
		 */		
		function get preferredX():Number;
		
		/**
		 * 组件的首选y坐标,常用于父级的measure()方法中
		 */
		function get preferredY():Number;
		
		/**
		 * 组件水平方向起始坐标
		 */		
		function get layoutBoundsX():Number;
		/**
		 * 组件竖直方向起始坐标
		 */		
		function get layoutBoundsY():Number;
		
		
		/**
		 * 组件的首选宽度,常用于父级的measure()方法中
		 * 按照：外部显式设置宽度>测量宽度 的优先级顺序返回宽度
		 * 注意:此数值已经包含了scaleX的值
		 */		
		function get preferredWidth():Number;
		
		/**
		 * 组件的首选高度,常用于父级的measure()方法中
		 * 按照：外部显式设置高度>测量高度 的优先级顺序返回高度
		 * 注意:此数值已经包含了scaleY的值
		 */
		function get preferredHeight():Number;
		/**
		 * 组件的布局宽度,常用于父级的updateDisplayList()方法中
		 * 按照：布局宽度>外部显式设置宽度>测量宽度 的优先级顺序返回宽度
		 * 注意:此数值已经包含了scaleX的值
		 */		
		function get layoutBoundsWidth():Number;
		/**
		 * 组件的布局高度,常用于父级的updateDisplayList()方法中
		 * 按照：布局高度>外部显式设置高度>测量高度 的优先级顺序返回高度
		 * 注意:此数值已经包含了scaleY的值
		 */		
		function get layoutBoundsHeight():Number;
		/**
		 * 表示从注册点开始应用的对象的水平缩放比例（百分比）。默认注册点为 (0,0)。1.0 等于 100% 缩放。 
		 */		
		function get scaleX():Number;
		/**
		 * 表示从对象注册点开始应用的对象的垂直缩放比例（百分比）。默认注册点为 (0,0)。1.0 是 100% 缩放。
		 */		
		function get scaleY():Number;
		/**
		 * 组件的最大测量宽度,仅影响measuredWidth属性的取值范围。
		 */	
		function get maxWidth():Number;
		function set maxWidth(value:Number):void;
		/**
		 * 组件的最小测量宽度,此属性设置为大于maxWidth的值时无效。仅影响measuredWidth属性的取值范围。
		 */
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		/**
		 * 组件的最大测量高度,仅影响measuredHeight属性的取值范围。
		 */
		function get maxHeight():Number;
		function set maxHeight(value:Number):void;
		/**
		 * 组件的最小测量高度,此属性设置为大于maxHeight的值时无效。仅影响measuredHeight属性的取值范围。
		 */
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		/**
		 * 设置组件的布局宽高,此值应已包含scaleX,scaleY的值
		 */		
		function setLayoutBoundsSize(width:Number,height:Number):void;
		/**
		 * 设置组件的布局位置
		 */		
		function setLayoutBoundsPosition(x:Number,y:Number):void;
	}
}