package org.flexlite.domUI.states
{
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.utils.OnDemandEventDispatcher;
	
	/**
	 * OverrideBase 类是视图状态所用的 override 类的基类。
	 * @author DOM
	 */	
	public class OverrideBase extends OnDemandEventDispatcher implements IOverride
	{
		public function OverrideBase() {}
		
		public function initialize(parent:IStateClient):void 
		{
		}
		
		public function apply(parent:IContainer):void 
		{
			
		}
		
		public function remove(parent:IContainer):void 
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
	
}