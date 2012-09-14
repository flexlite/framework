<<<<<<< HEAD
package org.flexlite.domUI.core
{
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.IVisualElement;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 绘图元素接口
	 * @author DOM
	 */	
	public interface IGraphicElement extends IVisualElement
	{
				
		/**
		 * 绘制此 IGraphicElement 所在的共享 DisplayObject。
		 */		
		function get displayObject():DisplayObject;
		/**
		 * 指示此 IGraphicElement 与其显示对象之间的关联。
		 */		
		function get displayObjectSharingMode():String;
		function set displayObjectSharingMode(value:String):void;
		/**
		 * 创建一个新 DisplayObject 以用于绘制此 IGraphicElement。
		 */		
		function createDisplayObject():DisplayObject;
		function setSharedDisplayObject(sharedDisplayObject:DisplayObject):Boolean;
		/**
		 * 如果此 IGraphicElement 是兼容的且可以与序列中上一个 IGraphicElement 共享显示对象，则返回 true。  
		 */		
		function canShareWithPrevious(element:IGraphicElement):Boolean;
		/**
		 * 如果此 IGraphicElement 是兼容的且可以与序列中下一个 IGraphicElement 共享显示对象，则返回 true。
		 */		
		function canShareWithNext(element:IGraphicElement):Boolean;
		/**
		 * 将 IGraphicElement 添加到主机组件或从主机组件将其删除时由 IGraphicElementContainer 调用。 
		 */		
		function parentChanged(parent:IGraphicElementContainer):void;
		/**
		 * 由 IGraphicElementContainer 所调用以验证此元素的属性
		 */		
		function validateProperties():void;
		/**
		 * 由 IGraphicElementContainer 调用以验证此元素的大小。
		 */		
		function validateSize():void;
		/**
		 * 由 IGraphicElementContainer 调用以在其 displayObject 属性中重新绘制此元素。 
		 */		
		function validateDisplayList():void;
		
	}
}
=======
package org.flexlite.domUI.core
{
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.IVisualElement;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 绘图元素接口
	 * @author DOM
	 */	
	public interface IGraphicElement extends IVisualElement
	{
				
		/**
		 * 绘制此 IGraphicElement 所在的共享 DisplayObject。
		 */		
		function get displayObject():DisplayObject;
		/**
		 * 指示此 IGraphicElement 与其显示对象之间的关联。
		 */		
		function get displayObjectSharingMode():String;
		function set displayObjectSharingMode(value:String):void;
		/**
		 * 创建一个新 DisplayObject 以用于绘制此 IGraphicElement。
		 */		
		function createDisplayObject():DisplayObject;
		function setSharedDisplayObject(sharedDisplayObject:DisplayObject):Boolean;
		/**
		 * 如果此 IGraphicElement 是兼容的且可以与序列中上一个 IGraphicElement 共享显示对象，则返回 true。  
		 */		
		function canShareWithPrevious(element:IGraphicElement):Boolean;
		/**
		 * 如果此 IGraphicElement 是兼容的且可以与序列中下一个 IGraphicElement 共享显示对象，则返回 true。
		 */		
		function canShareWithNext(element:IGraphicElement):Boolean;
		/**
		 * 将 IGraphicElement 添加到主机组件或从主机组件将其删除时由 IGraphicElementContainer 调用。 
		 */		
		function parentChanged(parent:IGraphicElementContainer):void;
		/**
		 * 由 IGraphicElementContainer 所调用以验证此元素的属性
		 */		
		function validateProperties():void;
		/**
		 * 由 IGraphicElementContainer 调用以验证此元素的大小。
		 */		
		function validateSize():void;
		/**
		 * 由 IGraphicElementContainer 调用以在其 displayObject 属性中重新绘制此元素。 
		 */		
		function validateDisplayList():void;
		
	}
}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
