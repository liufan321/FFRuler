# FFRuler

轻量级刻度尺控件

## 功能

* 简单／灵活／小巧的刻度尺控件

## 屏幕截图

![](https://github.com/liufan321/FFRuler/blob/master/screenshots/screenshots.gif?raw=true">)

## 系统支持

* iOS 7.0+
* Xcode 7.0

## 安装 

### CocoaPods

* 进入终端，`cd` 到项目目录，输入以下命令，建立 `Podfile`

```bash
$ pod init
```

* 在 Podfile 中输入以下内容：

```
platform :ios, '7.0'
use_frameworks!

target 'FFRulerDemo' do
pod 'FFRuler'
end
```

* 在终端中输入以下命令，安装或升级 Pod

```bash
# 安装 Pod，第一次使用
$ pod install

# 升级 Pod，后续使用
$ pod update
```

## 使用

* 代码示例

```objc
#import "FFRulerControl.h"

@interface CodeDemoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@end

@implementation CodeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FFRulerControl *ruler = [[FFRulerControl alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
    ruler.center = self.view.center;

    [self.view addSubview:ruler];

    ruler.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];

    // 最小值
    ruler.minValue = 10;
    // 最大值
    ruler.maxValue = 100;
    // 数值步长
    ruler.valueStep = 5;
    // 设置默认值
    ruler.selectedValue = 80;

    // 添加监听方法
    [ruler addTarget:self action:@selector(weightChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)weightChanged:(FFRulerControl *)ruler {
    _weightLabel.text = [NSString stringWithFormat:@"体重: %.02f kg", ruler.selectedValue];
}

@end
```

* 也可以直接使用 Interface Builder 设置所有属性，并且连接 `IBAction`

```objc
- (IBAction)weightChanged:(FFRulerControl *)sender {
    _weightLabel.text = [NSString stringWithFormat:@"体重: %.02f kg", sender.selectedValue];
}
```



