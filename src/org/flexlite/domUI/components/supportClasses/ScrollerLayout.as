package org.flexlite.domUI.components.supportClasses
{
	import flash.geom.Point;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.ScrollPolicy;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	
	use namespace dx_internal;
	/**
	 * 滚动条布局类
	 * @author DOM
	 */	
	public class ScrollerLayout extends LayoutBase
	{
		/**
		 * 构造函数
		 */		
		public function ScrollerLayout()    
		{
			super();
		}
		
		/**
		 * 开始显示滚动条的最小溢出值。例如：contentWidth >= viewport width + SDT时显示水平滚动条。
		 */		
		private static const SDT:Number = 1.0;
		
		/**
		 * 获取滚动条实例
		 */		
		private function getScroller():Scroller
		{
			return  target.parent as Scroller;
		}
		
		/**
		 * 获取目标视域组件的视域尺寸
		 */		
		private function getLayoutContentSize(viewport:IViewport):Point
		{
			var cw:Number = viewport.contentWidth;
			var ch:Number = viewport.contentHeight;
			if (((cw == 0) && (ch == 0)) || (isNaN(cw) || isNaN(ch)))
				return new Point(0,0);
			return new Point(cw, ch);
		}
		
		
		private var hsbScaleX:Number = 1;
		private var hsbScaleY:Number = 1;
		
		/**
		 * 水平滚动条是否可见
		 */		
		private function get hsbVisible():Boolean
		{
			var hsb:ScrollBarBase = getScroller().horizontalScrollBar;
			return hsb && hsb.visible;
		}
		
		private function set hsbVisible(value:Boolean):void
		{
			var hsb:ScrollBarBase = getScroller().horizontalScrollBar;
			if (!hsb)
				return;
			if(hsb.visible == value)
				return;
			hsb.visible = value;
			hsb._includeInLayout = value;
		}
		
		/**
		 * 返回考虑进水平滚动条后组件所需的最小高度
		 */		
		private function hsbRequiredHeight():Number 
		{
			var scroller:Scroller = getScroller();
			var minViewportInset:Number = scroller.minViewportInset;
			var hsb:ScrollBarBase = scroller.horizontalScrollBar;
			return Math.max(minViewportInset, hsb.preferredHeight);
		}
		
		/**
		 * 返回指定的尺寸下水平滚动条是否能够放下
		 */		
		private function hsbFits(w:Number, h:Number, includeVSB:Boolean=true):Boolean
		{
			if (vsbVisible && includeVSB)
			{
				var vsb:ScrollBarBase = getScroller().verticalScrollBar;            
				w -= vsb.preferredWidth;
				h -= vsb.minHeight;
			}
			var hsb:ScrollBarBase = getScroller().horizontalScrollBar;        
			return (w >= hsb.minWidth) && (h >= hsb.preferredHeight);
		}
		
		private var vsbScaleX:Number = 1;
		private var vsbScaleY:Number = 1;
		
		/**
		 * 垂直滚动条是否可见
		 */		
		private function get vsbVisible():Boolean
		{
			var vsb:ScrollBarBase = getScroller().verticalScrollBar;
			return vsb && vsb.visible;
		}
		
		private function set vsbVisible(value:Boolean):void
		{
			var vsb:ScrollBarBase = getScroller().verticalScrollBar;
			if (!vsb)
				return;
			if(vsb.visible == value)
				return;
			vsb.visible = value;
			vsb._includeInLayout = value;
		}
		
		/**
		 * 返回考虑进垂直滚动条后组件所需用的最小宽度
		 */		
		private function vsbRequiredWidth():Number 
		{
			var scroller:Scroller = getScroller();
			var minViewportInset:Number = scroller.minViewportInset;
			var vsb:ScrollBarBase = scroller.verticalScrollBar;
			return Math.max(minViewportInset, vsb.preferredWidth);
		}
		
		/**
		 * 返回在指定的尺寸下垂直滚动条是否能够放下
		 */		
		private function vsbFits(w:Number, h:Number, includeHSB:Boolean=true):Boolean
		{
			if (hsbVisible && includeHSB)
			{
				var hsb:ScrollBarBase = getScroller().horizontalScrollBar;            
				w -= hsb.minWidth;
				h -= hsb.preferredHeight;
			}
			var vsb:ScrollBarBase = getScroller().verticalScrollBar;  
			return (w >= vsb.preferredWidth) && (h >= vsb.minHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function measure():void
		{
			const scroller:Scroller = getScroller();
			if (!scroller) 
				return;
			
			const minViewportInset:Number = scroller.minViewportInset;
			const measuredSizeIncludesScrollBars:Boolean = scroller.measuredSizeIncludesScrollBars;
			
			var measuredW:Number = minViewportInset;
			var measuredH:Number = minViewportInset;
			
			const hsb:ScrollBarBase = scroller.horizontalScrollBar;
			var showHSB:Boolean = false;
			var hAuto:Boolean = false;
			if (measuredSizeIncludesScrollBars)
				switch(scroller.horizontalScrollPolicy) 
				{
					case ScrollPolicy.ON: 
						if (hsb) showHSB = true; 
						break;
					case ScrollPolicy.AUTO: 
						if (hsb) showHSB = hsb.visible;
						hAuto = true;
						break;
				} 
			
			const vsb:ScrollBarBase = scroller.verticalScrollBar;
			var showVSB:Boolean = false;
			var vAuto:Boolean = false;
			if (measuredSizeIncludesScrollBars)
				switch(scroller.verticalScrollPolicy) 
				{
					case ScrollPolicy.ON: 
						if (vsb) showVSB = true; 
						break;
					case ScrollPolicy.AUTO: 
						if (vsb) showVSB = vsb.visible;
						vAuto = true;
						break;
				}
			
			measuredH += (showHSB) ? hsbRequiredHeight() : minViewportInset;
			measuredW += (showVSB) ? vsbRequiredWidth() : minViewportInset;
			var viewport:IViewport = scroller.viewport;
			if (viewport)
			{
				if (measuredSizeIncludesScrollBars)
				{
					var viewportPreferredW:Number =  viewport.preferredWidth;
					measuredW += Math.max(viewportPreferredW, (showHSB) ? hsb.minWidth : 0);
					
					var viewportPreferredH:Number = viewport.preferredHeight;
					measuredH += Math.max(viewportPreferredH, (showVSB) ? vsb.minHeight : 0);
				}
				else
				{
					measuredW += viewport.preferredWidth;
					measuredH += viewport.preferredHeight;
				}
			}
			
			var minW:Number = minViewportInset * 2;
			var minH:Number = minViewportInset * 2;
			var viewportUIC:UIComponent = viewport as UIComponent;
			var explicitViewportW:Number = viewportUIC ? viewportUIC.explicitWidth : NaN;
			var explicitViewportH:Number = viewportUIC ? viewportUIC.explicitHeight : NaN;
			
			if (!isNaN(explicitViewportW)) 
				minW += explicitViewportW;
			
			if (!isNaN(explicitViewportH)) 
				minH += explicitViewportH;
			
			var g:GroupBase = target;
			g.measuredWidth = Math.ceil(measuredW);
			g.measuredHeight = Math.ceil(measuredH);
		}
		
		/**
		 * 布局计数，防止发生无限循环。
		 */		
		private var invalidationCount:int = 0;
		
//		Bug备注：
//		当viewport含有相对布局元素的子项(content尺寸跟随viewport尺寸而变，这是不规范的用法)，
//		且水平和垂直滚动条同时到达临界显示值时，会出现无限循环验证的情况。
//		(显示滚动条会导致content尺寸变小，继而导致关闭滚动条，content尺寸又变大，又开启滚动条...)
//		暂时没有根治的解决方案，只能通过计数检查的方式断开循环。
		
		/**
		 * @inheritDoc
		 */
		override public function updateDisplayList(w:Number, h:Number):void
		{  
			var scroller:Scroller = getScroller();
			if (!scroller) 
				return;
			var viewport:IViewport = scroller.viewport;
			var hsb:ScrollBarBase = scroller.horizontalScrollBar;
			var vsb:ScrollBarBase = scroller.verticalScrollBar;
			var minViewportInset:Number = scroller.minViewportInset;
			
			var contentW:Number = 0;
			var contentH:Number = 0;
			if (viewport)
			{
				var contentSize:Point = getLayoutContentSize(viewport);
				contentW = contentSize.x;
				contentH = contentSize.y;
			}
			var viewportUIC:UIComponent = viewport as UIComponent;
			var explicitViewportW:Number = viewportUIC ? viewportUIC.explicitWidth : NaN;
			var explicitViewportH:Number = viewportUIC ? viewportUIC.explicitHeight : NaN;
			
			var viewportW:Number = isNaN(explicitViewportW) ? (w - (minViewportInset * 2)) : explicitViewportW;
			var viewportH:Number = isNaN(explicitViewportH) ? (h - (minViewportInset * 2)) : explicitViewportH;
			var oldShowHSB:Boolean = hsbVisible;
			var oldShowVSB:Boolean = vsbVisible;
			
			var hAuto:Boolean = false; 
			switch(scroller.horizontalScrollPolicy) 
			{
				case ScrollPolicy.ON: 
					hsbVisible = true;
					break;
				
				case ScrollPolicy.AUTO: 
					if (hsb && viewport)
					{
						hAuto = true;
						hsbVisible = (contentW >= (viewportW + SDT));
					} 
					break;
				
				default:
					hsbVisible = false;
			} 
			
			var vAuto:Boolean = false;
			switch(scroller.verticalScrollPolicy) 
			{
				case ScrollPolicy.ON: 
					vsbVisible = true; 
					break;
				
				case ScrollPolicy.AUTO: 
					if (vsb && viewport)
					{ 
						vAuto = true;
						vsbVisible = (contentH >= (viewportH + SDT));
					}                        
					break;
				
				default:
					vsbVisible = false;
			}
			if (isNaN(explicitViewportW))
				viewportW = w - ((vsbVisible) ? (minViewportInset + vsbRequiredWidth()) : (minViewportInset * 2));
			else 
				viewportW = explicitViewportW;
			
			if (isNaN(explicitViewportH))
				viewportH = h - ((hsbVisible) ? (minViewportInset + hsbRequiredHeight()) : (minViewportInset * 2));
			else 
				viewportH = explicitViewportH;
			var hsbIsDependent:Boolean = false;
			var vsbIsDependent:Boolean = false;
			
			if (vsbVisible && !hsbVisible && hAuto && (contentW >= (viewportW + SDT)))
				hsbVisible = hsbIsDependent = true;
			else if (!vsbVisible && hsbVisible && vAuto && (contentH >= (viewportH + SDT)))
				vsbVisible = vsbIsDependent = true;
			if (hsbVisible && vsbVisible) 
			{
				if (hsbFits(w, h) && vsbFits(w, h))
				{
					
				}
				else if (!hsbFits(w, h, false) && !vsbFits(w, h, false))
				{
					
					hsbVisible = false;
					vsbVisible = false;
				}
				else
				{
					if (hsbIsDependent)
					{
						if (vsbFits(w, h, false))  
							hsbVisible = false;
						else 
							vsbVisible = hsbVisible = false;
						
					}
					else if (vsbIsDependent)
					{
						if (hsbFits(w, h, false)) 
							vsbVisible = false;
						else
							hsbVisible = vsbVisible = false; 
					}
					else if (vsbFits(w, h, false)) 
						hsbVisible = false;
					else 
						vsbVisible = false;
				}
			}
			else if (hsbVisible && !hsbFits(w, h))  
				hsbVisible = false;
			else if (vsbVisible && !vsbFits(w, h))  
				vsbVisible = false;
			if (isNaN(explicitViewportW))
				viewportW = w - ((vsbVisible) ? (minViewportInset + vsbRequiredWidth()) : (minViewportInset * 2));
			else 
				viewportW = explicitViewportW;
			
			if (isNaN(explicitViewportH))
				viewportH = h - ((hsbVisible) ? (minViewportInset + hsbRequiredHeight()) : (minViewportInset * 2));
			else 
				viewportH = explicitViewportH;
			if (viewport)
			{
				viewport.setLayoutBoundsSize(viewportW, viewportH);
				viewport.setLayoutBoundsPosition(minViewportInset, minViewportInset);
			}
			
			if (hsbVisible)
			{
				var hsbW:Number = (vsbVisible) ? w - vsb.preferredWidth : w;
				var hsbH:Number = hsb.preferredHeight;
				hsb.setLayoutBoundsSize(Math.max(hsb.minWidth, hsbW), hsbH);
				hsb.setLayoutBoundsPosition(0, h - hsbH);
			}
			
			if (vsbVisible)
			{
				var vsbW:Number = vsb.preferredWidth; 
				var vsbH:Number = (hsbVisible) ? h - hsb.preferredHeight : h;
				vsb.setLayoutBoundsSize(vsbW, Math.max(vsb.minHeight, vsbH));
				vsb.setLayoutBoundsPosition(w - vsbW, 0);
			}
			if ((invalidationCount < 2) && (((vsbVisible != oldShowVSB) && vAuto) || ((hsbVisible != oldShowHSB) && hAuto)))
			{
				target.invalidateSize();
				var viewportGroup:GroupBase = viewport as GroupBase;
				if (viewportGroup && viewportGroup.layout && viewportGroup.layout.useVirtualLayout)
					viewportGroup.invalidateSize();
				
				invalidationCount += 1; 
			}
			else
				invalidationCount = 0;
			
			target.setContentSize(w, h);
		}
		
	}
	
}
