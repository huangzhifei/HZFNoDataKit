# HZFNoDataKit

## 前文提要
近期准备重构项目，需要重写一些通用模块，正巧需要设置App异常加载占位图的问题，心血来潮设想是否可以零行代码解决此问题，特在此分享实现思路。

## 思路分享
对于App占位图，通常需要考虑的控件有tableView、collectionView和webView，异常加载情况区分为无数据和网络异常等。

既然要实现零代码形式，因此就不能继承原始类重写或添加方法等方式，而是通过对对应控件添加类别（分类）来实现。

简单来说，以tableView为例实现思路为每当tableView调用reloadData进行刷新时，检测此时tableView行数，若行数不为零，正常显示数据。若行数为零，说明无数据显示占位图。

添加占位图的方式有很多种，例如借助tableView的backgroundView或直接以addSubView的方式添加，这里采用的为addSubView方式，尽量避免原生属性的占用。

对于检测tableView数据是否为空，借助tableView的代理dataSource即可。核心代码如下，依次获取tableView所具有的组数与行数，通过isEmpty这个flag标示最后确定是否添加占位图。

```
- (void)checkEmpty {
    BOOL isEmpty = YES; //flag标示

    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1; //默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1; //获取当前TableView组数
    }

    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i]; //获取当前TableView各组行数
        if (rows) {
            isEmpty = NO; //若行数存在，不为空
        }
    }
    if (isEmpty) { //若为空，加载占位图
        //默认占位图
        if (!self.hzf_placeholderView) {
            [self makeDefaultPlaceholderView];
        }
        self.hzf_placeholderView.hidden = NO;
        [self addSubview:self.hzf_placeholderView];
    } else { //不为空，移除占位图
        self.hzf_placeholderView.hidden = YES;
    }
}
```

相应的对于 `CollectionView` 亦可通过 `numberOfSectionsInCollectionView:` 和 `collectionView:numberOfItemsInSection` 获取其组数和行数，这里就不一一赘述。

## 接下来说最重要的一步，如何实现零行代码添加占位图呢？

其实实现思路非常简单，如果可以让`tableView`在执行`reloadData`时自动检测其行数就可以了。也就是我们需要在`reloadData`原有方法的基础上添加`checkEmpty`此方法。

这里又能体现到`Runtime Method Swizzling`的作用了，我们可以通过`Method Swizzling`替换`reloadData`方法，给予它新的实现。核心代码如下：

```
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData)
                               bySwizzledSelector:@selector(sure_reloadData)];
    });
}

- (void)sure_reloadData {
    if (!self.hzf_firstReload) {
        [self checkEmpty];
    }
    self.hzf_firstReload = NO;
    [self sure_reloadData];
}
```

这样就可以实现reloadData的同时检测行数从而判断是否显示占位图的功能。

## 实现空视图点击刷新

让`tableView`调用`reloadBlock`，因为数据的刷新大多是不同的，所以具体刷新执行代码还是需要自己手动设置的。若不需要，则无需添加此操作。

```
__weak typeof(self) weakSelf = self;
    [self.tableView setHzf_reloadBlock:^{
        [weakSelf refresh];
    }];
```

如果需要自定制占位视图样式也非常简单，因占位图样式比较统一，所以可直接修改`SurePlaceholderView`占位图类以达到自己想要的效果，再而在`UITableView+HZFPlaceholder.h`、`UICollectionView+HZFPlaceholder.h`类别中都暴漏了`placeholderView`属性，将其赋值为新的视图亦可。

对于无数据与无网络的效果切换，也可以通过网络是否可用的标示来进行展示不同的占位图:

```
if (is_Net_Available) {
   _tableView.placeholderView = [[CustomPlaceholderView alloc]initWithFrame:_tableView.bounds];
 } else {
   _tableView.placeholderView = [[NetNoAvailableView alloc]initWithFrame:_tableView.bounds];
}
```

## 问题

1、首次网络请求未完成占位图显示问题

因tableView、collectionView在创建后系统会默认调用一次reloadData，所以会出现网络请求未完成即展示占位图的问题。类别中新增加属性hzf_firstReload（首次加载）加以限制，若希望在首次网络请求未完成时不显示占位图，可将hzf_firstReload置为YES即可。

```
 _tableView.hzf_firstReload = YES;
```

