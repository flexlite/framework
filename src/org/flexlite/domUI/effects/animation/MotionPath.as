package org.flexlite.domUI.effects.animation
{
	/**
	 * 数值运动路径。用于定义需要在Animation类中缓动的数值范围。
	 * @author DOM
	 */
	public class MotionPath
	{
		/**
		 * 构造函数
		 * @param property 正在设置动画的属性的名称。
		 * @param valueFrom 缓动的起始值
		 * @param valueTo 缓动的结束值
		 */		
		public function MotionPath(property:String=null, valueFrom:Number=0, valueTo:Number=1)
		{
			_property = property;
			_valueFrom = valueFrom;
			_valueTo = valueTo;
		}
		
		private var _property:String;
		/**
		 * 正在设置动画的属性的名称。
		 */		
		public function get property():String
		{
			return _property;
		}

		public function set property(value:String):void
		{
			_property = value;
		}
		
		private var _valueFrom:Number
		/**
		 * 缓动的起始值
		 */
		public function get valueFrom():Number
		{
			return _valueFrom;
		}

		public function set valueFrom(value:Number):void
		{
			_valueFrom = value;
		}

		private var _valueTo:Number
		/**
		 * 缓动的结束值
		 */
		public function get valueTo():Number
		{
			return _valueTo;
		}

		public function set valueTo(value:Number):void
		{
			_valueTo = value;
		}


	}
}