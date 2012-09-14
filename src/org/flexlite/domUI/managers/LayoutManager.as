<<<<<<< HEAD
package org.flexlite.domUI.managers
{
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.managers.layoutClass.DepthQueue;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
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
				if (client.hasParent)
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
				if (client.hasParent)
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
				if (client.hasParent)
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
			DomGlobals.stage.addEventListener(Event.ENTER_FRAME,doPhasedInstantiation);
			listenersAttached = true;
		}
		/**
		 * 执行属性应用
		 */		
		private function doPhasedInstantiation(event:Event=null):void
		{
			DomGlobals.stage.removeEventListener(Event.ENTER_FRAME,doPhasedInstantiation);
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
				doPhasedInstantiation();
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
					if (obj.hasParent)
					{
						obj.validateProperties();
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
					if (obj.hasParent)
					{
						obj.validateSize();
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
						if (obj.hasParent)
						{
							obj.validateDisplayList();
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
			}
		}

	}
=======
package org.flexlite.domUI.managers
{
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.managers.layoutClass.DepthQueue;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
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
				if (client.hasParent)
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
				if (client.hasParent)
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
				if (client.hasParent)
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
			DomGlobals.stage.addEventListener(Event.ENTER_FRAME,doPhasedInstantiation);
			listenersAttached = true;
		}
		/**
		 * 执行属性应用
		 */		
		private function doPhasedInstantiation(event:Event=null):void
		{
			DomGlobals.stage.removeEventListener(Event.ENTER_FRAME,doPhasedInstantiation);
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
				doPhasedInstantiation();
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
					if (obj.hasParent)
					{
						obj.validateProperties();
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
					if (obj.hasParent)
					{
						obj.validateSize();
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
						if (obj.hasParent)
						{
							obj.validateDisplayList();
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
			}
		}

	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}