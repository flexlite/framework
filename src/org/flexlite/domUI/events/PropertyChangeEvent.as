package org.flexlite.domUI.events
{
	import flash.events.Event;
	
	/**
	 * 对象的一个属性发生更改时传递到事件侦听器的事件
	 * @author DOM
	 */
	public class PropertyChangeEvent extends Event
	{
		/**
		 * 属性改变 
		 */		
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		/**
		 * 返回使用指定属性构建的 PropertyChangeEventKind.UPDATE 类型的新 PropertyChangeEvent。 
		 * @param source 发生更改的对象。
		 * @param property 指定已更改属性的 String、QName 或 int。
		 * @param oldValue 更改前的属性的值。
		 * @param newValue 更改后的属性的值。
		 */		
		public static function createUpdateEvent(
			source:Object,
			property:Object,
			oldValue:Object,
			newValue:Object):PropertyChangeEvent
		{
			var event:PropertyChangeEvent =
				new PropertyChangeEvent(PROPERTY_CHANGE);
			
			event.kind = PropertyChangeEventKind.UPDATE;
			event.oldValue = oldValue;
			event.newValue = newValue;
			event.source = source;
			event.property = property;
			
			return event;
		}
		
		/**
		 * 构造函数
		 */		
		public function PropertyChangeEvent(type:String, bubbles:Boolean = false,
											cancelable:Boolean = false,
											kind:String = null,
											property:Object = null, 
											oldValue:Object = null,
											newValue:Object = null,
											source:Object = null)
		{
			super(type, bubbles, cancelable);
			
			this.kind = kind;
			this.property = property;
			this.oldValue = oldValue;
			this.newValue = newValue;
			this.source = source;
		}
		
		/**
		 * 指定更改的类型。可能的值为 PropertyChangeEventKind.UPDATE、PropertyChangeEventKind.DELETE 和 null。 
		 */		
		public var kind:String;
		
		/**
		 * 更改后的属性的值。 
		 */		
		public var newValue:Object;
		
		/**
		 * 更改后的属性的值。 
		 */
		public var oldValue:Object;
		
		/**
		 * 指定已更改属性的 String、QName 或 int。 
		 */
		public var property:Object;
		
		/**
		 * 发生更改的对象。 
		 */		
		public var source:Object;
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new PropertyChangeEvent(type, bubbles, cancelable, kind,
				property, oldValue, newValue, source);
		}
	}
}