package org.flexlite.domUI.layouts
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	[DXML(show="false")]
	
	/**
	 * 垂直布局
	 * @author DOM
	 */
	public class VerticalLayout extends LayoutBase
	{
		public function VerticalLayout()
		{
			super();
		}
		
		private var _horizontalAlign:String = HorizontalAlign.LEFT;
		/**
		 * 布局元素的水平对齐策略。参考HorizontalAlign定义的常量。
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if(_horizontalAlign==value)
				return;
			_horizontalAlign = value;
			if(target)
				target.invalidateDisplayList();
		}
		
		private var _verticalAlign:String = VerticalAlign.TOP;
		/**
		 * 布局元素的竖直对齐策略。参考VerticalAlign定义的常量。
		 * 注意：此属性设置为CONTENT_JUSTIFY始终无效。当useVirtualLayout为true时，设置JUSTIFY也无效。
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(_verticalAlign==value)
				return;
			_verticalAlign = value;
			if(target)
				target.invalidateDisplayList();
		}
		
		private var _gap:Number = 6;
		/**
		 * 布局元素之间的垂直空间（以像素为单位）
		 */
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			if (_gap == value) 
				return;
			_gap = value;
			invalidateTargetSizeAndDisplayList();
			if(hasEventListener("gapChanged"))
				dispatchEvent(new Event("gapChanged"));
		}
		
		private var _padding:Number = 0;
		/**
		 * 四个边缘的共同内边距。若单独设置了任一边缘的内边距，则该边缘的内边距以单独设置的值为准。
		 * 此属性主要用于快速设置多个边缘的相同内边距。默认值：0。
		 */
		public function get padding():Number
		{
			return _padding;
		}
		public function set padding(value:Number):void
		{
			if(_padding==value)
				return;
			_padding = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		
		private var _paddingLeft:Number = NaN;
		/**
		 * 容器的左边缘与布局元素的左边缘之间的最少像素数,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value)
				return;
			
			_paddingLeft = value;
			invalidateTargetSizeAndDisplayList();
		}    
		
		private var _paddingRight:Number = NaN;
		/**
		 * 容器的右边缘与布局元素的右边缘之间的最少像素数,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value)
				return;
			
			_paddingRight = value;
			invalidateTargetSizeAndDisplayList();
		}    
		
		private var _paddingTop:Number = NaN;
		/**
		 * 容器的顶边缘与第一个布局元素的顶边缘之间的像素数,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value)
				return;
			
			_paddingTop = value;
			invalidateTargetSizeAndDisplayList();
		}    
		
		private var _paddingBottom:Number = NaN;
		/**
		 * 容器的底边缘与最后一个布局元素的底边缘之间的像素数,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value)
				return;
			
			_paddingBottom = value;
			invalidateTargetSizeAndDisplayList();
		}    
		
		/**
		 * 标记目标容器的尺寸和显示列表失效
		 */		
		private function invalidateTargetSizeAndDisplayList():void
		{
			if(target)
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		override public function measure():void
		{
			super.measure();
			if(!target)
				return;
			if(useVirtualLayout)
			{
				measureVirtual();
			}
			else
			{
				measureReal();
			}
		}
		
		/**
		 * 测量使用虚拟布局的尺寸
		 */		
		private function measureVirtual():void
		{
			var numElements:int = target.numElements;
			var typicalHeight:Number = typicalLayoutRect?typicalLayoutRect.height:22;
			var typicalWidth:Number = typicalLayoutRect?typicalLayoutRect.width:71;
			var measuredWidth:Number = Math.max(maxElementWidth,typicalWidth);
			var measuredHeight:Number = getElementTotalSize();
			
			var visibleIndices:Vector.<int> = target.getElementIndicesInView();
			for each(var i:int in visibleIndices)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement == null||!layoutElement.includeInLayout)
					continue;
				
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredHeight += preferredHeight;
				measuredHeight -= isNaN(elementSizeTable[i])?typicalHeight:elementSizeTable[i];
				measuredWidth = Math.max(measuredWidth,preferredWidth);
			}
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var hPadding:Number = paddingL + paddingR;
			var vPadding:Number = paddingT + paddingB;
			target.measuredWidth = Math.ceil(measuredWidth+hPadding);
			target.measuredHeight = Math.ceil(measuredHeight+vPadding);
		}
		
		/**
		 * 测量使用真实布局的尺寸
		 */		
		private function measureReal():void
		{
			var count:int = target.numElements;
			var numElements:int = count;
			var measuredWidth:Number = 0;
			var measuredHeight:Number = 0;
			for (var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if (!layoutElement||!layoutElement.includeInLayout)
				{
					numElements--;
					continue;
				}
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredHeight += preferredHeight;
				measuredWidth = Math.max(measuredWidth,preferredWidth);
			}
			var gap:Number = isNaN(_gap)?0:_gap;
			measuredHeight += (numElements-1)*gap;
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var hPadding:Number = paddingL + paddingR;
			var vPadding:Number = paddingT + paddingB;
			target.measuredWidth = Math.ceil(measuredWidth+hPadding);
			target.measuredHeight = Math.ceil(measuredHeight+vPadding);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			if(!target)
				return;
			if(useVirtualLayout)
			{
				updateDisplayListVirtual(width,height);
			}
			else
			{
				updateDisplayListReal(width,height);
			}
		}
		
		
		/**
		 * 虚拟布局使用的子对象尺寸缓存 
		 */		
		private var elementSizeTable:Array = [];
		
		/**
		 * 获取指定索引的起始位置
		 */		
		private function getStartPosition(index:int):Number
		{
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var gap:Number = isNaN(_gap)?0:_gap;
			if(!useVirtualLayout)
			{
				var element:IVisualElement;
				if(target)
				{
					element =  target.getElementAt(index);
				}
				return element?element.y:paddingT;
			}
			var typicalHeight:Number = typicalLayoutRect?typicalLayoutRect.height:22;
			var startPos:Number = paddingT;
			for(var i:int = 0;i<index;i++)
			{
				var eltHeight:Number = elementSizeTable[i];
				if(isNaN(eltHeight))
				{
					eltHeight = typicalHeight;
				}
				startPos += eltHeight+gap;
			}
			return startPos;
		}
		
		/**
		 * 获取指定索引的元素尺寸
		 */		
		private function getElementSize(index:int):Number
		{
			if(useVirtualLayout)
			{
				var size:Number = elementSizeTable[index];
				if(isNaN(size))
				{
					size = typicalLayoutRect?typicalLayoutRect.height:22;
				}
				return size;
			}
			if(target)
			{
				return target.getElementAt(index).height;
			}
			return 0;
		}
		
		/**
		 * 获取缓存的子对象尺寸总和
		 */		
		private function getElementTotalSize():Number
		{
			var gap:Number = isNaN(_gap)?0:_gap;
			var typicalHeight:Number = typicalLayoutRect?typicalLayoutRect.height:22;
			var totalSize:Number = 0;
			var length:int = target.numElements;
			for(var i:int = 0; i<length; i++)
			{
				var eltHeight:Number = elementSizeTable[i];
				if(isNaN(eltHeight))
				{
					eltHeight = typicalHeight;
				}
				totalSize += eltHeight+gap;
			}
			totalSize -= gap;
			return totalSize;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function elementAdded(index:int):void
		{
			super.elementAdded(index);
			var typicalHeight:Number = typicalLayoutRect?typicalLayoutRect.height:22;
			elementSizeTable.splice(index,0,typicalHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function elementRemoved(index:int):void
		{
			super.elementRemoved(index);
			elementSizeTable.splice(index,1);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clearVirtualLayoutCache():void
		{
			super.clearVirtualLayoutCache();
			elementSizeTable = [];
			maxElementWidth = 0;
		}
		
		
		
		/**
		 * 折半查找法寻找指定位置的显示对象索引
		 */		
		private function findIndexAt(y:Number, i0:int, i1:int):int
		{
			var index:int = (i0 + i1) / 2;
			var elementY:Number = getStartPosition(index);
			var elementHeight:Number = getElementSize(index);
			var gap:Number = isNaN(_gap)?0:_gap;
			if ((y >= elementY) && (y < elementY + elementHeight + gap))
				return index;
			else if (i0 == i1)
				return -1;
			else if (y < elementY)
				return findIndexAt(y, i0, Math.max(i0, index-1));
			else 
				return findIndexAt(y, Math.min(index+1, i1), i1);
		} 
		
		/**
		 * 虚拟布局使用的当前视图中的第一个元素索引
		 */		
		private var startIndex:int = -1;
		/**
		 * 虚拟布局使用的当前视图中的最后一个元素的索引
		 */		
		private var endIndex:int = -1;
		/**
		 * 视图的第一个和最后一个元素的索引值已经计算好的标志 
		 */		
		private var indexInViewCalculated:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override protected function scrollPositionChanged():void
		{
			super.scrollPositionChanged();
			if(useVirtualLayout)
			{
				var changed:Boolean = getIndexInView();
				if(changed)
				{
					indexInViewCalculated = true;
					target.invalidateDisplayList();
				}
			}
			
		}
		
		/**
		 * 获取视图中第一个和最后一个元素的索引,返回是否发生改变
		 */		
		private function getIndexInView():Boolean
		{
			if(!target||target.numElements==0)
			{
				startIndex = endIndex = -1;
				return false;
			}
			
			if(isNaN(target.width)||target.width==0||isNaN(target.height)||target.height==0)
			{
				startIndex = endIndex = -1;
				return false;
			}
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var numElements:int = target.numElements;			
			var contentHeight:Number = getStartPosition(numElements-1)+
				elementSizeTable[numElements-1]+paddingB;			
			var minVisibleY:Number = target.verticalScrollPosition;
			if(minVisibleY>contentHeight-paddingB)
			{
				startIndex = -1;
				endIndex = -1;
				return false;
			}
			var maxVisibleY:Number = target.verticalScrollPosition + target.height;
			if(maxVisibleY<paddingT)
			{
				startIndex = -1;
				endIndex = -1;
				return false;
			}
			var oldStartIndex:int = startIndex;
			var oldEndIndex:int = endIndex;
			startIndex = findIndexAt(minVisibleY,0,numElements-1);
			if(startIndex==-1)
				startIndex = 0;
			endIndex = findIndexAt(maxVisibleY,0,numElements-1);
			if(endIndex == -1)
				endIndex = numElements-1;
			return oldStartIndex!=startIndex||oldEndIndex!=endIndex;
		}
		
		/**
		 * 子对象最大宽度 
		 */		
		private var maxElementWidth:Number = 0;
		
		/**
		 * 更新使用虚拟布局的显示列表
		 */		
		private function updateDisplayListVirtual(width:Number,height:Number):void
		{
			if(indexInViewCalculated)
				indexInViewCalculated = false;
			else
				getIndexInView();
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var gap:Number = isNaN(_gap)?0:_gap;
			var contentHeight:Number;
			var numElements:int = target.numElements;
			if(startIndex == -1||endIndex==-1)
			{
				contentHeight = getStartPosition(numElements)-gap+paddingB;
				target.setContentSize(target.contentWidth,Math.ceil(contentHeight));
				return;
			}
			target.setVirtualElementIndicesInView(startIndex,endIndex);
			//获取水平布局参数
			var justify:Boolean = _horizontalAlign==HorizontalAlign.JUSTIFY||_horizontalAlign==HorizontalAlign.CONTENT_JUSTIFY;
			var contentJustify:Boolean = _horizontalAlign==HorizontalAlign.CONTENT_JUSTIFY;
			var hAlign:Number = 0;
			if(!justify)
			{
				if(_horizontalAlign==HorizontalAlign.CENTER)
				{
					hAlign = 0.5;
				}
				else if(_horizontalAlign==HorizontalAlign.RIGHT)
				{
					hAlign = 1;
				}
			}
			
			var targetWidth:Number = Math.max(0, width - paddingL - paddingR);
			var justifyWidth:Number = Math.ceil(targetWidth);
			var layoutElement:ILayoutElement;
			var typicalHeight:Number = typicalLayoutRect?typicalLayoutRect.height:22;
			var typicalWidth:Number = typicalLayoutRect?typicalLayoutRect.width:71;
			var oldMaxW:Number = Math.max(typicalWidth,maxElementWidth);
			if(contentJustify)
			{
				for(var index:int=startIndex;index<=endIndex;index++)
				{
					layoutElement = target.getVirtualElementAt(index) as ILayoutElement;
					if (!layoutElement||!layoutElement.includeInLayout)
						continue;
					maxElementWidth = Math.max(maxElementWidth,layoutElement.preferredWidth);
				}
				justifyWidth = Math.ceil(Math.max(targetWidth,maxElementWidth));
			}
			var x:Number = 0;
			var y:Number = 0;
			var contentWidth:Number = 0;
			var oldElementSize:Number;
			var needInvalidateSize:Boolean = false;
			//对可见区域进行布局
			for(var i:int=startIndex;i<=endIndex;i++)
			{
				var exceesWidth:Number = 0;
				layoutElement = target.getVirtualElementAt(i) as ILayoutElement;
				if (!layoutElement)
				{
					continue;
				}
				else if(!layoutElement.includeInLayout)
				{
					elementSizeTable[i] = 0;
					continue;
				}
				if(justify)
				{
					x = paddingL;
					layoutElement.setLayoutBoundsSize(justifyWidth,NaN);
				}
				else
				{
					exceesWidth = (targetWidth - layoutElement.layoutBoundsWidth)*hAlign;
					exceesWidth = exceesWidth>0?exceesWidth:0;
					x = paddingL+exceesWidth;
				}
				if(!contentJustify)
					maxElementWidth = Math.max(maxElementWidth,layoutElement.preferredWidth);
				contentWidth = Math.max(contentWidth,layoutElement.layoutBoundsWidth);
				if(!needInvalidateSize)
				{
					oldElementSize = isNaN(elementSizeTable[i])?typicalHeight:elementSizeTable[i];
					if(oldElementSize!=layoutElement.layoutBoundsHeight)
						needInvalidateSize = true;
				}
				if(i==0&&elementSizeTable.length>0&&elementSizeTable[i]!=layoutElement.layoutBoundsHeight)
					typicalLayoutRect = null;
				elementSizeTable[i] = layoutElement.layoutBoundsHeight;
				y = getStartPosition(i);
				layoutElement.setLayoutBoundsPosition(Math.round(x),Math.round(y));
			}
			contentWidth += paddingL+paddingR;
			contentHeight = getStartPosition(numElements)-gap+paddingB;	
			target.setContentSize(Math.ceil(contentWidth),Math.ceil(contentHeight));
			if(needInvalidateSize||oldMaxW<maxElementWidth)
			{
				target.invalidateSize();
			}
		}
		
		
		
		
		/**
		 * 更新使用真实布局的显示列表
		 */		
		private function updateDisplayListReal(width:Number,height:Number):void
		{
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var gap:Number = isNaN(_gap)?0:_gap;
			var targetWidth:Number = Math.max(0, width - paddingL - paddingR);
			var targetHeight:Number = Math.max(0, height - paddingT - paddingB);
			// 获取水平布局参数
			var vJustify:Boolean = _verticalAlign==VerticalAlign.JUSTIFY;
			var hJustify:Boolean = _horizontalAlign==HorizontalAlign.JUSTIFY||_horizontalAlign==HorizontalAlign.CONTENT_JUSTIFY;
			var hAlign:Number = 0;
			if(!hJustify)
			{
				if(_horizontalAlign==HorizontalAlign.CENTER)
				{
					hAlign = 0.5;
				}
				else if(_horizontalAlign==HorizontalAlign.RIGHT)
				{
					hAlign = 1;
				}
			}
			
			var count:int = target.numElements;
			var numElements:int = count;
			var x:Number = paddingL;
			var y:Number = paddingT;
			var i:int;
			var layoutElement:ILayoutElement;
			
			var totalPreferredHeight:Number = 0;
			var totalPercentHeight:Number = 0;
			var childInfoArray:Array = [];
			var childInfo:ChildInfo;
			var heightToDistribute:Number = targetHeight;
			for (i = 0; i < count; i++)
			{
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if (!layoutElement||!layoutElement.includeInLayout)
				{
					numElements--;
					continue;
				}
				maxElementWidth = Math.max(maxElementWidth,layoutElement.preferredWidth);
				if(vJustify)
				{
					totalPreferredHeight += layoutElement.preferredHeight;
				}
				else
				{
					if(!isNaN(layoutElement.percentHeight))
					{
						totalPercentHeight += layoutElement.percentHeight;
						
						childInfo = new ChildInfo();
						childInfo.layoutElement = layoutElement;
						childInfo.percent    = layoutElement.percentHeight;
						childInfo.min        = layoutElement.minHeight
						childInfo.max        = layoutElement.maxHeight;
						childInfoArray.push(childInfo);
					}
					else
					{
						heightToDistribute -= layoutElement.preferredHeight;
					}
				}
				
			}
			
			heightToDistribute -= (numElements-1)*gap;
			heightToDistribute = heightToDistribute>0?heightToDistribute:0;
			var excessSpace:Number = targetHeight - totalPreferredHeight - gap * (numElements - 1);
			
			var averageHeight:Number;
			var largeChildrenCount:int = numElements;
			var heightDic:Dictionary = new Dictionary;
			if(vJustify)
			{
				if(excessSpace<0)
				{
					averageHeight = heightToDistribute / numElements;
					for (i = 0; i < count; i++)
					{
						layoutElement = target.getElementAt(i);
						if (!layoutElement || !layoutElement.includeInLayout)
							continue;
						
						var preferredHeight:Number = layoutElement.preferredHeight;
						if (preferredHeight <= averageHeight)
						{
							heightToDistribute -= preferredHeight;
							largeChildrenCount--;
							continue;
						}
					}
					heightToDistribute = heightToDistribute>0?heightToDistribute:0;
				}
			}
			else
			{
				if(totalPercentHeight>0)
				{
					flexChildrenProportionally(targetHeight,heightToDistribute,
						totalPercentHeight,childInfoArray);
					var roundOff:Number = 0;
					for each (childInfo in childInfoArray)
					{
						var childSize:int = Math.round(childInfo.size + roundOff);
						roundOff += childInfo.size - childSize;
						
						heightDic[childInfo.layoutElement] = childSize;
						heightToDistribute -= childSize;
					}
					heightToDistribute = heightToDistribute>0?heightToDistribute:0;
				}
			}
		
			if(_verticalAlign==VerticalAlign.MIDDLE)
			{
				y = paddingT+heightToDistribute*0.5;
			}
			else if(_verticalAlign==VerticalAlign.BOTTOM)
			{
				y = paddingT+heightToDistribute;
			}
			
			//开始对所有元素布局
			var maxX:Number = paddingL;
			var maxY:Number = paddingT;
			var dx:Number = 0;
			var dy:Number = 0;
			var justifyWidth:Number = Math.ceil(targetWidth);
			if(_horizontalAlign==HorizontalAlign.CONTENT_JUSTIFY)
				justifyWidth = Math.ceil(Math.max(targetWidth,maxElementWidth));
			roundOff = 0;
			var layoutElementHeight:Number = NaN;
			var childHeight:Number;
			for (i = 0; i < count; i++)
			{
				var exceesWidth:Number = 0;
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if (!layoutElement||!layoutElement.includeInLayout)
					continue;
				layoutElementHeight = NaN;
				if(vJustify)
				{
					childHeight = NaN;
					if(excessSpace>0)
					{
						childHeight = heightToDistribute * layoutElement.preferredHeight / totalPreferredHeight;
					}
					else if(excessSpace<0&&layoutElement.preferredHeight>averageHeight)
					{
						childHeight = heightToDistribute / largeChildrenCount
					}
					if(!isNaN(childHeight))
					{
						layoutElementHeight = Math.round(childHeight + roundOff);
						roundOff += childHeight - layoutElementHeight;
					}
				}
				else
				{
					layoutElementHeight = heightDic[layoutElement];
				}
				if(hJustify)
				{
					x = paddingL;
					layoutElement.setLayoutBoundsSize(justifyWidth,layoutElementHeight);
				}
				else
				{
					var layoutElementWidth:Number = NaN;
					if(!isNaN(layoutElement.percentWidth))
					{
						var percent:Number = Math.min(100,layoutElement.percentWidth);
						layoutElementWidth = Math.round(targetWidth*percent*0.01);
					}
					layoutElement.setLayoutBoundsSize(layoutElementWidth,layoutElementHeight);
					exceesWidth = (targetWidth - layoutElement.layoutBoundsWidth)*hAlign;
					exceesWidth = exceesWidth>0?exceesWidth:0;
					x = paddingL+exceesWidth;
				}
				layoutElement.setLayoutBoundsPosition(Math.round(x),Math.round(y));
				dx = Math.ceil(layoutElement.layoutBoundsWidth);
				dy = Math.ceil(layoutElement.layoutBoundsHeight);
				maxX = Math.max(maxX,x+dx);
				maxY = Math.max(maxY,y+dy);
				y += dy+gap;
			}
			target.setContentSize(Math.ceil(maxX+paddingR),Math.ceil(maxY+paddingB));
		}
		
		/**
		 * 为每个可变尺寸的子项分配空白区域
		 */		
		public static function flexChildrenProportionally(spaceForChildren:Number,spaceToDistribute:Number,
														  totalPercent:Number,childInfoArray:Array):void
		{
			
			var numChildren:int = childInfoArray.length;
			var done:Boolean;
			
			do
			{
				done = true; 
				
				var unused:Number = spaceToDistribute -
					(spaceForChildren * totalPercent / 100);
				if (unused > 0)
					spaceToDistribute -= unused;
				else
					unused = 0;
				
				var spacePerPercent:Number = spaceToDistribute / totalPercent;
				
				for (var i:int = 0; i < numChildren; i++)
				{
					var childInfo:ChildInfo = childInfoArray[i];
					
					var size:Number = childInfo.percent * spacePerPercent;
					
					if (size < childInfo.min)
					{
						var min:Number = childInfo.min;
						childInfo.size = min;
						
						childInfoArray[i] = childInfoArray[--numChildren];
						childInfoArray[numChildren] = childInfo;
						
						totalPercent -= childInfo.percent;
						if (unused >= min)
						{
							unused -= min;
						}
						else
						{
							spaceToDistribute -= min - unused;
							unused = 0;
						}
						done = false;
						break;
					}
					else if (size > childInfo.max)
					{
						var max:Number = childInfo.max;
						childInfo.size = max;
						
						childInfoArray[i] = childInfoArray[--numChildren];
						childInfoArray[numChildren] = childInfo;
						
						totalPercent -= childInfo.percent;
						if (unused >= max)
						{
							unused -= max;
						}
						else
						{
							spaceToDistribute -= max - unused;
							unused = 0;
						}
						done = false;
						break;
					}
					else
					{
						childInfo.size = size;
					}
				}
			} 
			while (!done);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if(!target)
				return rect;
			var firstIndex:int = findIndexAt(scrollRect.top,0,target.numElements-1);
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			if(firstIndex==-1)
			{
				if(scrollRect.top>target.contentHeight - paddingB)
				{
					rect.top = target.contentHeight - paddingB;
					rect.bottom = target.contentHeight;
				}
				else
				{
					rect.top = 0;
					rect.bottom = paddingT;
				}
				return rect;
			}
			rect.top = getStartPosition(firstIndex);
			rect.bottom = getElementSize(firstIndex)+rect.top;
			if(rect.top==scrollRect.top)
			{
				firstIndex--;
				if(firstIndex!=-1)
				{
					rect.top = getStartPosition(firstIndex);
					rect.bottom = getElementSize(firstIndex)+rect.top;
				}
				else
				{
					rect.top = 0;
					rect.bottom = paddingT;
				}
			}
			return rect;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if(!target)
				return rect;
			var numElements:int = target.numElements;
			var lastIndex:int = findIndexAt(scrollRect.bottom,0,numElements-1);
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			if(lastIndex==-1)
			{
				if(scrollRect.right<paddingT)
				{
					rect.top = 0;
					rect.bottom = paddingT;
				}
				else
				{
					rect.top = target.contentHeight - paddingB;
					rect.bottom = target.contentHeight;
				}
				return rect;
			}
			rect.top = getStartPosition(lastIndex);
			rect.bottom = getElementSize(lastIndex)+rect.top;
			if(rect.bottom<=scrollRect.bottom)
			{
				lastIndex++;
				if(lastIndex<numElements)
				{
					rect.top = getStartPosition(lastIndex);
					rect.bottom = getElementSize(lastIndex)+rect.top;
				}
				else
				{
					rect.top = target.contentHeight - paddingB;
					rect.bottom = target.contentHeight;
				}
			}
			return rect;
		}
	}
}

import org.flexlite.domUI.core.ILayoutElement;

class ChildInfo
{
	public function ChildInfo()
	{
		super();
	}
	
	public var layoutElement:ILayoutElement;  
	
	public var size:Number = 0;
	
	public var percent:Number;
	
	public var min:Number;
	
	public var max:Number;
}