<<<<<<< HEAD
package org.flexlite.domUI.core
{
	/**
	 * 拥有失效验证机制组件接口
	 * @author DOM
	 */
	public interface IInvalidating
	{
		/**
		 * 标记提交过需要延迟应用的属性
		 */			
		function invalidateProperties():void;
		/**
		 * 标记提交过需要验证组件尺寸
		 */	
		function invalidateSize():void;
		/**
		 * 标记需要验证显示列表
		 */	
		function invalidateDisplayList():void;
		/**
		 * 有需要延迟验证的标记。
		 * invalidateProperties()，invalidateSize()，
		 * invalidateDisplayList()任何一个方法被调用过，返回true.
		 */		
		function get invalidateFlag():Boolean;
		/**
		 * 立即应用组件及其子项的所有属性 
		 * @param skipDisplayList 是否跳过显示列表验证阶段,默认false
		 */		
		function validateNow(skipDisplayList:Boolean = false):void;
	}
=======
package org.flexlite.domUI.core
{
	/**
	 * 拥有失效验证机制组件接口
	 * @author DOM
	 */
	public interface IInvalidating
	{
		/**
		 * 标记提交过需要延迟应用的属性
		 */			
		function invalidateProperties():void;
		/**
		 * 标记提交过需要验证组件尺寸
		 */	
		function invalidateSize():void;
		/**
		 * 标记需要验证显示列表
		 */	
		function invalidateDisplayList():void;
		/**
		 * 有需要延迟验证的标记。
		 * invalidateProperties()，invalidateSize()，
		 * invalidateDisplayList()任何一个方法被调用过，返回true.
		 */		
		function get invalidateFlag():Boolean;
		/**
		 * 立即应用组件及其子项的所有属性 
		 * @param skipDisplayList 是否跳过显示列表验证阶段,默认false
		 */		
		function validateNow(skipDisplayList:Boolean = false):void;
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}