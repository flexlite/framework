package org.flexlite.domUI.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvent;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.managers.layoutClass.DepthQueue;
	
	use namespace dx_internal;
	
	/**
	 * 所有组件的一次三个延迟验证渲染阶段全部完成 
	 */	
	[Event(name="updateComplete", type="org.flexlite.domUI.events.UIEvent")]
	/**
	 * 布局管理器
	 * @author DOM
	 */
	public class LayoutManager extends EventDispatcher
	{
		public function LayoutManager()
		{
			super();
		}
		
		private var targetLevel:int = int.MAX_VALUE;
		/**
		 * 需要抛出组件初始化完成事件的对象 
		 */		
		private var updateCompleteQueue:DepthQueue = new DepthQueue();
		
		private var invalidatePropertiesFlag:Boolean = false;
		
		private var invalidateClientPropertiesFlag:Boolean = false;
		
		private var invalidatePropertiesQueue:DepthQueue = new DepthQueue();
		/**
		 * 标记组件提交过属性
		 */		
		public function invalidateProperties(client:ILayoutManagerClient):void
		{
			if(!invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag = true;
				if(!listenersAttached)
					attachListeners();
			}
			if (targetLevel <= client.nestLevel)
				invalidateClientPropertiesFlag = true;
			invalidatePropertiesQueue.insert(client);
		}
		
		/**
		 * 使提交的属性生效
		 */		
		private function validateProperties():void
		{
			var client:ILayoutManagerClient = invalidatePropertiesQueue.shift();
			while(client)
			{
				if (client.parent)
				{
					client.validateProperties();
					if (!client.updateCompletePendingFlag)
					{
						updateCompleteQueue.insert(client);
						client.updateCompletePendingFlag = true;
					}
				}        
				client = invalidatePropertiesQueue.shift();
			}
			if(invalidatePropertiesQueue.isEmpty())
				invalidatePropertiesFlag = false;
		}
		
		private var invalidateSizeFlag:Boolean = false;
		
		private var invalidateClientSizeFlag:Boolean = false;
		
		private var invalidateSizeQueue:DepthQueue = new DepthQueue();
		/**
		 * 标记需要重新测量尺寸
		 */		
		public function invalidateSize(client:ILayoutManagerClient ):void
		{
			if(!invalidateSizeFlag)
			{
				invalidateSizeFlag = true;
				if(!listenersAttached)
					attachListeners();
			}
			if (targetLevel <= client.nestLevel)
				invalidateClientSizeFlag = true;
			invalidateSizeQueue.insert(client);
		}
		/**
		 * 测量属性
		 */		
		private function validateSize():void
		{
			var client:ILayoutManagerClient = invalidateSizeQueue.pop();
			while(client)
			{
				if (client.parent)
				{
					client.validateSize();
					if (!client.updateCompletePendingFlag)
					{
						updateCompleteQueue.insert(client);
						client.updateCompletePendingFlag = true;
					}
				}      
				client = invalidateSizeQueue.pop();
			}
			if(invalidateSizeQueue.isEmpty())
				invalidateSizeFlag = false;
		}
		
		
		private var invalidateDisplayListFlag:Boolean = false;
		
		private var invalidateDisplayListQueue:DepthQueue = new DepthQueue();
		/**
		 * 标记需要重新测量尺寸
		 */		
		public function invalidateDisplayList(client:ILayoutManagerClient ):void
		{
			if(!invalidateDisplayListFlag)
			{
				invalidateDisplayListFlag = true;
				if(!listenersAttached)
					attachListeners();
			}
			invalidateDisplayListQueue.insert(client);
		}
		/**
		 * 测量属性
		 */		
		private function validateDisplayList():void
		{
			var client:ILayoutManagerClient = invalidateDisplayListQueue.shift();
			while(client)
			{
				if (client.parent)
				{
					client.validateDisplayList();
					if (!client.updateCompletePendingFlag)
					{
						updateCompleteQueue.insert(client);
						client.updateCompletePendingFlag = true;
					}
				}      
				client = invalidateDisplayListQueue.shift();
			}
			if(invalidateDisplayListQueue.isEmpty())
				invalidateDisplayListFlag = false;
		}
		/** 
		 * 是否已经添加了事件监听
		 */		
		private var listenersAttached:Boolean = false;
		/**
		 * 添加事件监听
		 */		
		private function attachListeners():void
		{
			DomGlobals.stage.addEventListener(Event.ENTER_FRAME,doPhasedInstantiationCallBack);
			DomGlobals.stage.addEventListener(Event.RENDER, doPhasedInstantiationCallBack);
			DomGlobals.stage.invalidate();
			listenersAttached = true;
		}
		
		/**
		 * 执行属性应用
		 */		
		private function doPhasedInstantiationCallBack(event:Event=null):void
		{
			DomGlobals.stage.removeEventListener(Event.ENTER_FRAME,doPhasedInstantiationCallBack);
			DomGlobals.stage.removeEventListener(Event.RENDER, doPhasedInstantiationCallBack);
			if(DomGlobals.catchCallLaterExceptions)
			{
				try
				{
					doPhasedInstantiation();
				}
				catch(e:Error)
				{
					var errorEvent:UncaughtErrorEvent = new UncaughtErrorEvent("callLaterError",false,true,e.getStackTrace());
					DomGlobals.stage.dispatchEvent(errorEvent);
				}
			}
			else
			{
				doPhasedInstantiation();
			}
		}
		
		private function doPhasedInstantiation():void
		{
			if (invalidatePropertiesFlag)
			{
				validateProperties();
			}
			if (invalidateSizeFlag)
			{
				validateSize();
			}
			
			if (invalidateDisplayListFlag)
			{
				validateDisplayList();
			}
			
			if (invalidatePropertiesFlag ||
				invalidateSizeFlag ||
				invalidateDisplayListFlag)
			{
				attachListeners();
			}
			else
			{
				listenersAttached = false;
				var client:ILayoutManagerClient = updateCompleteQueue.pop();
				while (client)
				{
					if (!client.initialized)
						client.initialized = true;
					if (client.hasEventListener(UIEvent.UPDATE_COMPLETE))
						client.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
					client.updateCompletePendingFlag = false;
					client = updateCompleteQueue.pop();
				}
				
				dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
			}
		}
		/**
		 * 立即应用所有延迟的属性
		 */		
		public function validateNow():void
		{
			var infiniteLoopGuard:int = 0;
			while (listenersAttached && infiniteLoopGuard++ < 100)
				doPhasedInstantiationCallBack();
		}
		/**
		 * 使大于等于指定组件层级的元素立即应用属性 
		 * @param target 要立即应用属性的组件
		 * @param skipDisplayList 是否跳过更新显示列表阶段
		 */			
		public function validateClient(target:ILayoutManagerClient, skipDisplayList:Boolean = false):void
		{
			
			var obj:ILayoutManagerClient;
			var i:int = 0;
			var done:Boolean = false;
			var oldTargetLevel:int = targetLevel;
			
			if (targetLevel == int.MAX_VALUE)
				targetLevel = target.nestLevel;
			
			while (!done)
			{
				done = true;
				
				obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
				while (obj)
				{
					if (obj.parent)
					{
						obj.validateProperties();
						if (!obj.updateCompletePendingFlag)
						{
							updateCompleteQueue.insert(obj);
							obj.updateCompletePendingFlag = true;
						}
					}
					obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
				}
				
				if (invalidatePropertiesQueue.isEmpty())
				{
					invalidatePropertiesFlag = false;
				}
				invalidateClientPropertiesFlag = false;
				
				obj = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(target));
				while (obj)
				{
					if (obj.parent)
					{
						obj.validateSize();
						if (!obj.updateCompletePendingFlag)
						{
							updateCompleteQueue.insert(obj);
							obj.updateCompletePendingFlag = true;
						}
					}
					if (invalidateClientPropertiesFlag)
					{
						obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
						if (obj)
						{
							invalidatePropertiesQueue.insert(obj);
							done = false;
							break;
						}
					}
					
					obj = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(target));
				}
				
				if (invalidateSizeQueue.isEmpty())
				{
					invalidateSizeFlag = false;
				}
				invalidateClientPropertiesFlag = false;
				invalidateClientSizeFlag = false;
				
				if (!skipDisplayList)
				{
					obj = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallestChild(target));
					while (obj)
					{
						if (obj.parent)
						{
							obj.validateDisplayList();
							if (!obj.updateCompletePendingFlag)
							{
								updateCompleteQueue.insert(obj);
								obj.updateCompletePendingFlag = true;
							}
						}
						if (invalidateClientPropertiesFlag)
						{
							obj = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(target));
							if (obj)
							{
								invalidatePropertiesQueue.insert(obj);
								done = false;
								break;
							}
						}
						
						if (invalidateClientSizeFlag)
						{
							obj = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(target));
							if (obj)
							{
								invalidateSizeQueue.insert(obj);
								done = false;
								break;
							}
						}
						
						obj = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallestChild(target));
					}
					
					
					if (invalidateDisplayListQueue.isEmpty())
					{
						invalidateDisplayListFlag = false;
					}
				}
			}
			
			if (oldTargetLevel == int.MAX_VALUE)
			{
				targetLevel = int.MAX_VALUE;
				if (!skipDisplayList)
				{
					obj = ILayoutManagerClient(updateCompleteQueue.removeLargestChild(target));
					while (obj)
					{
						if (!obj.initialized)
							obj.initialized = true;
						
						if (obj.hasEventListener(UIEvent.UPDATE_COMPLETE))
							obj.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
						obj.updateCompletePendingFlag = false;
						obj = ILayoutManagerClient(updateCompleteQueue.removeLargestChild(target));
					}
				}
			}
		}

	}
}