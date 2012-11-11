package org.flexlite.domUI.utils
{
	/**
	 * 延迟函数到下一次重绘时执行。
	 * @param method 要延迟执行的函数
	 * @param args 函数参数列表
	 */		
	public function callLater(method:Function,args:Array=null):void
	{
		DelayCall.getInstance().callLater(method,args);
	}
}

import flash.display.Shape;
import flash.events.Event;

import org.flexlite.domUI.core.DomGlobals;

/**
 * 延迟执行函数管理类
 * @author DOM
 */
class DelayCall extends Shape
{
	
	private static var _instance:DelayCall;
	/**
	 * 获取单例
	 */	
	public static function getInstance():DelayCall
	{
		if(!_instance)
			_instance = new DelayCall();
		return _instance;
	}
	/**
	 * 延迟函数队列 
	 */		
	private var methodQueue:Vector.<MethodQueueElement>;
	/**
	 * 是否添加过事件监听标志 
	 */		
	private var hasListener:Boolean = false;
	
	/**
	 * 延迟函数到下一次重绘时执行
	 * @param method 要延迟执行的函数
	 * @param args 函数参数列表
	 */		
	public function callLater(method:Function,args:Array=null):void
	{
		if(methodQueue==null)
		{
			methodQueue = new Vector.<MethodQueueElement>();
		}
		methodQueue.push(new MethodQueueElement(method,args));
		if(!hasListener)
		{
			addEventListener(Event.ENTER_FRAME,onCallBack);
			if(DomGlobals.stage)
			{
				DomGlobals.stage.addEventListener(Event.RENDER,onCallBack);
				DomGlobals.stage.invalidate();
			}
			hasListener = true;
		}
	}
	/**
	 * 执行延迟函数
	 */		
	private function onCallBack(event:Event):void
	{
		removeEventListener(Event.ENTER_FRAME,onCallBack);
		if(DomGlobals.stage)
		{
			DomGlobals.stage.removeEventListener(Event.RENDER,onCallBack);
		}
		hasListener = false;
		var queue:Vector.<MethodQueueElement> = methodQueue;
		methodQueue = null;
		for each(var element:MethodQueueElement in queue)
		{
			if(element.args==null)
			{
				element.method();
			}
			else
			{
				element.method.apply(null,element.args);
			}
		}
	}
}

/**
 *  延迟执行函数元素
 */
class MethodQueueElement
{
	
	public function MethodQueueElement(method:Function,args:Array = null)
	{
		this.method = method;
		this.args = args;
	}
	
	public var method:Function;
	
	public var args:Array;
}