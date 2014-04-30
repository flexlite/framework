package org.flexlite.domUI.core
{
	/**
	 * DragSource 类中包含正被拖动的数据。数据可以采用多种格式，具体取决于启动拖动的控件的类型。 <p/>
	 * 每种数据格式都使用一个字符串进行标识。hasFormat() 方法用于确定对象是否包含使用相应格式的数据。dataForFormat() 方法用于检索指定格式的数据。<p/>
	 * 可以使用 addData() 方法直接添加数据，也可以使用 addHandler() 方法间接添加数据。
	 * addHandler() 方法会注册一个回调，请求该数据时将调用此回调。添加非本机格式的数据可能需要进行大量计算或转换，此时该方法就非常有用。
	 * 例如，如果您具有原始声音数据，则可以添加 MP3 格式处理程序。仅当请求 MP3 数据时才执行 MP3 转换。
	 * @author DOM
	 */	
	public class DragSource
	{
		/**
		 * 构造函数
		 */		
		public function DragSource()
		{
			super();
		}
		
		private var dataHolder:Object = {};	
		
		private var formatHandlers:Object = {};
		
		private var _formats:Array  = [];
		/**
		 * 包含拖动数据的格式，以字符串 Array 的形式表示。
		 * 使用 addData() 或 addHandler() 方法设置此属性。默认值取决于添加到 DragSource 对象的数据。
		 */		
		public function get formats():Array 
		{
			return _formats;
		}
		/**
		 * 向拖动源添加数据和相应的格式 String。
		 * @param data 用于指定拖动数据的对象。这可以是任何对象，如，String，ArrayCollection，等等。
		 * @param format 描述此数据格式的字符串。
		 */		
		public function addData(data:Object, format:String):void
		{
			_formats.push(format);
			
			dataHolder[format] = data;
		}
		
		/**
		 * 添加一个处理函数，当请求指定格式的数据时将调用此处理函数。当拖动大量数据时，此函数非常有用。仅当请求数据时才调用该处理函数。
		 * @param handler 一个函数，用于指定请求数据时需要调用的处理函数。此函数必须返回指定格式的数据。
		 * @param format 用于指定此数据的格式的字符串。
		 */		
		public function addHandler(handler:Function,
								   format:String):void
		{
			_formats.push(format);
			
			formatHandlers[format] = handler;
		}
		/**
		 * 检索指定格式的数据。如果此数据是使用 addData() 方法添加的，则可以直接返回此数据。
		 * 如果此数据是使用 addHandler() 方法添加的，则需调用处理程序函数来返回此数据。
		 * @param format 描述此数据格式的字符串。
		 */		
		public function dataForFormat(format:String):Object
		{
			var data:Object = dataHolder[format];
			if (data)
				return data;
			
			if (formatHandlers[format])
				return formatHandlers[format]();
			
			return null;
		}
		/**
		 * 如果数据源中包含所请求的格式，则返回 true；否则，返回 false。
		 * @param format 描述此数据格式的字符串。
		 */		
		public function hasFormat(format:String):Boolean
		{
			var n:int = _formats.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_formats[i] == format)
					return true;
			}
			
			return false;
		}
	}
	
}
