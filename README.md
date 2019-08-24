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

```
