package org.flexlite.domUI.layouts
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.flexlite.domUI.core.ILayoutElement;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	[DXML(show="false")]
	
	/**
	 * 格子布局
	 * @author DOM
	 */
	public class TileLayout extends LayoutBase
	{
		/**
		 * 构造函数
		 */		
		public function TileLayout()
		{
			super();
		}
		/**
		 * 标记horizontalGap被显式指定过 
		 */
		private var explicitHorizontalGap:Number = NaN;
		
		private var _horizontalGap:Number = 6;
		/**
		 * 列之间的水平空间（以像素为单位）。
		 */		
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		
		public function set horizontalGap(value:Number):void
		{
			if (value == _horizontalGap)
				return;
			explicitHorizontalGap = value;
				
			_horizontalGap = value;
			invalidateTargetSizeAndDisplayList();
			if(hasEventListener("gapChanged"))
				dispatchEvent(new Event("gapChanged"));
		}
		
		/**
		 * 标记verticalGap被显式指定过 
		 */		
		private var explicitVerticalGap:Number = NaN;
		
		private var _verticalGap:Number = 6;
		
		/**
		 * 行之间的垂直空间（以像素为单位）。
		 */		
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		public function set verticalGap(value:Number):void
		{
			if (value == _verticalGap)
				return;
			explicitVerticalGap = value;
			
			_verticalGap = value;
			invalidateTargetSizeAndDisplayList();
			if(hasEventListener("gapChanged"))
				dispatchEvent(new Event("gapChanged"));
		}
		
		
		private var _columnCount:int = -1;
		/**
		 * 实际列计数。
		 */		
		public function get columnCount():int
		{
			return _columnCount;
		}
		
		private var _requestedColumnCount:int = 0;
		/**
		 * 要显示的列数。设置为0表示自动确定列计数,默认值0。<br/>
		 * 注意:当orientation为TileOrientation.COLUMNS(逐列排列元素)且taget被显式设置宽度时，此属性无效。
		 */
		public function get requestedColumnCount():int
		{
			return _requestedColumnCount;
		}

		public function set requestedColumnCount(value:int):void
		{
			if (_requestedColumnCount == value)
				return;
			_requestedColumnCount = value;
			_columnCount = value;
			invalidateTargetSizeAndDisplayList();
		}

		
		private var _rowCount:int = -1;
		/**
		 * 实际行计数。
		 */		
		public function get rowCount():int
		{
			return _rowCount;
		}
		
		private var _requestedRowCount:int = 0;
		/**
		 * 要显示的行数。设置为0表示自动确定行计数,默认值0。<br/>
		 * 注意:当orientation为TileOrientation.ROWS(即逐行排列元素,此为默认值)且target被显式设置高度时，此属性无效。
		 */
		public function get requestedRowCount():int
		{
			return _requestedRowCount;
		}

		public function set requestedRowCount(value:int):void
		{
			if (_requestedRowCount == value)
				return;
			_requestedRowCount = value;
			_rowCount = value;
			invalidateTargetSizeAndDisplayList();
		}

		
		/**
		 * 外部显式指定的列宽
		 */
		private var explicitColumnWidth:Number = NaN;
	
		private var _columnWidth:Number = NaN;
		/**
		 * 实际列宽（以像素为单位）。 若未显式设置，则从根据最宽的元素的宽度确定列宽度。
		 */		
		public function get columnWidth():Number
		{
			return _columnWidth;
		}
		
		/**
		 *  @private
		 */
		public function set columnWidth(value:Number):void
		{
			if (value == _columnWidth)
				return;
			explicitColumnWidth = value;
			_columnWidth = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		/**
		 * 外部显式指定的行高 
		 */		
		private var explicitRowHeight:Number = NaN;

		private var _rowHeight:Number = NaN;
		/**
		 * 行高（以像素为单位）。 如果未显式设置，则从元素的高度的最大值确定行高度。
		 */		
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		
		/**
		 *  @private
		 */
		public function set rowHeight(value:Number):void
		{
			if (value == _rowHeight)
				return;
			explicitRowHeight = value;
			_rowHeight = value;
			invalidateTargetSizeAndDisplayList();
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
		
		
		private var _horizontalAlign:String = HorizontalAlign.JUSTIFY;
		/**
		 * 指定如何在水平方向上对齐单元格内的元素。
		 * 支持的值有 HorizontalAlign.LEFT、HorizontalAlign.CENTER、
		 * HorizontalAlign.RIGHT、HorizontalAlign.JUSTIFY。
		 * 默认值：HorizontalAlign.JUSTIFY
		 */		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if (_horizontalAlign == value)
				return;
			
			_horizontalAlign = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		private var _verticalAlign:String = VerticalAlign.JUSTIFY;
		
		/**
		 * 指定如何在垂直方向上对齐单元格内的元素。
		 * 支持的值有 VerticalAlign.TOP、VerticalAlign.MIDDLE、
		 * VerticalAlign.BOTTOM、VerticalAlign.JUSTIFY。 
		 * 默认值：VerticalAlign.JUSTIFY。
		 */		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if (_verticalAlign == value)
				return;
			
			_verticalAlign = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		private var _columnAlign:String = ColumnAlign.LEFT;
		
		/**
		 * 指定如何将完全可见列与容器宽度对齐。
		 * 设置为 ColumnAlign.LEFT 时，它会关闭列两端对齐。在容器的最后一列和右边缘之间可能存在部分可见的列或空白。这是默认值。
		 * 
		 * 设置为 ColumnAlign.JUSTIFY_USING_GAP 时，horizontalGap 的实际值将增大，
		 * 这样最后一个完全可见列右边缘会与容器的右边缘对齐。仅存在一个完全可见列时，
		 * horizontalGap 的实际值将增大，这样它会将任何部分可见列推到容器的右边缘之外。
		 * 请注意显式设置 horizontalGap 属性不会关闭两端对齐。它仅确定初始间隙值。两端对齐可能会增大它。
		 * 
		 * 设置为 ColumnAlign.JUSTIFY_USING_WIDTH 时，columnWidth 的实际值将增大，
		 * 这样最后一个完全可见列右边缘会与容器的右边缘对齐。请注意显式设置 columnWidth 属性不会关闭两端对齐。
		 * 它仅确定初始列宽度值。两端对齐可能会增大它。
		 */		
		public function get columnAlign():String
		{
			return _columnAlign;
		}
		
		public function set columnAlign(value:String):void
		{
			if (_columnAlign == value)
				return;
			
			_columnAlign = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		private var _rowAlign:String = RowAlign.TOP;
		
		public function get rowAlign():String
		{
			return _rowAlign;
		}
		/**
		 * 指定如何将完全可见行与容器高度对齐。
		 * 设置为 RowAlign.TOP 时，它会关闭列两端对齐。在容器的最后一行和底边缘之间可能存在部分可见的行或空白。这是默认值。
		 * 
		 * 设置为 RowAlign.JUSTIFY_USING_GAP 时，verticalGap 的实际值会增大，
		 * 这样最后一个完全可见行底边缘会与容器的底边缘对齐。仅存在一个完全可见行时，verticalGap 的值会增大，
		 * 这样它会将任何部分可见行推到容器的底边缘之外。请注意，显式设置 verticalGap
		 * 不会关闭两端对齐，而只是确定初始间隙值。两端对齐接着可以增大它。
		 * 
		 * 设置为 RowAlign.JUSTIFY_USING_HEIGHT 时，rowHeight 的实际值会增大，
		 * 这样最后一个完全可见行底边缘会与容器的底边缘对齐。请注意，显式设置 rowHeight 
		 * 不会关闭两端对齐，而只是确定初始行高度值。两端对齐接着可以增大它。
		 */		
		public function set rowAlign(value:String):void
		{
			if (_rowAlign == value)
				return;
			
			_rowAlign = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		private var _orientation:String = TileOrientation.ROWS;
		/**
		 * 指定是逐行还是逐列排列元素。
		 */		
		public function get orientation():String
		{
			return _orientation;
		}
		
		public function set orientation(value:String):void
		{
			if (_orientation == value)
				return;
			
			_orientation = value;
			invalidateTargetSizeAndDisplayList();
			if(hasEventListener("orientationChanged"))
				dispatchEvent(new Event("orientationChanged"));
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
			if (!target)
				return;
			
			var savedColumnCount:int = _columnCount;
			var savedRowCount:int = _rowCount;
			var savedColumnWidth:int = _columnWidth;
			var savedRowHeight:int = _rowHeight; 
			
			var measuredWidth:Number = 0;
			var measuredHeight:Number = 0;
			
			calculateRowAndColumn(target.explicitWidth,target.explicitHeight);
			var columnCount:int = _requestedColumnCount>0 ? _requestedColumnCount: _columnCount;
			var rowCount:int = _requestedRowCount>0 ? _requestedRowCount : _rowCount;
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			if (columnCount > 0)
			{
				measuredWidth = columnCount * (_columnWidth + horizontalGap) - horizontalGap;
			}
			
			if (rowCount > 0)
			{
				measuredHeight = rowCount * (_rowHeight + verticalGap) - verticalGap;
			}
			
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			
			var hPadding:Number = paddingL + paddingR;
			var vPadding:Number = paddingT + paddingB;
			
			target.measuredWidth = Math.ceil(measuredWidth + hPadding);
			target.measuredHeight = Math.ceil(measuredHeight + vPadding);
			
			_columnCount = savedColumnCount;
			_rowCount = savedRowCount;
			_columnWidth = savedColumnWidth;
			_rowHeight = savedRowHeight; 
		}
		
		/**
		 * 计算行和列的尺寸及数量
		 */		
		private function calculateRowAndColumn(explicitWidth:Number, explicitHeight:Number):void
		{
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			_rowCount = _columnCount = -1;
			var numElements:int = target.numElements;
			var count:int = numElements;
			for(var index:int = 0;index<count;index++)
			{
				var elt:ILayoutElement = target.getElementAt(index) as ILayoutElement;
				if(elt&&!elt.includeInLayout)
				{
					numElements--;
				}
			}
			if(numElements==0)
			{
				_rowCount = _columnCount = 0;
				return;
			}
			
			if(isNaN(explicitColumnWidth)||isNaN(explicitRowHeight))
				updateMaxElementSize();
			
			if(isNaN(explicitColumnWidth))
			{
				_columnWidth = maxElementWidth;
			}
			else
			{
				_columnWidth = explicitColumnWidth;
			}
			if(isNaN(explicitRowHeight))
			{
				_rowHeight = maxElementHeight;
			}
			else
			{
				_rowHeight = explicitRowHeight;
			}
			
			var itemWidth:Number = _columnWidth + horizontalGap;
			//防止出现除数为零的情况
			if(itemWidth <= 0)
				itemWidth = 1;
			var itemHeight:Number = _rowHeight + verticalGap;
			if(itemHeight <= 0)
				itemHeight = 1;
			
			var orientedByColumns:Boolean = (orientation == TileOrientation.COLUMNS);
			var widthHasSet:Boolean = !isNaN(explicitWidth);
			var heightHasSet:Boolean = !isNaN(explicitHeight);
			
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			
			if (_requestedColumnCount>0 || _requestedRowCount>0)
			{
				if (_requestedRowCount>0)
					_rowCount = Math.min(_requestedRowCount,numElements);
				
				if (_requestedColumnCount>0)
					_columnCount = Math.min(_requestedColumnCount,numElements);
			}
			else if(!widthHasSet&&!heightHasSet)
			{
				var side:Number = Math.sqrt(numElements*itemWidth*itemHeight);
				if(orientedByColumns)
				{
					_rowCount = Math.max(1,Math.round(side/itemHeight));
				}
				else
				{
					_columnCount = Math.max(1,Math.round(side/itemWidth));
				}
			}
			else if(widthHasSet&&(!heightHasSet||!orientedByColumns))
			{
				var targetWidth:Number = Math.max(0, 
					explicitWidth - paddingL - paddingR);
				_columnCount = Math.floor((targetWidth + horizontalGap)/itemWidth);
				_columnCount = Math.max(1,Math.min(_columnCount,numElements));
			}
			else
			{
				var targetHeight:Number = Math.max(0, 
					explicitHeight - paddingT - paddingB);
				_rowCount = Math.floor((targetHeight + verticalGap)/itemHeight);
				_rowCount = Math.max(1,Math.min(_rowCount,numElements));
			}
			if (_rowCount==-1)
				_rowCount = Math.max(1, Math.ceil(numElements / _columnCount));
			if (_columnCount==-1)
				_columnCount = Math.max(1, Math.ceil(numElements / _rowCount));
			if (_requestedColumnCount>0&&_requestedRowCount>0)
			{
				if (orientation == TileOrientation.ROWS)
					_rowCount = Math.max(1, Math.ceil(numElements / _requestedColumnCount));
				else
					_columnCount = Math.max(1, Math.ceil(numElements / _requestedRowCount));
			}
		}
		/**
		 * 缓存的最大子对象宽度
		 */		
		private var maxElementWidth:Number = 0;
		/**
		 * 缓存的最大子对象高度 
		 */		
		private var maxElementHeight:Number = 0;
		/**
		 * 更新最大子对象尺寸
		 */		
		private function updateMaxElementSize():void
		{
			if(!target)
				return;
			if(useVirtualLayout)
				updateMaxElementSizeVirtual();
			else 
				updateMaxElementSizeReal();
		}
		/**
		 * 更新虚拟布局的最大子对象尺寸
		 */		
		private function updateMaxElementSizeVirtual():void
		{
			var typicalHeight:Number = typicalLayoutRect?typicalLayoutRect.height:22;
			var typicalWidth:Number = typicalLayoutRect?typicalLayoutRect.width:22;
			maxElementWidth = Math.max(maxElementWidth,typicalWidth);
			maxElementHeight = Math.max(maxElementHeight,typicalHeight);

			if ((startIndex != -1) && (endIndex != -1))
			{
				for (var index:int = startIndex; index <= endIndex; index++)
				{
					var elt:ILayoutElement = target.getVirtualElementAt(index) as ILayoutElement;
					if(!elt||!elt.includeInLayout)
						continue;
					maxElementWidth = Math.max(maxElementWidth,elt.preferredWidth);
					maxElementHeight = Math.max(maxElementHeight,elt.preferredHeight);
				}
			}
				
		}
		/**
		 * 更新真实布局的最大子对象尺寸
		 */		
		private function updateMaxElementSizeReal():void
		{
			var numElements:int = target.numElements;
			for(var index:int = 0;index<numElements;index++)
			{
				var elt:ILayoutElement = target.getElementAt(index) as ILayoutElement;
				if(!elt||!elt.includeInLayout)
					continue;
				maxElementWidth = Math.max(maxElementWidth,elt.preferredWidth);
				maxElementHeight = Math.max(maxElementHeight,elt.preferredHeight);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clearVirtualLayoutCache():void
		{
			super.clearVirtualLayoutCache();
			maxElementWidth = 0;
			maxElementHeight = 0;
		}
		
		/**
		 * 当前视图中的第一个元素索引
		 */		
		private var startIndex:int = -1;
		/**
		 * 当前视图中的最后一个元素的索引
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
			
			var numElements:int = target.numElements;
			if(!useVirtualLayout)
			{
				startIndex = 0;
				endIndex = numElements-1;
				return false;
			}
			
			if(isNaN(target.width)||target.width==0||isNaN(target.height)||target.height==0)
			{
				startIndex = endIndex = -1;
				return false;
			}
			var oldStartIndex:int = startIndex;
			var oldEndIndex:int = endIndex;
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			if(orientation == TileOrientation.COLUMNS)
			{
				var itemWidth:Number = _columnWidth + horizontalGap;
				if(itemWidth <= 0)
				{
					startIndex = 0;
					endIndex = numElements-1;
					return false;
				}
				var minVisibleX:Number = target.horizontalScrollPosition;
				var maxVisibleX:Number = target.horizontalScrollPosition+target.width;
				var startColumn:int = Math.floor((minVisibleX-paddingL)/itemWidth);
				if(startColumn<0)
					startColumn = 0;
				var endColumn:int = Math.ceil((maxVisibleX-paddingL)/itemWidth);
				if(endColumn<0)
					endColumn = 0;
				startIndex = Math.min(numElements-1,Math.max(0,startColumn*_rowCount));
				endIndex = Math.min(numElements-1,Math.max(0,endColumn*_rowCount-1));
			}
			else
			{
				var itemHeight:Number = _rowHeight + verticalGap;
				if(itemHeight <= 0)
				{
					startIndex = 0;
					endIndex = numElements-1;
					return false;
				}
				var minVisibleY:Number = target.verticalScrollPosition;
				var maxVisibleY:Number = target.verticalScrollPosition+target.height;
				var startRow:int = Math.floor((minVisibleY-paddingT)/itemHeight);
				if(startRow<0)
					startRow = 0;
				var endRow:int = Math.ceil((maxVisibleY-paddingT)/itemHeight);
				if(endRow<0)
					endRow = 0;
				startIndex = Math.min(numElements-1,Math.max(0,startRow*_columnCount));
				endIndex = Math.min(numElements-1,Math.max(0,endRow*_columnCount-1));
			}
			
			return startIndex != oldStartIndex||endIndex != oldEndIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			if (!target)
				return;
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			if(indexInViewCalculated)
			{
				indexInViewCalculated = false;
			}
			else
			{
				calculateRowAndColumn(width,height);
				if(_rowCount==0||_columnCount==0)
				{
					target.setContentSize(paddingL+paddingR,paddingT+paddingB);
					return;
				}
				adjustForJustify(width,height);
				getIndexInView();
			}
			if(useVirtualLayout)
			{
				calculateRowAndColumn(width,height);
				adjustForJustify(width,height);
			}
			
			if(startIndex == -1||endIndex==-1)
			{
				target.setContentSize(0,0);
				return;
			}
			target.setVirtualElementIndicesInView(startIndex,endIndex);
			var elt:ILayoutElement;
			var x:Number;
			var y:Number;
			var columnIndex:int;
			var rowIndex:int;
			var orientedByColumns:Boolean = (orientation == TileOrientation.COLUMNS);
			var index:int = startIndex;
			for(var i:int = startIndex;i <= endIndex;i++)
			{
				if(useVirtualLayout)
					elt = target.getVirtualElementAt(i) as ILayoutElement;
				else
					elt = target.getElementAt(i) as ILayoutElement;
				if(elt == null||!elt.includeInLayout)
					continue;
				
				if(orientedByColumns)
				{
					columnIndex = Math.ceil((index+1)/_rowCount)-1;
					rowIndex = Math.ceil((index+1)%_rowCount)-1;
					if(rowIndex == -1)
						rowIndex = _rowCount-1;
				}
				else
				{
					columnIndex = Math.ceil((index+1)%_columnCount) - 1;
					if(columnIndex == -1)
						columnIndex = _columnCount - 1;
					rowIndex = Math.ceil((index+1)/_columnCount) - 1;
				}
				x = columnIndex*(_columnWidth+horizontalGap)+paddingL;
				y = rowIndex*(_rowHeight+verticalGap)+paddingT;
				sizeAndPositionElement(elt,x,y,_columnWidth,rowHeight);
				index++;
			}
			
			var hPadding:Number = paddingL + paddingR;
			var vPadding:Number = paddingT + paddingB;
			var contentWidth:Number = (_columnWidth+horizontalGap)*_columnCount-horizontalGap;
			var contentHeight:Number = (_rowHeight+verticalGap)*_rowCount-verticalGap;
			target.setContentSize(Math.ceil(contentWidth+hPadding),Math.ceil(contentHeight+vPadding));
		}

		/**
		 * 为单个元素布局
		 */		
		private function sizeAndPositionElement(element:ILayoutElement,cellX:int,cellY:int,
												cellWidth:int,cellHeight:int):void
		{
			var elementWidth:Number = NaN;
			var elementHeight:Number = NaN;
			
			if (horizontalAlign == HorizontalAlign.JUSTIFY)
				elementWidth = cellWidth;
			else if (!isNaN(element.percentWidth))
				elementWidth = cellWidth * element.percentWidth * 0.01;
			
			if (verticalAlign == VerticalAlign.JUSTIFY)
				elementHeight = cellHeight;
			else if (!isNaN(element.percentHeight))
				elementHeight = cellHeight * element.percentHeight * 0.01;
			
			
			element.setLayoutBoundsSize(Math.round(elementWidth), Math.round(elementHeight));
			
			var x:Number = cellX;
			switch (horizontalAlign)
			{
				case HorizontalAlign.RIGHT:
					x += cellWidth - element.layoutBoundsWidth;
					break;
				case HorizontalAlign.CENTER:
					x = cellX + (cellWidth - element.layoutBoundsWidth) / 2;
					break;
			}
			
			var y:Number = cellY;
			switch (verticalAlign)
			{
				case VerticalAlign.BOTTOM:
					y += cellHeight - element.layoutBoundsHeight;
					break;
				case VerticalAlign.MIDDLE:
					y += (cellHeight - element.layoutBoundsHeight) / 2;
					break;
			}
			element.setLayoutBoundsPosition(Math.round(x), Math.round(y));
		}			
		
		
		/**
		 * 为两端对齐调整间隔或格子尺寸
		 */		
		private function adjustForJustify(width:Number,height:Number):void
		{
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			
			var targetWidth:Number = Math.max(0, 
				width - paddingL - paddingR);
			var targetHeight:Number = Math.max(0, 
				height - paddingT - paddingB);
			if(!isNaN(explicitVerticalGap))
				_verticalGap = explicitVerticalGap;
			if(!isNaN(explicitHorizontalGap))
				_horizontalGap = explicitHorizontalGap;
			_verticalGap = isNaN(_verticalGap)?0:_verticalGap;
			_horizontalGap = isNaN(_horizontalGap)?0:_horizontalGap;
			
			var itemWidth:Number = _columnWidth + _horizontalGap;
			if(itemWidth <= 0)
				itemWidth = 1;
			var itemHeight:Number = _rowHeight + _verticalGap;
			if(itemHeight <= 0)
				itemHeight = 1;
			
			var offsetY:Number = targetHeight-_rowHeight*_rowCount;
			var offsetX:Number = targetWidth-_columnWidth*_columnCount;
			var gapCount:int;
			if(offsetY>0)
			{
				if(rowAlign == RowAlign.JUSTIFY_USING_GAP)
				{
					gapCount = Math.max(1,_rowCount-1);
					_verticalGap = offsetY/gapCount;
				}
				else if(rowAlign == RowAlign.JUSTIFY_USING_HEIGHT)
				{
					if(_rowCount>0)
					{
						_rowHeight += (offsetY-(_rowCount-1)*_verticalGap)/_rowCount;
					}
				}
			}
			if(offsetX>0)
			{
				if(columnAlign == ColumnAlign.JUSTIFY_USING_GAP)
				{
					gapCount = Math.max(1,_columnCount-1);
					_horizontalGap = offsetX/gapCount;
				}
				else if(columnAlign == ColumnAlign.JUSTIFY_USING_WIDTH)
				{
					if(_columnCount>0)
					{
						_columnWidth += (offsetX-(_columnCount-1)*_horizontalGap)/_columnCount;
					}
				}
			}			
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			if(scrollRect.left>target.contentWidth - paddingR)
			{
				bounds.left = target.contentWidth - paddingR;
				bounds.right = target.contentWidth;
			}
			else if(scrollRect.left>paddingL)
			{
				var column:int = Math.floor((scrollRect.left - 1 - paddingL) / (_columnWidth + horizontalGap));
				bounds.left = leftEdge(column);
				bounds.right = rightEdge(column);
			}
			else
			{
				bounds.left = 0;
				bounds.right = paddingL;
			}
			return bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var paddingR:Number = isNaN(_paddingRight)?padding:_paddingRight;
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			var bounds:Rectangle = new Rectangle();
			if(scrollRect.right<paddingL)
			{
				bounds.left = 0;
				bounds.right = paddingL;
			}
			else if(scrollRect.right<target.contentWidth - paddingR)
			{
				var column:int = Math.floor(((scrollRect.right + 1 + horizontalGap) - paddingL) / (_columnWidth + horizontalGap));
				bounds.left = leftEdge(column);
				bounds.right = rightEdge(column);
			}
			else
			{
				bounds.left = target.contentWidth - paddingR;
				bounds.right = target.contentWidth;
			}
			return bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			var bounds:Rectangle = new Rectangle();
			if(scrollRect.top>target.contentHeight - paddingB)
			{
				bounds.top = target.contentHeight - paddingB;
				bounds.bottom = target.contentHeight;
			}
			else if(scrollRect.top>paddingT)
			{
				var row:int = Math.floor((scrollRect.top - 1 - paddingT) / (_rowHeight + verticalGap));
				bounds.top = topEdge(row);
				bounds.bottom = bottomEdge(row);
			}
			else
			{
				bounds.top = 0;
				bounds.bottom = paddingT;
			}
			return bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var paddingB:Number = isNaN(_paddingBottom)?padding:_paddingBottom;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			var bounds:Rectangle = new Rectangle();
			if(scrollRect.bottom<paddingT)
			{
				bounds.top = 0;
				bounds.bottom = paddingT;
			}
			else if(scrollRect.bottom<target.contentHeight - paddingB)
			{
				var row:int = Math.floor(((scrollRect.bottom + 1 + verticalGap) - paddingT) / (_rowHeight + verticalGap));
				bounds.top = topEdge(row);
				bounds.bottom = bottomEdge(row);
			}
			else
			{
				bounds.top = target.contentHeight - paddingB;
				bounds.bottom = target.contentHeight;
			}
			
			return bounds;
		}
		
		private function leftEdge(columnIndex:int):Number
		{
			if (columnIndex < 0)
				return 0;
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			return Math.max(0, columnIndex * (_columnWidth + horizontalGap)) + paddingL;
		}
		
		private function rightEdge(columnIndex:int):Number
		{
			if (columnIndex < 0)
				return 0;
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingL:Number = isNaN(_paddingLeft)?padding:_paddingLeft;
			var horizontalGap:Number = isNaN(_horizontalGap)?0:_horizontalGap;
			return Math.min(target.contentWidth, columnIndex * (_columnWidth + horizontalGap) + 
				_columnWidth) + paddingL;
		}
		
		final private function topEdge(rowIndex:int):Number
		{
			if (rowIndex < 0)
				return 0;
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			return Math.max(0, rowIndex * (_rowHeight + verticalGap)) + paddingT;
		}
		
		final private function bottomEdge(rowIndex:int):Number
		{
			if (rowIndex < 0)
				return 0;
			var padding:Number = isNaN(_padding)?0:_padding;
			var paddingT:Number = isNaN(_paddingTop)?padding:_paddingTop;
			var verticalGap:Number = isNaN(_verticalGap)?0:_verticalGap;
			return Math.min(target.contentHeight, rowIndex * (_rowHeight + verticalGap) +
				_rowHeight) + paddingT;
		}
	
	}
}