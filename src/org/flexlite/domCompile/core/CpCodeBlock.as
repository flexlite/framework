<<<<<<< HEAD
package org.flexlite.domCompile.core
{
	import org.flexlite.domCompile.consts.KeyWords;

	/**
	 * 代码块
	 * @author DOM
	 */
	public class CpCodeBlock extends CodeBase
	{
		public function CpCodeBlock()
		{
			super();
			indent = 0;
		}
		
		/**
		 * 添加变量声明语句
		 * @param name 变量名
		 * @param type 变量类型
		 * @param value 变量初始值
		 */		
		public function addVar(name:String,type:String,value:String=""):void
		{
			var valueStr:String = "";
			if(value!=null&&value!="")
			{
				valueStr = " = "+value;
			}
			addCodeLine(KeyWords.KW_VAR+" "+name+":"+type+valueStr+";");
		}
		/**
		 * 添加赋值语句
		 * @param target 要赋值的目标
		 * @param value 值
		 * @param prop 目标的属性(用“.”访问)，不填则是对目标赋值
		 */		
		public function addAssignment(target:String,value:String,prop:String=""):void
		{
			var propStr:String = "";
			if(prop!=null&&prop!="")
			{
				propStr = "."+prop;
			}
			addCodeLine(target+propStr+" = "+value+";");
		}
		/**
		 * 添加返回值语句
		 */		
		public function addReturn(data:String):void
		{
			addCodeLine(KeyWords.KW_RETURN+" "+data+";");
		}
		/**
		 * 添加一条空行
		 */		
		public function addEmptyLine():void
		{
			addCodeLine("");
		}
		/**
		 * 开始添加if语句块,自动调用startBlock();
		 */		
		public function startIf(expression:String):void
		{
			addCodeLine("if("+expression+")");
			startBlock();
		}
		/**
		 * 开始else语句块,自动调用startBlock();
		 */		
		public function startElse():void
		{
			addCodeLine("else");
			startBlock();
		}
		
		/**
		 * 开始else if语句块,自动调用startBlock();
		 */		
		public function startElseIf(expression:String):void
		{
			addCodeLine("else if("+expression+")");
			startBlock();
		}
		/**
		 * 添加一个左大括号，开始新的语句块
		 */		
		public function startBlock():void
		{
			addCodeLine("{");
			indent++;
		}
		
		/**
		 * 添加一个右大括号,结束当前的语句块
		 */		
		public function endBlock():void
		{
			indent --;
			addCodeLine("}");
		}
		/**
		 * 添加执行函数语句块
		 * @param functionName
		 * @param args
		 */		
		public function doFunction(functionName:String,args:Array):void
		{
			var argsStr:String = "";
			var isFirst:Boolean = true;
			while(args.length>0)
			{
				var arg:String = args.shift();
				if(isFirst)
				{
					argsStr += arg;
				}
				else
				{
					argsStr += ","+arg;
				}
			}
			addCodeLine(functionName+"("+argsStr+")");
		}
		
		private var codeStr:String = "";
		
		/**
		 * 添加一行代码
		 */		
		public function addCodeLine(code:String):void
		{
			codeStr += getIndent()+code+"\n";
		}
		
		override public function toCode():String
		{
			return codeStr.substr(0,codeStr.length-1);
		}
	}
=======
package org.flexlite.domCompile.core
{
	import org.flexlite.domCompile.consts.KeyWords;

	/**
	 * 代码块
	 * @author DOM
	 */
	public class CpCodeBlock extends CodeBase
	{
		public function CpCodeBlock()
		{
			super();
			indent = 0;
		}
		
		/**
		 * 添加变量声明语句
		 * @param name 变量名
		 * @param type 变量类型
		 * @param value 变量初始值
		 */		
		public function addVar(name:String,type:String,value:String=""):void
		{
			var valueStr:String = "";
			if(value!=null&&value!="")
			{
				valueStr = " = "+value;
			}
			addCodeLine(KeyWords.KW_VAR+" "+name+":"+type+valueStr+";");
		}
		/**
		 * 添加赋值语句
		 * @param target 要赋值的目标
		 * @param value 值
		 * @param prop 目标的属性(用“.”访问)，不填则是对目标赋值
		 */		
		public function addAssignment(target:String,value:String,prop:String=""):void
		{
			var propStr:String = "";
			if(prop!=null&&prop!="")
			{
				propStr = "."+prop;
			}
			addCodeLine(target+propStr+" = "+value+";");
		}
		/**
		 * 添加返回值语句
		 */		
		public function addReturn(data:String):void
		{
			addCodeLine(KeyWords.KW_RETURN+" "+data+";");
		}
		/**
		 * 添加一条空行
		 */		
		public function addEmptyLine():void
		{
			addCodeLine("");
		}
		/**
		 * 开始添加if语句块,自动调用startBlock();
		 */		
		public function startIf(expression:String):void
		{
			addCodeLine("if("+expression+")");
			startBlock();
		}
		/**
		 * 开始else语句块,自动调用startBlock();
		 */		
		public function startElse():void
		{
			addCodeLine("else");
			startBlock();
		}
		
		/**
		 * 开始else if语句块,自动调用startBlock();
		 */		
		public function startElseIf(expression:String):void
		{
			addCodeLine("else if("+expression+")");
			startBlock();
		}
		/**
		 * 添加一个左大括号，开始新的语句块
		 */		
		public function startBlock():void
		{
			addCodeLine("{");
			indent++;
		}
		
		/**
		 * 添加一个右大括号,结束当前的语句块
		 */		
		public function endBlock():void
		{
			indent --;
			addCodeLine("}");
		}
		/**
		 * 添加执行函数语句块
		 * @param functionName
		 * @param args
		 */		
		public function doFunction(functionName:String,args:Array):void
		{
			var argsStr:String = "";
			var isFirst:Boolean = true;
			while(args.length>0)
			{
				var arg:String = args.shift();
				if(isFirst)
				{
					argsStr += arg;
				}
				else
				{
					argsStr += ","+arg;
				}
			}
			addCodeLine(functionName+"("+argsStr+")");
		}
		
		private var codeStr:String = "";
		
		/**
		 * 添加一行代码
		 */		
		public function addCodeLine(code:String):void
		{
			codeStr += getIndent()+code+"\n";
		}
		
		override public function toCode():String
		{
			return codeStr.substr(0,codeStr.length-1);
		}
	}
>>>>>>> master
}