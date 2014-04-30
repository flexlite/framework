package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 皮肤组件附加移除事件
	 * @author DOM
	 */
	public class SkinPartEvent extends Event
	{
		/**
		 * 附加皮肤公共子部件 
		 */		
		public static const PART_ADDED:String = "partAdded";
		/**
		 * 移除皮肤公共子部件 
		 */		
		public static const PART_REMOVED:String = "partRemoved";
		
		public function SkinPartEvent(type:String, bubbles:Boolean = false,
									  cancelable:Boolean = false,
									  partName:String = null, 
									  instance:Object = null) 
		{
			super(type, bubbles, cancelable);
			
			this.partName = partName;
			this.instance = instance;
		}
		
		/**
		 * 被添加或移除的皮肤组件实例
		 */    
		public var instance:Object;
		
		/**
		 * 被添加或移除的皮肤组件的实例名
		 */   
		public var partName:String;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SkinPartEvent(type, bubbles, cancelable, 
				partName, instance);
		}
	}
}