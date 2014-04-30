package org.flexlite.domUI.components
{
	import flash.display.MovieClip;
	
	import org.flexlite.domCore.IMovieClip;
	import org.flexlite.domUI.events.UIEvent;
	
	[DXML(show="true")]
	
	/**
	 * UIMoveClip一次播放完成事件。仅当UIMovieClip.totalFrames>1时会抛出此事件。 
	 */	
	[Event(name="playComplete", type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 影片剪辑素材包装器,通常用于在UI中控制动画素材的播放。
	 * @author DOM
	 */
	public class UIMovieClip extends UIAsset implements IMovieClip
	{
		/**
		 * 构造函数
		 */		
		public function UIMovieClip()
		{
			super();
		}
		
		private var movieClip:Object;
		/**
		 * 皮肤是MovieClip对象的标志
		 */		
		private var isMovieClip:Boolean = false;
		
		override protected function onGetSkin(skin:Object, skinName:Object):void
		{
			super.onGetSkin(skin,skinName);
			if(movieClip)
				detachMovieClip(movieClip);
			isMovieClip = (skin is MovieClip);
			if(isMovieClip||skin is IMovieClip)
			{
				movieClip = skin;
			}
			else
			{
				movieClip = null;
			}
			_totalFrames = 0;
			_frameLabels = [];
			if(movieClip)
				attachMovieClip(movieClip);
			actionCache = [];
		}
		
		private var actionCache:Array = [];
		/**
		 * 缓存一条动画操作记录
		 */		
		private function pushAction(func:Function,args:Array=null):void
		{
			actionCache.push({func:func,args:args});
		}
		
		/**
		 * 附加影片剪辑
		 */		
		protected function attachMovieClip(movieClip:Object):void
		{
			_totalFrames = movieClip.totalFrames;
			if(movieClip)
			{
				if(isMovieClip)
					_frameLabels = movieClip.currentLabels;
				else
					_frameLabels = movieClip.frameLabels;
			}
			for(var frame:* in frameMarkList)
			{
				if(movieClip.totalFrames-1==frame)
					movieClip.addFrameScript(frame,endCallBackFunction);
				else
					movieClip.addFrameScript(frame,callBackFunction);
			}
			if(_totalFrames>1)
			{
				addCallBackAtFrame(movieClip.totalFrames-1);
			}
			if(!isMovieClip)
			{
				movieClip.repeatPlay = _repeatPlay;
			}
			for each(var ac:Object in actionCache)
			{
				if(ac.args==null)
					ac.func();
				else
					ac.func.apply(null,ac.args);
			}
		}
		
		/**
		 * 卸载影片剪辑
		 */		
		protected function detachMovieClip(movieClip:Object):void
		{
			for(var frame:* in frameMarkList)
			{
				movieClip.addFrameScript(frame,null);
			}
			movieClip = null;
			if(_totalFrames>1)
				removeCallBackAtFrame(_totalFrames-1);
		}
		
		/**
		 * 是否含有实体动画显示对象。若为false，则currentFrame，totalFrames和frameLabels属性无效。
		 */		
		public function get hasContent():Boolean
		{
			return Boolean(movieClip);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentFrame():int
		{
			var frame:int = 0;
			if(movieClip)
			{
				frame = movieClip.currentFrame;
				if(isMovieClip)
					frame--;
			}
			return frame;
		}
		
		private var _totalFrames:int = 0;
		/**
		 * @inheritDoc
		 */
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		private var _frameLabels:Array = [];
		/**
		 * @inheritDoc
		 */		
		public function get frameLabels():Array
		{
			return _frameLabels.concat();
		}
		
		private var _repeatPlay:Boolean = true;
		/**
		 * @inheritDoc
		 */
		public function get repeatPlay():Boolean
		{
			return _repeatPlay;
		}
		public function set repeatPlay(value:Boolean):void
		{
			if(_repeatPlay==value)
				return;
			_repeatPlay = value;
			if(movieClip)
			{
				if(!isMovieClip)
				{
					movieClip.repeatPlay = _repeatPlay;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function gotoAndPlay(frame:Object):void
		{
			if(movieClip)
			{
				if(isMovieClip&&frame is int)
					frame += 1;
				movieClip.gotoAndPlay(frame);
			}
			else
				pushAction(gotoAndPlay,[frame]);
		}
		
		/**
		 * @inheritDoc
		 */
		public function gotoAndStop(frame:Object):void
		{
			if(movieClip)
			{
				if(isMovieClip&&frame is int)
					frame += 1;
				movieClip.gotoAndStop(frame);
			}
			else
				pushAction(gotoAndStop,[frame]);
		}
		
		/**
		 * @inheritDoc
		 */	
		public function play():void
		{
			if(movieClip)
				movieClip.play();
			else
				pushAction(play);
		}
		
		/**
		 * @inheritDoc
		 */	
		public function stop():void
		{
			if(movieClip)
				movieClip.stop();
			else
				pushAction(stop);
		}
		
		/**
		 * 添加过回调函数的帧列表
		 */		
		private var frameMarkList:Array = [];
		/**
		 * 帧回调函数列表
		 */		
		private var callBackList:Array = [];
		/**
		 * @inheritDoc
		 */
		public function addFrameScript(frame:int,callBack:Function):void
		{
			if(callBack==null)
			{
				delete callBackList[frame];
				removeCallBackAtFrame(frame);
			}
			else
			{
				callBackList[frame] = callBack;
				addCallBackAtFrame(frame);
			}
		}
		/**
		 * 标记某一帧需要回调
		 */		
		private function addCallBackAtFrame(frame:int):void
		{
			if(frameMarkList[frame])
				return;
			frameMarkList[frame] = true;
			if(movieClip)
			{
				if(_totalFrames-1==frame)
					movieClip.addFrameScript(frame,endCallBackFunction);
				else
					movieClip.addFrameScript(frame,callBackFunction);
			}
		}
		/**
		 * 移除某一帧的回调
		 */		
		private function removeCallBackAtFrame(frame:int):void
		{
			if(!frameMarkList[frame])
				return;
			if(movieClip&&_totalFrames-1==frame||callBackList[frame]!=null)
				return;
			delete frameMarkList[frame];
			if(movieClip)
			{
				movieClip.addFrameScript(frame,null);
			}
		}
		/**
		 * 回调函数
		 */		
		private function callBackFunction():void
		{
			var func:Function = callBackList[currentFrame];
			if(func!=null)
			{
				func();
			}
		}
		/**
		 * 帧末回调函数
		 */		
		private function endCallBackFunction():void
		{
			if(!_repeatPlay&&isMovieClip)
			{
				movieClip.stop();
			}
			callBackFunction();
			
			if(hasEventListener(UIEvent.PLAY_COMPLETE))
			{
				var event:UIEvent = new UIEvent(UIEvent.PLAY_COMPLETE);
				dispatchEvent(event);
			}
		}
		
	}
}