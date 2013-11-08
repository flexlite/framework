package org.flexlite.domUI.components
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCore.IMovieClip;
	
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
			if(movieClip)
				attachMovieClip(movieClip);
		}
		
		private var actionCache:Array = [];
		/**
		 * 缓存一条动画操作记录
		 */		
		private function pushAction(key:String,args:Array=null):void
		{
			actionCache.push({key:key,args:args});
		}
		
		/**
		 * 附加影片剪辑
		 */		
		protected function attachMovieClip(movieClip:Object):void
		{
			if(isMovieClip)
			{
				var totalFrame:int = movieClip.totalFrames;
			}
			else
			{
				movieClip.repeatPlay = _repeatPlay;
			}
		}
		
		/**
		 * 卸载影片剪辑
		 */		
		protected function detachMovieClip(movieClip:Object):void
		{
			
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
		
		/**
		 * @inheritDoc
		 */
		public function get totalFrames():int
		{
			return movieClip?movieClip.totalFrames:0;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get frameLabels():Array
		{
			var labels:Array = [];
			if(movieClip)
			{
				if(isMovieClip)
					labels = movieClip.currentLabels;
				else
					labels = movieClip.frameLabels;
			}
			return labels;
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
			_repeatPlay = value;
			if(movieClip)
			{
				if(isMovieClip)
				{
					
				}
				else
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
				movieClip.gotoAndPlay(frame);
			else
				pushAction("gotoAndPlay",[frame]);
		}
		
		/**
		 * @inheritDoc
		 */
		public function gotoAndStop(frame:Object):void
		{
			if(movieClip)
				movieClip.gotoAndStop(frame);
			else
				pushAction("gotoAndStop",[frame]);
		}
		
		/**
		 * @inheritDoc
		 */	
		public function play():void
		{
			if(movieClip)
				movieClip.play();
			else
				pushAction("play");
		}
		
		/**
		 * @inheritDoc
		 */	
		public function stop():void
		{
			if(movieClip)
				movieClip.stop();
			else
				pushAction("stop");
		}
		
		/**
		 * 添加过回调函数的帧列表
		 */		
		private var frameMark:Dictionary = new Dictionary();
		/**
		 * 标记某一帧需要回调
		 */		
		private function addCallBackAtFrame(frame:int):void
		{
			if(frameMark[frame])
				return;
			frameMark[frame] = true;
			if(movieClip)
				movieClip.addFrameScript(frame,callBackFunction);
		}
		
		/**
		 * 帧回调函数列表
		 */		
		private var callBackList:Array = [];
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
		 * @inheritDoc
		 */
		public function addFrameScript(frame:int,callBack:Function):void
		{
			callBackList[frame] = callBack;
			addCallBackAtFrame(frame);
		}
		
	}
}