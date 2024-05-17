import router from '@ohos.router'
import { categoryApi } from '../api/Api'
import CategoryDataModel from '../datamodels/CategoryDataModel'

@Entry
@Component
export default struct Category {
  @State categoryDataModels: CategoryDataModel[] = []
  @State selectedIndex: number = 0

  async aboutToAppear() {
    this.categoryDataModels = await categoryApi.categories()
  }

  @Builder
  buildTabbar(categoryDataModel: CategoryDataModel, index: number) {
    Row() {
      Text('')
        .width(4)
        .height(16)
        .backgroundColor(this.selectedIndex == index ? Color.Red : '#f5f6f7')

      Text(categoryDataModel.categoryName).fontSize(16)
        .margin({left: 6, right: 10})
        .fontColor(this.selectedIndex == index ? Color.Red : Color.Grey)

    }.backgroundColor(this.selectedIndex == index ? Color.White : '#f5f6f7')
    .height(50)
  }

  build() {
    Column() {
      Row() {
        Text('商品分类')
          .fontSize(20)
          .fontWeight(600)
      }.width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({
        top: 10,
        bottom: 10
      })
      Divider()
      .width('100%')
      Tabs() {
        ForEach(this.categoryDataModels, (categoryDataModel: CategoryDataModel, index: number) => {
          TabContent() {
            MallTabContent({ categoryDataModel: categoryDataModel })
          }.tabBar(this.buildTabbar(categoryDataModel, index))
          .align(Alignment.Top)
        })

      }.barPosition(BarPosition.Start)
      .vertical(true)
      .barWidth(80)
      .barMode(BarMode.Scrollable)
      .width('100%')
      .height('100%')
      .barHeight('100%')
      .backgroundColor('#f5f6f7')
      .onChange((index: number) => {
        this.selectedIndex = index
      })
    }
    .width('100%')
  }
}

@Component
struct MallTabContent {
  categoryDataModel: CategoryDataModel
  @State categories: CategoryDataModel[] = []

  async aboutToAppear() {
    this.categories = await categoryApi.categories(this.categoryDataModel.categoryId)
  }

  @Builder
  buildCategory(category: CategoryDataModel) {
    Column() {
      Image(category.pic)
        .width('80%')
        .margin({top: 6})
      Text(category.categoryName)
        .fontSize(14)
    }.width('100%')
  }

  build() {
    Scroll() {
      Column() {
        // banner图片
        Row() {
          Image(this.categoryDataModel.pic)
            .width('92%')
        }.width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({top: 5})


        if (this.categories.length == 0) {
          Row(){
            Text('该分类下暂无子分类')
              .fontSize(14)
              .fontColor(Color.Grey)
              .margin({top: 4})
          }.width('100%')
          .justifyContent(FlexAlign.Center)
        } else {
          Grid() {
            ForEach(this.categories, (category: CategoryDataModel, index: number) => {
              GridItem() {
                this.buildCategory(category)
              }.onClick(() => {
                router.pushUrl({
                  url: 'pages/ProductList',
                  params: {
                    category: this.categoryDataModel,
                    index: index
                  }
                })
              })
            })
          }.rowsTemplate('1f 1fr 1fr')
          .columnsTemplate('1fr 1fr 1fr')
          .width('100%')
          .layoutWeight(1)
          .columnsGap(10)
          .rowsGap(10)
        }

      }.width('100%')
    }.width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .align(Alignment.Top)

  }
}