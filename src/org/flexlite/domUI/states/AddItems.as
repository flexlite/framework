package org.flexlite.domUI.states
{
	import org.flexlite.domUI.core.IDeferredInstance;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	
	
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
		 * 创建项目的工厂类实例 
		 */		
		public var targetFactory:IDeferredInstance;
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
		 * 目标显示元素 
		 */		
		private var target:IVisualElement;
		
		override public function initialize():void
		{
			target = targetFactory.getInstance() as IVisualElement;
		}
		
		override public function apply(parent:IVisualElementContainer):void
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
			var dest:IVisualElementContainer = propertyName==null||propertyName==""?
					parent:parent[propertyName] as IVisualElementContainer;
			if(dest==null)
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
			dest.addElementAt(target,index);
		}
		
		override public function remove(parent:IVisualElementContainer):void
		{
			var dest:IVisualElementContainer = propertyName==null||propertyName==""?
				parent:parent[propertyName] as IVisualElementContainer;
			if(dest==null)
				return;
			if(dest.getElementIndex(target)!=-1)
			{
				dest.removeElement(target);
			}
		}
	}
	
}
