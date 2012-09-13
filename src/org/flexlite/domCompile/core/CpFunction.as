package org.flexlite.domCompile.core
{
	import org.flexlite.domCompile.consts.DataType;
	import org.flexlite.domCompile.consts.KeyWords;
	import org.flexlite.domCompile.consts.Modifiers;

	/**
	 * 函数定义
	 * @author DOM
	 */	
	public class CpFunction extends CodeBase
	{
		public function CpFunction()
		{
			super();
			indent = 2
		}
		
		/**
		 * 修饰符 ,默认Modifiers.M_PRIVATE
		 */		
		public var modifierName:String = Modifiers.M_PRIVATE;

		/**
		 * 代码块 
		 */		
		public var codeBlock:CpCodeBlock;
		
		/**
		 * 是否是静态 ，默认false
		 */		
		public var isStatic:Boolean = false;
		
		/**
		 * 是否覆盖父级方法 ，默认false
		 */		
		public var isOverride:Boolean = false;
		/**
		 *参数列表 
		 */		
		private var argumentBlock:Array = [];
		/**
		 * 添加参数
		 */		
		public function addArgument(argumentItem:ICode):void
		{
			for each(var item:CpArguments in argumentBlock)
			{
				if(item==argumentItem)
				{
					return;
				}
			}
			argumentBlock.push(argumentItem);
		}
		
		/**
		 * 函数注释 
		 */		
		public var notation:CpNotation;
		/**
		 * 函数名 
		 */		
		public var name:String = "";
		
		public var returnType:String = DataType.DT_VOID;
		
		override public function toCode():String
		{
			var index:int = 0;
			var indentStr:String = getIndent();
			var overrideStr:String = isOverride?KeyWords.KW_OVERRIDE+" ":"";
			var staticStr:String = isStatic?Modifiers.M_STATIC+" ":"";
			var noteStr:String = "";
			if(notation!=null)
			{
				notation.indent = indent;
				noteStr = notation.toCode()+"\n";
			}
			
			var returnStr:String = noteStr+indentStr+overrideStr+modifierName+" "
				+staticStr+KeyWords.KW_FUNCTION+" "+name+"(";
			
			var isFirst:Boolean = true;
			index = 0;
			while(argumentBlock.length>index)
			{
				var arg:ICode = argumentBlock[index];
				if(isFirst)
				{
					returnStr += arg.toCode();
					isFirst = false;
				}
				else
				{
					returnStr += ","+arg.toCode();
				}
				index++;
			}
			returnStr += ")";
			if(returnType!="")
				returnStr += ":"+returnType;
			returnStr += "\n"+indentStr+"{\n";
			if(codeBlock!=null)
			{
				var lines:Array = codeBlock.toCode().split("\n");
				var codeIndent:String = getIndent(indent+1);
				index = 0;
				while(lines.length>index)
				{
					var line:String = lines[index];
					returnStr += codeIndent+line+"\n";
					index ++;
				}
			}
			
			returnStr += indentStr+"}";
			return returnStr;
		}
	}
}