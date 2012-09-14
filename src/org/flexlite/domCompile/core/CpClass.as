<<<<<<< HEAD
package org.flexlite.domCompile.core
{
	import org.flexlite.domCompile.consts.KeyWords;
	import org.flexlite.domCompile.consts.Modifiers;
	

	/**
	 * 类定义
	 * @author DOM
	 */	
	public class CpClass extends CodeBase
	{
		public function CpClass()
		{
			super();
			indent = 1;
		}
		/**
		 * 构造函数的参数列表 
		 */		
		private var argumentBlock:Array = [];
		/**
		 * 添加构造函数的参数
		 */		
		public function addArgument(argumentItem:ICode):void
		{
			for each(var item:CpArguments in argumentBlock)
			{
				if(item==argumentItem)
				{
					return ;
				}
			}
			argumentBlock.push(argumentItem);
		}
		/**
		 * 构造函数代码块 
		 */		
		public var constructCode:CpCodeBlock;
		/**
		 * 类名 
		 */		
		public var className:String = "CpClass";
		
		/**
		 * 包名 
		 */		
		public var packageName:String = "";
		
		/**
		 * 修饰符 
		 */		
		public var modifierName:String = Modifiers.M_PUBLIC;
		
		/**
		 * 父类类名 
		 */		
		public var superClass:String = "";
		
		/**
		 * 接口列表 
		 */		
		private var interfaceBlock:Array = [];
		
		/**
		 * 添加接口
		 */		
		public function addInterface(interfaceName:String):void
		{
			if(interfaceName==null||interfaceName=="")
				return;
			for each(var item:String in interfaceBlock)
			{
				if(item==interfaceName)
				{
					return ;
				}
			}
			interfaceBlock.push(interfaceName);
		}
		/**
		 * 导入包区块 
		 */		
		private var importBlock:Array = [];
		/**
		 * 导入包
		 */		
		public function addImport(importItem:String):void
		{
			if(importItem==null||importItem=="")
				return;

			for each(var item:String in importBlock)
			{
				if(item==importItem)
				{
					return ;
				}
			}
			importBlock.push(importItem);
		}
		
		/**
		 * 对变量列表进行排序
		 */		
		private function sortImport():void
		{
			var length:int = importBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(importBlock[j]<importBlock[min])
						min = j;
				}
				if(min!=i)
				{
					var imp:String = importBlock[min];
					importBlock[min] = importBlock[i];
					importBlock[i] = imp;
				}
			}
		}
		
		/**
		 * 变量定义区块 
		 */		
		private var variableBlock:Array = [];
		
		/**
		 * 添加变量
		 */		
		public function addVariable(variableItem:ICode):void
		{
			for each(var item:ICode in variableBlock)
			{
				if(item==variableItem)
				{
					return ;
				}
			}
			variableBlock.push(variableItem);
		}
		/**
		 * 是否包含指定名称的变量
		 */		
		public function containsVar(name:String):Boolean
		{
			for each(var item:CpVariable in variableBlock)
			{
				if(item.name==name)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对变量列表进行排序
		 */		
		private function sortVariable():void
		{
			var length:int = variableBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(variableBlock[j].name<variableBlock[min].name)
						min = j;
				}
				if(min!=i)
				{
					var variable:CpVariable = variableBlock[min];
					variableBlock[min] = variableBlock[i];
					variableBlock[i] = variable;
				}
			}
		}
		
		/**
		 * 函数定义区块 
		 */		
		private var functionBlock:Array = [];
		
		/**
		 * 添加函数
		 */		
		public function addFunction(functionItem:ICode):void
		{
			for each(var item:ICode in functionBlock)
			{
				if(item==functionItem)
				{
					return ;
				}
			}
			functionBlock.push(functionItem);
		}
		/**
		 * 是否包含指定名称的函数
		 */		
		public function containsFunc(name:String):Boolean
		{
			for each(var item:CpFunction in functionBlock)
			{
				if(item.name==name)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对函数列表进行排序
		 */		
		private function sortFunction():void
		{
			var length:int = functionBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(functionBlock[j].name<functionBlock[min].name)
						min = j;
				}
				if(min!=i)
				{
					var func:CpFunction = functionBlock[min];
					functionBlock[min] = functionBlock[i];
					functionBlock[i] = func;
				}
			}
		}
		
		/**
		 * 类注释 
		 */		
		public var notation:CpNotation;
		
		override public function toCode():String
		{
			//字符串排序
			sortImport();
			sortVariable();
			sortFunction();
			
			var isFirst:Boolean = true;
			var index:int = 0;
			var indentStr:String = getIndent();
			
			//打印包名
			var returnStr:String = KeyWords.KW_PACKAGE+" "+packageName+"\n{\n";
			
			//打印导入包
			index = 0;
			while(index<importBlock.length)
			{
				var importItem:String = importBlock[index];
				returnStr += indentStr+KeyWords.KW_IMPORT+" "+importItem+";\n";
				index ++;
			}
			returnStr += "\n";
			
			//打印注释
			if(notation!=null)
			{
				notation.indent = indent;
				returnStr += notation.toCode()+"\n";
			}
			returnStr += indentStr+modifierName+" "+KeyWords.KW_CLASS+" "+
				className;
			
			//打印父类
			if(superClass!=null&&superClass!="")
			{
				returnStr += " "+KeyWords.KW_EXTENDS+" "+superClass;
			}
			
			//打印接口列表
			if(interfaceBlock.length>0)
			{
				returnStr += " "+KeyWords.KW_IMPLEMENTS+" ";
				
				index = 0;
				while(interfaceBlock.length>index)
				{
					isFirst = true;
					var interfaceItem:String = interfaceBlock[index];
					if(isFirst)
					{
						returnStr += interfaceItem;
						isFirst = false;
					}
					else
					{
						returnStr += ","+interfaceItem;
					}
					index++;
				}
			}
			returnStr += "\n"+indentStr+"{\n";
			
			//打印变量列表
			if(variableBlock.length>1)
				returnStr += 
					getIndent(indent+1)+"//==========================================================================\n"+
					getIndent(indent+1)+"//                                定义成员变量\n"+
					getIndent(indent+1)+"//==========================================================================\n";
			index = 0;
			while(variableBlock.length>index)
			{
				var variableItem:ICode = variableBlock[index];
				returnStr += variableItem.toCode()+"\n\n";
				index++;
			}
			returnStr += "\n";
			
			//打印构造函数
			returnStr += 
				getIndent(indent+1)+"//==========================================================================\n"+
				getIndent(indent+1)+"//                                定义构造函数\n"+
				getIndent(indent+1)+"//==========================================================================\n";
			returnStr +=getIndent(indent+1)+Modifiers.M_PUBLIC+" "+KeyWords.KW_FUNCTION+" "+className+"(";
			isFirst = true;
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
			returnStr += ")\n"+getIndent(indent+1)+"{\n";
			var indent2Str:String = getIndent(indent+2);
			if(superClass!=null&&superClass!="")
			{
				returnStr += indent2Str+"super();\n";
			}
			if(constructCode!=null)
			{
				var codes:Array = constructCode.toCode().split("\n");
				index = 0;
				while(codes.length>index)
				{
					var code:String = codes[index];
					returnStr += indent2Str+code+"\n";
					index++;
				}
			}
			returnStr += getIndent(indent+1)+"}\n\n\n";
			
			
			//打印函数列表
			if(functionBlock.length>1)
				returnStr += 
					getIndent(indent+1)+"//==========================================================================\n"+
					getIndent(indent+1)+"//                                定义成员方法\n"+
					getIndent(indent+1)+"//==========================================================================\n";
			index = 0;
			while(functionBlock.length>index)
			{
				var functionItem:ICode = functionBlock[index];
				returnStr += functionItem.toCode()+"\n\n";
				index++;
			}
			
			returnStr += indentStr+"}\n}";
			
			//不能移除完整包名，因为同目录下若出现同名类，这情况是无法判断的。
			//returnStr = removeImportStr(returnStr);
			
			return returnStr;
		}
		/**
		 * 移除多余的导入包名
		 */		
		private function removeImportStr(returnStr:String):String
		{
			var sameStrs:Array = [];
			for(var i:int=0;i<importBlock.length;i++)
			{
				var found:Boolean = false;
				var name:String = getClassName(importBlock[i]);
				var j:int;
				for(j=i+1;j<importBlock.length;j++)
				{
					if(name==getClassName(importBlock[j]))
					{
						found = true;
						break;
					}
				}
				if(found)
				{
					sameStrs.push(importBlock[i]);
					sameStrs.push(importBlock[j]);
				}
			}
			
			var removeStrs:Array = importBlock.concat();
			for(var index:int=0;index<removeStrs.length;index++)
			{
				var str:String = removeStrs[index];
				if(sameStrs.indexOf(str)!=-1)
				{
					removeStrs.splice(index,1);
					index--;
				}
			}
			
			for each(var impStr:String in removeStrs)
			{
				var className:String = getClassName(impStr);
				returnStr = replaceStr(returnStr,":"+impStr,":"+className);
				returnStr = replaceStr(returnStr,"new "+impStr,"new "+className);
				returnStr = replaceStr(returnStr,"extends "+impStr,"extends "+className);
			}
			return returnStr
		}
		/**
		 * 获取类名
		 */		
		private function getClassName(packageName:String):String
		{
			var lastIndex:int = packageName.lastIndexOf(".");
			return packageName.substr(lastIndex+1);
		}
		/**
		 * 替换字符串
		 */		
		private static function replaceStr(targetStr:String,p:String,rep:String):String
		{
			var arr:Array = targetStr.split(p);
			var returnStr:String = "";
			var isFirst:Boolean = true;
			for each(var str:String in arr)
			{
				if(isFirst)
				{
					returnStr = str;
					isFirst = false;
				}
				else
				{
					returnStr += rep+str;
				}
			}
			return returnStr;
		}
		
		
	}
