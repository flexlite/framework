package org.flexlite.domCompile.core
{
	import org.flexlite.domCompile.consts.DataType;
	import org.flexlite.domCompile.consts.KeyWords;
	import org.flexlite.domCompile.consts.Modifiers;

	/**
	 * 变量定义
	 * @author DOM
	 */	
	public class CpVariable extends CodeBase
	{
		public function CpVariable(name:String = "varName",modifierName:String="public",
								   type:String = "Object",defaultValue:String="",
								   isStatic:Boolean = false,isConst:Boolean=false,metadata:String="")
		{
			super();
			indent = 2;
			this.name = name;
			this.modifierName = modifierName;
			this.type = type;
			this.isStatic = isStatic;
			this.isConst = isConst;
			this.defaultValue = defaultValue;
			this.metadata = metadata;
		}
		
		/**
		 * 变量之前的原标签声明 
		 */		
		public var metadata:String = "";
		/**
		 * 修饰符 
		 */		
		public var modifierName:String = Modifiers.M_PUBLIC;
		
		/**
		 * 是否是静态 
		 */		
		public var isStatic:Boolean = false;
		
		/**
		 * 是否是常量 
		 */		
		public var isConst:Boolean = false;
		
		/**
		 * 常量名 
		 */		
		public var name:String = "varName";
		/**
		 * 默认值 
		 */		
		public var defaultValue:String = "";
		
		/**
		 * 数据类型 
		 */		
		public var type:String = DataType.DT_OBJECT;
		
		/**
		 * 变量注释 
		 */		
		public var notation:CpNotation;
		
		override public function toCode():String
		{
			var noteStr:String = "";
			if(notation!=null)
			{
				notation.indent = indent;
				noteStr = notation.toCode()+"\n";
			}
			var metadataStr:String = "";
			if(metadata!=""&&metadata!=null)
			{
				metadataStr = getIndent()+"["+metadata+"]\n";
			}
			var staticStr:String = isStatic?Modifiers.M_STATIC+" ":"";
			var valueStr:String = "";
			if(defaultValue!=""&&defaultValue!=null)
			{
				valueStr = " = "+defaultValue;
			}
			var keyWord:String = isConst?KeyWords.KW_CONST:KeyWords.KW_VAR;
			return noteStr+metadataStr+getIndent()+modifierName+" "+staticStr+keyWord
				+" "+name+":"+type+valueStr+";";
		}
	}
}