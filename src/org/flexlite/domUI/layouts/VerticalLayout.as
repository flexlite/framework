package org.flexlite.domUI.layouts
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.flexlite.domUI.core.ILayoutElement;
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
			if(target!=null)
				target.invalidateDisplayList();
		}
		
		private var _verticalAlign:String = VerticalAlign.TOP;
		/**
		 * 布局元素的竖直对齐策略。参考VerticalAlign定义的常量。
		 * 注意：对VerticalLayout.verticalAlign设置JUSTIFY无效。
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
			if(target!=null)
				target.invalidateDisplayList();
		}
		
		private var _gap:int = 6;
		/**
		 * 布局元素之间的垂直空间（以像素为单位）
		 */
		public function get gap():int
		{
			return _gap;
		}
		
		public function set gap(value:int):void
		{
			if (_gap == value) 
				return;
			_gap = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		private var _paddingLeft:Number = 0;
		/**
		 * 容器的右边缘与布局元素的右边缘之间的最少像素数
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
		
		private var _paddingRight:Number = 0;
		/**
		 * 容器的右边缘与布局元素的右边缘之间的最少像素数
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
		
		private var _paddingTop:Number = 0;
		/**
		 * 容器的顶边缘与第一个布局元素的顶边缘之间的像素数。
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
		
		private var _paddingBottom:Number = 0;
		/**
		 * 容器的底边缘与最后一个布局元素的底边缘之间的像素数。
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
			if(target!=null)
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
		
		
		
		override public function measure():void
		{
			super.measure();
			if(target==null)
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
			
			var typicalHeight:Number = typicalLayoutRect.height;
			if(isNaN(typicalHeight))
				typicalHeight = 22;
			
			var measuredWidth:Number = maxElementWidth;
			if(measuredWidth==0)
				measuredWidth = 71;
			var measuredHeight:Number = getElementTotalSize();
			
			var visibleIndices:Vector.<int> = target.getElementIndicesInView();
			for each(var i:int in visibleIndices)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement == null)
					continue;
				
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredHeight += preferredHeight;
				measuredHeight -= isNaN(elementSizeTable[i])?typicalHeight:elementSizeTable[i];
				measuredWidth = Math.max(measuredWidth,preferredWidth);
			}
			measuredHeight += (numElements-1)*_gap
			var hPadding:Number = _paddingLeft + _paddingRight;
			var vPadding:Number = _paddingTop + _paddingBottom;
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
				if (!layoutElement)
				{
					numElements--;
					continue;
				}
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredHeight += preferredHeight;
				measuredWidth = Math.max(measuredWidth,preferredWidth);
			}
			measuredHeight += (numElements-1)*_gap
			var hPadding:Number = _paddingLeft + _paddingRight;
			var vPadding:Number = _paddingTop + _paddingBottom;
			target.measuredWidth = Math.ceil(measuredWidth+hPadding);
			target.measuredHeight = Math.ceil(measuredHeight+vPadding);
		}
		
		override public function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			if (target==null)
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
			if(!useVirtualLayout)
			{
				if(target!=null)
				{
					return target.getElementAt(index).y;
				}
				return _paddingTop;
			}
			var typicalHeight:Number = typicalLayoutRect.height;		
			if(isNaN(typicalHeight))
				typicalHeight = 22;
			var startPos:Number = paddingTop;
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
				return elementSizeTable[index];
			}
			if(target!=null)
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
			var typicalHeight:Number = typicalLayoutRect.height;		
			if(isNaN(typicalHeight))
				typicalHeight = 22;
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
			return totalSize;
		}
		
		override public function elementAdded(index:int):void
		{
			super.elementAdded(index);
			var typicalHeight:Number = typicalLayoutRect.height;		
			if(isNaN(typicalHeight))
				typicalHeight = 22;
			elementSizeTable.splice(index,0,typicalHeight);
		}
		
		override public function elementRemoved(index:int):void
		{
			super.elementRemoved(index);
			elementSizeTable.splice(index,1);
		}
		
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
			if(target==null||target.numElements==0)
			{
				startIndex = endIndex = -1;
				return false;
			}
			
			if(isNaN(target.width)||target.width==0||isNaN(target.height)||target.height==0)
			{
				startIndex = endIndex = -1;
				return false;
			}
			
			var numElements:int = target.numElements;			
			var contentHeight:Number = getStartPosition(numElements-1)+
				elementSizeTable[numElements-1]+paddingBottom;			
			var minVisibleY:Number = target.verticalScrollPosition;
			if(minVisibleY>contentHeight-paddingBottom)
			{
				startIndex = -1;
				endIndex = -1;
				return false;
			}
			var maxVisibleY:Number = target.verticalScrollPosition + target.height;
			if(maxVisibleY<paddingTop)
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
		
			if(startIndex == -1||endIndex==-1)
				return;
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
			
			var targetWidth:Number = Math.max(0, width - paddingLeft - paddingRight);
			var justifyWidth:Number = Math.ceil(targetWidth);
			var layoutElement:ILayoutElement;
			if(contentJustify)
			{
				for(var index:int=startIndex;index<=endIndex;index++)
				{
					layoutElement = target.getVirtualElementAt(i) as ILayoutElement;
					if (layoutElement==null)
						continue;
					maxElementWidth = Math.max(maxElementWidth,layoutElement.preferredWidth);
				}
				justifyWidth = Math.ceil(Math.max(targetWidth,maxElementWidth));
			}
			var x:Number = 0;
			var y:Number = 0;
			var contentWidth:Number = 0;
			//对可见区域进行布局
			for(var i:int=startIndex;i<=endIndex;i++)
			{
				var exceesWidth:Number = 0;
				layoutElement = target.getVirtualElementAt(i) as ILayoutElement;
				if (layoutElement==null)
					continue;
				if(justify)
				{
					x = _paddingLeft;
					layoutElement.setLayoutBoundsSize(justifyWidth,NaN);
				}
				else
				{
					exceesWidth = (targetWidth - layoutElement.layoutBoundsWidth)*hAlign;
					exceesWidth = exceesWidth>0?exceesWidth:0;
					x = _paddingLeft+Math.round(exceesWidth);
				}
				if(!contentJustify)
					maxElementWidth = Math.max(maxElementWidth,layoutElement.preferredWidth);
				contentWidth = Math.max(contentWidth,layoutElement.layoutBoundsWidth);
				elementSizeTable[i] = layoutElement.layoutBoundsHeight;
				y = getStartPosition(i);
				layoutElement.setLayoutBoundsPosition(Math.round(x),Math.round(y));
			}
			var numElements:int = target.numElements;
			contentWidth += paddingLeft+_paddingRight;
			var contentHeight:Number = getStartPosition(numElements-1)+elementSizeTable[numElements-1]+paddingBottom;	
			target.setContentSize(Math.ceil(contentWidth),Math.ceil(contentHeight));
		}
		
		
		
		
		/**
		 * 更新使用真实布局的显示列表
		 */		
		private function updateDisplayListReal(width:Number,height:Number):void
		{
			var targetWidth:Number = Math.max(0, width - paddingLeft - paddingRight);
			var targetHeight:Number = Math.max(0, height - paddingTop - paddingBottom);
			// 获取水平布局参数
			var justify:Boolean = _horizontalAlign==HorizontalAlign.JUSTIFY||_horizontalAlign==HorizontalAlign.CONTENT_JUSTIFY;
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
			
			var count:int = target.numElements;
			var numElements:int = count;
			var x:Number = _paddingLeft;
			var y:Number = _paddingTop;
			var i:int;
			var layoutElement:ILayoutElement;
			
			
			var excessHeight:Number = targetHeight;
			var totalPercentHeight:Number = 0;
			var childInfoArray:Array = [];
			var childInfo:ChildInfo;
			for (i = 0; i < count; i++)
			{
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement==null)
				{
					numElements--;
					continue;
				}
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
					maxElementWidth = Math.max(maxElementWidth,layoutElement.preferredWidth);
					excessHeight -= layoutElement.layoutBoundsHeight;
				}
			}
			
			excessHeight -= (numElements-1)*_gap;
			excessHeight = excessHeight>0?excessHeight:0;
			
			var heightDic:Dictionary = new Dictionary;
			if(totalPercentHeight>0)
			{
				flexChildrenProportionally(targetHeight,excessHeight,
					totalPercentHeight,childInfoArray);
				var roundOff:Number = 0;
				for each (childInfo in childInfoArray)
				{
					var childSize:int = Math.round(childInfo.size + roundOff);
					roundOff += childInfo.size - childSize;
					
					heightDic[childInfo.layoutElement] = childSize;
					excessHeight -= childSize;
				}
			}
			
			excessHeight = excessHeight>0?excessHeight:0;
		
			if(_verticalAlign==VerticalAlign.MIDDLE)
			{
				y = _paddingTop+Math.round(excessHeight*0.5);
			}
			else if(_verticalAlign==VerticalAlign.BOTTOM)
			{
				y = _paddingTop+Math.round(excessHeight);
			}
			
			//开始对所有元素布局
			var maxX:Number = _paddingLeft;
			var maxY:Number = _paddingTop;
			var dx:Number = 0;
			var dy:Number = 0;
			var justifyWidth:Number = Math.ceil(targetWidth);
			if(_horizontalAlign==HorizontalAlign.CONTENT_JUSTIFY)
				justifyWidth = Math.ceil(Math.max(targetWidth,maxElementWidth));
			for (i = 0; i < count; i++)
			{
				var exceesWidth:Number = 0;
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if (layoutElement==null)
					continue;
				if(justify)
				{
					x = _paddingLeft;
					layoutElement.setLayoutBoundsSize(justifyWidth,heightDic[layoutElement]);
				}
				else
				{
					if(!isNaN(layoutElement.percentWidth))
					{
						var percent:Number = Math.min(100,layoutElement.percentWidth);
						layoutElement.setLayoutBoundsSize(Math.round(targetWidth*percent*0.01),heightDic[layoutElement]);
					}
					exceesWidth = (targetWidth - layoutElement.layoutBoundsWidth)*hAlign;
					exceesWidth = exceesWidth>0?exceesWidth:0;
					x = _paddingLeft+Math.round(exceesWidth);
				}
				layoutElement.setLayoutBoundsPosition(Math.round(x),Math.round(y));
				dx = Math.ceil(layoutElement.layoutBoundsWidth);
				dy = Math.ceil(layoutElement.layoutBoundsHeight);
				maxX = Math.max(maxX,x+dx);
				maxY = Math.max(maxY,y+dy);
				y += dy+_gap;
			}
			target.setContentSize(Math.ceil(maxX+_paddingRight),Math.ceil(maxY+_paddingBottom));
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
		
		
		override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if(target==null)
				return rect;
			var firstIndex:int = findIndexAt(scrollRect.top,0,target.numElements-1);
			if(firstIndex!=-1)
			{
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
						rect.bottom = _paddingTop;
					}
				}
				return rect;
			}
			
			rect.top = 0;
			rect.bottom = _paddingTop;
			return rect;
		}
		
		override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if(target==null)
				return rect;
			var numElements:int = target.numElements;
			var lastIndex:int = findIndexAt(scrollRect.bottom,0,numElements-1);
			if(lastIndex!=-1)
			{
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
						rect.top = target.contentHeight - _paddingBottom;
						rect.bottom = target.contentHeight;
					}
				}
				return rect;
			}
			
			rect.top = target.contentHeight - _paddingBottom;
			rect.bottom = target.contentHeight;
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