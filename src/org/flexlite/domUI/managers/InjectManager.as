package org.flexlite.domUI.managers
{
	import org.flexlite.domUI.managers.impl.InjectManagerImpl;
	
	/**
	 * 单例注入管理器<br/>
	 * 以下类若有调用，需要显式注入：<br>
	 * IBitmapDecoder:DXR位图动画所用的解码器实例,可选值：JpegXRDecoder,Jpeg32Decoder,PngDecoder<br>
	 * IBitmapEncoder:DXR位图动画所用的编码器实例,可选值：JpegXREncoder,Jpeg32Encoder,PngEncoder<br>
	 * ISkinAdapter:皮肤解析适配器实例。通过解析UIAsset.skinName属性，返回特定显示对象作为皮肤。
	 * Theme:皮肤默认主题。组件在未显式设置skinName时会调用注入的主题来获取默认皮肤。
	 * @author DOM
	 */
	public class InjectManager
	{
		private static var _impl:InjectManagerImpl;
		/**
		 * 获取单例
		 */		
		private static function get impl():InjectManagerImpl
		{
			if (!_impl)
			{
				_impl = new InjectManagerImpl();
			}
			return _impl;
		}
		
		/**
		 * 以类定义为值进行映射注入，只有第一次请求它的单例时才会被实例化。
		 * @param whenAskedFor 传递类或接口作为需要映射的键。
		 * @param instantiateClass 传递类作为需要映射的值，它的构造函数必须为空。
		 * @param named 可选参数，在同一个类作为键需要映射多条规则时，可以传入此参数区分不同的映射。在调用getInstance()方法时要传入同样的参数。
		 */		
		public static function mapClass(whenAskedFor:Class,instantiateClass:Class,named:String=""):void
		{
			impl.mapClass(whenAskedFor,instantiateClass,named);
		}
		/**
		 * 以实例为值进行映射注入,当请求单例时始终返回注入的这个实例。
		 * @param whenAskedFor 传递类或接口作为需要映射的键。
		 * @param useValue 传递对象实例作为需要映射的值。
		 * @param named 可选参数，在同一个类作为键需要映射多条规则时，可以传入此参数区分不同的映射。在调用getInstance()方法时要传入同样的参数。
		 */		
		public static function mapValue(whenAskedFor:Class,useValue:Object,named:String=""):void
		{
			impl.mapValue(whenAskedFor,useValue,named);
		}
		/**
		 * 获取指定类映射的单例
		 * @param clazz 类定义
		 * @param named 可选参数，若在调用mapClass()映射时设置了这个值，则要传入同样的字符串才能获取对应的单例
		 */	
		public static function getInstance(clazz:Class,named:String=""):*
		{	
			return impl.getInstance(clazz,named);
		}
	}
}