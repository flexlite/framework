package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	
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
		private var pollTimer:Object;
		
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
						
		}
		
		protected function startPlayingIndeterminate():void
		{
			if (!indeterminatePlaying)
			{
//				indeterminatePlaying = true;
//				
//				pollTimer.addEventListener(TimerEvent.TIMER, updateIndeterminateHandler, false, 0, true);
//				pollTimer.start();
			}		
		}
		
		private function updateIndeterminateHandler():void
		{
			if (thumb.x < 1)
				thumb.x += 1;
			else
				thumb.x = - (getStyle("indeterminateMoveInterval") - 2);
		}
		
		/**
		 * [SkinPart]实体滑块组件
		 */		
		public var thumb:DisplayObject;
		
		/**
		 * [SkinPart]实体轨道组件
		 */
		public var track:DisplayObject; 
		
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