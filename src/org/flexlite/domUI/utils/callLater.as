package org.flexlite.domUI.utils
{
	/**
	 * 延迟函数到屏幕重绘前执行。
	 * @param method 要延迟执行的函数
	 * @param args 函数参数列表
	 * @param delayFrames 延迟的帧数，0表示在当前帧的屏幕重绘前执行,1表示下一帧，以此类推。默认值0。
	 */		
	public function callLater(method:Function,args:Array=null,delayFrames:int=0):void
	{
		DelayCall.getInstance().callLater(method,args,delayFrames);
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
	private var methodQueue:Vector.<MethodQueueElement> = new Vector.<MethodQueueElement>();
	/**
	 * 是否添加过EnterFrame事件监听标志 
	 */		
	private var listenForEnterFrame:Boolean = false;
	/**
	 * 是否添加过Render事件监听标志 
	 */	
	private var listenForRender:Boolean = false;
	
	/**
	 * 延迟函数到屏幕重绘前执行。
	 * @param method 要延迟执行的函数
	 * @param args 函数参数列表
	 * @param delayFrames 延迟的帧数，0表示在当前帧的屏幕重绘前执行,1表示下一帧，以此类推。默认值0。
	 */		
	public function callLater(method:Function,args:Array=null,delayFrames:int=0):void
	{
		methodQueue.push(new MethodQueueElement(method,args,delayFrames));
		if(!listenForEnterFrame)
		{
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			listenForEnterFrame = true;
		}
		if(!listenForRender&&DomGlobals.stage)
		{
			DomGlobals.stage.addEventListener(Event.RENDER,onCallBack,false,-1000);
			DomGlobals.stage.invalidate();
			listenForRender = true;
		}
	}
	/**
	 * EnterFrame事件
	 */	
	private function onEnterFrame(event:Event):void
	{
		if(listenForRender)
			DomGlobals.stage.invalidate();
		else
			onCallBack();
	}
	/**
	 * 执行延迟函数
	 */		
	private function onCallBack(event:Event=null):void
	{
		var element:MethodQueueElement;
		for(var i:int=0;i<methodQueue.length;i++)
		{
			element = methodQueue[i];
			if(element.delayFrames>0)
			{
				element.delayFrames--;
				continue;
			}
			methodQueue.splice(i,1);
			i--;
			if(element.args==null)
			{
				element.method();
			}
			else
			{
				element.method.apply(null,element.args);
			}
		}
		if(methodQueue.length==0)
		{
			if(listenForEnterFrame)
			{
				removeEventListener(Event.ENTER_FRAME,onCallBack);
				listenForEnterFrame = false;
			}
			if(listenForRender)
			{
				DomGlobals.stage.removeEventListener(Event.RENDER,onCallBack);
				listenForRender = false;
			}
		}
	}
}

/**
 *  延迟执行函数元素
 */
class MethodQueueElement
{
	
	public function MethodQueueElement(method:Function,args:Array = null,delayFrames:int=0)
	{
		this.method = method;
		this.args = args;
		this.delayFrames = delayFrames;
	}
	
	public var method:Function;
	
	public var args:Array;
	
	public var delayFrames:int;
}