# 蓝牙智能锁swift5

先上个项目大致效果图

[](https://github.com/qpc2015/lock/blob/master/scrrenshot/01.PNG)

[](https://github.com/qpc2015/lock/blob/master/scrrenshot/02.PNG)

## Origin

这个智能锁项目是前些年的项目,因为当时负责人推荐使用swift开发,然后当时是一边学一边写,因为项目工期赶所以写的很一般,后该项目因为投入资金问题被放弃.最近看swift5在api方面已经基本稳定,遂想将其做基本适配.



## Problem

一  This workspace has projects that contain source code developed with Swift 3.x. This version of Xcode does not support building or migrating Swift 3.x targets.

Use Xcode 10.1 to migrate the code to Swift 4.

**[Xcode安装多个版本并自动切换版本](https://www.cnblogs.com/zndxall/p/12463744.html)**

二 The “Swift Language Version” (SWIFT_VERSION) build setting must be set to a supported value for targets which use Swift. Supported values are: 3.0, 4.0, 4.2. This setting can be set in the build settings editor.

1.更新三方sdk到最新
2.更改三方库使用build至swift5



项目run起来后的报错,

[](https://github.com/qpc2015/lock/blob/master/scrrenshot/eeror.png)

发觉大多错误是三方库升级后部分参数变化导致,原swift语法未有较大不兼容



## Contact

If you have any suggestions, leave a message here
[简书](https://www.jianshu.com/p/80150063e579)