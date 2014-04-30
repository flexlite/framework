package org.flexlite.domUI.states
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.SkinnableComponent;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.ISkinnableClient;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.core.IVisualElement;
	
	use namespace dx_internal;
	
	/**
	 * 添加显示元素
	 * @author DOM
	 */	
	public class AddItems extends OverrideBase 
	{
		/**
		 * 添加父级容器的底层
		 */		
		public static const FIRST:String = "first";
		/**
		 * 添加在父级容器的顶层 
		 */		
		public static const LAST:String = "last";
		/**
		 * 添加在相对对象之前 
		 */		
		public static const BEFORE:String = "before";
		/**
		 * 添加在相对对象之后 
		 */		
		public static const AFTER:String = "after";
		
		/**
		 * 构造函数
		 */		
		public function AddItems()
		{
			super();
		}
		
		/**
		 * 要添加到的属性 
		 */		
		public var propertyName:String = "";
		
		/**
		 * 添加的位置 
		 */		
		public var position:String = AddItems.LAST;
		
		/**
		 * 相对的显示元素的实例名
		 */		
		public var relativeTo:String;
		
		/**
		 * 目标实例名
		 */		
		public var target:String;
		
		private var INITIALIZE_FUNCTION:QName = new QName(dx_internal, "initialize")
		
		override public function initialize(parent:IStateClient):void
		{
			var targetElement:IVisualElement = parent[target] as IVisualElement;
			if(!targetElement||targetElement is SkinnableComponent)
				return;
			//让UIAsset和UIMovieClip等素材组件立即开始初始化，防止延迟闪一下或首次点击失效的问题。
			if(targetElement is ISkinnableClient)
			{
				try
				{
					targetElement[INITIALIZE_FUNCTION]();
				}
				catch(e:Error)
				{
				}
			}
		}
		
		override public function apply(parent:IContainer):void
		{
			var index:int;
			var relative:IVisualElement;
			try
			{
				relative = parent[relativeTo] as IVisualElement;
			}
			catch(e:Error)
			{
			}
			var targetElement:IVisualElement = parent[target] as IVisualElement;
			var dest:IContainer = propertyName?parent[propertyName]:parent as IContainer;
			if(!targetElement||!dest)
				return;
			switch (position)
			{
				case FIRST:
					index = 0;
					break;
				case LAST:
					index = -1;
					break;
				case BEFORE:
					index = dest.getElementIndex(relative);
					break;
				case AFTER:
					index = dest.getElementIndex(relative) + 1;
					break;
			}    
			if (index == -1)
				index = dest.numElements;
			dest.addElementAt(targetElement,index);
		}
		
		override public function remove(parent:IContainer):void
		{
			var dest:IContainer = propertyName==null||propertyName==""?
				parent:parent[propertyName] as IContainer;
			var targetElement:IVisualElement = parent[target] as IVisualElement;
			if(!targetElement||!dest)
				return;
			if(dest.getElementIndex(targetElement)!=-1)
			{
				dest.removeElement(targetElement);
			}
		}
	}
	
}
