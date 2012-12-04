package org.flexlite.domUI.components.supportClasses
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.flexlite.domUI.core.ISkinAdapter;
	
	
	/**
	 * 默认的ISkinAdapter接口实现
	 * @author DOM
	 */
	public class DefaultSkinAdapter implements ISkinAdapter
	{
		/**
		 * 构造函数
		 */		
		public function DefaultSkinAdapter()
		{
		}
		/**
		 * @inheritDoc
		 */
		public function getSkin(skinName:Object,compFunc:Function,oldSkin:DisplayObject=null):void
		{
			if(skinName is Class)
			{
				compFunc(new skinName(),skinName);
			}
			else if(skinName is String||skinName is ByteArray)
			{
				var loader:Loader = new Loader;
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:Event):void{
					compFunc(skinName,skinName);
				});
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
					if(loader.content is Bitmap)
					{
						var bitmapData:BitmapData = (loader.content as Bitmap).bitmapData;
						compFunc(new Bitmap(bitmapData,"auto",true),skinName);
					}
					else
					{
						compFunc(loader.content,skinName);
					}
				});
				if(skinName is String)
					loader.load(new URLRequest(skinName as String));
				else
					loader.loadBytes(skinName as ByteArray);
			}
			else if(skinName is BitmapData)
			{
				var skin:Bitmap;
				if(oldSkin is Bitmap)
				{
					skin = oldSkin as Bitmap;
					skin.bitmapData = skinName as BitmapData;
				}
				else
				{
					skin = new Bitmap(skinName as BitmapData,"auto",true);
				}
				compFunc(skin,skinName);
			}
			else
			{
				compFunc(skinName,skinName);
			}
		}
	}
}