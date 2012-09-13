package org.flexlite.domCompile.core
{
	/**
	 * 注释
	 * @author DOM
	 */	
	public class CpNotation extends CodeBase
	{
		public function CpNotation(notation:String = "")
		{
			super();
			this.notation = notation;
		}
		
		public var notation:String = "";
		
		override public function toCode():String
		{
			var lines:Array = notation.split("\n");
			var firstIndent:String = getIndent();
			var secondIndent:String = firstIndent+" ";
			var returnStr:String = firstIndent+"/**\n";
			var line:String;
			while(lines.length>0)
			{
				line = lines.shift();
				returnStr += secondIndent + "* "+line+"\n";
			}
			returnStr += secondIndent +"*/";
			return returnStr;
			
		}
	}
}