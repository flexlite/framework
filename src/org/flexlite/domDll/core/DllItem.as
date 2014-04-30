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
		/**
		 * SWF素材文件
		 */		
		public static const TYPE_SWF:String = "swf";
		/**
		 * RSL文件,对必须加载到当前域的SWF文件,使用这种文件类型。
		 */		
		public static const TYPE_RSL:String = "rsl";
		/** 
		 * XML文件  
		 */		
		public static const TYPE_XML:String = "xml";
		/** 
		 * 图片文件 
		 */		
		public static const TYPE_IMG:String = "img";
		/** 
		 * 二进制流文件
		 */		
		public static const TYPE_BIN:String = "bin";
		/** 
		 * DXR文件 
		 */		
		public static const TYPE_DXR:String = "dxr";
		/** 
		 * 二进制序列化对象 
		 */		
		public static const TYPE_AMF:String = "amf";
		/** 
		 * 文本文件(解析为字符串)
		 */		
		public static const TYPE_TXT:String = "txt";
		/**
		 * 声音文件
		 */		
		public static const TYPE_SOUND:String = "sound";
		/**
		 * 组资源文件,多种类型文件打包合并成的文件。
		 */		
		public static const TYPE_GRP:String = "grp";
		
		/**
		 * 构造函数
		 * @param name 加载项名称
		 * @param url 要加载的文件地址 
		 * @param type 加载项文件类型
		 * @param size 加载项文件大小(单位:字节)
		 * @param compFunc 加载并解析完成回调函数
		 */			
		public function DllItem(name:String,url:String,type:String,size:int=0)
		{
			this.name = name;
			this.url = url;
			this.type = type;
			this.size = size;
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
		 * 二级键名列表
		 */		
		public function get subkeys():Array
		{
			return data?data.subkeys:null;
		}
		
		dx_internal var _groupName:String;
		/**
		 * 所属组名
		 */
		public function get groupName():String
		{
			return _groupName;
		}

		/**
		 * 加载结束回调函数。无论加载成功或者出错都将执行回调函数。示例：compFunc(dllItem:DllItem):void;
		 */		
		dx_internal var compFunc:Function;

		/**
		 * 已经加载的字节数
		 */		
		dx_internal var bytesLoaded:int = 0;
		/**
		 * 开始加载时间
		 */		
		dx_internal var startTime:int = 0;
		/**
		 * 加载结束时间
		 */		
		dx_internal var _loadTime:int = 0;
		/**
		 * 加载时间,单位:ms
		 */		
		public function get loadTime():int
		{
			return _loadTime;
		}
		/**
		 * 被引用的原始数据对象
		 */		
		dx_internal var data:Object;
		
		private var _loaded:Boolean = false;
		/**
		 * 加载完成的标志
		 */
		public function get loaded():Boolean
		{
			return data?data.loaded:_loaded;
		}

		public function set loaded(value:Boolean):void
		{
			if(data)
				data.loaded = value;
			_loaded = value;
		}

		
		public function toString():String
		{
			return "[DllItem name=\""+name+"\" url=\""+url+"\" type=\""+type+"\" " +
				"size=\""+size+"\" loadTime=\""+loadTime+"\" loaded=\""+loaded+"\"]";
		}
	}
}