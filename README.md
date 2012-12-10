framework
=========

an Open Source UI Framework for Flash Games!


检出说明：

1.Framework：FlexLite核心框架，项目开发只需要引用这一个库。

2.Extended：作为FlexLite核心框架的补充。存放开发工具软件需要的代码（如XML编译器模块），以及各种util类。如果您需要开发定制的工具软件，可能需要引用这个库。

3.Examples：测试例子。

4.注意：框架现在仍然在开发中，在没有发布正式版之前原则上不建议直接投入项目使用。因为开发过程中可能会有很多接口发生改变。但在发布正式版之后，会永久保证Framework的持续向后兼容性。而Extended里的代码由于并不涉及实际项目开发，只是作为开发辅助工具用，在必要时可能会进行微量调整。

5.编译条件：

(1) Framework库项目的编译需要Flash Player11.3或以上版本，若干供注入使用的类引用了高版本的接口，只要在项目里不引用，不会导致项目有版本需求。

下载最新的playerglobal.swc，在sdk目录下的"frameworks\libs\player\"下创建对应的版本号的文件夹，如：11.3,将playerglobal.swc放其中。再在库项目的属性里将"Adobe Flash player选项"下的FP版本设置为对应版本号即可。

(2) Extended库项目的编译需要Flash Player11.3+和AIR SDK3.3+支持。Flash Player11.3+的配置方式同上。AIR更新：下载最新的AIR SDK，解压覆盖到Flex SDK目录即可。另外请在项目属性里勾选"包含AIR库"，并且在"库构建路径"里引用Framework库项目。

(3) 测试例子项目没有FP版本需求。在"库构建路径"里引用Framework库项目即可。

