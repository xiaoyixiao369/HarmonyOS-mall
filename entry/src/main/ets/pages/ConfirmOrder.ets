import router from '@ohos.router'
import Prompt from '@system.prompt'
import { confirmOrderApi, homeApi } from '../api/Api'
import ConfirmOrderDataModel from '../datamodels/ConfirmOrderDataModel'
import ConfirmOrderReqModel from '../datamodels/ConfirmOrderReqModel'
import ResData from '../datamodels/ResData'
import ShopCartItemDataModel from '../datamodels/ShopCartItemDataModel'
import ShopCartItemDiscount from '../datamodels/ShopCartItemDiscountDataModel'
import ShopCartOrderDataModel from '../datamodels/ShopCartOrderDataModel'
import SubmitOrderDataModel from '../datamodels/SubmitOrderDataModel'
import SubmitOrderItemDataModel from '../datamodels/SubmitOrderItemDataModel'
import UserAddrDataModel from '../datamodels/UserAddrDataModel'

@Entry
@Component
export default struct ConfirmOrder {
  @State basketIds: number[] = []
  @State confirmOrderDataModel: ConfirmOrderDataModel = new ConfirmOrderDataModel()
  @State totalTransfee: number = 0
  @State remark: string = ''
  private selectedAddrId: number = 0
  private selectedAddr: UserAddrDataModel

  async aboutToAppear() {
    this.basketIds = router.getParams()["basketIds"] as number[]
    if (this.basketIds && this.basketIds.length > 0) {
      const confirmOrderReqModel = new ConfirmOrderReqModel()
      confirmOrderReqModel.basketIds = this.basketIds
      confirmOrderReqModel.addrId = 0
      confirmOrderReqModel.couponIds = []
      confirmOrderReqModel.userChangeCoupon = 1
      try {
        this.confirmOrderDataModel = await confirmOrderApi.confirm(confirmOrderReqModel)
        console.log('confirmOrderDataModel:', JSON.stringify(this.confirmOrderDataModel))
        // 计算总运费
        this.confirmOrderDataModel.shopCartOrders.forEach(shopCartOrder => {
          this.totalTransfee += shopCartOrder.transfee
        })
      } catch (e) {
        console.log("confirmOrderDataModel err:", JSON.stringify(e))
      }
    } else {
      Prompt.showToast({
        message: '没有获取到购物车商品'
      })
    }
  }

  onPageShow() {
    this.selectedAddrId = router.getParams()['selectedAddrId']
    this.selectedAddr = router.getParams()['selectedAddr']
    this.confirmOrderDataModel.userAddr = this.selectedAddr
  }

