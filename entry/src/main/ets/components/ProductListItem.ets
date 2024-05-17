
import router from '@ohos.router'
import ProductDataModel from '../datamodels/ProductDataModel'
@Component
export default struct ProductListItem {
  productDataModel: ProductDataModel
  build() {
    Row() {
      Image(this.productDataModel.pic)
        .width(80)
        .height(100)
        .objectFit(ImageFit.Fill)
        .borderRadius(5)

      Column() {
        Text(this.productDataModel.prodName)
          .fontWeight(500)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
        Text(this.productDataModel.brief)
          .fontSize(10)
          .fontColor(Color.Grey)
        Text(`￥ ${this.productDataModel.price}`)
        Row() {
          Image($r('app.media.basket_sel'))
            .width(16)
            .margin({ right: 10 })
        }.width('100%')
        .justifyContent(FlexAlign.End)

      }
      .layoutWeight(1)
      .height(80)
      .margin({ left: 6 })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)

    }.width('100%')
    .padding(10)
    .justifyContent(FlexAlign.Center)
    .height(120)
    .onClick(() => {
      router.pushUrl({
        url: 'pages/ProductDetail',
        params: {
          prodId: this.productDataModel.prodId
        }
      })
    })
  }
}