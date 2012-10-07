package org.flexlite.domDisplay.codec
{
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDisplay.DxrData;
	
	use namespace dx_internal;
	
	/**
	 * DXR动画解码器
	 * @author DOM
	 */	
	public class DxrDecoder
	{
		public function DxrDecoder()
		{
		}
		
		/**
		 * 解码完成回调函数
		 */		
		private var compFunc:Function;
		/**
		 * 位图解码器
		 */		
		private var bitmapDecoder:IBitmapDecoder;
		/**
		 * dxr原始数据
		 */		
		private var dxrSourceData:Object;
		/**
		 * 解码完成的DxrData对象
		 */		
		private var dxrData:DxrData;
		/**
		 * 当前加载到的位图序号
		 */		
		private var currentIndex:int;
		/**
		 * 解码后的位图列表
		 */		
		private var bitmapDataList:Vector.<BitmapData>;
		/**
		 * 将一个Dxr动画数据解码为DxrData对象
		 * @param data 要解码的原始数据
		 * @param key 动画导出键名
		 * @param onComp 解码完成回调函数，示例：onComp(data:DxrData);
		 */		
		public function decode(data:Object,key:String,onComp:Function):void
		{
			dxrData = new DxrData(key,data.codec);	
			compFunc = onComp;
			currentIndex = 0;
			dxrSourceData = data;
			bitmapDataList = new Vector.<BitmapData>();
			this.bitmapDecoder =Injector.getInstance(IBitmapDecoder,dxrData.codecKey);
			addToDecodeList(this);
		}
		/**
		 * 解码下一张位图
		 */		
		private function next():void
		{
			if(currentIndex>=dxrSourceData["bitmapList"]["length"])
				allComp();
			else
				decodeOneBitmap();
		}
		/**
		 * 解码一张位图
		 */		
		private function decodeOneBitmap():void
		{
			bitmapDecoder.decode(dxrSourceData["bitmapList"][currentIndex] as ByteArray,onOneComp);
		}
		/**
		 * 一张位图解码完成
		 */		
		private function onOneComp(data:BitmapData):void
		{
			bitmapDataList.push(data);
			currentIndex++;
			next();
		}
		/**
		 * 所有位图序列解码完成
		 */
		private function allComp():void
		{
			var bd:BitmapData;
			var rect:Rectangle;
			for each(var info:Array in dxrSourceData.frameInfo)
			{
				bd = new BitmapData(info[3],info[4],true,0);
				rect = new Rectangle(info[1],info[2],info[3],info[4]);
				bd.copyPixels(bitmapDataList[info[0]],rect,new Point(0,0),null,null,true);
				dxrData.frameList.push(bd);
				dxrData.frameOffsetList.push(new Point(info[5],info[6]));
				if(info[7])
				{
					dxrData.filterOffsetList[dxrData.frameList.length-1] = new Point(info[7],info[8]);
				}
			}
			if(dxrSourceData.hasOwnProperty("scale9Grid"))
			{
				var sg:Array = dxrSourceData.scale9Grid as Array;
				dxrData._scale9Grid = new Rectangle();
				dxrData._scale9Grid.left = sg[0];
				dxrData._scale9Grid.top = sg[1];
				dxrData._scale9Grid.right = sg[2];
				dxrData._scale9Grid.bottom = sg[3];
			}
			
			if(dxrSourceData.hasOwnProperty("frameLabels"))
			{
				var fls:Array = dxrSourceData.frameLabels as Array;
				dxrData._frameLabels = [];
				for each(var label:Array in fls)
				{
					dxrData._frameLabels.push(new FrameLabel(label[1],label[0]));
				}
			}
			if(compFunc!=null)
			{
				compFunc(dxrData);
			}
			dxrData = null;
			compFunc = null;
			currentIndex = 0;
			dxrSourceData = null;
			bitmapDataList = null;
		}
		
		/**
		 * EnterFrame事件抛出者
		 */		
		private static var eventDispatcher:Sprite = new Sprite();
		/**
		 * 待解码列表
		 */		
		private static var decodeList:Vector.<DxrDecoder> = new Vector.<DxrDecoder>();
		/**
		 * 添加到待解码队列
		 */		
		private static function addToDecodeList(decoder:DxrDecoder):void
		{
			if(decodeList.indexOf(decoder)!=-1)
				return;
			decodeList.push(decoder);
			if(decodeList.length==1)
			{
				eventDispatcher.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		/**
		 * 每帧最大解码字节流总大小
		 */		
		dx_internal static var MAX_DECODE_LENGTH:int = 5000;
		/**
		 * EnterFrame事件处理函数
		 */		
		private static function onEnterFrame(event:Event):void
		{
			var max:int = MAX_DECODE_LENGTH;
			var total:int = 0;
			while(total<max&&decodeList.length>0)
			{
				var decoder:DxrDecoder = decodeList.shift();
				decoder.next();
				for each(var byte:ByteArray in decoder.dxrSourceData.bitmapList)
				{
					total += byte.length;
				}
			}
			if(decodeList.length==0)
			{
				eventDispatcher.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		/**
		 * 从字节流数据中读取文件信息描述对象
		 * @param data 文件的字节流数据
		 */		
		public static function readObject(data:ByteArray):Object
		{
			if(data==null)
			{
				throw new Error("DXR动画文件字节流为空！");
			}
			try
			{
				data.position = 0;
				if(data.readUTF() != "dxr")
				{
					throw new Error();
				}
				var hasCompress:Boolean = data.readBoolean();
				var dxrBytes:ByteArray = new ByteArray();
				data.readBytes(dxrBytes);
				if(hasCompress)
				{
					dxrBytes.uncompress();
				}
				var keyObject:Object = dxrBytes.readObject();
				if(keyObject["keyList"]==null)
				{
					throw new Error();
				}
				return keyObject;
			}
			catch(e:Error)
			{
				throw new Error("不是有效的DXR动画文件！");
			}
			return null;
		}
	}
}