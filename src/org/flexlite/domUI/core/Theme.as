package org.flexlite.domUI.core
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * 主题管理类。
	 * 在子类调用mapSkin()方法为每个组件映射默认的皮肤。
	 * @author DOM
	 */
	public class Theme
	{
		/**
		 * 构造函数
		 */		
		public function Theme()
		{
		}
		
		/**
		 * 储存类的映射规则
		 */		
		private var skinNameDic:Dictionary;
		
		/**
		 * 为指定的组件映射默认皮肤。
		 * @param hostComponentKey 传入组件实例，类定义或完全限定类名。
		 * @param skinClass 传递类定义作为需要映射的皮肤，它的构造函数必须为空。
		 * @param named 可选参数，当需要为同一个组件映射多个皮肤时，可以传入此参数区分不同的映射。在调用getInstance()方法时要传入同样的参数。
		 */		
		public function mapSkin(hostComponentKey:Object,skinName:Object,named:String=""):void
		{
			var requestName:String = getKey(hostComponentKey)+"#"+named;;
			
			if(!skinNameDic)
			{
				skinNameDic = new Dictionary;
			}
			skinNameDic[requestName] = skinName;
		}
		/**
		 * 获取完全限定类名
		 */		
		private function getKey(hostComponentKey:Object):String
		{
			if(hostComponentKey is String)
				return hostComponentKey as String;
			return getQualifiedClassName(hostComponentKey);
		}
		
		/**
		 * 获取指定类映射的实例
		 * @param hostComponentKey 组件实例,类定义或完全限定类名
		 * @param named 可选参数，若在调用mapClass()映射时设置了这个值，则要传入同样的字符串才能获取对应的实例
		 */		
		public function getSkinName(hostComponentKey:Object,named:String=""):Object
		{
			var requestName:String = getKey(hostComponentKey)+"#"+named;;
			if(skinNameDic)
			{
				return skinNameDic[requestName];
			}
			return null;
		}
	}
}