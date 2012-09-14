<<<<<<< HEAD
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
=======
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
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
