package org.flexlite.domCompile.compiler
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import org.flexlite.domCompile.consts.KeyWords;
	import org.flexlite.domCompile.consts.Modifiers;
	import org.flexlite.domCompile.core.CpClass;
	import org.flexlite.domCompile.core.CpCodeBlock;
	import org.flexlite.domCompile.core.CpFunction;
	import org.flexlite.domCompile.core.CpNotation;
	import org.flexlite.domCompile.core.CpVariable;
	import org.flexlite.domCompile.events.CompileEvent;
	import org.flexlite.domUI.core.DXML;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUtils.DomLoader;
	import org.flexlite.domUtils.StringUtil;
	
	/**
	 * 编译成功 
	 */	
	[Event(name="compileComplete", type="org.flexlite.domCompile.events.CompileEvent")]
	
	/**
	 * 编译失败 
	 */	
	[Event(name="compileError", type="org.flexlite.domCompile.events.CompileEvent")]
	
	/**
	 * DXML皮肤编译器 
	 * @author DOM
	 */	
	public class DXMLCompiler extends EventDispatcher
	{
		public function DXMLCompiler()
		{
			super();
		}
		
		
		private static const FACTORY_CLASS_PACKAGE:String = "org.flexlite.domUI.core.DeferredInstanceFromFunction";
		
		private static const FACTORY_CLASS:String = "DeferredInstanceFromFunction";
		
		private static const ADD_ITEMS_PACKAGE:String = "org.flexlite.domUI.states.AddItems";
		
		private static const SETPROPERTY_PACKAGE:String = "org.flexlite.domUI.states.SetProperty";
		
		private static const DECLARATIONS:String = "Declarations";
		/**
		 * 使用框架配置文件的默认命名空间 
		 */		
		private static const DEFAULT_NS:Array = 
			   [DXML.NS,
				new Namespace("s","library://ns.adobe.com/flex/spark"),
				new Namespace("mx","library://ns.adobe.com/flex/mx"),
				new Namespace("fx","http://ns.adobe.com/mxml/2009")];
		
		/**
		 * 指定的命名空间是否是默认命名空间
		 */		
		private static function isDefaultNs(ns:Namespace):Boolean
		{
			for each(var dns:Namespace in DEFAULT_NS)
			{
				if(ns==dns)
					return true;
			}
			return false;
		}
		
		
		
		private static var _configData:XML;

		/**
		 * 框架配置文件 
		 */
		public static function get configData():XML
		{
			return _configData;
		}
		public static function set configData(value:XML):void
		{
			_configData = value;
		}
		
		private static var _projectConfigData:XML;
		/**
		 * 项目配置文件
		 */
		public static function get projectConfigData():XML
		{
			return _projectConfigData;
		}

		public static function set projectConfigData(value:XML):void
		{
			_projectConfigData = value;
		}
		
		/**
		 * 标记指定的文件需要重新编译
		 */		
		public static function markChanged(packageName:String):void
		{
			if(_projectConfigData==null)
				return;
			for each(var node:XML in _projectConfigData.children())
			{
				if(node.@p == packageName)
				{
					node.@changed = "true";
					return;
				}
			}
		}
		
		/**
		 * 根据类名获取对应的包，并自动导入相应的包
		 */		
		private function getPackageByNode(node:XML):String
		{
			var packageName:String = "";
			var config:XML = getConfigNode(node);
			if(config!=null)
				packageName = config.@p;
			if(packageName!="")
			{
				currentClass.addImport(packageName);
			}
			return packageName;
		}
		/**
		 * 获取配置节点
		 */		
		private static function getConfigNode(node:XML):XML
		{
			var ns:Namespace = node.namespace();
			var className:String = node.localName();
			if(isDefaultNs(ns))
			{
				for each(var component:XML in configData.children())
				{
					if(component.@id==className)
					{
						return component;
					}
				}
			}
			else if(projectConfigData!=null)
			{
				for each(var item:XML in projectConfigData.children())
				{
					if(item.localName()==className&&item.namespace()==ns)
					{
						return item;
					}
				}
			}
			return null;
		}
		/**
		 * 根据包名获取配置节点
		 */		
		private static function getConfigNodeByPackage(packageName:String):XML
		{
			for each(var component:XML in configData.children())
			{
				if(component.@p==packageName)
				{
					return component;
				}
			}
			if(projectConfigData!=null)
			{
				for each(var item:XML in projectConfigData.children())
				{
					if(item.@p == packageName)
					{
						return item;
					}
				}
			}
			return null;
		}
		/**
		 * 根据类名获取对应默认属性
		 */
		private static function getDefaultPropByNode(node:XML):Object
		{
			var config:XML = getConfigNode(node);
			if(config==null)
				return {d:"",array:false};
			findProp(config);
			return {d:config.@d,array:config.@array=="true"};
		}
		/**
		 * 递归查询默认值
		 */		
		private static function findProp(node:XML):String
		{
			if(node.hasOwnProperty("@d"))
			{
				return node.@d;
			}
			
			var superClass:String = node.@s;
			var superNode:XML;
			var item:XML;
			var found:Boolean;
			for each(item in _configData.children())
			{
				if(item.@p==superClass)
				{
					superNode = item;
					break;
				}
			}
			if(!found&&projectConfigData!=null)
			{
				for each(item in _projectConfigData.children())
				{
					if(item.@p==superClass)
					{
						superNode = item;
						break;
					}
				}
			}
			if(superNode!=null)
			{
				var prop:String = findProp(superNode);
				if(prop!="")
				{
					node.@d = prop;
					if(superNode.hasOwnProperty("@array"))
						node.@array = superNode.@array;
				}
			}
			return node.@d;
		}
		/**
		 * 指定的变量名是否是工程默认包里的类名
		 */		
		private static function isDefaultPackageClass(name:String):Boolean
		{
			if(_projectConfigData==null||name=="")
				return false;
			for each(var item:XML in _projectConfigData.children())
			{
				if(item.@p == name)
					return true;
			}
			return false;
		}
		
		/**
		 * 检查变量是否是包名
		 */		
		private function isPackageName(name:String):Boolean
		{
			return name.indexOf(".")!=-1;
		}
		
		/**
		 * 当前类 
		 */		
		private var currentClass:CpClass;
		/**
		 * 当前要编译的皮肤文件 
		 */		
		private var currentSkin:XML;
		/**
		 * id缓存字典 
		 */		
		private var idDic:Dictionary;
		/**
		 * 状态代码列表 
		 */		
		private var stateCode:Vector.<CpState>;
		/**
		 * 工程目录 
		 */		
		private var srcPath:String;
		/**
		 * 皮肤文件路径 
		 */		
		private var xmlPath:String;
		
		/**
		 * xml文件缓存路径
		 */		
		private var dxmlPath:String;
		/**
		 * 忽略编译子项时抛出的错误 
		 */		
		private var skipChildError:Boolean = true;
		/**
		 * 通过视图状态名称获取对应的视图状态
		 */		
		private function getStateByName(name:String):Vector.<CpState>
		{
			var states:Vector.<CpState> = new Vector.<CpState>;
			for each(var state:CpState in stateCode)
			{
				if(state.name == name)
				{
					if(states.indexOf(state)==-1)
						states.push(state);
				}
				else if(state.stateGroups.length>0)
				{
					var found:Boolean = false;
					for each(var g:String in state.stateGroups)
					{
						if(g==name)
						{
							found = true;
							break;
						}
					}
					if(found)
					{
						if(states.indexOf(state)==-1)
							states.push(state);
					}
						
				}
					
			}
			return states;
		}
		
		/**
		 * 编译指定路径的皮肤文件
		 * @param xmlPath 皮肤文件的路径
		 * @param srcPath 工程src根目录
		 * @param dxmlPath dxml文件目录
		 * @param xmlData 可选项，如果传入就不使用xmlPath重新加载xml数据
		 */		
		public function compile(xmlPath:String,srcPath:String,dxmlPath:String=null,xmlData:XML=null):void
		{
			currentClass = new CpClass();
			currentClass.notation = new CpNotation(
				"@private\n此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。\n@author DXMLCompiler");
			idDic = new Dictionary;
			stateCode = new Vector.<CpState>();
			
//			this.skipChildError = skipChildError;
			var xmlFile:File = File.applicationDirectory.resolvePath(xmlPath);
			if(!xmlFile.exists||xmlFile.isDirectory)
			{
				dispatchError("目标文件不存在:"+xmlFile.nativePath);
				return;
			}
			this.xmlPath = xmlFile.nativePath;
			var srcDir:File = File.applicationDirectory.resolvePath(srcPath);
			this.srcPath = srcDir.nativePath;
			var dxmlDir:File;
			if(dxmlPath)
			{
				dxmlDir = File.applicationDirectory.resolvePath(dxmlPath);
				this.dxmlPath = dxmlDir.nativePath;
			}
			else
			{
				this.dxmlPath = srcPath.substr(0,srcPath.length-3)+"dxml";
				dxmlDir = new File(this.dxmlPath);
			}
			
			var index:int = xmlFile.nativePath.indexOf(dxmlDir.nativePath)
			if(index==-1)
			{
				dispatchError("目标文件"+xmlFile.nativePath+",不包含在指定的dxml工程目录下:"+dxmlDir.nativePath);
				return;
			}
			
			var subPath:String = xmlFile.nativePath.substring(dxmlDir.nativePath.length+1);
			index = subPath.lastIndexOf(File.separator);
			if(index!=-1)
			{
				currentClass.packageName = StringUtil.replaceStr(subPath.substr(0,index),File.separator,".");
			}
			index = xmlFile.name.lastIndexOf(".");
			currentClass.className = xmlFile.name.substr(0,index);
			
			if(xmlData)
			{
				onXMLComp(xmlData);
			}
			else
			{
				loadXML(xmlPath);
			}
		}
		/**
		 * 加载皮肤文件
		 */		
		private function loadXML(xmlPath:String):void
		{
			DomLoader.loadXML(xmlPath,onXMLComp);
		}
		
		/**
		 * 皮肤文件加载完成
		 */		
		private function onXMLComp(data:XML):void
		{
			currentSkin = data;	
			if(data==null)
			{
				dispatchError("要编译的目标文件无法解析为有效的XML:"+xmlPath);
				return;
			}
			if(_configData==null)
			{
				dispatchError("还未初始化编译器的框架配置文件数据！");
				return;
			}
			else
			{
				needCompileList = []
				var error:Boolean = checkNeedCompileList(currentSkin);
				if(error&&!skipChildError)
				{
					return;
				}
				if(needCompileList.length>0)
				{
					startOneNeedCompile();
				}
				else
				{
					startCompile();
				}
			}
		}
		
		private var needCompileList:Array = [];
		/**
		 * 递归检查需要先编译的子项列表,返回是否发生错误
		 */		
		private function checkNeedCompileList(item:XML):Boolean
		{
			var error:Boolean = false;
			var config:XML;
			if(!isProperty(item)&&item.localName()!=DECLARATIONS)
			{
				config = getConfigNode(item);
				if(config==null)
				{
					if(!skipChildError)
					{
						dispatchError("找不到类的定义："+item.localName()+",位置:"+xmlPath);
						return true;
					}
					error = true;
				}
				else if(!isDefaultNs(item.namespace())&&config.@changed=="true")
				{
					needCompileList.push(config);
				}
			}
			//遍历属性
			for each(var att:XML in item.attributes())
			{
				if(att.localName()=="skinClass")
				{
					config = getConfigNodeByPackage(att);
					if(config==null)
					{
						if(!skipChildError)
						{
							dispatchError("找不到类的定义："+item.localName()+",位置:"+xmlPath);
							return true;
						}
						error = true;
					}
					else if(config.@changed=="true")
					{
						needCompileList.push(config);
					}
				}
			}
			//遍历子节点
			for each(var node:XML in item.children())
			{
				if(checkNeedCompileList(node))
					error = true;
			}
			return error;
		}
		
		/**
		 * 开始一个待编译子项
		 */		
		private function startOneNeedCompile():void
		{
			if(needCompileList.length==0)
			{
				startCompile();
				return;
			}
			var config:XML = needCompileList.pop();
			var packageName:String = config.@p;
			
			var path:String = StringUtil.replaceStr(packageName,".",File.separator);
			if(path!="")
				path += "."+DXML.EXTENSION;
			var xmlPath:String = this.dxmlPath+File.separator+path;
			var skinCp:DXMLCompiler = new DXMLCompiler();
			skinCp.addEventListener(CompileEvent.COMPILE_COMPLETE,onCompileComp);
			skinCp.addEventListener(CompileEvent.COMPILE_ERROR,onCompileError);
			skinCp.compile(xmlPath,this.srcPath,dxmlPath);
		}
		
		/**
		 * 编译一项成功
		 */		
		private function onCompileComp(event:CompileEvent):void
		{
			var skinCp:DXMLCompiler = event.target as DXMLCompiler;
			skinCp.removeEventListener(CompileEvent.COMPILE_COMPLETE,onCompileComp);
			skinCp.removeEventListener(CompileEvent.COMPILE_ERROR,onCompileError);
			startOneNeedCompile();
		}
		/**
		 * 编译失败
		 */		
		private function onCompileError(event:CompileEvent):void
		{
			var skinCp:DXMLCompiler = event.target as DXMLCompiler;
			skinCp.removeEventListener(CompileEvent.COMPILE_COMPLETE,onCompileComp);
			skinCp.removeEventListener(CompileEvent.COMPILE_ERROR,onCompileError);
			if(skipChildError)
			{
				startOneNeedCompile();
			}
			else
			{
				dispatchError(event.message);
			}
		}
		/**
		 * 抛出错误事件
		 */		
		private function dispatchError(message:String):void
		{
			if(hasEventListener(CompileEvent.COMPILE_ERROR))
			{
				var event:CompileEvent = new CompileEvent(CompileEvent.COMPILE_ERROR);
				event.message = message;
				event.xmlPath = this.xmlPath;
				event.srcPath = this.srcPath;
				dispatchEvent(event);
			}
			else
			{
				throw new Error(message);
			}
		}
		
		
		
		/**
		 * 开始编译
		 */		
		private function startCompile():void
		{
			currentClass.superClass = getPackageByNode(currentSkin);
			stateIds = [];
			addIds(currentSkin.children());
			
			
			createConstructFunc();
			
			
			for each(var node:XML in currentSkin.children())
			{
				createFuncForNode(node);
			}
			
			var path:String = StringUtil.replaceStr(currentClass.packageName,".",File.separator);
			if(path!="")
				path += File.separator;
			path += currentClass.className+".as";
			var asPath:String = this.srcPath+File.separator+path;
			var file:File = new File(asPath);
			if(file.exists)
			{
				try
				{
					if(file.isDirectory)
						file.deleteDirectory(true);
					else
						file.deleteFile();
				}
				catch(e:Error)
				{
				}
			}
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.WRITE);
			_resultCode = currentClass.toCode();
			stream.writeUTFBytes(_resultCode)
			stream.close();
			
			var event:CompileEvent = new CompileEvent(CompileEvent.COMPILE_COMPLETE);
			event.xmlPath = this.xmlPath;
			event.asPath = asPath;
			event.srcPath = this.srcPath;
			dispatchEvent(event);
		}
		
		private var _resultCode:String = "";
		/**
		 * 编译后的代码
		 */		
		public function get resultCode():String
		{
			return _resultCode;
		}
	
		/**
		 * 添加必须的id
		 */		
		private function addIds(items:XMLList):void
		{
			for each(var node:XML in items)
			{
				if(node.hasOwnProperty("@id"))
				{
					createVarForNode(node);
					if(isStateNode(node))//检查节点是否只存在于一个状态里，需要延迟实例化
						stateIds.push(node.@id);
				}
				else if(getPackageByNode(node)!="")
				{
					createIdForNode(node);
					if(isStateNode(node))
						stateIds.push(node.@id);
					if(containsState(node))
					{
						createVarForNode(node);
						
						var parentNode:XML = node.parent() as XML;
						if(isStateNode(node)&&parentNode!=null&&parentNode!=currentSkin
							&&!currentClass.containsVar(getNodeId(parentNode)))
						{
							createVarForNode(parentNode);
						}
					}
				}
				addIds(node.children());
			}
		}
		/**
		 * 检测指定节点的属性是否含有视图状态
		 */		
		private static function containsState(node:XML):Boolean
		{
			if(node.hasOwnProperty("@includeIn")||node.hasOwnProperty("@excludeFrom"))
			{
				return true;
			}
			var attributes:XMLList = node.attributes();
			for each(var item:XML in attributes)
			{
				var name:String= item.localName();
				if(name.indexOf(".")!=-1)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 为指定节点创建id属性
		 */		
		private function createIdForNode(node:XML):void
		{
			var idName:String = getNodeId(node);
			if(idDic[idName]==null)
				idDic[idName] = 1;
			else
				idDic[idName] ++;
			idName += idDic[idName];
			node.@id = idName;
		}
		/**
		 * 获取节点ID
		 */		
		private function getNodeId(node:XML):String
		{
			if(node.hasOwnProperty("@id"))
				return node.@id;
			return "__"+currentClass.className+"_"+node.localName();
		}
		
		/**
		 * 为指定节点创建变量
		 */		
		private function createVarForNode(node:XML):void
		{
			var packageName:String = getPackageByNode(node);
			if(packageName=="")
				return;
			if(!currentClass.containsVar(node.@id))
				currentClass.addVariable(new CpVariable(node.@id,Modifiers.M_PUBLIC,packageName));
		}
		/**
		 * 为指定节点创建初始化函数,返回函数名引用
		 */		
		private function createFuncForNode(node:XML):String
		{
			var packageName:String = getPackageByNode(node);
			var className:String = node.localName();
			if(className!="Array"&&(isProperty(node)||packageName==""))
				return "";
			
			if(className=="Array")
			{//如果子节点是数组类型
				var returnValue:String = "[";
				var isFirst:Boolean = true;
				for each(var child:XML in node.children())
				{
					if(isFirst)
					{
						isFirst = false;
						returnValue += createFuncForNode(child);
					}
					else
					{
						returnValue += ","+createFuncForNode(child);
					}
					
				}
				returnValue += "]";
				return returnValue;
			}
			var func:CpFunction = new CpFunction;
			var tailName:String = "_i";
			func.name = node.@id+tailName;
			func.returnType = packageName;
			var cb:CpCodeBlock = new CpCodeBlock;
			var varName:String = "temp";
			if(packageName=="flash.geom.Transform")
			{//Transform需要构造函数参数
				cb.addVar(varName,packageName,"new "+packageName+"(new Shape())");
				currentClass.addImport("flash.display.Shape");
			}
			else
			{
				cb.addVar(varName,packageName,"new "+packageName+"()");
			}
			var containsId:Boolean = currentClass.containsVar(node.@id);
			if(containsId)
			{
				cb.addAssignment(node.@id,varName);
			}
			
			addAttributesToCodeBlock(cb,varName,node);
			
			var children:XMLList = node.children();
			var property:String = "";
			var isArray:Boolean = false;
			if(property=="")
			{
				var obj:Object = getDefaultPropByNode(node);
				property = obj.d;
				isArray = obj.array;
			}
			
			initlizeChildNode(cb,children,property,isArray,varName);
			
			cb.addReturn(varName);
			func.codeBlock = cb;
			currentClass.addFunction(func);
			return func.name+"()";
		}
		/**
		 * 将节点属性赋值语句添加到代码块
		 */		
		private function addAttributesToCodeBlock(cb:CpCodeBlock,varName:String,node:XML):void
		{
			var keyList:Array = [];
			var key:String;
			var value:String;
			for each(var item:XML in node.attributes())
			{
				key = item.localName();
				if(!isNormalKey(key))
					continue;
				keyList.push(key);
			}
			keyList.sort();//排序一下防止出现随机顺序
			for each(key in keyList)
			{
				value = node["@"+key].toString();
				key = formatKey(key,value);
				value  = formatValue(key,value,node.@id);
				cb.addAssignment(varName,value,key);
			}
		}
		/**
		 * 初始化子项
		 */		
		private function initlizeChildNode(cb:CpCodeBlock,children:XMLList,
										   property:String,isArray:Boolean,varName:String):void
		{
			var child:XML;
			var childFunc:String = "";
			if(children.length()>0)
			{
				
				var directChild:Array = [];
				var prop:String = "";
				for each(child in children)
				{
					if(isProperty(child))
					{
						if(child.children().length()==0)
							continue;
						prop = child.localName();
						childFunc = createFuncForNode(child.children()[0]);
						if(childFunc!=""&&!isStateNode(child))
							cb.addAssignment(varName,childFunc,prop);
					}
					else
					{
						directChild.push(child);
					}
					
				}
				if(directChild.length==0)
					return;
				if(isArray)
				{
					var arrValue:String = "[";
					var isFirst:Boolean = true;
					for each(child in directChild)
					{
						childFunc = createFuncForNode(child);
						if(childFunc==""||isStateNode(child))
							continue;
						if(isFirst)
						{
							arrValue += childFunc;
							isFirst = false;
						}
						else
						{
							arrValue += ","+childFunc;
						}
					}
					arrValue += "]";
					cb.addAssignment(varName,arrValue,property);
				}
				else
				{
					childFunc = createFuncForNode(directChild[0]);
					if(childFunc!=""&&!isStateNode(child))
						cb.addAssignment(varName,childFunc,property);
				}
			}
		}
		
		/**
		 * 指定节点是否是属性节点
		 */		
		private function isProperty(node:XML):Boolean
		{
			var name:String = node.localName();
			if(name==null)
				return true;
			var firstChar:String = name.charAt(0);
			return firstChar<"A"||firstChar>"Z";
		}
		/**
		 * 是否是普通赋值的key
		 */		
		private function isNormalKey(key:String):Boolean
		{
			if(key==null||key==""||key=="id"||key=="includeIn"
				||key == "excludeFrom"||key.indexOf(".")!=-1)
				return false;
			return true;
		}
		/**
		 * 格式化key
		 */		
		private function formatKey(key:String,value:String):String
		{
			if(key=="skinClass")
			{
				key = "skinName";
			}
			else if(value.indexOf("%")!=-1)
			{
				if(key=="height")
					key = "percentHeight";
				else if(key=="width")
					key = "percentWidth";
			}
			return key;
		}
		/**
		 * 格式化值
		 */		
		private function formatValue(key:String,value:String,id:String):String
		{
			var index:int = value.indexOf("@Embed(");
			if(index!=-1)
			{
				var metadata:String = value.substr(index+1);
				currentClass.addVariable(new CpVariable(id+"_"+key,Modifiers.M_PRIVATE,"Class","",true,false,metadata));
				value = id+"_"+key; 
			}
			else if(key=="skinClass"||key=="skinName"||key=="itemRenderer")
			{
				if(isPackageName(value))
				{
					currentClass.addImport(value);
				}
				else
				{
					value = formatString(value);
				}
			}
			else if(isStringKey(key))
			{
				value = formatString(value);
			}
			else if(value.indexOf("{")!=-1)
			{
				value = value.substr(1,value.length-2);
			}
			else if(value.indexOf("%")!=-1)
			{
				value = Number(value.substr(0,value.length-1)).toString();
			}
			else if(value.indexOf("#")==0)
			{
				value = "0x"+value.substr(1);
			}
			else if(isNaN(Number(value))&&value!="true"&&value!="false")
			{
				value = formatString(value);
			}
			return value;
		}
		/**
		 * 格式化字符串
		 */		
		private function formatString(value:String):String
		{
			value = "\""+value+"\"";
			value = StringUtil.replaceStr(value,"\n","\\n");
			value = StringUtil.replaceStr(value,"\r","\\n");
			return value;
		}
		
		/**
		 * 类型为字符串的属性名列表
		 */		
		private var stringKeyList:Array = ["text","label"];
		/**
		 * 判断一个属性是否是字符串类型。
		 */		
		private function isStringKey(key:String):Boolean
		{
			for each(var str:String in stringKeyList)
			{
				if(str==key)
					return true;
			}
			return false;
		}
		
		/**
		 * 需要延迟创建的实例id列表
		 */		
		private var stateIds:Array = [];
		/**
		 * 创建构造函数
		 */		
		private function createConstructFunc():void
		{
			var cb:CpCodeBlock = new CpCodeBlock;
			cb.addEmptyLine();
			var varName:String = KeyWords.KW_THIS;
			addAttributesToCodeBlock(cb,varName,currentSkin);
			
			var declarations:XML;
			
			var noneStateIds:Array = [];
			for each(var node:XML in currentSkin.children())
			{
				if(node.localName()==DECLARATIONS)
				{
					declarations = node;
					continue;
				}
				if(isProperty(node))
				{
					if(node.localName()!="states")
					{
						initlizeChildNode(cb,node.children(),node.localName(),false,varName);
					}
					continue;
				}
				
				if(getPackageByNode(node)=="")
					continue;
				if(!isStateNode(node))
					noneStateIds.push(node.@id);
			}
			
			if(declarations&&declarations.children().length()>0)
			{
				for each(var decl:XML in declarations.children())
				{
					var funcName:String = createFuncForNode(decl);
					if(funcName!="")
					{
						cb.addCodeLine(funcName+";");
					}
				}
			}
			
			var id:String;
			if(noneStateIds.length>0)
			{
				var elements:String = "[";
				var isFirst:Boolean = true;
				for each(id in noneStateIds)
				{
					if(isFirst)
					{
						elements += id+"_i()";
						isFirst = false;
					}
					else
					{
						elements += ","+id+"_i()";
					}
				}
				elements += "]";
				var property:String = getDefaultPropByNode(currentSkin).d;
				cb.addAssignment(varName,elements,property);
			}
			
			getStateNames();
			if(stateCode.length>0&&!currentSkin.hasOwnProperty("@currentState"))
			{
				cb.addAssignment(varName,"\""+stateCode[0].name+"\"","currentState");
			}
			cb.addEmptyLine();
			
			if(stateIds.length>0)
			{
				currentClass.addImport(FACTORY_CLASS_PACKAGE);
				for each(id in stateIds)
				{
					var name:String = id+"_factory";
					var value:String = "new "+FACTORY_CLASS_PACKAGE+"("+id+"_i)";
					cb.addVar(name,FACTORY_CLASS_PACKAGE,value);
				}
				cb.addEmptyLine();
			}
			
			//生成视图状态代码
			createStates(currentSkin.children());
			var states:Vector.<CpState>;
			for each(var item:XML in currentSkin.attributes())
			{
				var itemName:String= item.localName();
				var index:int = itemName.indexOf(".");
				if(index!=-1)
				{
					var key:String = itemName.substring(0,index);
					key = formatKey(key,item);
					var itemValue:String = formatValue(key,item,"this");
					var stateName:String = itemName.substr(index+1);
					states = getStateByName(stateName);
					if(states.length>0)
					{
						for each(var state:CpState in states)
							state.addOverride(new CpSetProperty("",key,itemValue));
					}
				}
			}
			
			for each(state in stateCode)
			{
				if(state.addItems.length>0)
				{
					currentClass.addImport(ADD_ITEMS_PACKAGE);
					break;
				}
			}
			
			for each(state in stateCode)
			{
				if(state.setProperty.length>0)
				{
					currentClass.addImport(SETPROPERTY_PACKAGE);
					break;
				}
			}
			
			//打印视图状态初始化代码
			if(stateCode.length>0)
			{
				cb.addCodeLine("states = [");
				var first:Boolean = true;
				var indentStr:String = "	";
				for each(state in stateCode)
				{
					if(first)
						first = false;
					else
						cb.addCodeLine(indentStr+",");
					var codes:Array = state.toCode().split("\n");
					var codeIndex:int = 0;
					while(codeIndex<codes.length)
					{
						cb.addCodeLine(indentStr+codes[codeIndex]);
						codeIndex++;
					}
				}
				cb.addCodeLine("];");
			}
			
			
			currentClass.constructCode = cb;
		}
		
		/**
		 * 是否含有includeIn和excludeFrom属性
		 */		
		private function isStateNode(node:XML):Boolean
		{
			return node.hasOwnProperty("@includeIn")||node.hasOwnProperty("@excludeFrom");
		}
		
		/**
		 * 获取视图状态名称列表
		 */		
		private function getStateNames():void
		{
			var states:XMLList;
			for each(var item:XML in currentSkin.children())
			{
				if(item.localName()=="states")
				{
					states = item.children();
					break;
				}
			}
			if(states==null||states.length()==0)
				return;
			for each(var state:XML in states)
			{
				var stateGroups:Array = [];
				if(state.hasOwnProperty("@stateGroups"))
				{
					var groups:Array = String(state.@stateGroups).split(",");
					for each(var group:String in groups)
					{
						if(StringUtil.trim(group)!="")
						{
							stateGroups.push(StringUtil.trim(group));
						}
					}
				}
				stateCode.push(new CpState(state.@name,stateGroups));
			}
			currentClass.addImport(getPackageByNode(states[0]));
		}
		
		/**
		 * 解析视图状态代码
		 */		
		private function createStates(items:XMLList):void
		{
			for each(var node:XML in items)
			{
				createStates(node.children());
				if(isProperty(node)||getPackageByNode(node)=="")
					continue;
				if(containsState(node))
				{
					var id:String = node.@id;
					var stateName:String;
					var states:Vector.<CpState>;
					var state:CpState;
					if(isStateNode(node))
					{
						var propertyName:String = "";
						var parentNode:XML = node.parent() as XML;
						if(parentNode!=null&&parentNode != currentSkin)
							propertyName = parentNode.@id;
						var positionObj:Object = findNearNodeId(node);
						var stateNames:Array = [];
						if(node.hasOwnProperty("@includeIn"))
						{
							stateNames = node.@includeIn.toString().split(".");
						}
						else
						{
							var excludeNames:Array = node.@excludeFrom.toString().split(".");
							for each(state in stateCode)
							{
								if(excludeNames.indexOf(state.name)==-1)
									stateNames.push(state.name);
							}
						}
							
						for each(stateName in stateNames)
						{
							states = getStateByName(stateName);
							if(states.length>0)
							{
								for each(state in states)
									state.addOverride(new CpAddItems(id+"_factory",propertyName,
										positionObj.position,positionObj.relativeTo));
							}
						}
					}
					
					for each(var item:XML in node.attributes())
					{
						var name:String= item.localName();
						var index:int = name.indexOf(".");
						if(index!=-1)
						{
							var key:String = name.substring(0,index);
							key = formatKey(key,item);
							var value:String = formatValue(key,item,node.@id);
							stateName = name.substr(index+1);
							states = getStateByName(stateName);
							if(states.length>0)
							{
								for each(state in states)
									state.addOverride(new CpSetProperty(id,key,value));
							}
						}
					}
				}
			}
			
		}
		/**
		 * 寻找节点的临近节点ID和位置
		 */		
		private function findNearNodeId(node:XML):Object
		{
			var parentNode:XML = node.parent();
			var item:XML;
			var targetId:String = "";
			var postion:String;
			var index:int = node.childIndex();
			if(index==0)
			{
				postion = AddItems.FIRST;
				return {position:postion,relativeTo:targetId};
			}
			if(index==parentNode.children().length()-1)
			{
				postion = AddItems.LAST;
				return {position:postion,relativeTo:targetId};
			}
			
			postion = AddItems.AFTER;
			index--;
			while(index>=0)
			{
				item = parentNode.children()[index];
				if(!isStateNode(item)&&item.hasOwnProperty("@id"))
				{
					targetId = item.@id;
					break;
				}
				index--;
			}
			if(targetId!="")
			{
				createVarForNode(item);
				return {position:postion,relativeTo:targetId};
			}
			
			postion = AddItems.BEFORE;
			index = node.childIndex();
			index++;
			while(index<parentNode.children().length())
			{
				item = parentNode.children()[index];
				if(!isStateNode(item)&&item.hasOwnProperty("@id"))
				{
					targetId = item.@id;
					break;
				}
				index++;
			}
			if(targetId!="")
			{
				createVarForNode(item);
				return {position:postion,relativeTo:targetId};
			}
			else
			{
				return {position:AddItems.LAST,relativeTo:targetId};
			}
		}
		
	}
}


