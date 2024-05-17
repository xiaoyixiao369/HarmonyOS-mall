import router from '@ohos.router'
import { homeApi } from '../api/Api'
import NoticeDataModel from '../datamodels/NoticeDataModel'
import ProductDataModel from '../datamodels/ProductDataModel'
import SwiperDataModel from '../datamodels/SwiperDataModel'
import Brand from '../viewmodels/Brand'
import ProductListItem from './ProductListItem'

@Preview
@Component
export default struct Home {
  @State swiperDataModels: SwiperDataModel[] = []
  @State noticeDataModels: NoticeDataModel[] = []
  @State lastedProductData: ProductDataModel[] = []
  @State moreProductData: ProductDataModel[] = []
  private brands: Brand[] = [
    new Brand($r('app.media.newProd'), '新品推荐'),
    new Brand($r('app.media.timePrice'), '新品推荐'),
    new Brand($r('app.media.neweveryday'), '每日疯抢'),
    new Brand($r('app.media.newprods'), '领券优惠'),
  ]

  @Builder
  buildBrand(brand: Brand) {
    Column() {
      Image(brand.image)
        .width(30)
      Text(brand.title)
        .fontSize(13)
        .margin({ top: 6 })

    }
  }

  @Builder
  buildLastedProductItem(productDataModel: ProductDataModel) {
    Column() {
      Image(productDataModel.pic)
        .width(100)
        .height(140)
        .objectFit(ImageFit.Fill)
        .borderRadius(5)
      Text(productDataModel.prodName)
        .fontSize(12)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .height(24)
        .width(120)
        .padding({
          right: 4
        })
        .margin({top: 4})
      Text(`￥ ${productDataModel.price}`)
        .fontSize(12)
        .fontWeight(500)
        .height(20)
        .width(120)
    }.width('100%')
    .height(220)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      // 跳转商品详情页
      router.pushUrl({
        url: 'pages/ProductDetail',
        params: {
          prodId: productDataModel.prodId
        }
      })
    })
  }

  async aboutToAppear() {
    const swiperData = await homeApi.getSwiperData();
    console.log("swiperData: ", swiperData)
    for (let item of swiperData) {
      if (!item.imgUrl.endsWith('.dpg')) {
        this.swiperDataModels.push(item)
      }
    }

    this.noticeDataModels = await homeApi.getNoticeData()
    console.log('aaa0' + JSON.stringify(this.noticeDataModels))

    this.lastedProductData = (await homeApi.getLastedProductData())['records']
    console.log("aaa1", JSON.stringify(this.lastedProductData))

    this.moreProductData = (await homeApi.getMoreProductData())['records']
    console.log('aaa2' + JSON.stringify(this.moreProductData))
  }

  build() {
    Scroll() {
      Column() {
        // 搜索
        Row() {
          Row() {
            Image($r('app.media.search'))
              .width(20)
            Text('搜索').margin({ left: 5 })
              .fontColor(Color.Grey)
          }.width('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/SearchProduct'
            })
          })
        }
        .backgroundColor('#f7f7f7')
        .width('96%')
        .height(40)
        .margin({ top: 5 })

        // 轮播
        Row() {
          Swiper() {
            ForEach(this.swiperDataModels, (swiperDataModel: SwiperDataModel) => {
              Image(swiperDataModel.imgUrl)
                .width('100%')
            })
          }
          .margin({ top: 5 })
          .autoPlay(true)
        }.width('100%')


        // 品牌推荐
        Row() {
          ForEach(this.brands, (brand: Brand) => {
            this.buildBrand(brand)
          })
        }.width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: 6 })


        // 公告
        Row() {
          Image($r('app.media.horn'))
            .width(30)
          Swiper() {
            ForEach(this.noticeDataModels, (noticeDataModel: NoticeDataModel) => {
              Row() {
                Text(noticeDataModel.title)
                  .fontSize(14)
                  .fontWeight(600)
                  .fontColor(Color.Black)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ right: 10 })
                  .layoutWeight(1)

                Image($r('app.media.more'))
                  .width(16)
              }
            })

          }
          .vertical(true)
          .autoPlay(true)
          .indicator(false)
          .height(30)
          .itemSpace(0)
          .layoutWeight(1)
          .margin(6)

        }.width('100%')
        .padding({ left: 10, right: 10 })


        // 每日上新
        Row() {
          Text('每日上新')
            .fontSize(14)
            .fontColor(Color.White)
            .margin({ left: 10, top: 20 })
          Button('查看更多')
            .fontSize(12)
            .fontColor(Color.White)
            .margin({ right: 10, top: 20 })
            .backgroundColor('#65addf')
            .height(24)
        }
        .width('100%')
        .height(120)
        .backgroundColor('#3e99d7')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Top)

        // 每日上新商品列表
        Column() {
          Grid() {
            ForEach(this.lastedProductData, (productDatModel: ProductDataModel) => {
              GridItem() {
                this.buildLastedProductItem(productDatModel)
              }
            })
          }
          .rowsTemplate('1fr 1fr 1fr')
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(0)
          .rowsGap(100)
          .width('94%')
          // .height(520)
          .offset({ y: -60 })
        }.width('100%')
        .height(520)


        // 更多宝贝
        Column() {
          Text('更多宝贝')
            .fontSize(14)
            .margin({ left: 10, top: 20, bottom: 10 })
          Divider()
          ForEach(this.moreProductData, (productDataModel: ProductDataModel) => {
            ProductListItem({productDataModel: productDataModel})
          })

        }.width('94%')
        .offset({ y: -150 })
        .alignItems(HorizontalAlign.Start)

      }
      .width('100%')
    }
    .width('100%').height('100%').align(Alignment.TopStart)
  }
}