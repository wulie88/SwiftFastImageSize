# SwiftFastImageSize

> 快速获得图片类型及尺寸大小

只加载图片文件头就可以通过协议确定图片类型及尺寸，用于本地图片（后续加入远程）列表展示，特别适合需要根据图片尺寸动态布局的视图，如`CollectionView`等瀑布流布局/自适应布局。

## 技术优势

1. 无需加载整个文件
2. 支持bmp/jpg/png/apng/gif/webp

## 最佳实践

1. 通过`SwiftFastImageSize`获得全部图片的图片尺寸，用于布局计算；
2. 针对当前要显示的图片使用`ImageIO`库中的`CGImageSource`再次获取图片信息，及每一帧内容用于显示。

## 代码亮点

1. 没有分层设计，代码紧凑
2. 使用`BinUtils`进行字节解包，代码简洁

## 协议

* 遵循 MIT 协议
* 请自由地享受和参与开源

Thanks for https://github.com/scardine/image_size and https://github.com/nst/BinUtils
