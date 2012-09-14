package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexlite.domUI.components.supportClasses.Range;
	import org.flexlite.domUI.components.supportClasses.TrackBase;
	
	[DXML(show="true")]
	/**
	 * 进度条
	 * 支持通过setProgress手动设定进度
	 * @author chenglong
	 * 
	 */
	public class ProgressBar extends Range
	{
		public function ProgressBar()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();			
		}
		
		private var indeterminatePlaying:Boolean;
		private var pollTimer:Timer = new Timer(100);
		
		/**
		 *  设置想对于总量的当前进度值		 
		 *  @param value 当前进度值		 
		 *  @param maximum 总量		   
		 */
		public function setProgress(value:uint, total:uint):void
		{
			if( isNaN(value) || isNaN(maximum)) return;
			
			this.value = value;
			maximum = total;
			
			// 抛出 "change"类型事件
			dispatchEvent(new Event(Event.CHANGE));
			
			// 抛出 Progress 事件
			var progressEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			progressEvent.bytesLoaded = value;
			progressEvent.bytesTotal = maximum;
			dispatchEvent(progressEvent);
			
			startPlayingIndeterminate();
			
			// 抛出完成事件
			if (value == maximum && value > 0)
			{
				stopPlayingIndeterminate();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			invalidateDisplayList();
		}
		
		private function stopPlayingIndeterminate():void
		{
			if (indeterminatePlaying)
			{
				indeterminatePlaying = false;
				
				pollTimer.removeEventListener(TimerEvent.TIMER,updateIndeterminateHandler);
				pollTimer.stop();
			}				
		}
		
		protected function startPlayingIndeterminate():void
		{
			if (!indeterminatePlaying)
			{
				indeterminatePlaying = true;
				
				pollTimer.addEventListener(TimerEvent.TIMER,updateIndeterminateHandler, false, 0, true);
				pollTimer.start();
			}		
		}
		
		private function updateIndeterminateHandler(e:TimerEvent):void
		{
			if(thumb.width<this.width*(value/maximum))
			{
				if(label) label.text = String(value+"/"+maximum);
				thumb.width++;
			}
			else
			{
				stopPlayingIndeterminate();
			}
		}
		
		/**
		 * [SkinPart]实体滑块组件
		 */		
		public var thumb:Button;
		
		/**
		 * [SkinPart]实体轨道组件
		 */
		public var track:Button; 
		
		/**
		 * [SkinPart]进度数字显示 可选
		 */
		public var label:Label;
		
		/**
		 * 更新滑块的大小 
		 * 
		 */
		protected function updateSkinDisplayList():void
		{
			if(thumb) thumb.width = uint(maxWidth * (value/maximum));
		}
	}
}