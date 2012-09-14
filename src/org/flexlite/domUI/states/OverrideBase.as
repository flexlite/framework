<<<<<<< HEAD
package org.flexlite.domUI.states
{
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.utils.OnDemandEventDispatcher;
	
	/**
	 * OverrideBase 类是视图状态所用的 override 类的基类。
	 * @author DOM
	 */	
	public class OverrideBase extends OnDemandEventDispatcher implements IOverride
	{
		public function OverrideBase() {}
		
		public function initialize():void {}
		
		public function apply(parent:IVisualElementContainer):void 
		{
			
		}
		
		public function remove(parent:IVisualElementContainer):void 
		{
			
		}
		/**
		 * 从对象初始化，这是一个便利方法
		 */		
		public function initializeFromObject(properties:Object):Object
		{
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
			
			return Object(this);
		}
		
	}
	
=======
package org.flexlite.domUI.states
{
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.utils.OnDemandEventDispatcher;
	
	/**
	 * OverrideBase 类是视图状态所用的 override 类的基类。
	 * @author DOM
	 */	
	public class OverrideBase extends OnDemandEventDispatcher implements IOverride
	{
		public function OverrideBase() {}
		
		public function initialize():void {}
		
		public function apply(parent:IVisualElementContainer):void 
		{
			
		}
		
		public function remove(parent:IVisualElementContainer):void 
		{
			
		}
		/**
		 * 从对象初始化，这是一个便利方法
		 */		
		public function initializeFromObject(properties:Object):Object
		{
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
			
			return Object(this);
		}
		
	}
	
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}