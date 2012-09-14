<<<<<<< HEAD
package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.components.SkinnableElement;
	import org.flexlite.domUI.components.supportClasses.Skin;
	import org.flexlite.domUI.layouts.VerticalLayout;
	
	
	/**
	 * List默认皮肤
	 * @author DOM
	 */
	public class ListSkin extends Skin
	{
		public function ListSkin()
		{
			super();
			this.minWidth = 112;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(borderSkin)
			{
				var border:SkinnableElement = new SkinnableElement;
				border.skinName  = borderSkin;
				border.left = 0;
				border.right = 0;
				border.top = 0;
				border.bottom = 0;
				addElement(border);
			}
			dataGroup = new DataGroup();
			var temp:VerticalLayout = new VerticalLayout();
			dataGroup.layout = temp;
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
			
			scroller = new Scroller();
			if(scrollerSkin)
			{
				scroller.skinName = scrollerSkin;
			}
			scroller.left = 0;
			scroller.top = 0;
			scroller.right = 0;
			scroller.bottom = 0;
			scroller.minViewportInset = 1;
			scroller.viewport = dataGroup;
			scroller.horizontalScrollPolicy = horizontalScrollPolicy;
			scroller.verticalScrollPolicy = verticalScrollPolicy;
			addElement(scroller);
			
		}
		
		
		/**
		 * [SkinPart]
		 */		
		public var dataGroup:DataGroup;
		/**
		 * [SkinPart]
		 */		
		public var scroller:Scroller;
		/**
		 * 滚动条皮肤
		 */		
		public var scrollerSkin:Object;
		/**
		 * 背景皮肤
		 */		
		public var borderSkin:Object;
		/**
		 * @copy org.flexlite.domUI.components.Scroller#verticalScrollPolicy
		 */		
		public var verticalScrollPolicy:String = "auto";
		/**
		 * @copy org.flexlite.domUI.components.Scroller#horizontalScrollPolicy
		 */
		public var horizontalScrollPolicy:String = "auto";
	}
=======
package org.flexlite.domUI.skins.halo
{
	import org.flexlite.domUI.components.DataGroup;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.components.SkinnableElement;
	import org.flexlite.domUI.components.supportClasses.Skin;
	import org.flexlite.domUI.layouts.VerticalLayout;
	
	
	/**
	 * List默认皮肤
	 * @author DOM
	 */
	public class ListSkin extends Skin
	{
		public function ListSkin()
		{
			super();
			this.minWidth = 112;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(borderSkin)
			{
				var border:SkinnableElement = new SkinnableElement;
				border.skinName  = borderSkin;
				border.left = 0;
				border.right = 0;
				border.top = 0;
				border.bottom = 0;
				addElement(border);
			}
			dataGroup = new DataGroup();
			var temp:VerticalLayout = new VerticalLayout();
			dataGroup.layout = temp;
			temp.gap = 0;
			temp.horizontalAlign = "contentJustify";
			
			scroller = new Scroller();
			if(scrollerSkin)
			{
				scroller.skinName = scrollerSkin;
			}
			scroller.left = 0;
			scroller.top = 0;
			scroller.right = 0;
			scroller.bottom = 0;
			scroller.minViewportInset = 1;
			scroller.viewport = dataGroup;
			scroller.horizontalScrollPolicy = horizontalScrollPolicy;
			scroller.verticalScrollPolicy = verticalScrollPolicy;
			addElement(scroller);
			
		}
		
		
		/**
		 * [SkinPart]
		 */		
		public var dataGroup:DataGroup;
		/**
		 * [SkinPart]
		 */		
		public var scroller:Scroller;
		/**
		 * 滚动条皮肤
		 */		
		public var scrollerSkin:Object;
		/**
		 * 背景皮肤
		 */		
		public var borderSkin:Object;
		/**
		 * @copy org.flexlite.domUI.components.Scroller#verticalScrollPolicy
		 */		
		public var verticalScrollPolicy:String = "auto";
		/**
		 * @copy org.flexlite.domUI.components.Scroller#horizontalScrollPolicy
		 */
		public var horizontalScrollPolicy:String = "auto";
	}
>>>>>>> f78d49f3fecf49af6a0fd0692d66a604051e89be
}