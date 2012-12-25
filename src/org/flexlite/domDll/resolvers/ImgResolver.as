package org.flexlite.domDll.resolvers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * 图片文件解析器<br/>
	 * 由于图片如果直接缓存解码后的数据将会造成巨大的内存开销。 所以图片只缓存二进制数据，
	 * 需要使用时异步获取。即使把图片配置到预加载组里，也需要通过异步方式才能获取。
	 * @author DOM
	 */
	public class ImgResolver extends BinResolver
	{
		public function ImgResolver()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getRes(key:String):*
		{
			if(sharedMap.has(key))
				return sharedMap.get(key);
			return null;
		}
		
		/**
		 * 回调函数字典类 
		 */		
		private var compFuncDic:Dictionary;
		/**
		 * 键名字典
		 */		
		private var keyDic:Dictionary;
		
		/**
		 * @inheritDoc
		 */
		override public function getResAsync(key:String,compFunc:Function):void
		{
			if(sharedMap.has(key))
			{
				var res:* = sharedMap.get(key);
				if(compFunc!=null)
					compFunc(res);
			}
			else
			{
				var bytes:ByteArray = fileDic[key];
				if(bytes)
				{
					if(!compFuncDic)
						compFuncDic = new Dictionary();
					var compFuncList:Vector.<Function> = compFuncDic[key];
					if(compFuncList)
					{
						compFuncList.push(compFunc);
						return;
					}
					compFuncList = compFuncDic[key] =  new Vector.<Function>();
					compFuncList.push(compFunc);
					
					var loader:Loader = new Loader();
					var loaderContext:LoaderContext = new LoaderContext();
					if(loaderContext.hasOwnProperty("imageDecodingPolicy"))//如果是FP11以上版本，开启异步位图解码
						loaderContext["imageDecodingPolicy"] = "onLoad";
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,bytesComplete);
					if(!keyDic)
						keyDic = new Dictionary();
					keyDic[loader] = key;
					loader.loadBytes(bytes,loaderContext);
				}
				else
				{
					if(compFunc!=null)
						compFunc(null);
				}
			}
		}
		
		/**
		 * 图片解码完成
		 */		
		private function bytesComplete(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bytesComplete); 
			var key:String = keyDic[loader];
			delete keyDic[loader];
			var compFuncList:Vector.<Function> = compFuncDic[key];
			delete compFuncDic[key];
			var bitmapData:BitmapData = null;
			try
			{
				bitmapData= (loader.content as Bitmap).bitmapData;
			}
			catch(e:Error){}
			sharedMap.set(key,bitmapData);
			for each(var func:Function in compFuncList)
			{
				if(func!=null)
					func(bitmapData);
			}
		}
	}
}