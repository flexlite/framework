package org.flexlite.domUI.states
{
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.IStateClient;
	
	/**
	 * IOverride 接口用于视图状态覆盖。State 类 overrides 属性数组中的所有条目均必须实现此接口。
	 * @author DOM
	 */	
	public interface IOverride
	{
		/**
		 * 初始化覆盖。在第一次调用 apply() 方法之前调用此方法，因此将覆盖的一次性初始化代码放在此方法中。 
		 */		 
		function initialize(parent:IStateClient):void;
		/**
		 * 应用覆盖。将保留原始值，以便以后可以在 remove() 方法中恢复该值。 
		 */			
		function apply(parent:IContainer):void;
		/**
		 * 删除覆盖。在 apply() 方法中记住的值将被恢复。 
		 */		
		function remove(parent:IContainer):void;
	}
}
