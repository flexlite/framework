package org.flexlite.domUI.skins.spark
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.supportClasses.Skin;
	
	
	/**
	 * PageNavigator默认皮肤
	 * @author DOM
	 */
	public class PageNavigatorSkin extends Skin
	{
		public function PageNavigatorSkin()
		{
			super();
			this.minWidth = 375;
			this.minHeight = 30;
		}
		
		/**
		 * [SkinPart]上一页按钮
		 */	
		public var prevPageButton:Button;
		/**
		 * [SkinPart]下一页按钮
		 */	
		public var nextPageButton:Button;
		
		/**
		 * [SkinPart]第一页按钮
		 */	
		public var firstPageButton:Button;
		/**
		 * [SkinPart]最后一页按钮
		 */	
		public var lastPageButton:Button;
		/**
		 * [SkinPart]页码文本显示对象
		 */		
		public var labelDisplay:Label;
		/**
		 * [SkinPart]装载目标viewport的容器
		 */		
		public var contentGroup:Group;
		
		override protected function createChildren():void
		{
			super.createChildren();
			contentGroup = new Group;
			contentGroup.left = 0;
			contentGroup.right = 0;
			contentGroup.top = 22;
			contentGroup.bottom = 0;
			addElement(contentGroup);
			
			firstPageButton = new Button;
			firstPageButton.label = "首页";
			firstPageButton.x = 0;
			addElement(firstPageButton);
			
			prevPageButton = new Button;
			prevPageButton.label = "上一页";
			prevPageButton.x = 75;
			addElement(prevPageButton);
			
			nextPageButton = new Button;
			nextPageButton.label = "下一页";
			nextPageButton.right = 75;
			addElement(nextPageButton);
			
			lastPageButton = new Button;
			lastPageButton.label = "尾页";
			lastPageButton.right = 0;
			addElement(lastPageButton);
			
			labelDisplay = new Label();
			labelDisplay.horizontalCenter = 0;
			addElement(labelDisplay);
		}
	}
}