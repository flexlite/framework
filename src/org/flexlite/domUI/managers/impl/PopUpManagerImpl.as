package org.flexlite.domUI.managers.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.managers.PopUpData;
	
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
		
		private var resizeEventAttached:Boolean = false;
		/**
		 * 弹出一个窗口,请调用 removePopUp()来移除使用 addPopUp()方法弹出的窗口。<br/>
		 * 注意：弹出层禁用了自动布局功能。所有相对位置属性在弹出层都是无效的。只能通过设置x,y绝对坐标来控制位置。
		 * @param popUp 要弹出的窗口显示对象
		 * @param modal 是否启用模态。禁用弹出层以下的鼠标事件。默认false。
		 * @param center 是否居中窗口。默认true。
		 * @param exclusive 是否独占。若为true，它总是不与任何窗口共存。当弹出时，将隐藏层级在它后面的所有窗口。
		 * 若有层级在它前面的窗口弹出，无论新窗口是否独占，都将它和它后面的窗口全部隐藏。默认为false。
		 * @param priority 弹出优先级。优先级高的窗口显示层级在低的前面。同一优先级的窗口，后添加的窗口层级在前面。
		 * @param popUpEffect 窗口弹出时要播放的动画特效。
		 */		
		public function addPopUp(popUp:IVisualElement,modal:Boolean = false,center:Boolean=true,
										exclusive:Boolean=false,priority:int=0,
										popUpEffect:IEffect=null):void
		{
			var popUpData:PopUpData = new PopUpData(popUp,modal,center,exclusive,priority,popUpEffect);
			if(popUpDataDic[popUp]!=null)
			{
				remove(popUpDataDic[popUp]);
			}
			popUpDataDic[popUp] = popUpData;
			if(popUp is IUIComponent)
				(popUp as IUIComponent).isPopUp = true;
			insert(popUpData);
			updateCurrentPopUps();
			if(!resizeEventAttached)
			{
				resizeEventAttached = true;
				DomGlobals.stage.addEventListener(Event.RESIZE,onStageResize);
			}
		}
		
		/**
		 * 舞台尺寸改变,重绘遮罩层。
		 */		
		private function onStageResize(event:Event=null):void
		{
			if(modalAttached)
				updateModalSize();
			for each(var data:PopUpData in _currentPopUps)
			{
				if(data.center&&lastCenterPopUps.indexOf(data.popUp)==-1)
				{
					setOnePopUpCenter(data.popUp)
				}
			}
			updateCenterPopUps();
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
		 * 更新模态层的大小
		 */		
		private function updateModalSize():void
		{
			var g:Graphics = modalLayer.graphics;
			g.clear();
			g.beginFill(0xFFFFFF,0);
			g.drawRect(0,0,DomGlobals.stage.stageWidth,DomGlobals.stage.stageHeight);
			g.endFill();
		}

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
				if(data.center&&
					lastCenterPopUps.indexOf(data.popUp)==-1)
				{
					setOnePopUpCenter(data.popUp)
				}
				if(data.popUpEffect&&_currentPopUps.indexOf(data.popUp)==-1)
				{
					showEffect(data.popUp,data.popUpEffect);
				}
				if(!needModal&&data.modal)
					needModal = true;
			}
			updateCenterPopUps();
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
				updateModalSize();
				modalAttached = true;
			}
			else
			{
				popUpContainer.removeElement(modalLayer);
				modalAttached = false;
			}
		}
		
		/**
		 * 居中一个popUp
		 */		
		private function setOnePopUpCenter(popUp:IVisualElement):void
		{
			if(popUp is IInvalidating&&(popUp as IInvalidating).invalidateFlag)
				(popUp as IInvalidating).validateNow();
			popUp.x = (DomGlobals.stage.stageWidth-popUp.layoutBoundsWidth)*0.5;
			popUp.y = (DomGlobals.stage.stageHeight-popUp.layoutBoundsHeight)*0.5;
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
		 * 上一次居中的窗口列表
		 */		
		private var lastCenterPopUps:Array=[];
		private var centerGap:Number = 5;
		private var centerOffsetX:Number;
		private var centerOffsetY:Number;
		/**
		 * 设置指定的窗口位置居中。若窗口为多个，则将按水平排列窗口，并使其整体居中。
		 * @param popUps 要居中显示的窗口列表
		 * @param gap 若窗口为多个，此值为水平排列时的间隔
		 * @param offsetX 整体水平位置偏移量
		 * @param offsetY 整体竖直位置偏移量
		 */
		public function centerPopUps(popUps:Array,gap:Number=5,offsetX:Number=0,offsetY:Number=0):void
		{
			if(!popUps)
				popUps = [];
			lastCenterPopUps = popUps.concat();
			centerGap = gap;
			centerOffsetX = offsetX;
			centerOffsetY = offsetY;
			updateCenterPopUps();
		}
		/**
		 * 更新当前的居中窗口队列
		 */		
		private function updateCenterPopUps():void
		{
			if(lastCenterPopUps.length==0)
				return;
			var popUp:IVisualElement;
			var maxWidth:Number = 0;
			for each(popUp in lastCenterPopUps)
			{
				if(!popUp.parent)
					continue;
				if((popUp is IInvalidating)&&(popUp as IInvalidating).invalidateFlag)
					(popUp as IInvalidating).validateNow();
				maxWidth += popUp.layoutBoundsWidth;
			}
			maxWidth += centerGap*lastCenterPopUps.length-1;
			var startX:Number = (DomGlobals.stage.stageWidth-maxWidth)*0.5;
			var layerHeight:Number = DomGlobals.stage.stageHeight;
			var layerWidth:Number = DomGlobals.stage.stageWidth;
			
			for each(popUp in lastCenterPopUps)
			{
				if(!popUp.parent)
					continue;
				var w:Number = popUp.layoutBoundsWidth;
				var h:Number = popUp.layoutBoundsHeight;
				popUp.x = startX;
				if(popUp.x+w>layerWidth)
					popUp.x = layerWidth-w;
				if(popUp.x<0)
					popUp.x = 0;
				startX += popUp.layoutBoundsWidth+centerGap;
				popUp.y = (layerHeight-popUp.layoutBoundsHeight)*0.5;
				if(popUp.y+h>layerHeight)
					popUp.y = layerHeight-h;
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
				var index:int = lastCenterPopUps.indexOf(data.popUp);
				if(index!=-1)
				{
					lastCenterPopUps.splice(index,1);
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
	public function PopUpData(popUp:IVisualElement,modal:Boolean,center:Boolean,
							  exclusive:Boolean,priority:int,popUpEffect:IEffect)
	{
		this.popUp = popUp;
		this.modal = modal;
		this.center = center;
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
	 * 窗口居中
	 */	
	public var center:Boolean;
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