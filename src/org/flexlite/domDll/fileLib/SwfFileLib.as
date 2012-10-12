package org.flexlite.domDll.fileLib
{
	import flash.system.ApplicationDomain;
	
	/**
	 * SWF文件解析缓存库
	 * @author DOM
	 */
	public class SwfFileLib extends FileLibBase
	{
		public function SwfFileLib()
		{
			super();
		}
		/**
		 * 程序域
		 */		
		private var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		
		override public function getRes(key:String):*
		{
			var res:*  = fileDic[key];
			if(res)
				return res;
			if(sharedMap.has(key))
				return sharedMap.get(key);
			if(appDomain.hasDefinition(key))
			{
				var clazz:Class = appDomain.getDefinition(key) as Class;
				sharedMap.set(key,clazz);
				return clazz;
			}
			return null;
		}
	}
}