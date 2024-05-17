import router from '@ohos.router'
import Prompt from '@system.prompt'
import { myOrderApi } from '../api/Api'
import MyOrderListItemDataModel from '../datamodels/MyOrderListItemDataModel'
import MyOrderListItemDtoDataModel from '../datamodels/MyOrderListItemDtoDataModel'

@Component
export default struct OrderList {
  // 订单状态
  @Prop status: number
  // 分页: 页码
  @State current: number = 1
  // 分页: 每页数量
  @State page: number = 10
  @State data: MyOrderListItemDataModel[] = []
  private statusTitle: string[] = [
    '', '待支付', '待发货', '待收货', '', '已完成', '已取消'
  ]

  // 选中操作的订单编号
  @State selectedOrderNumber: string = ''
  @State @Watch('onShouldLoadData') shouldLoadData: boolean = false

  async onShouldLoadData() {
    if (this.shouldLoadData) {
      await this.requestData()
      this.shouldLoadData = false
    }
  }
  
  cancelOrderDialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmCancel({
      cancel: this.onCancel,
      confirm: this.onCancelOrderAccept,
      orderNumber: this.selectedOrderNumber,
      shouldLoadData: $shouldLoadData
    }),
    alignment: DialogAlignment.Center
  })

  onCancel() {
  }

  async onCancelOrderAccept(orderNumber: string) {
    // 发起网络请求，刷新页面数据
    // 注意： 这里是无法访问到this.selecteedOrderNumber的，英文这个方法是在子组件中执行的，因为参数需要传递进来
    console.log('onCancelOrderAccept:', orderNumber)
    await myOrderApi.cancel(orderNumber)
  }

  async requestData() {
    // 发起网络请求
    const data = await myOrderApi.list(this.status, this.page, this.current)
    this.data = data.records
    console.log('订单数据:', JSON.stringify(this.data))
  }

  async aboutToAppear() {
    this.requestData()
  }

  @Builder
  buildOrderListItem(myOrderListItemDataModel: MyOrderListItemDataModel, index: number) {
    Column({ space: 10 }) {
      Row() {
        Text(`订单编号: ${myOrderListItemDataModel.orderNumber}`)
          .fontColor(14)
        Text(`${this.statusTitle[myOrderListItemDataModel.status]}`)
          .fontSize(14)
          .fontColor(myOrderListItemDataModel.status < 2 ? Color.Red : Color.Black)
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        ForEach(myOrderListItemDataModel.orderItemDtos, (item: MyOrderListItemDtoDataModel, index: number) => {
          Image(item.pic)
            .width(80)
        })
      }
      .width('100%')
      .backgroundColor('#fafafa')

      Row() {
        Text(`共${myOrderListItemDataModel.orderItemDtos.length}件商品  合计:  ¥ ${myOrderListItemDataModel.actualTotal}`)
          .fontSize(14)
      }.width('100%')
      .justifyContent(FlexAlign.End)

      Divider()
        .opacity(0.3)
        .margin({ top: 6, bottom: 6 })
      if (myOrderListItemDataModel.status == 1) {
        Row() {
          Button('取消订单')
            .type(ButtonType.Capsule)
            .backgroundColor(Color.White)
            .fontColor(Color.Black)
            .fontSize(12)
            .border({
              color: Color.Gray,
              width: 1
            })
            .padding({top: 0, bottom: 0, left: 8, right: 8})
            .onClick(() => {
              this.selectedOrderNumber = myOrderListItemDataModel.orderNumber
              console.log('selectedOrderNumber', this.selectedOrderNumber)
              this.cancelOrderDialogController.open()
            })

          Button('付款')
            .type(ButtonType.Capsule)
            .backgroundColor(Color.White)
            .fontColor(Color.Red)
            .fontSize(12)
            .border({
              color: Color.Red,
              width: 1
            })
            .padding({top: 0, bottom: 0, left: 8, right: 8})
            .margin({ left: 5, right: 5 })
            .onClick(async () => {
              Prompt.showToast({
                message: '模拟支付'
              })
              await myOrderApi.pay(myOrderListItemDataModel.orderNumber)
              router.replaceUrl({
                url: 'pages/PaySuccess'
              })
            })
        }.width('100%')
        .justifyContent(FlexAlign.End)
      }

    }.width('100%')
    .padding(10)
  }

  build() {
    Column() {
     Scroll() {
       if (this.data.length > 0) {
         // 选单订单列表
         List() {
           ForEach(this.data, (myOrderListItemDataModel: MyOrderListItemDataModel, index: number) => {
             ListItem() {
               this.buildOrderListItem(myOrderListItemDataModel, index)
             }.width('100%')
           })
         }.width('100%')

       } else {
         Row() {
           Text('还没有任何相关订单')
             .fontSize(16)
             .fontColor(Color.Black)

         }.width('100%')
         .height(100)
         .justifyContent(FlexAlign.Center)
         .alignItems(VerticalAlign.Center)

       }
     }.width('100%')


    }.width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)

  }
}

// 确定取消订单对话框
@CustomDialog
struct ConfirmCancel {
  controller: CustomDialogController
  cancel: () => void
  confirm: (orderNumber: string) => void
  @Prop orderNumber: string
  @Link shouldLoadData: boolean

  build() {
    Column() {
      Text('确定取消订单？').fontSize(20).margin({ top: 10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确定')
          .onClick(() => {
            this.controller.close()
            this.confirm(this.orderNumber)
            this.shouldLoadData = true
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}