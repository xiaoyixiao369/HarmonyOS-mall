import router from '@ohos.router'

@Entry
@Component
struct PaySuccess {

  private greenColor: string = '#19be6b'

  build() {
    Column() {
      Row() {
        Blank()
        Row() {
          Text('支付结果')
            .fontSize(20)
            .fontWeight(600)
        }.layoutWeight(1)
        .justifyContent(FlexAlign.Center)

        Blank()
          .width(20)
      }.width('100%')
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceAround)
      .padding(10)

      Row() {
        Text('支付成功')
          .fontSize(22)
          .fontColor(this.greenColor)
      }
        .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({top: 30})

      Row() {
        Text('感谢您的购买')
          .fontSize(18)
          .fontColor(Color.Gray)
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({top: 10})

      Row({space: 10}) {
        Button('查看订单')
          .type(ButtonType.Normal)
          .backgroundColor(this.greenColor)
          .fontColor(Color.White)
          .fontSize(16)
          .borderRadius(6)
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/Order',
              params: {
                status: 0
              }
            })
          })

        Button('继续购物')
          .type(ButtonType.Normal)
          .backgroundColor(Color.White)
          .fontColor(this.greenColor)
          .border({
            width: 1,
            color: this.greenColor
          })
          .fontSize(16)
          .borderRadius(6)
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/Index'
            })
          })
      }
        .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({top: 20})
    }
    .width('100%')
    .height('100%')
  }
}