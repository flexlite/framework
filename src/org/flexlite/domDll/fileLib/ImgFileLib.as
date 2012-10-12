package org.flexlite.domDll.fileLib
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * 图片文件解析缓存库
	 * @author DOM
	 */
	public class ImgFileLib extends FileLibBase
	{
		public function ImgFileLib()
		{
			super();
		}
		
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
					var loader:Loader=new Loader();    
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bytesComplete); 
					if(!keyDic)
						keyDic = new Dictionary();
					keyDic[loader] = key;
					loader.loadBytes(bytes); 
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
			for each(var func:Function in compFuncList)
			{
				if(func!=null)
					func(bitmapData);
			}
			sharedMap.set(key,bitmapData);
		}
	}
}