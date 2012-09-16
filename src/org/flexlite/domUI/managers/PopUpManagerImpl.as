package org.flexlite.domUI.managers
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.IEffect;
	import org.flexlite.domUI.core.IInvalidating;
	import org.flexlite.domUI.core.IUIComponent;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.events.EffectEvent;

	[ExcludeClass]
	
	/**
	 * 窗口弹出管理器实现类
	 * @author DOM
	 */
	public class PopUpManagerImpl
	{
		public function PopUpManagerImpl()
		{
		}
		
		/**
		 * 优先级队列
		 */		
		private var priorityQueue:Array = [];
		/**
		 * 插入数据到优先级队列
		 */		
		private function insert(data:PopUpData):void
		{
			var index:int = 0;
			if(priorityQueue.length>0)
			{
				index = findIndexAt(data.priority,0,priorityQueue.length-1);
				var priority:int = priorityQueue[index][0].priority;
				if(data.priority<priority)
				{
					priorityQueue.splice(index,0,new Vector.<PopUpData>());
				}
				else if(data.priority>priority)
				{
					index++;
					priorityQueue.splice(index,0,new Vector.<PopUpData>());
				}
			}
			else
			{
				priorityQueue.push(new Vector.<PopUpData>());
			}
			priorityQueue[index].push(data);
		}
		/**
		 * 折半查找法查询插入的索引,返回大于等于priority的第一个索引
		 */		
		private function findIndexAt(priority:int,i0:int,i1:int):int
		{
			if(i0==i1)
				return i0;
			var index:int = Math.floor((i0 + i1)*0.5);
			var p:int = priorityQueue[index][0].priority;
			
			if(priority==p)
				return index;
			else if (priority<p)
				return findIndexAt(priority, i0, Math.max(i0, index-1));
			else 
				return findIndexAt(priority, Math.min(index+1, i1), i1);
		}
		/**
		 * 从优先级队列移除数据
		 */		
		private function remove(data:PopUpData):void
		{
			if(priorityQueue.length==0)
				return;
			var index:int = findIndexAt(data.priority,0,priorityQueue.length-1);
			var priority:int = priorityQueue[index][0].priority;
			if(data.priority==priority)
			{
				var list:Vector.<PopUpData> = priorityQueue[index];
				var dataIndex:int = list.indexOf(data);
				list.splice(dataIndex,1);
				if(list.length==0)
					priorityQueue.splice(index,1);
			}
		}
		
		private var popUpDataDic:Dictionary = new Dictionary;
		/**
		 * 当前显示的窗口数据列表
		 */		
		private var _currentPopUps:Vector.<PopUpData> = new Vector.<PopUpData>;
		/**
		 * 返回当前弹出并显示的窗口列表
		 */		
		public function get currentPopUps():Array
		{
			var arr:Array = [];
			for each(var data:PopUpData in _currentPopUps)
			{
				arr.push(data.popUp);
			}
			return arr;
		}
		/**
		 * 弹出一个窗口,请调用 removePopUp()来移除使用 addPopUp()方法弹出的窗口。
		 * @param popUp 要弹出的窗口显示对象
		 * @param modal 是否启用模态。禁用弹出层以下的鼠标事件。默认false。
		 * @param exclusive 是否独占。若为true，它总是不与任何窗口共存。当弹出时，将隐藏层级在它后面的所有窗口。
		 * 若有层级在它前面的窗口弹出，无论新窗口是否独占，都将它和它后面的窗口全部隐藏。默认为false。
		 * @param priority 弹出优先级。优先级高的窗口显示层级在低的前面。同一优先级的窗口，后添加的窗口层级在前面。
		 * @param popUpEffect 窗口弹出时要播放的动画特效。
		 */		
		public function addPopUp(popUp:IVisualElement,modal:Boolean = false,
										exclusive:Boolean=false,priority:int=0,
										popUpEffect:IEffect=null):void
		{
			var popUpData:PopUpData = new PopUpData(popUp,modal,exclusive,priority,popUpEffect);
			if(popUpDataDic[popUp]!=null)
			{
				remove(popUpDataDic[popUp]);
			}
			popUpDataDic[popUp] = popUpData;
			if(popUp is IUIComponent)
				(popUp as IUIComponent).isPopUp = true;
			insert(popUpData);
			updateCurrentPopUps();
		}
		/**
		 * 模态层
		 */		
		private var modalLayer:UIComponent;
		/**
		 * 遮罩层已经添加的标志 
		 */		
		private var modalAttached:Boolean = false;
		/**
		 * 更新当前的窗口打开项
		 */		
		private function updateCurrentPopUps():void
		{
			var popUps:Vector.<PopUpData> = getCurrentPopUps();
			var popUpContainer:IContainer = DomGlobals.systemManager.popUpContainer;
			for each(var data:PopUpData in _currentPopUps)
			{
				if(popUps.indexOf(data)==-1)
				{
					if(data.popUp.parent)
						popUpContainer.removeElement(data.popUp);
				}
			}
			var needModal:Boolean = false;
			for each(data in popUps)
			{
				popUpContainer.addElement(data.popUp);
				if(data.popUpEffect&&_currentPopUps.indexOf(data.popUp)==-1)
				{
					showEffect(data.popUp,data.popUpEffect);
				}
				if(!needModal&&data.modal)
					needModal = true;
			}
			_currentPopUps = popUps;
			if(needModal==modalAttached)
				return;
			if(needModal)
			{
				if(!modalLayer)
				{
					modalLayer = new UIComponent();
				}
				popUpContainer.addElementAt(modalLayer,0);
				onResize();
				DomGlobals.stage.addEventListener(Event.RESIZE,onResize);
				modalAttached = true;
			}
			else
			{
				DomGlobals.stage.removeEventListener(Event.RESIZE,onResize);
				popUpContainer.removeElement(modalLayer);
				modalAttached = false;
			}
		}
		/**
		 * 播放动画特效
		 */		
		private function showEffect(popUp:IVisualElement,effect:IEffect):void
		{
			popUp.visible = false;
			popUp.callLater(function():void{
				effect.addEventListener(EffectEvent.EFFECT_START,onEffectStart);
				effect.play([popUp]);
			});
		}
		/**
		 * 动画开始播放
		 */		
		private function onEffectStart(event:EffectEvent):void
		{
			var effect:IEffect = event.target as IEffect;
			effect.removeEventListener(EffectEvent.EFFECT_START,onEffectStart);
			(effect.target as IVisualElement).visible = true;
		}
		
		/**
		 * 舞台尺寸改变,重绘遮罩层。
		 */		
		private function onResize(event:Event=null):void
		{
			var g:Graphics = modalLayer.graphics;
			g.clear();
			g.beginFill(0xFFFFFF,0);
			g.drawRect(0,0,DomGlobals.stage.stageWidth,DomGlobals.stage.stageHeight);
			g.endFill();
		}
		
		/**
		 * 获取当前应该弹出的窗口列表
		 */		
		private function getCurrentPopUps():Vector.<PopUpData>
		{
			var returnArr:Vector.<PopUpData> = new Vector.<PopUpData>();
			if(priorityQueue.length==0)
				return returnArr;
			var isFirst:Boolean = true;
			
			for(var i:int=priorityQueue.length-1;i>=0;i--)
			{
				var list:Vector.<PopUpData> = priorityQueue[i];
				for(var j:int=list.length-1;j>=0;j--)
				{
					if(isFirst)
					{
						returnArr.splice(0,0,list[j]);
						if(list[j].exclusive)
							return returnArr;
						isFirst = false;
					}
					else if(list[j].exclusive)
					{
						return returnArr;
					}
					else
					{
						returnArr.splice(0,0,list[j]);
					}
				}
			}
			return returnArr;
		}
		
		/**
		 * 设置指定的窗口位置居中。若窗口为多个，则将按水平排列窗口，并使其整体居中。
		 * @param popUps 要居中显示的窗口列表
		 * @param gap 若窗口为多个，此值为水平排列时的间隔
		 * @param offsetX 整体水平位置偏移量
		 * @param offsetY 整体竖直位置偏移量
		 */
		public function centerPopUps(popUps:Array,gap:Number=5,offsetX:Number=0,offsetY:Number=0):void
		{
			var maxWidth:Number = 0;
			for each(var popUp:IVisualElement in popUps)
			{
				if((popUp is IInvalidating)&&(popUp as IInvalidating).invalidateFlag)
					(popUp as IInvalidating).validateNow();
				maxWidth += popUp.layoutBoundsWidth;
			}
			maxWidth += gap*popUps.length-1;
			var startX:Number = (DomGlobals.stage.stageWidth-maxWidth)*0.5;
			var layerHeight:Number = DomGlobals.stage.stageHeight;
			for each(popUp in popUps)
			{
				popUp.x = Math.round(startX+offsetX);
				if(popUp.x<0)
					popUp.x = 0;
				startX += popUp.layoutBoundsWidth+gap;
				popUp.y = Math.round((layerHeight-popUp.layoutBoundsHeight)*0.5+offsetY);
				if(popUp.y<0)
					popUp.y = 0;
			}
		}
		/**
		 * 移除由addPopUp()方法弹出的窗口。
		 * @param popUp 要移除的窗口
		 */		
		public function removePopUp(popUp:IVisualElement):void
		{
			var data:PopUpData = popUpDataDic[popUp];
			var popUpContainer:IContainer = DomGlobals.systemManager.popUpContainer;
			if(data)
			{
				delete popUpDataDic[popUp];
				remove(data);
				if(data.popUp is IUIComponent)
					(data.popUp as IUIComponent).isPopUp = false;
				var parent:DisplayObjectContainer = data.popUp.parent;
				if(data.popUp.parent==popUpContainer)
				{
					popUpContainer.removeElement(data.popUp);
				}
				updateCurrentPopUps();	
			}
		}
	}
}


import org.flexlite.domUI.core.IEffect;
import org.flexlite.domUI.core.IVisualElement;

/**
 * 弹出数据
 * @author DOM
 */
class PopUpData
{
	public function PopUpData(popUp:IVisualElement,modal:Boolean,
							  exclusive:Boolean,priority:int,popUpEffect:IEffect)
	{
		this.popUp = popUp;
		this.modal = modal;
		this.exclusive = exclusive;
		this.priority = priority;
		this.popUpEffect = popUpEffect;
	}
	/**
	 * 弹出窗口
	 */	
	public var popUp:IVisualElement;
	/**
	 * 是否启用模态
	 */	
	public var modal:Boolean;
	/**
	 * 是否独占
	 */	
	public var exclusive:Boolean;
	/**
	 * 优先级
	 */	
	public var priority:int;
	/**
	 * 窗口弹出时要播放的特效
	 */	
	public var popUpEffect:IEffect;
}