import org.flexlite.domCompile.core.CodeBase;
import org.flexlite.domCompile.core.ICode;
import org.flexlite.domUI.states.AddItems;

/**
 * 状态类代码块
 * @author DOM
 */
class CpState extends CodeBase
{
	public function CpState(name:String,stateGroups:Array=null)
	{
		super();
		this.name = name;
		if(stateGroups)
			this.stateGroups = stateGroups;
	}
	/**
	 * 视图状态名称
	 */	
	public var name:String = "";
	
	public var stateGroups:Array = [];
	
	public var addItems:Array = [];
	
	public var setProperty:Array = [];
	
	/**
	 * 添加一个覆盖
	 */	
	public function addOverride(item:ICode):void
	{
		if(item is CpAddItems)
			addItems.push(item);
		else
			setProperty.push(item);
	}
	
	override public function toCode():String
	{
		var indentStr:String = getIndent(1);
		var returnStr:String = "new org.flexlite.domUI.states.State ({name: \""+name+"\",\n"+indentStr+"overrides: [\n";
		var index:int = 0;
		var isFirst:Boolean = true;
		var overrides:Array = addItems.concat(setProperty);
		while(index<overrides.length)
		{
			if(isFirst)
				isFirst = false;
			else
				returnStr += indentStr+indentStr+",\n";
			var item:ICode = overrides[index];
			var codes:Array = item.toCode().split("\n");
			for each(var code:String in codes)
			{
				returnStr += indentStr+indentStr+code+"\n";
			}
			index++;
		}
		returnStr += indentStr+"]\n})";
		return returnStr;
	}
}

