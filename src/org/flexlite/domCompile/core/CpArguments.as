<<<<<<< HEAD
package org.flexlite.domCompile.core
{
	/**
	 * 参数定义
	 * @author DOM
	 */	
	public class CpArguments extends CodeBase
	{
		public function CpArguments(name:String = "",type:String = "")
		{
			super();
			this.name = name;
			this.type = type;
		}
		
		public var name:String = "";
		
		public var type:String = "";
		
		override public function toCode():String
		{
			return name+":"+type;
		}
	}
=======
package org.flexlite.domCompile.core
{
	/**
	 * 参数定义
	 * @author DOM
	 */	
	public class CpArguments extends CodeBase
	{
		public function CpArguments(name:String = "",type:String = "")
		{
			super();
			this.name = name;
			this.type = type;
		}
		
		public var name:String = "";
		
		public var type:String = "";
		
		override public function toCode():String
		{
			return name+":"+type;
		}
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}