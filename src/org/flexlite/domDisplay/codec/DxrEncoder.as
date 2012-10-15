package org.flexlite.domDisplay.codec
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.flexlite.domCore.Injector;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDisplay.DxrData;
	import org.flexlite.domUtils.CRC32Util;
	
	use namespace dx_internal;

	/**
	 * DXR动画编码器
	 * @author DOM
	 */	
	public class DxrEncoder
	{
		/**
		 * 构造函数
		 */		
		public function DxrEncoder()
		{
		}
		/**
		 * 默认位图编解码器标识符
		 */		
		public static const DEFAULT_CODEC:String = "jpeg32";
		/**
		 * 将多个MovieClip对象编码为Dxr动画数据，合并到一个文件，返回文件的字节流数组
		 * @param mcList MovieClip对象列表,也可以传入显示对象列表,当做单帧处理
		 * @param keyList MovieClip在文件中的导出键名列表
		 * @param codecList 位图编解码器标识符列表,"jpegxr"|"jpeg32"|"png",留空默认值为"jpeg32"
		 * @param compress 二进制压缩格式，仅支持CompressionAlgorithm.ZLIB和CompressionAlgorithm.LZMA(需要11.4支持),
		 * 输入其他任何值都认为不启用二进制压缩。默认值：CompressionAlgorithm.ZLIB。
		 * @param maxBitmapWidth 单张位图最大宽度
		 * @param maxBitmapHeight 单张位图最大高度
		 */	
		public function encode(mcList:Array,keyList:Array=null,codecList:Array=null,compress:String="zlib",
							   maxBitmapWidth:Number=4000,maxBitmapHeight:Number=4000):ByteArray
		{
			var dxrDataList:Array = drawMcList(mcList,keyList,codecList);
			return encodeDxrDataList(dxrDataList,compress,maxBitmapWidth,maxBitmapHeight);
		}
		
		/**
		 * 绘制多个MovieClip对象，返回对应的dxrData列表
		 * @param mcList MovieClip列表
		 * @param keyList 导出键名列表,如果留空,编码器会为每个dxrData自动生成一个唯一的key
		 * @param codecList 位图编解码器标识符列表,"jpegxr"|"jpeg32"|"png",留空默认值为"jpeg32"
		 */		
		public function drawMcList(mcList:Array,keyList:Array=null,codecList:Array=null):Array
		{
			var dxrDataList:Array = [];
			var index:int = 0;
			for each(var mc:DisplayObject in mcList)
			{
				var codec:String = codecList?codecList[index]:DEFAULT_CODEC;
				var key:String = keyList?keyList[index]:null;
				var dxrData:DxrData = drawDxrData(mc,key,codec);
				if(key==null||key=="")
				{
					generateKey(dxrData);
				}
				dxrDataList.push(dxrData);
				index++;
			}
			return dxrDataList;
		}
		
		/**
		 * 将多个DxrData对象编码合并到一个文件，返回文件的字节流数组
		 * @param dxrDataList DxrData对象列表
		 * @param compress 二进制压缩格式，仅支持CompressionAlgorithm.ZLIB和CompressionAlgorithm.LZMA(需要11.4支持),
		 * 输入其他任何值都认为不启用二进制压缩。默认值：CompressionAlgorithm.ZLIB。
		 * @param maxBitmapWidth 单张位图最大宽度
		 * @param maxBitmapHeight 单张位图最大高度
		 */		
		public function encodeDxrDataList(dxrDataList:Array,compress:String="zlib",
							   maxBitmapWidth:Number=4000,maxBitmapHeight:Number=4000):ByteArray
		{
			var dxrFile:Object = {keyList:{}};
			for each(var dxrData:DxrData in dxrDataList)
			{
				dxrFile.keyList[dxrData.key] = encodeDxrData(dxrData,maxBitmapWidth,maxBitmapHeight);
			}
			var bytes:ByteArray = writeObject(dxrFile,compress);
			return bytes;
		}
		/**
		 * 将DXR 转换为文件字节流数据
		 * @param keyObject 文件信息描述对象 
		 * @param compress 二进制压缩格式，仅支持CompressionAlgorithm.ZLIB和CompressionAlgorithm.LZMA(需要11.4支持),
		 * 输入其他任何值都认为不启用二进制压缩。默认值：CompressionAlgorithm.ZLIB。
		 */		
		public static function writeObject(keyObject:Object,compress:String="zlib"):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.position = 0;
			bytes.writeUTF("dxr");
			if(compress!="zlib"&&compress!="lzma")
			{
				compress = "false";
			}
			bytes.writeUTF(compress);
			var dxrBytes:ByteArray = new ByteArray();
			dxrBytes.writeObject(keyObject);
			if(compress!="false")
			{
				dxrBytes.compress(compress);
			}
			bytes.writeBytes(dxrBytes);
			return bytes;
		}
		
		/**
		 * 编码单个DxrData对象
		 * @param dxrData 要编码的DxrData对象
		 * @param maxBitmapWidth 单张位图最大宽度
		 * @param maxBitmapHeight 单张位图最大高度
		 */		
		private function encodeDxrData(dxrData:DxrData,maxBitmapWidth:Number=4000,maxBitmapHeight:Number=4000):Object
		{
			var bitmapEncoder:IBitmapEncoder = Injector.getInstance(IBitmapEncoder,dxrData.codecKey);
			var data:Object = {codec:bitmapEncoder.codecKey,bitmapList:[],frameInfo:[]};
			var frmaeInfo:Array;
			var tempBmData:BitmapData = new BitmapData(maxBitmapWidth,maxBitmapHeight,true,0);
			var bitmapIndex:int = 0;
			var currentX:Number = 0;
			var currentY:Number = 0;
			var maxHeight:Number = 0;
			var index:int = 0;
			var tempBmRect:Rectangle;
			var pageData:BitmapData;
			for each(var frameBmData:BitmapData in dxrData.frameList)
			{
				var offsetRect:Rectangle = getColorRect(frameBmData);
				if(offsetRect.width>maxBitmapWidth||offsetRect.height>maxBitmapHeight)
				{
					throw new Error("DXR动画："+dxrData.key+" 的第"+index
						+"帧超过了所设置的最大位图尺寸:"+maxBitmapWidth+"x"+maxBitmapHeight+"!");
				}
				if(offsetRect.width>maxBitmapWidth-currentX)
				{
					currentY += maxHeight;
					currentX = 0;
					maxHeight = 0;
				}
				if(offsetRect.height>maxBitmapHeight-currentY)
				{
					tempBmRect = getColorRect(tempBmData);
					pageData = new BitmapData(tempBmRect.width,tempBmRect.height,true,0);
					pageData.copyPixels(tempBmData,tempBmRect,new Point(0,0),null,null,true);
					data.bitmapList[bitmapIndex] = bitmapEncoder.encode(pageData);
					tempBmData = new BitmapData(maxBitmapWidth,maxBitmapHeight,true,0);
					currentX = 0;
					currentY = 0;
					maxHeight = 0;
					bitmapIndex++;
				}
				tempBmData.copyPixels(frameBmData,offsetRect,new Point(currentX,currentY),null,null,true);
				var offsetPoint:Point = dxrData.frameOffsetList[index];
				frmaeInfo = [bitmapIndex,currentX,currentY,offsetRect.width,offsetRect.height,
					offsetPoint.x+offsetRect.x,offsetPoint.y+offsetRect.y];
				var filterOffset:Point = dxrData.filterOffsetList[index];
				if(filterOffset)
				{
					frmaeInfo[7] = filterOffset.x;
					frmaeInfo[8] = filterOffset.y;
				}
				data.frameInfo[index] = frmaeInfo;
				maxHeight = Math.max(maxHeight,offsetRect.height);
				currentX += offsetRect.width; 
				index++;
			}
			tempBmRect = getColorRect(tempBmData);
			if(tempBmRect.width>1&&tempBmRect.height>1)
			{
				pageData = new BitmapData(tempBmRect.width,tempBmRect.height,true,0);
				pageData.copyPixels(tempBmData,tempBmRect,new Point(0,0),null,null,true);
				data.bitmapList[bitmapIndex] = bitmapEncoder.encode(pageData);
			}
			else if(bitmapIndex==0)
			{
				data.bitmapList[bitmapIndex] = bitmapEncoder.encode(new BitmapData(1,1,true,0));
			}
			
			if(dxrData._scale9Grid)
			{
				var rect:Rectangle = dxrData._scale9Grid;
				data.scale9Grid = [rect.left,rect.top,rect.right,rect.bottom];
			}
			
			if(dxrData._frameLabels&&dxrData._frameLabels.length>0)
			{
				var fls:Array = [];
				for each(var frameLabel:FrameLabel in dxrData._frameLabels)
				{
					fls.push([frameLabel.frame,frameLabel.name]);
				}
				data.frameLabels = fls;
			}
			return data;
		}
		
		/**
		 * 获取指定BitmapData中包含像素的最大矩形区域。
		 */		
		private function getColorRect(bitmapData:BitmapData):Rectangle
		{
			var rect:Rectangle =  bitmapData.getColorBoundsRect(0xff000000,0,false);
			if(rect.width<1)
				rect.width = 1;
			if(rect.height<1)
				rect.height = 1;
			return rect;
		}
		
		/**
		 * 绘制一个显示对象，转换为DxrData对象。<br/>
		 * 注意：绘制的结果是其原始显示对象，不包含alpha,scale,rotation,或matrix值。但包含滤镜和除去alpha的colorTransfrom。
		 * @param dp 要绘制的显示对象，可以是MovieClip
		 * @param key DxrData对象的导出键名
		 * @param codec 位图编解码器标识符,"jpegxr"|"jpeg32"|"png",留空默认值为"jpeg32"
		 */	
		public function drawDxrData(dp:DisplayObject,key:String="",codec:String="jpeg32"):DxrData
		{
			if(codec==null||codec=="")
				codec = DxrEncoder.DEFAULT_CODEC;
			var dxrData:DxrData = new DxrData(key,codec);
			if(dp is MovieClip)
			{
				var mc:MovieClip = dp as MovieClip;
				var oldFrame:int = mc.currentFrame;
				var isPlaying:Boolean = mc.isPlaying;
				mc.gotoAndStop(1);
				drawDisplayObject(mc,dxrData);
				while(mc.currentFrame<mc.totalFrames)
				{
					mc.gotoAndStop(mc.currentFrame+1);
					drawDisplayObject(mc,dxrData);
				}
				if(isPlaying)
					mc.gotoAndPlay(oldFrame);
				else
					mc.gotoAndStop(oldFrame);
				dxrData._frameLabels = mc.currentLabels;
			}
			else
			{
				drawDisplayObject(dp,dxrData);
			}
			dxrData._scale9Grid = dp.scale9Grid;
			return dxrData;
		}
		/**
		 * 为指定的dxrData生成唯一的key
		 * @param dxrData 要赋值key的DxrData对象
		 */			
		public static function generateKey(dxrData:DxrData):void
		{
			var buf:ByteArray = new ByteArray();
			for each(var bd:BitmapData in dxrData.frameList)
			{
				buf.writeBytes(bd.getPixels(bd.rect));
			}
			var crc32:uint = CRC32Util.getCRC32(buf);
			dxrData._key = "DXR__"+crc32.toString(16).toUpperCase();
		}
		
		/**
		 * 绘制一个显示对象的当前外观，存储其一帧位图信息到dxrData内
		 */		
		private function drawDisplayObject(dp:DisplayObject,dxrData:DxrData):void
		{
			var dpRect:Rectangle = dp.getBounds(dp);
			if(dpRect.width<1)
				dpRect.width = 1;
			if(dpRect.height<1)
				dpRect.height = 1;
			var offsetX:Number = 100;
			var offsetY:Number = 100;
			var matrix:Matrix = new Matrix(1,0,0,1,offsetX-dpRect.left,offsetY-dpRect.top);
			var tempBmData:BitmapData = new BitmapData(dpRect.width+offsetX*2,dpRect.height+offsetY*2,true,0); 
			var ct:ColorTransform = drawColorTransfrom(dp);
			tempBmData.draw(dp,matrix,ct,null,null,true);
			
			var colorRect:Rectangle = getColorRect(tempBmData);
			var frameData:BitmapData = new BitmapData(colorRect.width,colorRect.height,true,0);
			frameData.copyPixels(tempBmData,colorRect,new Point(),null,null,true);
			dxrData.frameList.push(frameData);
			var offsetPoint:Point = new Point(Math.round(dpRect.left)+colorRect.x-offsetX,
				Math.round(dpRect.top)+colorRect.y-offsetY);
			dxrData.frameOffsetList.push(offsetPoint);
			var filterOffset:Point = new Point(Math.round(colorRect.width-dpRect.width),
				Math.round(colorRect.height-dpRect.height));
			if(filterOffset.x!=0||filterOffset.y!=0)
			{
				dxrData.filterOffsetList[dxrData.frameOffsetList.length-1]=filterOffset;
			}
		}
		/**
		 * 获取指定显示对象的除去alpha值的colorTransform对象。若对象各个属性都是初始状态，则返回null。
		 */		
		private function drawColorTransfrom(dp:DisplayObject):ColorTransform
		{
			var ct:ColorTransform = dp.transform.colorTransform;
			if(ct.redMultiplier==1&&ct.greenMultiplier==1&&ct.blueMultiplier==1&&
				ct.redOffset==0&&ct.greenOffset==0&&ct.blueOffset==0&&ct.alphaOffset==0)
			{
				return null;
			}
			var newCT:ColorTransform = new ColorTransform();
			newCT.concat(ct);
			newCT.alphaMultiplier = 1;
			return newCT;
		}
	}
}