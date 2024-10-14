# SwiftFastImageSize

[Github地址](https://github.com/wulie88/SwiftFastImageSize)

To swiftly determine image type and dimensions, a method that parses only the header of the image file can be utilized, allowing identification of the image format and size without loading the entire file. This technique is initially designed for local images (with future support for remote images) and is particularly beneficial for scenarios requiring dynamic layout adjustments based on image dimensions, such as the display of images in CollectionView with waterfall or adaptive layouts.

Technical Advantages:

Only the file header needs to be loaded, making it efficient even with large files.
Supports formats including BMP, JPG, PNG, APNG, GIF, and WebP.

> 快速获得图片类型及尺寸大小

只加载图片文件头就可以通过协议确定图片类型及尺寸，用于本地图片（后续加入远程）列表展示，特别适合需要根据图片尺寸动态布局的视图，如`CollectionView`等瀑布流布局/自适应布局。

## 技术优势

1. 只需要加载文件头部，无惧大文件
2. 支持bmp/jpg/png/apng/gif/webp


## 示例代码

完整示例代码在`Tests`中

```Swift
let sizer = SwiftFastImageSize(path)
do {
    try sizer.parse()
    XCTAssertEqual(sizer.imageType, type)
    XCTAssertEqual(sizer.imageSize, size)
} catch let error {
    print("error", error)
}
```


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
