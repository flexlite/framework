package org.flexlite.domCompile.core
{
	/**
	 * 
	 * @author DOM
	 */	
	public interface ICode
	{
		/**
		 * 打印代码
		 */		
		function toCode():String;
		/**
		 * 行缩进值
		 */		
		function get indent():int;
		function set indent(value:int):void;
	}
}