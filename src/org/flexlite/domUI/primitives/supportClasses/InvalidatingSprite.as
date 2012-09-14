package org.flexlite.domUI.primitives.supportClasses
{
	
	import org.flexlite.domUI.core.ISharedDisplayObject;
	
	import flash.display.Sprite;
	
	public class InvalidatingSprite extends Sprite implements ISharedDisplayObject
	{
		public function InvalidatingSprite()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		private var _redrawRequested:Boolean = false;
		
		public function get redrawRequested():Boolean
		{
			return _redrawRequested;
		}
		
		public function set redrawRequested(value:Boolean):void
		{
			_redrawRequested = value;
		}
	}
}
