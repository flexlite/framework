<<<<<<< HEAD
package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domUI.core.ISkinAdapter;
	
	import flash.display.DisplayObject;
	
	
	/**
	 * 默认的ISkinAdapter接口实现
	 * @author DOM
	 */
	public class DefaultSkinAdapter implements ISkinAdapter
	{
		/**
		 * 构造函数
		 */		
		public function DefaultSkinAdapter()
		{
		}
		
		public function getSkin(skinName:Object, compFunc:Function):void
		{
			if(skinName is Class)
			{
				compFunc(new skinName(),skinName);
			}
			else
			{
				compFunc(skinName,skinName);
			}
		}
	}
=======
package org.flexlite.domUI.components.supportClasses
{
	import org.flexlite.domUI.core.ISkinAdapter;
	
	import flash.display.DisplayObject;
	
	
	/**
	 * 默认的ISkinAdapter接口实现
	 * @author DOM
	 */
	public class DefaultSkinAdapter implements ISkinAdapter
	{
		/**
		 * 构造函数
		 */		
		public function DefaultSkinAdapter()
		{
		}
		
		public function getSkin(skinName:Object, compFunc:Function):void
		{
			if(skinName is Class)
			{
				compFunc(new skinName(),skinName);
			}
			else
			{
				compFunc(skinName,skinName);
			}
		}
	}
>>>>>>> master
}