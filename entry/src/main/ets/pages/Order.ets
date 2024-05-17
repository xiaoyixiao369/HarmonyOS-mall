import router from '@ohos.router'
import OrderList from '../components/OrderList'
import OrderCountDataModel from '../datamodels/OrderCountDataModel'
import OrderTabViewModel from '../datamodels/OrderTabViewModel'

@Entry
@Component
struct Order {

  private orderTabs: OrderTabViewModel[] = [
    {title: '全部', status: 0},
    {title: '待支付', status: 1},
    {title: '待发货', status: 2},
    {title: '待收货', status: 3},
    {title: '已完成', status: 5}
  ]

  @State selectedIndex: number = 0
  @State status: number = 0

  private tabsController = new TabsController()

  aboutToAppear() {
    const status = router.getParams()["status"]
    if (status >= 0) {
      this.status = status
    }
  }

  onPageShow() {
    // 跳转到对应的标签
    if (this.status != 0) {
      this.selectedIndex = this.status
      this.tabsController.changeIndex(this.selectedIndex)
    }
  }

  @Builder
  buildOrderTab(orderTabViewModel: OrderTabViewModel, index: number) {
    Column() {
      Text(orderTabViewModel.title)
        .fontColor(this.selectedIndex == index ? Color.Red : Color.Black)
        .fontSize(16)

      Divider()
        .color(this.selectedIndex == index ? Color.Red : Color.Gray)
        .opacity(this.selectedIndex == index ? 1 : 0)
        .margin({top: 10})
        .height(3)
        .width('100%')

    }
  }

  build() {

    Column() {
      Row() {
        Image($r('app.media.more'))
          .width(16)
          .margin({ left: 10 })
          .rotate({
            angle: 180
          }).onClick(() => {
          router.back()
        })
        Row() {
          Text('订单')
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

      Tabs({controller: this.tabsController}){
        ForEach(this.orderTabs, (orderTab: OrderTabViewModel, index: number) => {
          TabContent() {
            OrderList({status: orderTab.status as number})
          }.tabBar(this.buildOrderTab(orderTab, index))
          .tabIndex(index)
          .align(Alignment.Top)
        })

      }.barPosition(BarPosition.Start)
      .onChange((index: number) => {
        this.selectedIndex = index
      })

    }.width('100%')

  }
}