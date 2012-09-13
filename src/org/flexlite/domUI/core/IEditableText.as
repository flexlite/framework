package org.flexlite.domUI.core
{
	/**
	 * 可编辑文本控件接口
	 * @author DOM
	 */	
	public interface IEditableText extends IDisplayText
	{ 
		/**
		 * @copy flash.text.TextField#displayAsPassword
		 */		
		function get displayAsPassword():Boolean;
		function set displayAsPassword(value:Boolean):void;
		
		/**
		 * 文本是否可编辑的标志。
		 */		
		function get editable():Boolean;
		function set editable(value:Boolean):void;
		
		/**
		 * @copy org.flexlite.domUI.core.UIComponent#enabled
		 */		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
		/**
		 * @copy org.flexlite.domUI.core.IViewport#horizontalScrollPosition
		 */		
		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		
		/**
		 * @copy org.flexlite.domUI.core.IViewport#verticalScrollPosition
		 */
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		/**
		 * @copy flash.text.TextField#maxChars
		 */		
		function get maxChars():int;
		function set maxChars(value:int):void;
		
		/**
		 * @copy flash.text.TextField#multiline
		 */		
		function get multiline():Boolean;
		function set multiline(value:Boolean):void;
		
		/**
		 * @copy flash.text.TextField#restrict
		 */	
		function get restrict():String;
		function set restrict(value:String):void;
		
		/**
		 * @copy flash.text.TextField#selectable
		 */
		function get selectable():Boolean;
		function set selectable(value:Boolean):void;
		
		/**
		 * @copy flash.text.TextField#selectionBeginIndex
		 */		
		function get selectionBeginIndex():int;
		
		/**
		 * @copy flash.text.TextField#selectionEndIndex
		 */		
		function get selectionEndIndex():int;
		
		/**
		 * @copy flash.text.TextField#caretIndex
		 */	
		function get caretIndex():int;
		
		/**
		 * @copy flash.text.TextField#setSelection()
		 */		
		function setSelection(beginIndex:int,endIndex:int):void;
		
		/**
		 * 选中所有文本。
		 */		
		function selectAll():void;
	}
}