// 商品详详情页
import router from '@ohos.router'
import Prompt from '@system.prompt'
import { cartApi, productApi } from '../api/Api'
import NumberInput from '../components/NumberInput'
import AddCartReqModel from '../datamodels/AddCartReqModel'
import ProductDataModel from '../datamodels/ProductDataModel'
import SkuDataModel from '../datamodels/SkuDataModel'

@Entry
@Component
struct ProductDetail {
  @State prodId: number = 0
  @State imgs: string[] = []
  @State title: string = ''
  @State bref: string = ''
  @State price: number = 0
  @State content: string = ''
  @State curVersionIndex: number = 0
  @State curColorIndex: number = 0
  @State curMemIndex: number = 0
  @State versions: string[] = []
  @State colors: string[] = []
  @State mems: string[] = []
  @State dialogHeight: number = 300
  @State selectedSku: SkuDataModel = new SkuDataModel()
  @State selectedCount: number = 1
  private productDataModel: ProductDataModel = new ProductDataModel()

  @State isEmptyProperties: Boolean = true

  skuDialogController: CustomDialogController = new CustomDialogController({
    builder: SkuDialog({
      productDataModel: this.productDataModel,
      skuList: this.productDataModel.skuList,
      selectedSku: $selectedSku,
      versions: this.versions,
      colors: this.colors,
      mems: this.mems,
      selectedCount: $selectedCount
    }),
    alignment: DialogAlignment.Bottom
  })

  async aboutToAppear() {
    // 从页面跳转的路由获取商品ID
    this.prodId = router.getParams()["prodId"] as number
    if (!this.prodId) {
      this.prodId = 18
    }
    // 请求商品详情信息
    this.productDataModel = await productApi.getProductData(this.prodId)
    this.title = this.productDataModel.prodName
    this.bref = this.productDataModel.brief
    this.imgs = this.productDataModel.imgs.split(",")
    this.price = this.productDataModel.price
    this.content = this.productDataModel.content

    // SKU处理，版本，颜色，内存
    // 遍历所有的sku的properties切分
    for (const sku of this.productDataModel.skuList) {
      if (sku.properties == "") {
        this.isEmptyProperties = true
        break;
      }
      // 版本:公开版;颜色:深空灰色;内存:256GB
      const split = sku.properties.split(";")
      for (const pair of split) {
        const property = pair.split(":")
        if ("版本" == property[0]) {
          this.versions.push(property[1])
        }
        if ("颜色" == property[0]) {
          this.colors.push(property[1])
        }
        if ("内存" == property[0]) {
          this.mems.push(property[1])
        }
      }
    }

    this.versions = this.versions.filter((value, index, self) =>
    self.indexOf(value) === index
    );
    this.colors = this.colors.filter((value, index, self) =>
    self.indexOf(value) === index
    );
    this.mems = this.mems.filter((value, index, self) =>
    self.indexOf(value) === index
    );

  }

