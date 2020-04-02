# 蓝牙智能锁swift3升级swift5

先上个项目大致效果图

[](https://github.com/qpc2015/lock/blob/master/scrrenshot/01.png)

[](https://github.com/qpc2015/lock/blob/master/scrrenshot/02.png)

一  This workspace has projects that contain source code developed with Swift 3.x. This version of Xcode does not support building or migrating Swift 3.x targets.

Use Xcode 10.1 to migrate the code to Swift 4.

**[Xcode安装多个版本并自动切换版本](https://www.cnblogs.com/zndxall/p/12463744.html)**

二 The “Swift Language Version” (SWIFT_VERSION) build setting must be set to a supported value for targets which use Swift. Supported values are: 3.0, 4.0, 4.2. This setting can be set in the build settings editor.

1.更新三方sdk到最新
2.更改三方库使用build至swift5