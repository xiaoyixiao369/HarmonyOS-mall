// 商品列表组件
import router from '@ohos.router'
import { categoryApi, productApi } from '../api/Api'
import CategoryDataModel from '../datamodels/CategoryDataModel'
import ProductDataModel from '../datamodels/ProductDataModel'

@Entry
@Component
struct ProductList {
  parentCategoryDataModel: CategoryDataModel
  @State categories: CategoryDataModel[] = []
  @State selectedIndex: number = 0

  async aboutToAppear() {
    this.parentCategoryDataModel = router.getParams()["category"] as CategoryDataModel
    // 这样在第一次进入页面后tabbar可以切换到正确的索引,但是tabcontent不会切换,只能手工切换
    this.selectedIndex = router.getParams()["index"] as number
    this.categories = await categoryApi.categories(this.parentCategoryDataModel.categoryId)
  }

  @Builder
  buildTabbar(categoryDataModel: CategoryDataModel, index: number) {
    Column() {
      Text(categoryDataModel.categoryName)
        .fontColor(this.selectedIndex == index ? Color.Red : Color.Black)
      Divider()
        .width('100%')
        .height(this.selectedIndex == index ? 4 : 0)
        .backgroundColor(this.selectedIndex == index ? Color.Red : '#f5f6f7')
        .margin({ top: 6 })
    }
    .height(50)
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.more'))
          .width(16)
          .rotate({
            angle: 180
          })

        Text('返回')
          .margin({ left: 5 })
          .fontSize(14)
      }
      .width('100%')
      .margin({ top: 10, left: 10 })
      .backgroundColor(Color.White)
      .onClick(() => {
        router.back()
      })

      Tabs() {
        ForEach(this.categories, (category: CategoryDataModel, index: number) => {
          TabContent() {
            ProductCell({ categoryId: category.categoryId })
              .backgroundColor('#f5f6f7')
          }
          .tabBar(this.buildTabbar(category, index))
        })

      }
      .scrollable(true)
      .onChange((index: number) => {
        this.selectedIndex = index
      })
      .backgroundColor(Color.White)

    }.width('100%')
  }
}

@Component
struct ProductCell {
  categoryId: number
  @State products: ProductDataModel[] = []

  async aboutToAppear() {
    this.products = (await productApi.getCategoryProductData(this.categoryId))['records']
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.products, (product: ProductDataModel) => {
          GridItem() {
            Column() {
              Image(product.pic)
                .width(150)
              Text(product.prodName)
                .fontSize(14)
                .maxLines(1)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
              Text(product.brief)
                .fontSize(12)
                .fontColor(Color.Grey)
              Text(`￥ ` + product.price)
                .fontSize(12)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .padding({ left: 6 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/ProductDetail',
                params: {
                  prodId: product.prodId
                }
              })
            })
          }.width('92%')
          .backgroundColor(Color.White)
        })
      }
      .width('100%')
      .rowsTemplate("1fr 1fr")
      .columnsTemplate("1fr 1fr")
      .rowsGap(10)
      .columnsGap(10)
      .margin({ top: 10 })
    }
  }
}