  @Builder
  buildTag(label: string, num: number) {
    Text(label + '（' + num + ')')
      .fontSize(12)
      .fontColor(Color.Grey)
      .backgroundColor('#fdf0f0')
      .padding({ left: 10, right: 10, top: 3, bottom: 3 })
      .margin({ left: 6, right: 6 })
      .borderRadius(5)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Scroll() {
        Column() {
          // 导航栏
          Row() {
            Image($r('app.media.more'))
              .width(18)
              .rotate({
                angle: 180
              })
              .margin({ left: 10 })
            .onClick(() => {
              router.back()
            })
            Row() {
              Text('商品详情')
                .fontSize(16)
                .fontWeight(800)
                .margin({ left: 10 })
            }.layoutWeight(1)
            .justifyContent(FlexAlign.Center)

            Blank()
              .width(20)

          }.width('100%')
          .height(50)

          // 商品图片swiper
          Row() {
            Swiper() {
              ForEach(this.imgs, (img: string) => {
                Image(img.trim())
                  .width('92%')

              })
            }.width('96%')
          }.width('100%')
          .justifyContent(FlexAlign.Center)
          .width('100%')

          Divider()

          // 标题栏，收藏
          Row() {
            Text(this.title)
              .fontSize(16)
              .maxLines(2)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .layoutWeight(1)

            Row() {
              Blank()
                .width(1)
                .backgroundColor(Color.Grey)

              Column() {
                Image($r('app.media.prod_col'))
                  .width(16)

                Text('收藏')
                  .fontColor(Color.Grey)
              }.margin({ left: 10 })
            }
          }.width('96%')
          .margin({ top: 10 })
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Text(this.bref)
              .fontSize(12)
              .fontColor(Color.Grey)
          }.width('96%')
          .margin({ top: 5 })

          // 价格行
          Row() {
            Text(`￥ ${this.price}`)
              .fontSize(16)
              .fontColor(Color.Red)
          }.width("96%")
          .margin({ top: 6 })
          .padding({ bottom: 10 })

          Blank()
            .width('100%')
            .height(10)
            .backgroundColor('#f4f4f4')

          // 选择SKU行
          Row() {
            Row() {
              Text('已选   ')
                .fontSize(12)
                .fontColor(Color.Grey)

              Text(`1件`)
                .fontSize(14)
                .fontWeight(600)
            }.layoutWeight(1)

            Text('···')
              .fontSize(12)
              .fontColor(Color.Grey)
              .width(20)
              .onClick(() => {
                // 显示sku选择弹窗
                this.skuDialogController.open()

              })
          }.width('96%')
          .height(30)

          Blank()
            .width('100%')
            .height(10)
            .backgroundColor('#f4f4f4')

          // 评价
          Row() {
            Row() {
              Text('评价')
                .fontSize(16)
              Text(`好评0%`)
                .fontSize(14)
                .fontColor(Color.Red)
            }

            Row() {
              Text(`共0条`)
                .fontColor(Color.Grey)
              Image($r('app.media.more'))
                .width(16)
            }

          }.width('96%')
          .height(40)
          .justifyContent(FlexAlign.SpaceBetween)

          Divider()

          // 标签
          Row() {
            // 全部
            this.buildTag('全部', 0)
            // 好评
            this.buildTag('好评', 0)
            // 差评
            this.buildTag('差评', 0)
            // 有图
            this.buildTag('有图', 0)

          }.width('100%')
          .height(40)

          Blank()
            .width('100%')
            .height(10)
            .backgroundColor('#f4f4f4')

          // 详情
          RichText(this.content)
            .height(2000)
            .padding(0)
            .width('130%')

        }.width('100%')
      }
      .height('100%')

      // 悬浮菜单
      Row() {
        Row() {
          Column() {
            Image($r('app.media.homepage'))
              .width(24)
            Text('首页')
              .fontSize(14)
          }
          .width('20%')
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/Index',
              params: {
                selectedIndex: 0
              }
            })
          })

          Blank()
            .width(1)
            .height('100%')
            .backgroundColor('#c3c3c3')

          Column() {
            Image($r('app.media.basket'))
              .width(24)
            Text('购物车')
              .fontSize(14)
          }
          .width('20%')
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/Index',
              params: {
                selectedIndex: 2
              }
            })
          })

          Row() {
            Text('加入购物车')
              .fontColor(Color.White)
              .onClick(() => {
                this.skuDialogController.open()
              })
          }
          .backgroundColor('#584e61')
          .width('30%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)

          Row() {
            Text('立即购买')
              .fontColor(Color.White)
          }
          .backgroundColor(Color.Red)
          .width('30%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
        }
      }.width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .zIndex(2)

    }
  }
}

@CustomDialog
struct SkuDialog {
  controller: CustomDialogController
  productDataModel: ProductDataModel
  skuList: SkuDataModel[]
  versions: string[]
  colors: string[]
  mems: string[]
  @Link selectedCount: number
  @State @Watch('onSkuChanged') curVersionIndex: number = 0
  @State @Watch('onSkuChanged') curColorIndex: number = 0
  @State @Watch('onSkuChanged') curMemIndex: number = 0
  @Link selectedSku: SkuDataModel

  @State isEmptyProperties: Boolean = true

  onSkuChanged() {
    // 获取版本，颜色，内存的具体值并组装，反向查询是哪一个商品
    const version = this.versions[this.curVersionIndex]
    const color = this.colors[this.curColorIndex]
    const mem = this.mems[this.curMemIndex]
    const propertiesStr = `版本:${version};颜色:${color};内存:${mem}`

    const skuDataModels: SkuDataModel[] = this.skuList.filter(it => it.properties == propertiesStr)
    if (skuDataModels.length > 0) {
      this.selectedSku = skuDataModels[0]
    }

  }

