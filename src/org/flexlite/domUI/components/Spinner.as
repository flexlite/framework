package org.flexlite.domUI.components
{
	import org.flexlite.domUI.components.supportClasses.Range;
	import org.flexlite.domUI.core.dx_internal;
	import org.flexlite.domUI.events.UIEvent;
	
	import flash.events.Event;
	
	
	use namespace dx_internal;
	/**
	 * 当控件的值由于用户交互操作而发生更改时分派。 
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 微调控制器
	 * @author DOM
	 */
	public class Spinner extends Range
	{
		/**
		 * 构造函数
		 */
		public function Spinner():void
		{
			super();
		}
		
		override protected function get hostComponentKey():Object
		{
			return Spinner;
		}
		/**
		 * [SkinPart]减小值按钮
		 */	
		public var decrementButton:Button;
		/**
		 * [SkinPart]增大值按钮
		 */	
		public var incrementButton:Button;
		
		private var _allowValueWrap:Boolean = false;
		/**
		 * 此属性为true时，当value已达到最大值时，还要继续增大将会跳到最小值重新循环，反之当小于最小值时将跳到最大值。
		 */	
		public function get allowValueWrap():Boolean
		{
			return _allowValueWrap;
		}
		
		public function set allowValueWrap(value:Boolean):void
		{
			_allowValueWrap = value;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == incrementButton)
			{
				incrementButton.addEventListener(UIEvent.BUTTON_DOWN,
					incrementButton_buttonDownHandler);
				incrementButton.autoRepeat = true;
			}
			else if (instance == decrementButton)
			{
				decrementButton.addEventListener(UIEvent.BUTTON_DOWN,
					decrementButton_buttonDownHandler);
				decrementButton.autoRepeat = true;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == incrementButton)
			{
				incrementButton.removeEventListener(UIEvent.BUTTON_DOWN, 
					incrementButton_buttonDownHandler);
			}
			else if (instance == decrementButton)
			{
				decrementButton.removeEventListener(UIEvent.BUTTON_DOWN, 
					decrementButton_buttonDownHandler);
			}
		}
		
		override public function changeValueByStep(increase:Boolean = true):void
		{
			if (allowValueWrap)
			{
				if (increase && (value == maximum))
					value = minimum;
				else if (!increase && (value == minimum))
					value = maximum;
				else 
					super.changeValueByStep(increase);
			}
			else
				super.changeValueByStep(increase);
		}
		/**
		 * 增大值按钮按下事件
		 */	
		protected function incrementButton_buttonDownHandler(event:Event):void
		{
			var prevValue:Number = this.value;
			
			changeValueByStep(true);
			
			if (value != prevValue)
				dispatchEvent(new Event("change"));
		}
		/**
		 * 减小值按钮按下事件
		 */	
		protected function decrementButton_buttonDownHandler(event:Event):void
		{
			var prevValue:Number = this.value;
			
			changeValueByStep(false);
			
			if (value != prevValue)
				dispatchEvent(new Event("change"));
		}   
	}	
	
}
