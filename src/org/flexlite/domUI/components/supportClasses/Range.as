package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domUI.components.SkinnableComponent;

	[DXML(show="false")]
	
	/**
	 * 范围选取组件,该组件包含一个值和这个值所允许的最大最小约束范围。
	 * @author DOM
	 */	
	public class Range extends SkinnableComponent
	{
		/**
		 * 构造函数
		 */		
		public function Range():void
		{
			super();
			focusEnabled = true;
		}
		
		private var _maximum:Number = 100;
		
		/**
		 * 最大有效值改变标志
		 */		
		private var maxChanged:Boolean = false;
		
		/**
		 * 最大有效值
		 */		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			if (value == _maximum)
				return;
			
			_maximum = value;
			maxChanged = true;
			
			invalidateProperties();
		}
		
		private var _minimum:Number = 0;
		
		/**
		 * 最小有效值改变标志 
		 */		
		private var minChanged:Boolean = false;
		
		/**
		 * 最小有效值
		 */		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			if (value == _minimum)
				return;
			
			_minimum = value;
			minChanged = true;
			
			invalidateProperties();
		}
		
		private var _stepSize:Number = 1;
		
		/**
		 * 单步大小改变的标志
		 */	
		private var stepSizeChanged:Boolean = false;
		
		/**
		 * 调用 changeValueByStep() 方法时 value 属性更改的单步大小。默认值为 1。<br/>
		 * 除非 snapInterval 为 0，否则它必须是 snapInterval 的倍数。<br/>
		 * 如果 stepSize 不是倍数，则会将它近似到大于或等于 snapInterval 的最近的倍数。<br/>
		 */		
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		public function set stepSize(value:Number):void
		{
			if (value == _stepSize)
				return;
			
			_stepSize = value;
			stepSizeChanged = true;
			
			invalidateProperties();       
		}
		
		private var _value:Number = 0;
		
		private var _changedValue:Number = 0;
		/**
		 * 此范围的当前值改变标志 
		 */		
		private var valueChanged:Boolean = false;
		/**
		 * 此范围的当前值。
		 */		
		public function get value():Number
		{
			return (valueChanged) ? _changedValue : _value;
		}
		    
		public function set value(newValue:Number):void
		{
			if (newValue == value)
				return;
			_changedValue = newValue;
			valueChanged = true;
			invalidateProperties();
		}
		
		private var _snapInterval:Number = 1;
		
		private var snapIntervalChanged:Boolean = false;
		
		private var _explicitSnapInterval:Boolean = false;
		
		/**
		 * snapInterval 属性定义 value 属性的有效值。如果为非零，则有效值为 minimum 与此属性的整数倍数之和，且小于或等于 maximum。 <br/>
		 * 例如，如果 minimum 为 10，maximum 为 20，而此属性为 3，则可能的有效值为 10、13、16、19 和 20。<br/>
		 * 如果此属性的值为零，则仅会将有效值约束到介于 minimum 和 maximum 之间（包括两者）。<br/>
		 * 此属性还约束 stepSize 属性（如果设置）的有效值。如果未显式设置此属性，但设置了 stepSize，则 snapInterval 将默认为 stepSize。<br/>
		 */		
		public function get snapInterval():Number
		{
			return _snapInterval;
		}
		
		public function set snapInterval(value:Number):void
		{
			_explicitSnapInterval = true;
			
			if (value == _snapInterval)
				return;
			if (isNaN(value))
			{
				_snapInterval = 1;
				_explicitSnapInterval = false;
			}
			else
			{
				_snapInterval = value;
			}
			
			snapIntervalChanged = true;
			stepSizeChanged = true;
			
			invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (minimum > maximum)
			{
				
				if (!maxChanged)
					_minimum = _maximum;
				else
					_maximum = _minimum;
			}
			
			if (valueChanged || maxChanged || minChanged || snapIntervalChanged)
			{
				var currentValue:Number = (valueChanged) ? _changedValue : _value;
				valueChanged = false;
				maxChanged = false;
				minChanged = false;
				snapIntervalChanged = false;
				setValue(nearestValidValue(currentValue, snapInterval));
			}
			
			if (stepSizeChanged)
			{
				if (_explicitSnapInterval)
				{
					_stepSize = nearestValidSize(_stepSize);
				}
				else
				{
					_snapInterval = _stepSize;
					setValue(nearestValidValue(_value, snapInterval));
				}
				
				stepSizeChanged = false;
			}
		}
		
		/**
		 * 修正stepSize到最接近snapInterval的整数倍
		 */		
		private function nearestValidSize(size:Number):Number
		{
			var interval:Number = snapInterval;
			if (interval == 0)
				return size;
			
			var validSize:Number = Math.round(size / interval) * interval
			return (Math.abs(validSize) < interval) ? interval : validSize;
		}
		
		/**
		 * 修正输入的值为有效值
		 * @param value 输入值。
		 * @param interval snapInterval 的值，或 snapInterval 的整数倍数。
		 */		
		protected function nearestValidValue(value:Number, interval:Number):Number
		{ 
			if (interval == 0)
				return Math.max(minimum, Math.min(maximum, value));
			
			var maxValue:Number = maximum - minimum;
			var scale:Number = 1;
			
			value -= minimum;
			if (interval != Math.round(interval)) 
			{ 
				const parts:Array = (new String(1 + interval)).split("."); 
				scale = Math.pow(10, parts[1].length);
				maxValue *= scale;
				value = Math.round(value * scale);
				interval = Math.round(interval * scale);
			}   
			
			var lower:Number = Math.max(0, Math.floor(value / interval) * interval);
			var upper:Number = Math.min(maxValue, Math.floor((value + interval) / interval) * interval);
			var validValue:Number = ((value - lower) >= ((upper - lower) / 2)) ? upper : lower;
			
			return (validValue / scale) + minimum;
		}
		
		/**
		 * 设置当前值。此方法假定调用者已经使用了 nearestValidValue() 方法来约束 value 参数
		 * @param value value属性的新值
		 */				
		protected function setValue(value:Number):void
		{
			if (_value == value)
				return;
			if(isNaN(value))
				value = 0;
			if (!isNaN(maximum) && !isNaN(minimum) && (maximum > minimum))
				_value = Math.min(maximum, Math.max(minimum, value));
			else
				_value = value;
			valueChanged = false;
		}
		
		/**
		 * 按 stepSize增大或减小当前值
		 * @param increase 若为 true，则向value增加stepSize，否则减去它。
		 */		
		public function changeValueByStep(increase:Boolean = true):void
		{
			if (stepSize == 0)
				return;
			
			var newValue:Number = (increase) ? value + stepSize : value - stepSize;
			setValue(nearestValidValue(newValue, snapInterval));
		}
	}
	
}