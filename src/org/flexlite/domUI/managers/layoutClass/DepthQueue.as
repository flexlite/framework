package org.flexlite.domUI.managers.layoutClass
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.flexlite.domUI.managers.ILayoutManagerClient;

	[ExcludeClass]
	/**
	 * 显示列表嵌套深度排序队列
	 * @author DOM
	 */
	public class DepthQueue
	{
		public function DepthQueue()
		{
		}
		
		/**
		 * 深度队列
		 */
		private var depthBins:Array = [];
		
		/**
		 * 最小深度
		 */
		private var minDepth:int = 0;
		
		/**
		 * 最大深度
		 */
		private var maxDepth:int = -1;
		/**
		 * 插入一个元素
		 */		
		public function insert(client:ILayoutManagerClient):void
		{
			var depth:int = client.nestLevel;
			if (maxDepth < minDepth)
			{
				minDepth = maxDepth = depth;
			}
			else
			{
				if (depth < minDepth)
					minDepth = depth;
				if (depth > maxDepth)
					maxDepth = depth;
			}
			
			var bin:DepthBin = depthBins[depth];
			
			if (!bin)
			{
				bin = new DepthBin();
				depthBins[depth] = bin;
				bin.items[client] = true;
				bin.length++;
			}
			else
			{
				if (bin.items[client] == null)
				{ 
					bin.items[client] = true;
					bin.length++;
				}
			}
		}
		/**
		 * 从队列尾弹出深度最大的一个对象
		 */		
		public function pop():ILayoutManagerClient
		{
			var client:ILayoutManagerClient = null;
			
			if (minDepth <= maxDepth)
			{
				var bin:DepthBin = depthBins[maxDepth];
				while (!bin || bin.length == 0)
				{
					maxDepth--;
					if (maxDepth < minDepth)
						return null;
					bin = depthBins[maxDepth];
				}
				
				for (var key:Object in bin.items )
				{
					client = key as ILayoutManagerClient;
					remove(client, maxDepth);
					break;
				}
				
				while (!bin || bin.length == 0)
				{
					maxDepth--;
					if (maxDepth < minDepth)
						break;
					bin = depthBins[maxDepth];
				}
				
			}
			
			return client;
		}
		/**
		 * 从队列首弹出深度最小的一个对象
		 */		
		public function shift():ILayoutManagerClient
		{
			var client:ILayoutManagerClient = null;
			
			if (minDepth <= maxDepth)
			{
				var bin:DepthBin = depthBins[minDepth];
				while (!bin || bin.length == 0)
				{
					minDepth++;
					if (minDepth > maxDepth)
						return null;
					bin = depthBins[minDepth];
				}           
				
				for (var key:Object in bin.items )
				{
					client = key as ILayoutManagerClient;
					remove(client, minDepth);
					break;
				}
				
				while (!bin || bin.length == 0)
				{
					minDepth++;
					if (minDepth > maxDepth)
						break;
					bin = depthBins[minDepth];
				}           
			}
			
			return client;
		}
		
		/**
		 * 移除大于等于指定组件层级的元素中最大的元素
		 */
		public function removeLargestChild(client:ILayoutManagerClient ):Object
		{
			var max:int = maxDepth;
			var min:int = client.nestLevel;
			
			while (min <= max)
			{
				var bin:DepthBin = depthBins[max];
				if (bin && bin.length > 0)
				{
					if (max == client.nestLevel)
					{
						if (bin.items[client])
						{
							remove(ILayoutManagerClient(client), max);
							return client;
						}
					}
					else
					{
						for (var key:Object in bin.items )
						{
							if ((key is DisplayObject) && (client is DisplayObjectContainer)
								&&(client as DisplayObjectContainer).contains(DisplayObject(key)))
							{
								remove(ILayoutManagerClient(key), max);
								return key;
							}
						}
					}
					
					max--;
				}
				else
				{
					if (max == maxDepth)
						maxDepth--;
					max--;
					if (max < min)
						break;
				}           
			}
			
			return null;
		}
		
		/**
		 * 移除大于等于指定组件层级的元素中最小的元素
		 */
		public function removeSmallestChild(client:ILayoutManagerClient ):Object
		{
			var min:int = client.nestLevel;
			
			while (min <= maxDepth)
			{
				var bin:DepthBin = depthBins[min];
				if (bin && bin.length > 0)
				{   
					if (min == client.nestLevel)
					{
						if (bin.items[client])
						{
							remove(ILayoutManagerClient(client), min);
							return client;
						}
					}
					else
					{
						for (var key:Object in bin.items)
						{
							if ((key is DisplayObject) && (client is DisplayObjectContainer)
								&&(client as DisplayObjectContainer).contains(DisplayObject(key)))
							{
								remove(ILayoutManagerClient(key), min);
								return key;
							}
						}
					}
					
					min++;
				}
				else
				{
					if (min == minDepth)
						minDepth++;
					min++;
					if (min > maxDepth)
						break;
				}           
			}
			
			return null;
		}
		
		/**
		 * 移除一个元素
		 */
		public function remove(client:ILayoutManagerClient,level:int=-1):ILayoutManagerClient
		{
			var depth:int = (level >= 0) ? level : client.nestLevel;
			var bin:DepthBin = depthBins[depth];
			if (bin && bin.items[client] != null)
			{
				delete bin.items[client];
				bin.length--;
				return client;
			}
			return null;
		}
		
		/**
		 * 清空队列
		 */		
		public function removeAll():void
		{
			depthBins.length = 0;
			minDepth = 0;
			maxDepth = -1;
		}
		/**
		 * 队列是否为空
		 */		
		public function isEmpty():Boolean
		{
			return minDepth > maxDepth;
		}
	}
}
import flash.utils.Dictionary;

/**
 * 列表项
 */
class DepthBin 
{
	public function DepthBin()
	{
		
	}
	public var length:int;
	public var items:Dictionary = new Dictionary();
}