=======
package org.flexlite.domCompile.core
{
	import org.flexlite.domCompile.consts.KeyWords;
	import org.flexlite.domCompile.consts.Modifiers;
	

	/**
	 * 类定义
	 * @author DOM
	 */	
	public class CpClass extends CodeBase
	{
		public function CpClass()
		{
			super();
			indent = 1;
		}
		/**
		 * 构造函数的参数列表 
		 */		
		private var argumentBlock:Array = [];
		/**
		 * 添加构造函数的参数
		 */		
		public function addArgument(argumentItem:ICode):void
		{
			for each(var item:CpArguments in argumentBlock)
			{
				if(item==argumentItem)
				{
					return ;
				}
			}
			argumentBlock.push(argumentItem);
		}
		/**
		 * 构造函数代码块 
		 */		
		public var constructCode:CpCodeBlock;
		/**
		 * 类名 
		 */		
		public var className:String = "CpClass";
		
		/**
		 * 包名 
		 */		
		public var packageName:String = "";
		
		/**
		 * 修饰符 
		 */		
		public var modifierName:String = Modifiers.M_PUBLIC;
		
		/**
		 * 父类类名 
		 */		
		public var superClass:String = "";
		
		/**
		 * 接口列表 
		 */		
		private var interfaceBlock:Array = [];
		
		/**
		 * 添加接口
		 */		
		public function addInterface(interfaceName:String):void
		{
			if(interfaceName==null||interfaceName=="")
				return;
			for each(var item:String in interfaceBlock)
			{
				if(item==interfaceName)
				{
					return ;
				}
			}
			interfaceBlock.push(interfaceName);
		}
		/**
		 * 导入包区块 
		 */		
		private var importBlock:Array = [];
		/**
		 * 导入包
		 */		
		public function addImport(importItem:String):void
		{
			if(importItem==null||importItem=="")
				return;

			for each(var item:String in importBlock)
			{
				if(item==importItem)
				{
					return ;
				}
			}
			importBlock.push(importItem);
		}
		
		/**
		 * 对变量列表进行排序
		 */		
		private function sortImport():void
		{
			var length:int = importBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(importBlock[j]<importBlock[min])
						min = j;
				}
				if(min!=i)
				{
					var imp:String = importBlock[min];
					importBlock[min] = importBlock[i];
					importBlock[i] = imp;
				}
			}
		}
		
		/**
		 * 变量定义区块 
		 */		
		private var variableBlock:Array = [];
		
		/**
		 * 添加变量
		 */		
		public function addVariable(variableItem:ICode):void
		{
			for each(var item:ICode in variableBlock)
			{
				if(item==variableItem)
				{
					return ;
				}
			}
			variableBlock.push(variableItem);
		}
		/**
		 * 是否包含指定名称的变量
		 */		
		public function containsVar(name:String):Boolean
		{
			for each(var item:CpVariable in variableBlock)
			{
				if(item.name==name)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对变量列表进行排序
		 */		
		private function sortVariable():void
		{
			var length:int = variableBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(variableBlock[j].name<variableBlock[min].name)
						min = j;
				}
				if(min!=i)
				{
					var variable:CpVariable = variableBlock[min];
					variableBlock[min] = variableBlock[i];
					variableBlock[i] = variable;
				}
			}
		}
		
		/**
		 * 函数定义区块 
		 */		
		private var functionBlock:Array = [];
		
		/**
		 * 添加函数
		 */		
		public function addFunction(functionItem:ICode):void
		{
			for each(var item:ICode in functionBlock)
			{
				if(item==functionItem)
				{
					return ;
				}
			}
			functionBlock.push(functionItem);
		}
		/**
		 * 是否包含指定名称的函数
		 */		
		public function containsFunc(name:String):Boolean
		{
			for each(var item:CpFunction in functionBlock)
			{
				if(item.name==name)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 对函数列表进行排序
		 */		
		private function sortFunction():void
		{
			var length:int = functionBlock.length;
			for(var i:int=0; i<length; i++)
			{
				var min:int = i;
				for(var j:int=i+1;j<length;j++)
				{
					if(functionBlock[j].name<functionBlock[min].name)
						min = j;
				}
				if(min!=i)
				{
					var func:CpFunction = functionBlock[min];
					functionBlock[min] = functionBlock[i];
					functionBlock[i] = func;
				}
			}
		}
		
		/**
		 * 类注释 
		 */		
		public var notation:CpNotation;
		
		override public function toCode():String
		{
			//字符串排序
			sortImport();
			sortVariable();
			sortFunction();
			
			var isFirst:Boolean = true;
			var index:int = 0;
			var indentStr:String = getIndent();
			
			//打印包名
			var returnStr:String = KeyWords.KW_PACKAGE+" "+packageName+"\n{\n";
			
			//打印导入包
			index = 0;
			while(index<importBlock.length)
			{
				var importItem:String = importBlock[index];
				returnStr += indentStr+KeyWords.KW_IMPORT+" "+importItem+";\n";
				index ++;
			}
			returnStr += "\n";
			
			//打印注释
			if(notation!=null)
			{
				notation.indent = indent;
				returnStr += notation.toCode()+"\n";
			}
			returnStr += indentStr+modifierName+" "+KeyWords.KW_CLASS+" "+
				className;
			
			//打印父类
			if(superClass!=null&&superClass!="")
			{
				returnStr += " "+KeyWords.KW_EXTENDS+" "+superClass;
			}
			
			//打印接口列表
			if(interfaceBlock.length>0)
			{
				returnStr += " "+KeyWords.KW_IMPLEMENTS+" ";
				
				index = 0;
				while(interfaceBlock.length>index)
				{
					isFirst = true;
					var interfaceItem:String = interfaceBlock[index];
					if(isFirst)
					{
						returnStr += interfaceItem;
						isFirst = false;
					}
					else
					{
						returnStr += ","+interfaceItem;
					}
					index++;
				}
			}
			returnStr += "\n"+indentStr+"{\n";
			
			//打印变量列表
			if(variableBlock.length>1)
				returnStr += 
					getIndent(indent+1)+"//==========================================================================\n"+
					getIndent(indent+1)+"//                                定义成员变量\n"+
					getIndent(indent+1)+"//==========================================================================\n";
			index = 0;
			while(variableBlock.length>index)
			{
				var variableItem:ICode = variableBlock[index];
				returnStr += variableItem.toCode()+"\n\n";
				index++;
			}
			returnStr += "\n";
			
			//打印构造函数
			returnStr += 
				getIndent(indent+1)+"//==========================================================================\n"+
				getIndent(indent+1)+"//                                定义构造函数\n"+
				getIndent(indent+1)+"//==========================================================================\n";
			returnStr +=getIndent(indent+1)+Modifiers.M_PUBLIC+" "+KeyWords.KW_FUNCTION+" "+className+"(";
			isFirst = true;
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
			returnStr += ")\n"+getIndent(indent+1)+"{\n";
			var indent2Str:String = getIndent(indent+2);
			if(superClass!=null&&superClass!="")
			{
				returnStr += indent2Str+"super();\n";
			}
			if(constructCode!=null)
			{
				var codes:Array = constructCode.toCode().split("\n");
				index = 0;
				while(codes.length>index)
				{
					var code:String = codes[index];
					returnStr += indent2Str+code+"\n";
					index++;
				}
			}
			returnStr += getIndent(indent+1)+"}\n\n\n";
			
			
			//打印函数列表
			if(functionBlock.length>1)
				returnStr += 
					getIndent(indent+1)+"//==========================================================================\n"+
					getIndent(indent+1)+"//                                定义成员方法\n"+
					getIndent(indent+1)+"//==========================================================================\n";
			index = 0;
			while(functionBlock.length>index)
			{
				var functionItem:ICode = functionBlock[index];
				returnStr += functionItem.toCode()+"\n\n";
				index++;
			}
			
			returnStr += indentStr+"}\n}";
			
			//不能移除完整包名，因为同目录下若出现同名类，这情况是无法判断的。
			//returnStr = removeImportStr(returnStr);
			
			return returnStr;
		}
		/**
		 * 移除多余的导入包名
		 */		
		private function removeImportStr(returnStr:String):String
		{
			var sameStrs:Array = [];
			for(var i:int=0;i<importBlock.length;i++)
			{
				var found:Boolean = false;
				var name:String = getClassName(importBlock[i]);
				var j:int;
				for(j=i+1;j<importBlock.length;j++)
				{
					if(name==getClassName(importBlock[j]))
					{
						found = true;
						break;
					}
				}
				if(found)
				{
					sameStrs.push(importBlock[i]);
					sameStrs.push(importBlock[j]);
				}
			}
			
			var removeStrs:Array = importBlock.concat();
			for(var index:int=0;index<removeStrs.length;index++)
			{
				var str:String = removeStrs[index];
				if(sameStrs.indexOf(str)!=-1)
				{
					removeStrs.splice(index,1);
					index--;
				}
			}
			
			for each(var impStr:String in removeStrs)
			{
				var className:String = getClassName(impStr);
				returnStr = replaceStr(returnStr,":"+impStr,":"+className);
				returnStr = replaceStr(returnStr,"new "+impStr,"new "+className);
				returnStr = replaceStr(returnStr,"extends "+impStr,"extends "+className);
			}
			return returnStr
		}
		/**
		 * 获取类名
		 */		
		private function getClassName(packageName:String):String
		{
			var lastIndex:int = packageName.lastIndexOf(".");
			return packageName.substr(lastIndex+1);
		}
		/**
		 * 替换字符串
		 */		
		private static function replaceStr(targetStr:String,p:String,rep:String):String
		{
			var arr:Array = targetStr.split(p);
			var returnStr:String = "";
			var isFirst:Boolean = true;
			for each(var str:String in arr)
			{
				if(isFirst)
				{
					returnStr = str;
					isFirst = false;
				}
				else
				{
					returnStr += rep+str;
				}
			}
			return returnStr;
		}
		
		
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}