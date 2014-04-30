package org.flexlite.domUI.components
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.core.IContainer;
	import org.flexlite.domUI.core.ISkin;
	import org.flexlite.domUI.core.IStateClient;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.IVisualElementContainer;
	import org.flexlite.domUI.events.ElementExistenceEvent;
	import org.flexlite.domUI.events.StateChangeEvent;
	import org.flexlite.domUI.states.StateClientHelper;
	
	use namespace dx_internal;
	
	/**
	 * 元素添加事件
	 */	
	[Event(name="elementAdd", type="org.flexlite.domUI.events.ElementExistenceEvent")]
	/**
	 * 元素移除事件 
	 */	
	[Event(name="elementRemove", type="org.flexlite.domUI.events.ElementExistenceEvent")]
	
	/**
	 * 当前视图状态已经改变 
	 */	
	[Event(name="currentStateChange", type="org.flexlite.domUI.events.StateChangeEvent")]
	/**
	 * 当前视图状态即将改变 
	 */	
	[Event(name="currentStateChanging", type="org.flexlite.domUI.events.StateChangeEvent")]
	
	[DXML(show="false")]
	
	[DefaultProperty(name="elementsContent",array="true")]
	
	/**
	 * 含有视图状态功能的皮肤基类。注意：为了减少嵌套层级，此皮肤没有继承显示对象，若需要显示对象版本皮肤，请使用Skin。
	 * @see org.flexlite.domUI.components.supportClasses.Skin
	 * @author DOM
	 */
	public class StateSkin extends EventDispatcher 
		implements IStateClient, ISkin, IContainer
	{
		/**
		 * 构造函数
		 */		
		public function StateSkin()
		{
			super();
			stateClientHelper = new StateClientHelper(this);
		}
		
		/**
		 * 组件的最大测量宽度,仅影响measuredWidth属性的取值范围。
		 */	
		public var maxWidth:Number = 10000;
		/**
		 * 组件的最小测量宽度,此属性设置为大于maxWidth的值时无效。仅影响measuredWidth属性的取值范围。
		 */
		public var minWidth:Number = 0;
		/**
		 * 组件的最大测量高度,仅影响measuredHeight属性的取值范围。
		 */
		public var maxHeight:Number = 10000;
		/**
		 * 组件的最小测量高度,此属性设置为大于maxHeight的值时无效。仅影响measuredHeight属性的取值范围。
		 */
		public var minHeight:Number = 0;
		/**
		 * 组件宽度
		 */
		public var width:Number = NaN;
		/**
		 * 组件高度
		 */
		public var height:Number = NaN;
		
		/**
		 * x坐标
		 */		
		public var x:Number = 0;
		/**
		 * y坐标 
		 */		
		public var y:Number = 0;
		
		//以下这两个属性无效，仅用于防止DXML编译器报错。
		public var percentWidth:Number = NaN;
		public var percentHeight:Number = NaN;
		
		//========================state相关函数===============start=========================

		private var stateClientHelper:StateClientHelper;
		
		/**
		 * @inheritDoc
		 */
		public function get states():Array
		{
			return stateClientHelper.states;
		}
		
		public function set states(value:Array):void
		{
			stateClientHelper.states = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentState():String
		{
			return stateClientHelper.currentState;
		}
		
		public function set currentState(value:String):void
		{
			stateClientHelper.currentState = value;
			if (_hostComponent&&stateClientHelper.currentStateChanged)
			{
				stateClientHelper.commitCurrentState();
				commitCurrentState();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasState(stateName:String):Boolean
		{
			return stateClientHelper.hasState(stateName); 
		}
		
		/**
		 * 应用当前的视图状态。子类覆盖此方法在视图状态发生改变时执行相应更新操作。
		 */
		protected function commitCurrentState():void
		{
			
		}
		//========================state相关函数===============end=========================
		
		private var _hostComponent:SkinnableComponent;
		/**
		 * @inheritDoc
		 */
		public function get hostComponent():SkinnableComponent
		{
			return _hostComponent;
		}
		/**
		 * @inheritDoc
		 */
		public function set hostComponent(value:SkinnableComponent):void
		{
			if(_hostComponent==value)
				return;
			var i:int;
			if(_hostComponent)
			{
				for(i = _elementsContent.length - 1; i >= 0; i--)
				{
					elementRemoved(_elementsContent[i], i);
				}
			}
			
			_hostComponent = value;
			
			if(_hostComponent)
			{			
				var n:int = _elementsContent.length;
				for (i = 0; i < n; i++)
				{   
					var elt:IVisualElement = _elementsContent[i];
					if (elt.parent is IVisualElementContainer)
						IVisualElementContainer(elt.parent).removeElement(elt);
					else if(elt.owner is IContainer)
						IContainer(elt.owner).removeElement(elt);
					elementAdded(elt, i);
				}
				
				stateClientHelper.initializeStates();
				
				if(stateClientHelper.currentStateChanged)
				{
					stateClientHelper.commitCurrentState();
					commitCurrentState();
				}
			}
		}
		
		private var _elementsContent:Array = [];
		/**
		 * 返回子元素列表
		 */		
		dx_internal function getElementsContent():Array
		{
			return _elementsContent;
		}
		
		/**
		 * 设置容器子对象数组 。数组包含要添加到容器的子项列表，之前的已存在于容器中的子项列表被全部移除后添加列表里的每一项到容器。
		 * 设置该属性时会对您输入的数组进行一次浅复制操作，所以您之后对该数组的操作不会影响到添加到容器的子项列表数量。
		 */		
		public function set elementsContent(value:Array):void
		{
			if(value==null)
				value = [];
			if(value==_elementsContent)
				return;
			if(_hostComponent)
			{
				var i:int;
				for (i = _elementsContent.length - 1; i >= 0; i--)
				{
					elementRemoved(_elementsContent[i], i);
				}
				
				_elementsContent = value.concat();
				
				var n:int = _elementsContent.length;
				for (i = 0; i < n; i++)
				{   
					var elt:IVisualElement = _elementsContent[i];
					
					if(elt.parent is IVisualElementContainer)
						IVisualElementContainer(elt.parent).removeElement(elt);
					else if(elt.owner is IContainer)
						IContainer(elt.owner).removeElement(elt);
					elementAdded(elt, i);
				}
			}
			else
			{
				_elementsContent = value.concat();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return _elementsContent.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IVisualElement
		{
			checkForRangeError(index);
			return _elementsContent[index];
		}
		
		private function checkForRangeError(index:int, addingElement:Boolean = false):void
		{
			var maxIndex:int = _elementsContent.length - 1;
			
			if (addingElement)
				maxIndex++;
			
			if (index < 0 || index > maxIndex)
				throw new RangeError("索引:\""+index+"\"超出可视元素索引范围");
		}
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IVisualElement):IVisualElement
		{
			var index:int = numElements;
			
			if (element.owner == this)
				index = numElements-1;
			
			return addElementAt(element, index);
		}
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			checkForRangeError(index, true);
			
			var host:Object = element.owner; 
			if (host == this)
			{
				setElementIndex(element, index);
				return element;
			}
			else if (element.parent is IVisualElementContainer)
			{
				IVisualElementContainer(element.parent).removeElement(element);
			}
			else if(host is IContainer)
			{
				IContainer(host).removeElement(element);
			}
			
			_elementsContent.splice(index, 0, element);
			
			if(_hostComponent)
				elementAdded(element, index);
			
			return element;
		}
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IVisualElement):IVisualElement
		{
			return removeElementAt(getElementIndex(element));
		}
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IVisualElement
		{
			checkForRangeError(index);
			
			var element:IVisualElement = _elementsContent[index];
			
			if(_hostComponent)
				elementRemoved(element, index);
			
			_elementsContent.splice(index, 1);
			
			return element;
		}
			
		/**
		 * @inheritDoc
		 */
		public function getElementIndex(element:IVisualElement):int
		{
			return _elementsContent.indexOf(element);
		}
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IVisualElement, index:int):void
		{
			checkForRangeError(index);
			
			var oldIndex:int = getElementIndex(element);
			if (oldIndex==-1||oldIndex == index)
				return;
			
			if(_hostComponent)
				elementRemoved(element, oldIndex, false);
			
			_elementsContent.splice(oldIndex, 1);
			_elementsContent.splice(index, 0, element);
			
			if(_hostComponent)
				elementAdded(element, index, false);
		}
		
		private var addToDisplayListAt:QName = new QName(dx_internal,"addToDisplayListAt");
		private var removeFromDisplayList:QName = new QName(dx_internal,"removeFromDisplayList");
		/**
		 * 添加一个显示元素到容器
		 */		
		dx_internal function elementAdded(element:IVisualElement, index:int, notifyListeners:Boolean = true):void
		{
			element.ownerChanged(this);
			if(element is DisplayObject)
				_hostComponent[addToDisplayListAt](DisplayObject(element), index);
			
			if (notifyListeners)
			{
				if (hasEventListener(ElementExistenceEvent.ELEMENT_ADD))
					dispatchEvent(new ElementExistenceEvent(
						ElementExistenceEvent.ELEMENT_ADD, false, false, element, index));
			}
			
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		/**
		 * 从容器移除一个显示元素
		 */		
		dx_internal function elementRemoved(element:IVisualElement, index:int, notifyListeners:Boolean = true):void
		{
			if (notifyListeners)
			{        
				if (hasEventListener(ElementExistenceEvent.ELEMENT_REMOVE))
					dispatchEvent(new ElementExistenceEvent(
						ElementExistenceEvent.ELEMENT_REMOVE, false, false, element, index));
			}
			
			var childDO:DisplayObject = element as DisplayObject; 
			if (childDO && childDO.parent == _hostComponent)
			{
				_hostComponent[removeFromDisplayList](element);
			}
			
			element.ownerChanged(null);
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
	}
}