/**
 * AddItems类代码块
 * @author DOM
 */
class CpAddItems extends CodeBase
{
	public function CpAddItems(targetFactory:String,propertyName:String,position:String,relativeTo:String)
	{
		super();
		this.targetFactory = targetFactory;
		this.propertyName = propertyName;
		this.position = position;
		this.relativeTo = relativeTo;
	}
	
	/**
	 * 创建项目的工厂类实例 
	 */		
	public var targetFactory:String;
	
	/**
	 * 要添加到的属性 
	 */		
	public var propertyName:String;
	
	/**
	 * 添加的位置 
	 */		
	public var position:String;
	
	/**
	 * 相对的显示元素 
	 */		
	public var relativeTo:String;
	
	override public function toCode():String
	{
		var indentStr:String = getIndent(1);
		var returnStr:String = "new org.flexlite.domUI.states.AddItems().initializeFromObject({\n";
		returnStr += indentStr+"targetFactory:"+targetFactory+",\n";
		returnStr += indentStr+"propertyName:\""+propertyName+"\",\n";
		returnStr += indentStr+"position:\""+position+"\",\n";
		returnStr += indentStr+"relativeTo:\""+relativeTo+"\"\n})";
		return returnStr;
	}
}
/**
 * SetProperty类代码块
 * @author DOM
 */
class CpSetProperty extends CodeBase
{
	public function CpSetProperty(target:String,name:String,value:String)
	{
		super();
		this.target = target;
		this.name = name;
		this.value = value;
	}
	
	/**
	 * 要修改的属性名
	 */		
	public var name:String;
	
	/**
	 * 目标实例名
	 */		
	public var target:String;
	
	/**
	 * 属性值 
	 */		
	public var value:String;
	
	override public function toCode():String
	{
		var indentStr:String = getIndent(1);
		var returnStr:String = "new org.flexlite.domUI.states.SetProperty().initializeFromObject({\n";
		returnStr += indentStr+"target:\""+target+"\",\n";
		returnStr += indentStr+"name:\""+name+"\",\n";
		returnStr += indentStr+"value:"+value+"\n})";
		return returnStr;
	}
}