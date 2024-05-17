import router from '@ohos.router'
import { myApi } from '../api/Api'
import AppConst from '../configurations/AppConst'
import OrderCountDataModel from '../datamodels/OrderCountDataModel'
import PreferencesUtil from '../utils/PreferencesUtil'

@Preview
@Component
export default struct My {
  @State isLogin: boolean = false
  @State orderCount: OrderCountDataModel = new OrderCountDataModel()

  async aboutToAppear() {
    // 从首选项中获取用户的登录状态
    const loginCode = await PreferencesUtil.getPreference(AppConst.PREFERENCES_LOGIN_CODE)
    console.log("loginCode", loginCode)
    if (loginCode) {
      // 已登录
      this.isLogin = true
      // 获取订单信息
      this.orderCount = await myApi.orders()
      console.log('获取订单信息数据: ', JSON.stringify(this.orderCount))
    }
  }

  @Builder
  buildTag(title: string, content: string) {
    Column() {
      Text(content)
        .fontSize(14)
        .margin({ left: 10, top: 10 })
        .fontColor(Color.Blue)
      Text(title)
        .fontSize(14)
        .margin({ left: 5, top: 5 })
    }.width(100)
  }

  @Builder
  buildListItem(image: Resource, title: string) {
    Row() {
      Row() {
        Image(image)
          .width(30)
        Text(title)
          .fontSize(14)
      }.margin({ left: 20 })

      Image($r('app.media.more'))
        .width(14).margin({ right: 20 })
        .onClick(() => {
          if (title == '收货地址') {
            router.pushUrl({
              url: 'pages/Addr'
            })
          }
        })
    }.width('100%')
    .margin({ top: 5, bottom: 5 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column() {
      Row() {
        Text('个人中心')
          .fontSize(20)
          .fontWeight(500)
          .margin({ left: 10, top: 10 })
      }.justifyContent(FlexAlign.Center)
      .width('100%')
      .backgroundColor(Color.White)

      if (this.isLogin) {
        // 已登录状态
        Column() {
          Image($r('app.media.head04'))
            .width(100)
            .margin({ left: 20 })
          Text('用户昵称')
            .fontSize(14)
            .margin({ left: 10, top: 10 })
        }.width('100%')
        .width('100%')
        .padding({ top: 10, bottom: 20 })
        .backgroundColor(Color.White)
      } else {
        // 未登录状态
        Row() {
          Image($r('app.media.head04'))
            .width(100)
            .margin({ left: 20 })
          Column() {
            Text('未登录')
              .fontSize(14)
              .margin({ left: 10, top: 10 })
            Text('点击登录账号')
              .margin({ left: 10, top: 10 })
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Login'
                })
              })
          }
          .margin({ left: 10 })
          .alignItems(HorizontalAlign.Start)
        }.justifyContent(FlexAlign.Start)
        .width('100%')
        .padding({ top: 10, bottom: 20 })
        .backgroundColor(Color.White)
      }

      Blank()
        .width('100%')
        .height(10)
        .backgroundColor('#fff8f6f6')
      // 我的订单
      Column() {
        Row() {
          Text('我的订单')
            .fontSize(16)
            .fontWeight(500)
            .margin({ left: 20 })

          Row() {
            Text('查看全部')
              .fontSize(14)
              .fontColor(Color.Grey)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Order',
                  params: {
                    status: 0
                  }
                })
              })
            Image($r('app.media.more'))
              .width(14)
          }.margin({ right: 20 })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          OrderItem({
            isLogin: this.isLogin,
            title: '待支付',
            image: $r('app.media.toPay'),
            count: this.orderCount.unPay
          }).onClick(() => {
            router.pushUrl({
              url: 'pages/Order',
              params: {
                status: 1
              }
            })
          })
          OrderItem({
            isLogin: this.isLogin,
            title: '待发货',
            image: $r('app.media.toDelivery'),
            count: this.orderCount.payed
          }).onClick(() => {
            router.pushUrl({
              url: 'pages/Order',
              params: {
                status: 2
              }
            })
          })
          OrderItem({
            isLogin: this.isLogin,
            title: '待收货',
            image: $r('app.media.toTake'),
            count: this.orderCount.consignment
          }).onClick(() => {
            router.pushUrl({
              url: 'pages/Order',
              params: {
                status: 3
              }
            })
          })
          OrderItem({
            isLogin: this.isLogin,
            title: '已完成',
            image: $r('app.media.toComment'),
            count: this.orderCount.success
          }).onClick(() => {
            router.pushUrl({
              url: 'pages/Order',
              params: {
                status: 5
              }
            })
          })

        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)

      }.justifyContent(FlexAlign.Start)
      .width('100%')
      .padding({ top: 20, bottom: 20 })
      .backgroundColor(Color.White)

      Blank()
        .width('100%')
        .height(10)
        .backgroundColor('#fff8f6f6')
      Row() {
        this.buildTag('我的收藏', '--')
        this.buildTag('我的消息', '--')
        this.buildTag('我的足迹', '--')
      }.width('100%')
      .backgroundColor(Color.White)
      .padding({ bottom: 10 })
      .justifyContent(FlexAlign.SpaceAround)

      Blank()
        .width('100%')
        .height(10)
        .backgroundColor('#fff8f6f6')
      // 列表
      List() {
        ListItem() {
          this.buildListItem($r('app.media.promotion'), '分销中心')
        }

        ListItem() {
          this.buildListItem($r('app.media.getCoupon'), '领券中心')
        }

        ListItem() {
          this.buildListItem($r('app.media.myCoupon'), '我的优惠券')
        }

        ListItem() {
          this.buildListItem($r('app.media.myAddr'), '收货地址')
        }
      }.width('100%')
      .backgroundColor(Color.White)
      .divider({
        strokeWidth: 1,
        color: '#fff5f5f5'
      })
      .height(160)

      if (this.isLogin) {
        // 登录的状态显示 退出登录 按钮
        Row() {
          Button('退出登录')
            .type(ButtonType.Normal)
            .width('60%')
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .fontSize(14)
            .borderRadius(5)
            .onClick(async () => {
              // 从首选项中删除登录信息
              await PreferencesUtil.deletePreference(AppConst.PREFERENCES_LOGIN_CODE)
              // 跳回到首页
              router.replaceUrl({
                url: 'pages/Index'
              })
            })
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 10, bottom: 20 })
      }

    }.width('100%')
    .backgroundColor('#f7f7f7')

  }
}

@Component
struct OrderItem {
  @Prop isLogin: boolean
  @Prop title: string
  image: Resource
  @Prop count: number

  build() {
    Stack() {
      Image(this.image)
        .width(40)
        .height(40)
        .margin({ top: 20 })
      if (this.isLogin) {
        Badge({
          count: this.count,
          position: BadgePosition.RightTop,
          style: { badgeSize: 16, badgeColor: '#FA2A2D' }
        }) {
          Text(' ')
        }.width(30)
        .height(30)
        .offset({x: 13})

      }
      Text(this.title)
        .fontSize(14)
        .margin({ top: 70 })

    }.height(90)
  }
}