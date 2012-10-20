package org.flexlite.domDisplay
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.IBitmapAsset;
	import org.flexlite.domCore.IMovieClip;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domDisplay.events.MoveClipPlayEvent;
	
	use namespace dx_internal;
	
	/**
	 * 一次播放完成事件
	 */	
	[Event(name="playComplete", type="org.flexlite.domDisplay.events.MoveClipPlayEvent")]
	
	/**
	 * DXR影片剪辑
	 * @author DOM
	 */	
	public class DxrMovieClip extends Sprite implements IMovieClip,IBitmapAsset
	{
		/**
		 * 构造函数
		 * @param data 被引用的DxrData对象
		 * @param smoothing 在缩放时是否对位图进行平滑处理。
		 */
		public function DxrMovieClip(data:DxrData=null,smoothing:Boolean=true)
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAddedOrRemoved);
			addEventListener(Event.REMOVED_FROM_STAGE,onAddedOrRemoved);
			mouseChildren = false;
			this._smoothing = smoothing;
			if(data)
				dxrData = data;
		}
		
		/**
		 * smoothing改变标志
		 */		
		private var smoothingChanged:Boolean = true;
		
		private var _smoothing:Boolean;
		/**
		 * 在缩放时是否对位图进行平滑处理。
		 */
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			if(_smoothing==value)
				return;
			_smoothing = value;
			smoothingChanged = true;
			invalidateProperties();
		}
		
		/**
		 * 被添加到显示列表时
		 */		
		private function onAddedOrRemoved(event:Event):void
		{
			checkEventListener();
		}		
		
		/**
		 * 位图显示对象
		 */		
		private var bitmapContent:Bitmap;
		/**
		 * 具有九宫格缩放功能的位图显示对象
		 */		
		private var s9gBitmapContent:Scale9GridBitmap;
		
		private var useScale9Grid:Boolean = false;
		
		private var _dxrData:DxrData;
		/**
		 * 被引用的DxrData对象
		 */
		public function get dxrData():DxrData
		{
			return _dxrData;
		}

		public function set dxrData(value:DxrData):void
		{
			if(_dxrData==value)
				return;
			_dxrData = value;
			_currentFrame = 0;
			checkEventListener();
			if(!value)
			{
				if(bitmapContent)
				{
					removeChild(bitmapContent);
					bitmapContent = null;
				}
				if(s9gBitmapContent)
				{
					graphics.clear();
					s9gBitmapContent = null;
				}
				return;
			}
			useScale9Grid = (_dxrData._scale9Grid!=null);
			if(_dxrData.frameLabels.length>0)
			{
				frameLabelDic = new Dictionary;
				for each(var label:FrameLabel in _dxrData.frameLabels)
				{
					frameLabelDic[label.name] = label.frame;
				}
			}
			else
			{
				frameLabelDic = null;
			}
			initContent();
			applyCurrentFrameData();
		}
		/**
		 * 当使用九宫格缩放时的x方向缩放值
		 */		
		private var frameScaleX:Number = 1;
		/**
		 * 当使用九宫格缩放时的y方向缩放值
		 */
		private var frameScaleY:Number = 1;
		/**
		 * 初始化显示对象实体
		 */		
		private function initContent():void
		{
			frameScaleX = 1;
			frameScaleY = 1;
			if(widthExplicitSet)
			{
				frameScaleX = _width/_dxrData.frameList[0].width;
			}
			if(heightExplicitSet)
			{
				frameScaleY = _height/_dxrData.frameList[0].height;
			}
			if(useScale9Grid)
			{
				if(bitmapContent)
				{
					removeChild(bitmapContent);
					bitmapContent = null;
				}
				if(!s9gBitmapContent)
				{
					s9gBitmapContent = new Scale9GridBitmap(null,this.graphics,_smoothing);
				}
			}
			else
			{
				if(s9gBitmapContent)
				{
					graphics.clear();
					s9gBitmapContent = null;
				}
				if(!bitmapContent)
				{
					bitmapContent = new Bitmap();
					addChild(bitmapContent);
				}
			}
		}
		
		private var eventListenerAdded:Boolean = false;
		/**
		 * 检测是否需要添加事件监听
		 * @param remove 强制移除事件监听标志
		 */			
		private function checkEventListener(remove:Boolean=false):void
		{
			var needAddEventListener:Boolean = (!remove&&stage&&!isStop&&totalFrames>1);
			if(eventListenerAdded==needAddEventListener)
				return;
			if(eventListenerAdded)
			{
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				eventListenerAdded = false;
			}
			else
			{
				this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
				eventListenerAdded = true;
			}
		}
		
		/**
		 * 帧标签字典索引
		 */		
		private var frameLabelDic:Dictionary;
		
		private function onEnterFrame(event:Event):void
		{
			render();
		}
		
		/**
		 * 应用当前帧的位图数据
		 */		
		private function applyCurrentFrameData():void
		{
			var bitmapData:BitmapData = dxrData.frameList[_currentFrame];
			var pos:Point = dxrData.frameOffsetList[_currentFrame];
			var sizeOffset:Point = dxrData.filterOffsetList[_currentFrame];
			if(!sizeOffset)
				sizeOffset = zeroPoint;
			_width = Math.round(bitmapData.width*frameScaleX);
			_height = Math.round(bitmapData.height*frameScaleY);
			if(useScale9Grid)
			{
				if(smoothingChanged)
				{
					smoothingChanged = false;
					s9gBitmapContent.smoothing = _smoothing;
				}
				s9gBitmapContent.scale9Grid = dxrData._scale9Grid;
				s9gBitmapContent._offsetPoint = pos;
				s9gBitmapContent.width = _width+sizeOffset.x;
				s9gBitmapContent.height = _height+sizeOffset.y;
				s9gBitmapContent.bitmapData = bitmapData;
			}
			else
			{
				bitmapContent.x = pos.x;
				bitmapContent.y = pos.y;
				bitmapContent.bitmapData = bitmapData;
				if(_smoothing)
					bitmapContent.smoothing = _smoothing;
				bitmapContent.width = _width+sizeOffset.x;
				bitmapContent.height = _height+sizeOffset.y;
			}
			widthChanged = false;
			heightChanged = false;
		}
		
		private var widthChanged:Boolean = false;
		/**
		 * 显式设置的宽度
		 */		
		private var widthExplicitSet:Boolean;
		
		private var _width:Number;
		
		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			if(value==_width)
				return;
			_width = value;
			widthExplicitSet = !isNaN(value);
			if(widthExplicitSet)
			{
				if(_dxrData)
					frameScaleX = _width/_dxrData.frameList[0].width;
			}
			else
			{
				frameScaleX = 1;
			}
			
			widthChanged = true;
			invalidateProperties();
		}
		
		private var heightChanged:Boolean = false;
		/**
		 * 显式设置的高度
		 */		
		private var heightExplicitSet:Boolean;
		
		private var _height:Number;
		
		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			if(_height==value)
				return;
			_height = value;
			heightExplicitSet = !isNaN(value);
			if(heightExplicitSet)
			{
				if(_dxrData)
					frameScaleY = _height/_dxrData.frameList[0].height;
			}
			else 
			{
				frameScaleY = 1;
			}
			widthChanged = true;
			invalidateProperties();
		}
		
		private var invalidateFlag:Boolean = false;
		/**
		 * 标记有属性变化需要延迟应用
		 */		
		protected function invalidateProperties():void
		{
			if(!invalidateFlag)
			{
				invalidateFlag = true;
				if(stage)
				{
					addEventListener(Event.RENDER,validateProperties);
					if(stage) 
						stage.invalidate();
				}
				else
				{
					addEventListener(Event.ENTER_FRAME,validateProperties);
				}
			}
		}
		
		/**
		 * 立即应用所有标记为延迟验证的属性
		 */		
		public function validateNow():void
		{
			if(invalidateFlag)
				validateProperties();
		}
		
		/**
		 * 延迟应用属性事件
		 */		
		private function validateProperties(event:Event=null):void
		{
			removeEventListener(Event.RENDER,validateProperties);
			removeEventListener(Event.ENTER_FRAME,validateProperties);
			commitProperties();
			invalidateFlag = false;
		}	
		/**
		 * 延迟应用属性
		 */
		protected function commitProperties():void
		{
			if(widthChanged||heightChanged||smoothingChanged)
			{
				if(dxrData)
				{
					applyCurrentFrameData();
				}
			}
		}

		private var _currentFrame:int = 0;
		/**
		 * 当前播放到的帧索引,从0开始
		 */
		public function get currentFrame():int
		{
			return _currentFrame;
		}

		/**
		 * 动画总帧数
		 */
		public function get totalFrames():int
		{
			return dxrData?dxrData.frameList.length:0;
		}
		
		/**
		 * 返回由FrameLabel对象组成的数组。数组包括整个Dxr动画实例的所有帧标签。
		 */		
		public function get frameLabels():Array
		{
			return dxrData?dxrData.frameLabels:[];
		}
		
		/**
		 * 是否停止播放
		 */		
		private var isStop:Boolean = false;
		
		/**
		 * 执行一次渲染
		 */		
		public function render():void
		{
			var total:int = totalFrames;
			if(total<=1||!visible)
				return;
			if(_currentFrame>=totalFrames-1)
			{
				_currentFrame = totalFrames-1;
				if(hasEventListener(MoveClipPlayEvent.PLAY_COMPLETE))
				{
					var event:MoveClipPlayEvent = new MoveClipPlayEvent(MoveClipPlayEvent.PLAY_COMPLETE);
					dispatchEvent(event);
				}
				if(!_repeatPlay)
				{
					checkEventListener(true);
					return;
				}
			}
			if(_currentFrame<total-1)
			{
				gotoFrame(_currentFrame+1);
			}
			else
			{
				gotoFrame(0);
			}
		}
		
		private var _repeatPlay:Boolean = true;
		
		public function get repeatPlay():Boolean
		{
			return _repeatPlay;
		}

		public function set repeatPlay(value:Boolean):void
		{
			if(value==_repeatPlay)
				return;
			_repeatPlay = value;
		}
		
		public function gotoAndPlay(frame:Object):void
		{
			gotoFrame(frame);
			isStop = false;
			checkEventListener();
		}
		/**
		 * 跳到指定帧
		 */		
		private function gotoFrame(frame:Object):void
		{
			if(_dxrData==null)
				return;
			if(frame is int)
			{
				_currentFrame = frame as int;
			}
			else if(frameLabelDic&&frameLabelDic[frame]!==undefined)
			{
				_currentFrame = frameLabelDic[frame] as int;
			}
			else
			{
				return;
			}
			if(_currentFrame>totalFrames-1)
				_currentFrame = totalFrames-1;
			applyCurrentFrameData();
		}
			
		public function gotoAndStop(frame:Object):void
		{
			gotoFrame(frame);
			isStop = true;
			checkEventListener();
		}
		
		public function get bitmapData():BitmapData
		{
			return dxrData?dxrData.frameList[_currentFrame]:null;
		}
		
		private static var zeroPoint:Point = new Point;
		
		public function get offsetPoint():Point
		{
			return _dxrData?_dxrData.frameOffsetList[_currentFrame]:zeroPoint;
		}
	}
}