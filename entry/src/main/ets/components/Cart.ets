import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import { cartApi } from '../api/Api'
import CartDataModel from '../datamodels/CartDataModel'
import ShopCartItemDataModel from '../datamodels/ShopCartItemDataModel'
import ShopCartItemDiscount from '../datamodels/ShopCartItemDiscountDataModel'
import TotalPayDataModel from '../datamodels/TotalPayDataModel'
import NumberInput from './NumberInput'

@Entry
@Component
export default struct Cart {
  @State cartDataModel: CartDataModel[] = []
  @State checkboxGroupName: string = 'group'
  @State @Watch('onCheckedBasketIdsChanged') checkedBasketIds: number[] = []
  @State totalPayDataModel: TotalPayDataModel = new TotalPayDataModel()

  async onCheckedBasketIdsChanged() {
    // 请求购物车内所有商品的总费用
    this.totalPayDataModel = await cartApi.totalPay(this.checkedBasketIds)
  }

  async aboutToAppear() {
    this.cartDataModel = await cartApi.list()
  }

  @Builder
  buildItemHeader(title: string) {
    Row() {
      Text(title)
        .fontSize(14)
        .fontWeight(600)
    }.width('100%')
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 购物车商品列表
      Column() {
        Row() {
          Text('购物车')
            .fontSize(20)
            .fontWeight(600)
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({
          top: 10,
          bottom: 10
        })
        .backgroundColor(Color.White)

        // 购物车列表数据
        Scroll() {
          List() {
            ForEach(this.cartDataModel, (cartDataModel) => {
              ListItemGroup({ header: this.buildItemHeader(cartDataModel.shopName) })
                .padding({ bottom: 15 })
                .backgroundColor(Color.White)

              ForEach(cartDataModel.shopCartItemDiscounts, (shopCartItemDiscount: ShopCartItemDiscount) => {
                ForEach(shopCartItemDiscount.shopCartItems, (shopCartItem: ShopCartItemDataModel, index: number) => {
                  ListItem() {
                    CartItem({
                      checkboxGroupName: this.checkboxGroupName,
                      shopCartItemDataModel: shopCartItem,
                      checkedBasketIds: $checkedBasketIds
                    })
                  }
                  .padding({ bottom: 20 })
                  .backgroundColor(Color.White)
                })
              })

            })
          }.width('92%')
          .divider({
            strokeWidth: 1,
            color: '#ffdddcdc',
            startMargin: 40
          })
        }.width('100%')
        .backgroundColor(Color.White)

      }.width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)

      // 操作栏
      Row({ space: 10 }) {
        Row() {
          CheckboxGroup({ group: this.checkboxGroupName })
            .width(20)
            .margin({ left: 20 })
          Text('全选')
            .fontSize(12)
            .margin({ left: 5 })
        }.width(80)

        Text('删除')
          .fontSize(12)
          .fontColor(Color.Red)
          .onClick(() => {
            if (this.checkedBasketIds.length > 0) {
              promptAction.showDialog({
                title: '确认',
                message: '确认要删除选中的商品吗',
                buttons: [
                  {
                    text: '取消',
                    color: '#666666',
                  },
                  {
                    text: '确定',
                    color: '#ffef3131',
                  },
                ]
              }, async (err, data) => {
                if (err) {
                  return
                }

                await cartApi.deleteCartProds(this.checkedBasketIds)
                // 清空保存的数组
                this.checkedBasketIds = []
                // 刷新
                this.aboutToAppear()

              })

            } else {
              promptAction.showToast({
                message: "请先选择商品"
              })
            }
          })
        Column() {
          Text('合计：')
            .fontSize(14)
          Text(`￥ ${this.totalPayDataModel?.totalMoney || 0}`)
            .fontColor(Color.Red)
        }
        .layoutWeight(1)

        Button('结算')
          .type(ButtonType.Normal)
          .backgroundColor(Color.Red)
          .borderRadius(0)
          .fontColor(Color.White)
          .fontSize(14)
          .width(100)
          .height(50)
          .onClick(() => {
            if (this.checkedBasketIds.length > 0) {
              router.pushUrl({
                url: "pages/ConfirmOrder",
                params: {
                  "basketIds": this.checkedBasketIds
                }
              })

            } else {
              promptAction.showToast({
                message: "请先选择商品"
              })
            }
          })

      }.height(50)
      .backgroundColor(Color.White)
      .zIndex(2)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4f4f4')
  }
}

@Component
struct CartItem {
  @Prop checkboxGroupName: string
  shopCartItemDataModel: ShopCartItemDataModel
  @State prodCount: number = 0
  @Link checkedBasketIds: number[]

  aboutToAppear() {
    this.prodCount = this.shopCartItemDataModel?.prodCount
  }

  build() {
    Row() {
      Checkbox({ group: this.checkboxGroupName, name: this.shopCartItemDataModel.basketId + '' })
        .width(20)
        .onChange((value: boolean) => {
          if (value) {
            this.checkedBasketIds.push(this.shopCartItemDataModel.basketId)
          } else {
            const removeIndex = this.checkedBasketIds.indexOf(this.shopCartItemDataModel.basketId)
            if (removeIndex != -1) {
              this.checkedBasketIds.splice(removeIndex, 1)
            }
          }
        })


      Image(this.shopCartItemDataModel.pic)
        .width(80)
        .margin({ left: 10 })
      Column() {
        Row() {
          Text(this.shopCartItemDataModel.prodName)
            .fontSize(14)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
            .maxLines(2)
        }
        .width('100%')

        Row() {
          Text(this.shopCartItemDataModel.skuName)
            .fontSize(12)
            .fontColor('#999999')
            .backgroundColor('#f9f9f9')
            .borderRadius(5)
        }.width('100%')

        Row() {
          Text(`￥ ${this.shopCartItemDataModel.price}`)
            .fontSize(12)
            .fontColor(Color.Red)
          NumberInput({ value: $prodCount, min: 1, max: 9999 })
        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }.layoutWeight(1)
      .margin({ left: 15 })
    }.width('100%')
    .margin({ top: 10 })
  }
}