  @Builder
  buildItemHeader(title: string) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontWeight(500)
        .margin({ left: 10 })
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.White)
  }

  build() {

    Stack({ alignContent: Alignment.Bottom }) {
      Scroll() {
        Column() {
          // 导航栏
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
              Text('提交订单')
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

          // 地址栏
          Row() {
            Row() {
              Column() {
                Row() {
                  Image($r('app.media.addr'))
                    .width(12)
                  Text(this.confirmOrderDataModel?.userAddr?.receiver)
                    .margin({ left: 10 })
                  Text(this.confirmOrderDataModel?.userAddr?.mobile)
                    .margin({ left: 10 })
                }
                // 详细地址
                Text(`${this.confirmOrderDataModel?.userAddr?.province + this.confirmOrderDataModel?.userAddr?.city + this.confirmOrderDataModel?.userAddr?.area + this.confirmOrderDataModel?.userAddr?.addr}`)
                  .fontSize(16)
                  .fontColor(Color.Grey)
                  .margin({ top: 10, left: 10 })
              }
            }
            .layoutWeight(1)

            Row() {
              Image($r('app.media.more'))
                .width(12)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/Addr'
                  })
                })
            }.width(30)

          }
          .width('100%')
          .backgroundColor(Color.White)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ top: 10, left: 10, bottom: 10 })

          // 商品列表
          List() {
            ForEach(this.confirmOrderDataModel?.shopCartOrders, (shopCartOrder: ShopCartOrderDataModel) => {
              ListItemGroup({ header: this.buildItemHeader(shopCartOrder.shopName), space: 10 })

              ForEach(shopCartOrder?.shopCartItemDiscounts, (shopCartItemDiscount: ShopCartItemDiscount) => {
                ForEach(shopCartItemDiscount?.shopCartItems, (shopCartItem: ShopCartItemDataModel) => {
                  ListItem() {
                    Row() {
                      Image(shopCartItem.pic)
                        .width(80)
                      Column() {
                        Row() {
                          // 商品标题
                          Text(shopCartItem.prodName)
                            .fontSize(14)
                            .maxLines(2)
                            .textOverflow({
                              overflow: TextOverflow.Ellipsis
                            })
                        }.width('100%')

                        // 商品SKU
                        Row() {
                          Text(shopCartItem.skuName)
                            .fontSize(12)
                            .fontColor('#c3c3c3')
                        }.width('100%')
                        .margin({ top: 4 })

                        // 商品价格和数量
                        Row() {
                          Text(`￥ ${shopCartItem.price}`)
                            .fontSize(12)
                          Text(`✕ ${shopCartItem.prodCount}`)
                            .fontColor('#c3c3c3')
                            .fontSize(12)
                        }.justifyContent(FlexAlign.SpaceBetween)
                        .width('100%')
                        .margin({ top: 4 })

                      }.layoutWeight(1)
                    }
                    .width('100%')
                  }.width('92%')
                  .padding(10)
                })
              })
            })
          }.width('100%')
          .backgroundColor(Color.White)
          .divider({
            strokeWidth: 1,
            startMargin: 10,
            color: '#c3c3c3'
          })

          Divider()
            .strokeWidth(1)
            .color('#c3c3c3')
            .width('100%')
            .padding(4)
            .opacity(0.7)
            .backgroundColor(Color.White)

          // 商品总计
          Row() {
            Text(`共${this.confirmOrderDataModel?.totalCount}件商品  合计: ￥ ${this.confirmOrderDataModel?.total}`)
              .margin({ right: 10 })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .justifyContent(FlexAlign.End)
          .padding(10)

          // 优惠券
          Row() {
            Text(`优惠券: 暂无可用`)
              .margin({ left: 10 })
            Row() {
              Text('0张')
                .fontSize(12)
                .fontColor(Color.Grey)
              Image($r('app.media.more'))
                .width(12)
                .margin({ left: 10, right: 10 })
            }
          }
          .padding({ top: 10, bottom: 10 })
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor(Color.White)
          .margin({ top: 4 })

          Divider()
            .strokeWidth(1)
            .color('#c3c3c3')
            .margin({ left: 10, right: 10 })
            .width('100%')
            .padding(4)
            .opacity(0.7)
            .backgroundColor(Color.White)

          // 买家留言
          // 优惠券
          Row() {
            Text(`买家留言: `)
              .fontSize(14)
              .margin({ left: 10 })
            TextInput({ text: this.remark, placeholder: '给卖家留言' })
              .fontSize(14)
              .fontColor(Color.Grey)
          }.width('100%')
          .padding({ top: 10, bottom: 10 })
          .backgroundColor(Color.White)

          // 订单总金额
          Column() {
            Row() {
              Text('订单总额:')
                .margin({ left: 10 })
              Text(`￥ ${this.confirmOrderDataModel?.total}`)
                .margin({ right: 10 })
            }.width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Row() {
              Text('运费:')
                .margin({ left: 10 })
              Text(`￥ ${this.totalTransfee}`)
                .margin({ right: 10 })
            }.width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 10 })

            Row() {
              Text('优惠金额:')
                .margin({ left: 10 })
              Text(`￥ ${this.confirmOrderDataModel?.orderReduce}`)
                .margin({ right: 10 })
            }.width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 10 })

            Divider()
              .strokeWidth(1)
              .color('#c3c3c3')
              .opacity(0.7)
              .margin({ left: 10, right: 10 })
              .width('100%')
              .padding(4)

            // 小计
            Row() {
              Text(`小计: ￥ ${this.confirmOrderDataModel?.actualTotal}`)
                .margin({ right: 10 })
                .fontColor(Color.Red)
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
            .padding(10)

          }.width('100%')
          .backgroundColor(Color.White)
          .padding({ top: 8 })
          .margin({ top: 12 })

        }
        .width('100%')
        .height('100%')
        .backgroundColor('#f4f4f4')
      }.width('100%')
      .height('100%')

      // 底部悬浮菜单栏
      Row() {
        Row() {
          Text('合计:')
            .fontSize(14)
          Text(`￥ ${this.confirmOrderDataModel?.total}`)
            .fontSize(14)
            .fontColor(Color.Red)
        }
        .margin({ left: 10 })

        Button('提交订单')
          .type(ButtonType.Normal)
          .width(120)
          .height('100%')
          .borderRadius(3)
          .backgroundColor(Color.Red)
          .onClick(async () => {
            const reqData: SubmitOrderDataModel = new SubmitOrderDataModel()
            reqData.orderShopParam = []
            this.confirmOrderDataModel.shopCartOrders.forEach((shopCartOrder: ShopCartOrderDataModel) => {
              const reqDataItem: SubmitOrderItemDataModel = new SubmitOrderItemDataModel()
              reqDataItem.remarks = this.remark
              reqDataItem.shopId = shopCartOrder.shopId

              reqData.orderShopParam.push(reqDataItem)
            })

            // 发起网络请求
            const resData = await confirmOrderApi.submit(reqData)
            console.log('resData, ', JSON.stringify(resData))
            if (!resData.success) {
              Prompt.showToast({
                message: resData.msg
              })
            }
            router.pushUrl({
              url: 'pages/Index'
            })
          })

      }
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.SpaceBetween)

    }.width('100%')

  }
}