  aboutToAppear() {
    // 让UI产生变化
    this.onSkuChanged()
  }

  build() {
    // sku选择
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 图片行
        Row() {
          Row() {
            Image(this.selectedSku.pic)
              .width(80)
            Column() {
              Text(`￥ ${this.selectedSku.price}`)
              .fontColor(Color.Red)
              .fontSize(12)
              Row() {
                Text('已选 ')
                  .fontSize(12)
                  .fontColor(Color.Grey)
                Text(`${this.selectedCount} 件`)
                  .fontSize(12)
              }
            }
          }

          Text(" × ")
            .fontSize(25)
            .margin({ right: 12 })
            .fontColor(Color.Grey)
            .offset({y: -20})
            .onClick(() => {
              this.controller.close()
            })
        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        // 版本
        Column() {
          Row() {
            Text('版本')
              .fontColor(Color.Grey)
              .fontSize(12)
          }.width('100%')

          Row() {
            ForEach(Array.from(this.versions), (version: string, index: number) => {
              Button(version)
                .type(ButtonType.Normal)
                .fontColor(Color.White)
                .padding({ left: 4, right: 4 })
                .fontSize(12)
                .borderRadius(3)
                .margin({ right: 10 })
                .backgroundColor(this.curVersionIndex == index ? Color.Red : '#c3c3c3')
                .onClick(() => {
                  this.curVersionIndex = index
                })
            })
          }.width('100%')
          .margin({ top: 10 })
        }.width('100%')
        .margin({top: 10})

        // 颜色
        Column() {
          Row() {
            Text('颜色')
              .fontColor(Color.Grey)
              .fontSize(12)
          }.width('100%')
          .margin({ top: 10 })

          Row() {
            ForEach(Array.from(this.colors), (color: string, index: number) => {
              Button(color)
                .type(ButtonType.Normal)
                .fontColor(Color.White)
                .padding({ left: 4, right: 4 })
                .fontSize(12)
                .borderRadius(3)
                .margin({ right: 10 })
                .backgroundColor(this.curColorIndex == index ? Color.Red : '#c3c3c3')
                .onClick(() => {
                  this.curColorIndex = index
                })
            })
          }.width('100%')
          .margin({ top: 10 })
        }.width('100%')

        // 内存
        Column() {
          Row() {
            Text('内存')
              .fontColor(Color.Grey)
              .fontSize(12)
          }.width('100%')
          .margin({ top: 10 })

          Row() {
            ForEach(Array.from(this.mems), (mem: string, index: number) => {
              Button(mem)
                .type(ButtonType.Normal)
                .fontColor(Color.White)
                .padding({ left: 4, right: 4 })
                .fontSize(12)
                .borderRadius(3)
                .margin({ right: 10 })
                .backgroundColor(this.curMemIndex == index ? Color.Red : '#c3c3c3')
                .onClick(() => {
                  this.curMemIndex = index
                })
            })
          }.width('100%')
          .margin({ top: 10 })
        }.width('100%')

        // 数量
        Row() {
          Text('数量')
            .fontColor(Color.Grey)

          NumberInput({ value: $selectedCount, min: 1, max: 100 })

        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 10 })

      }.width('100%')
      .padding({ bottom: 60, left: 10 })

      // 固定底部的按钮
      Row() {
        Button('加入购物车')
          .type(ButtonType.Normal)
          .width('50%')
          .backgroundColor('#584e61')
          .onClick(() => {
            const addCartReqModel = new AddCartReqModel(0, this.selectedCount, this.productDataModel.prodId, this.productDataModel.shopId, this.selectedSku.skuId)
            cartApi.add(addCartReqModel)
            this.controller.close()
            Prompt.showToast({
              message: '加入购物车成功'
            })
          })
        Button('立即购买')
          .type(ButtonType.Normal)
          .layoutWeight(1)
          .backgroundColor('#eb2444')
      }.width('100%')
    }.width('100%')
    .backgroundColor(Color.White)
    .zIndex(3)
  }
}
