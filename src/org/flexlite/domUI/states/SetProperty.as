package org.flexlite.domUI.states
{
	import org.flexlite.domUI.core.IContainer;
	
	/**
	 * 设置属性
	 * @author DOM
	 */	
	public class SetProperty extends OverrideBase
	{
		/**
		 * 构造函数
		 */		
		public function SetProperty()
		{
			super();
		}
		
		/**
		 * 要修改的属性名
		 */		
		public var name:String;
		
		/**
		 * 目标实例名
		 */		
		public var target:String;
		
		/**
		 * 属性值 
		 */		
		public var value:*;
		
		/**
		 * 旧的属性值 
		 */		
		private var oldValue:Object;
		
		override public function apply(parent:IContainer):void
		{   
			var obj:Object = target==null||target==""?parent:parent[target];
			if(obj==null)
				return;
			oldValue = obj[name];
			setPropertyValue(obj, name, value, oldValue);
		}
		
		override public function remove(parent:IContainer):void
		{   
			var obj:Object = target==null||target==""?parent:parent[target];
			if(obj==null)
				return;
			setPropertyValue(obj, name, oldValue, oldValue);
			oldValue = null;
		}
		
		/**
		 * 设置属性值
		 */		
		private function setPropertyValue(obj:Object, name:String, value:*,
										  valueForType:Object):void
		{
			if (value === undefined || value === null)
				obj[name] = value;
			else if (valueForType is Number)
				obj[name] = Number(value);
			else if (valueForType is Boolean)
				obj[name] = toBoolean(value);
			else
				obj[name] = value;
		}
		/**
		 * 转成Boolean值
		 */		
		private function toBoolean(value:Object):Boolean
		{
			if (value is String)
				return value.toLowerCase() == "true";
			
			return value != false;
		}
	}
	
}
