package org.flexlite.domDll.core
{
	import org.flexlite.domCore.dx_internal;

	use namespace dx_internal;
	/**
	 * 加载项
	 * @author DOM
	 */
	public class DllItem
	{
		/** SWF文件 */		
		public static const TYPE_SWF:String = "swf";
		/** XML文件  */		
		public static const TYPE_XML:String = "xml";
		/** 图片文件 */		
		public static const TYPE_IMG:String = "img";
		/** 二进制流 */		
		public static const TYPE_BIN:String = "bin";
		/** DXR文件 */		
		public static const TYPE_DXR:String = "dxr";
		/** 二进制序列化对象 */		
		public static const TYPE_AMF:String = "amf";
		/** JSON文件 */		
		public static const TYPE_JSON:String = "json";
		
		
		/**
		 * 构造函数
		 * @param name 加载项名称
		 * @param url 要加载的文件地址 
		 * @param type 加载项文件类型
		 * @param size 加载项文件大小(单位:字节)
		 * @param compFunc 加载并解析完成回调函数
		 */			
		public function DllItem(name:String,url:String,
								type:String,size:int=0,compFunc:Function=null)
		{
			this.name = name;
			this.url = url;
			this.type = type;
			this.size = size;
			this.compFunc = compFunc;
		}
		
		/**
		 * 加载项名称
		 */
		public var name:String;
		/**
		 * 要加载的文件地址 
		 */
		public var url:String;
		/**
		 * 加载项文件类型
		 */
		public var type:String;
		/**
		 * 加载项文件大小(单位:字节)
		 */		
		public var size:int = 0;
		/**
		 * 加载结束回调函数。无论加载成功或者出错都将执行回调函数。示例：compFunc(dllItem:DllItem):void;
		 */		
		public var compFunc:Function;
		/**
		 * 出于队列加载中
		 */		
		dx_internal var inGroupLoading:Boolean = false;
		
		public function toString():String
		{
			return "[DllItem name=\""+name+"\" url=\""+url+"\" type=\""+type+"\" size=\""+size+"\"]";
		}
	}
}