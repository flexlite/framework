package org.flexlite.domCompile.core
{
	/**
	 * 代码定义基类
	 * @author DOM
	 */	
	public class CodeBase implements ICode
	{
		public function CodeBase()
		{
		}
		
		public function toCode():String
		{
			return "";
		}
		
		private var _indent:int = 0;
		
		public function get indent():int
		{
			return _indent;
		}
		public function set indent(value:int):void
		{
			_indent = value;
		}
		
		/**
		 * 获取缩进字符串
		 */		
		protected function getIndent(indent:int = -1):String
		{
			if(indent==-1)
				indent = _indent;
			var str:String = "";
			for(var i:int = 0;i<indent;i++)
			{
				str += "	";
			}
			return str;
		}
	}
}