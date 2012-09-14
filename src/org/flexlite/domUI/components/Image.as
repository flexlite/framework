package org.flexlite.domUI.components
{
	
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.primitives.BitmapImage;
	import org.flexlite.domUI.primitives.graphic.BitmapScaleMode;
	import org.flexlite.domUI.skins.spark.ImageSkin;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	use namespace dx_internal;
	
	[DXML(show="true")]
	
	/**
	 * 图像仅仅加载完成数据，还未显示 
	 */	
	[Event(name="complete", type="flash.events.Event")]
	
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/**
	 * 图像源已完全加载完成并显示
	 */	
	[Event(name="ready", type="org.flexlite.domUI.events.UIEvent")]
	
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	
	[SkinState("invalid")]
	
	[SkinState("disabled")]
	
	[SkinState("ready")]
	
	
	[DXML(show="true")]
	
	/**
	 * 图片控件
	 * @author DOM
	 */	
	public class Image extends SkinnableComponent
	{
		/**
		 * 构造函数
		 */		
		public function Image()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			if(!skinName)
			{
				skinName = ImageSkin;
			}
			super.createChildren();
		}
		
		override protected function get hostComponentKey():Object
		{
			return Image;
		}
		
		/**
		 * 正在加载
		 */		
		protected var _loading:Boolean = false;
		/**
		 * 已经加载完成并显示 
		 */		
		protected var _ready:Boolean = false;
		/**
		 * 发生错误,加载失败 
		 */		
		protected var _invalid:Boolean = false;
		
		/**
		 * 在皮肤还未应用时保存外部设置的属性值 
		 */		
		private var imageDisplayProperties:Object = {scaleMode: BitmapScaleMode.LETTERBOX, trustedSource: true};
		
		/**
		 * [SkinPart]图片显示对象实体
		 */		
		public var imageDisplay:BitmapImage;  
		
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#bitmapData
		 */		
		public function get bitmapData():BitmapData 
		{
			return imageDisplay !=null ? imageDisplay.bitmapData : null; 
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#bytesLoaded
		 */	
		public function get bytesLoaded():Number 
		{
			return imageDisplay !=null ? imageDisplay.bytesLoaded : NaN; 
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#bytesTotal
		 */
		public function get bytesTotal():Number 
		{
			return imageDisplay !=null ? imageDisplay.bytesTotal : NaN;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#clearOnLoad
		 */
		public function get clearOnLoad():Boolean 
		{
			if (imageDisplay!=null)
				return imageDisplay.clearOnLoad;
			else
				return imageDisplayProperties.clearOnLoad;
		}
		
		public function set clearOnLoad(value:Boolean):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.clearOnLoad = value;
				imageDisplayProperties.clearOnLoad = true;
			}
			else
				imageDisplayProperties.clearOnLoad = value;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#fillMode
		 */
		public function get fillMode():String
		{
			if (imageDisplay!=null)
				return imageDisplay.fillMode;
			else
				return imageDisplayProperties.fillMode;
		}
		
		public function set fillMode(value:String):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.fillMode = value;
				imageDisplayProperties.fillMode = true;
			}
			else
				imageDisplayProperties.fillMode = value;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#horizontalAlign
		 */
		public function get horizontalAlign():String
		{
			if (imageDisplay!=null)
				return imageDisplay.horizontalAlign;
			else
				return imageDisplayProperties.horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.horizontalAlign = value;
				imageDisplayProperties.horizontalAlign = true;
			}
			else
				imageDisplayProperties.horizontalAlign = value;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#preliminaryHeight
		 */
		public function get preliminaryHeight():Number
		{
			if (imageDisplay!=null)
				return imageDisplay.preliminaryHeight;
			else
				return imageDisplayProperties.preliminaryHeight;
		}
		
		public function set preliminaryHeight(value:Number):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.preliminaryHeight = value;
				imageDisplayProperties.preliminaryHeight = true;
			}
			else
				imageDisplayProperties.preliminaryHeight = value;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#preliminaryWidth
		 */
		public function get preliminaryWidth():Number
		{
			if (imageDisplay!=null)
				return imageDisplay.preliminaryWidth;
			else
				return imageDisplayProperties.preliminaryWidth;
		}
		
		public function set preliminaryWidth(value:Number):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.preliminaryWidth = value;
				imageDisplayProperties.preliminaryWidth = true;
			}
			else
				imageDisplayProperties.preliminaryWidth = value;
		}
		/**
		 * 缩放图像方式。仅当fillMode为BitmapFillMode.SCALE时此属性有效<br/>
		 * 当设置为BitmapScaleMode.STRETCH时,将拉伸位图以填充区域。<br/>
		 * 当设置为BitmapScaleMode.LETTERBOX时,将在保持原始高宽比的情况下拉伸位图<br/>
		 * 当设置为BitmapScaleMode.ZOOM时,将缩放和裁剪位图，以使原始内容的高宽比保持不变并且不显示空白或突出的边界。<br/>
		 * 默认值为：BitmapScaleMode.LETTERBOX。
		 */	
		public function get scaleMode():String
		{
			if (imageDisplay!=null)
				return imageDisplay.scaleMode;
			else
				return imageDisplayProperties.scaleMode;
		}
		
		public function set scaleMode(value:String):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.scaleMode = value;
				imageDisplayProperties.scaleMode = true;
			}
			else
				imageDisplayProperties.scaleMode = value;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#smooth
		 */
		public function set smooth(value:Boolean):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.smooth = value;
				imageDisplayProperties.smooth = true;
			}
			else
				imageDisplayProperties.smooth = value;
		}
		
		public function get smooth():Boolean          
		{
			if (imageDisplay!=null)
				return imageDisplay.smooth;
			else
				return imageDisplayProperties.smooth;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#source
		 */
		public function get source():Object          
		{
			if (imageDisplay!=null)
				return imageDisplay.source;
			else
				return imageDisplayProperties.source;
		}
		
		public function set source(value:Object):void
		{
			if (source == value)
				return;
			
			_loading = false;
			_invalid = false;
			_ready = false;
			
			if (imageDisplay!=null)
			{
				imageDisplay.source = value;
				imageDisplayProperties.source = true;
			}
			else
				imageDisplayProperties.source = value;
			
			invalidateSkinState();
			dispatchEvent(new Event("sourceChanged"));
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#sourceHeight
		 */
		public function get sourceHeight():Number
		{
			if (imageDisplay!=null)
				return imageDisplay.sourceHeight;
			else
				return NaN;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#sourceWidth
		 */
		public function get sourceWidth():Number
		{
			if (imageDisplay!=null)
				return imageDisplay.sourceWidth;
			else
				return NaN;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#trustedSource
		 */
		public function get trustedSource():Boolean          
		{
			if (imageDisplay!=null)
				return imageDisplay.trustedSource;
			else
				return imageDisplayProperties.trustedSource;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#verticalAlign
		 */
		public function get verticalAlign():String
		{
			if (imageDisplay!=null)
				return imageDisplay.verticalAlign;
			else
				return imageDisplayProperties.verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.verticalAlign = value;
				imageDisplayProperties.verticalAlign = true;
			}
			else
				imageDisplayProperties.verticalAlign = value;
		}
		/**
		 * @copy org.flexlite.domUI.primitives.BitmapImage#smoothingQuality
		 */
		public function get smoothingQuality():String
		{
			if (imageDisplay!=null)
				return imageDisplay.smoothingQuality;
			else
				return imageDisplayProperties.smoothingQuality;
		}
		
		public function set smoothingQuality(value:String):void
		{
			if (imageDisplay!=null)
			{
				imageDisplay.smoothingQuality = value;
				imageDisplayProperties.smoothingQuality = true;
			}
			else
				imageDisplayProperties.smoothingQuality = value;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == imageDisplay)
			{
				imageDisplay.addEventListener(IOErrorEvent.IO_ERROR, imageDisplay_ioErrorHandler, false, 0, true);
				imageDisplay.addEventListener(ProgressEvent.PROGRESS, imageDisplay_progressHandler, false, 0, true);
				imageDisplay.addEventListener(UIEvent.READY, imageDisplay_readyHandler, false, 0, true);
				imageDisplay.addEventListener(Event.COMPLETE, dispatchEvent, false, 0, true);
				imageDisplay.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent, false, 0, true);
				imageDisplay.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent, false, 0, true);
				
				var newImageDisplayProperties:Object = {};
				
				if (imageDisplayProperties.clearOnLoad !== undefined)
				{
					imageDisplay.clearOnLoad = imageDisplayProperties.clearOnLoad;
					newImageDisplayProperties.clearOnLoad = true;
				}
				
				if (imageDisplayProperties.fillMode !== undefined)
				{
					imageDisplay.fillMode = imageDisplayProperties.fillMode;
					newImageDisplayProperties.fillMode = true;
				}
				
				if (imageDisplayProperties.preliminaryHeight !== undefined)
				{
					imageDisplay.preliminaryHeight = imageDisplayProperties.preliminaryHeight;
					newImageDisplayProperties.preliminaryHeight = true;
				}
				
				if (imageDisplayProperties.preliminaryWidth !== undefined)
				{
					imageDisplay.preliminaryWidth = imageDisplayProperties.preliminaryWidth;
					newImageDisplayProperties.preliminaryWidth = true;
				}
				
				if (imageDisplayProperties.smooth !== undefined)
				{
					imageDisplay.smooth = imageDisplayProperties.smooth;
					newImageDisplayProperties.smooth = true;
				}
				
				if (imageDisplayProperties.source !== undefined)
				{
					imageDisplay.source = imageDisplayProperties.source;
					newImageDisplayProperties.source = true;
				}
				
				if (imageDisplayProperties.smoothingQuality !== undefined)
				{
					imageDisplay.smoothingQuality = imageDisplayProperties.smoothingQuality;
					newImageDisplayProperties.smoothingQuality = true;
				}
				
				if (imageDisplayProperties.scaleMode !== undefined)
				{
					imageDisplay.scaleMode = imageDisplayProperties.scaleMode;
					newImageDisplayProperties.scaleMode = true;
				}
				
				if (imageDisplayProperties.verticalAlign !== undefined)
				{
					imageDisplay.verticalAlign = imageDisplayProperties.verticalAlign;
					newImageDisplayProperties.verticalAlign = true;
				}
				
				if (imageDisplayProperties.horizontalAlign !== undefined)
				{
					imageDisplay.horizontalAlign = imageDisplayProperties.horizontalAlign;
					newImageDisplayProperties.horizontalAlign = true;
				}
				
				imageDisplayProperties = newImageDisplayProperties;
				imageDisplay.validateSource();
			}
		}
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == imageDisplay)
			{
				imageDisplay.removeEventListener(IOErrorEvent.IO_ERROR, imageDisplay_ioErrorHandler);
				imageDisplay.removeEventListener(ProgressEvent.PROGRESS, imageDisplay_progressHandler);
				imageDisplay.removeEventListener(UIEvent.READY, imageDisplay_readyHandler);
				imageDisplay.removeEventListener(Event.COMPLETE, dispatchEvent);
				imageDisplay.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
				imageDisplay.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
				
				var newImageDisplayProperties:Object = {scaleMode: BitmapScaleMode.LETTERBOX, trustedSource: true};
				
				if (imageDisplayProperties.clearOnLoad)
					newImageDisplayProperties.clearOnLoad = imageDisplay.clearOnLoad;
				
				if (imageDisplayProperties.fillMode)
					newImageDisplayProperties.fillMode = imageDisplay.fillMode;
				
				if (imageDisplayProperties.preliminaryHeight)
					newImageDisplayProperties.preliminaryHeight = imageDisplay.preliminaryHeight;
				
				if (imageDisplayProperties.preliminaryWidth)
					newImageDisplayProperties.preliminaryWidth = imageDisplay.preliminaryWidth;
				
				if (imageDisplayProperties.source)
					newImageDisplayProperties.source = imageDisplay.source;
				
				if (imageDisplayProperties.smooth)
					newImageDisplayProperties.smooth = imageDisplay.smooth;
				
				if (imageDisplayProperties.smoothingQuality)
					newImageDisplayProperties.smoothingQuality = imageDisplay.smoothingQuality;
				
				if (imageDisplayProperties.scaleMode)
					newImageDisplayProperties.scaleMode = imageDisplay.scaleMode;
				
				if (imageDisplayProperties.verticalAlign)
					newImageDisplayProperties.verticalAlign = imageDisplay.verticalAlign;
				
				if (imageDisplayProperties.horizontalAlign)
					newImageDisplayProperties.horizontalAlign = imageDisplay.horizontalAlign;
				
				imageDisplay.source = null;
				
				imageDisplayProperties = newImageDisplayProperties;
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if (_invalid)
				return "invalid";
			else if (!enabled)
				return "disabled";
			else
				return "ready";
		}

		/**
		 * 图片加载失败
		 */		
		private function imageDisplay_ioErrorHandler(error:IOErrorEvent):void
		{
			_invalid = true;
			_loading = false;
			invalidateSkinState();
			
			if (hasEventListener(error.type))
				dispatchEvent(error);
		}
		
		/**
		 * 图片加载进度
		 */		
		private function imageDisplay_progressHandler(event:ProgressEvent):void
		{
			if (!_loading)
				invalidateSkinState();
			
			_loading = true;
			
			dispatchEvent(event);
		}
		
		/**
		 * 图片加载完成并已显示
		 */		
		private function imageDisplay_readyHandler(event:Event):void
		{
			invalidateSkinState();
			_loading = false;
			_ready = true;
			dispatchEvent(event);
		}    
	}
	
}
