package org.flexlite.domUI.managers
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.DomGlobals;
	
	import flash.events.Event;
	import flash.events.FullScreenEvent;

	/**
	 * 全局容器类，有两层，应用层，弹出框层
	 * @author LC
	 * 
	 */	
	public class AppContainer extends Group
	{
		
		/**
		 * 应用程序层
		 */		
		private var _applicationLayer:Group;
		/**
		 * 弹出框层
		 */		
		private var _popUpLayer:Group;
		
		public function AppContainer()
		{
			super();
			
			if(stage)
			{
				stage.addEventListener(Event.RESIZE,onResize);
				stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullScreenHandle);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			}
			
			_applicationLayer = new Group;
			_applicationLayer.percentHeight = _applicationLayer.percentWidth = 100;
			addElement(_applicationLayer);
			
			_popUpLayer = new Group;
			_popUpLayer.percentHeight = _popUpLayer.percentWidth = 100;
			addElement(_popUpLayer);
		}
		
		protected function onAddToStage(event:Event):void
		{
			setWH();
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullScreenHandle);
		}
		
		protected function onResize(event:Event):void
		{
			setWH();
		}
		
		protected function onFullScreenHandle(event:FullScreenEvent):void
		{
			setWH();
		}
		
		private function setWH():void
		{
			this.width = DomGlobals.stage.stageWidth;
			this.height = DomGlobals.stage.stageHeight;
		}
		
		public function get applicationLayer():Group
		{
			return _applicationLayer;
		}
		
		public function get popUpLayer():Group
		{
			return _popUpLayer;
		}
	}
}