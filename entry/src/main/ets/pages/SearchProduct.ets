import router from '@ohos.router'
import { productApi } from '../api/Api'
import ProductListItem from '../components/ProductListItem'
import AppConst from '../configurations/AppConst'
import ProductDataModel from '../datamodels/ProductDataModel'
import PreferencesUtil from '../utils/PreferencesUtil'

@Entry
@Component
struct SearchProduct {
  @State searchText: string = ''

  @State searchHisArr: string[] = []

  @State data: ProductDataModel[] = []

  private pageSize: number = 10
  @State current: number = 1

  async aboutToAppear() {
    const searchHis = await PreferencesUtil.getPreference(AppConst.PREFERENCES_SEARCH_HIS)
    console.log("searchHis", JSON.stringify(searchHis))
    if (searchHis) {
      this.searchHisArr = searchHis.split(',')
    }
  }

  // 搜索商品
  async searchProds() {
    this.data = (await productApi.search(this.current, this.searchText, this.pageSize))['records']
    console.log("searchProds:", JSON.stringify(this.data))
    this.searchHisArr.push(this.searchText)
    await PreferencesUtil.setPreference(AppConst.PREFERENCES_SEARCH_HIS, this.searchHisArr.join(","))
  }

  @Builder
  buildHisTag(his: string) {
    Text(his)
      .backgroundColor('#f2f2f2')
      .fontSize(12)
      .padding({ top: 4, bottom: 4, left: 8, right: 8 })
      .borderRadius(6)
      .margin({ right: 6 })
      .onClick(() => {
        this.searchText = his
      })
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
          Text('商品搜索')
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

      // 搜索框
      Row() {
        Row() {
          Image($r('app.media.search'))
            .width(16)
          TextInput({ text: this.searchText, placeholder: '输入关键字搜索' })
            .backgroundColor(Color.Transparent)
            .stateStyles({
              normal: {
                .backgroundColor(Color.Transparent)
              },
              pressed: {
                .backgroundColor(Color.Transparent)
              },
              focused: {
                .backgroundColor(Color.Transparent)
              },
              clicked: {
                .backgroundColor(Color.Transparent)
              },
              disabled: {
              .backgroundColor(Color.Transparent)
            }
            })
            .onChange((value) => {
              this.searchText = value
            })

        }.backgroundColor('#f7f7f7')
        .borderRadius(10)
        .padding(4)
        .layoutWeight(1)

        Text('搜索')
          .fontSize(14)
          .fontColor(Color.Red)
          .width(30)
          .margin({ left: 10, right: 10 })
          .onClick(async () => {
            if (this.searchText == '') {
              return
            }
            // 搜索商品
            await this.searchProds()
          })
      }.width('100%')
      .padding(8)
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .color(Color.Gray)
        .width('100%')
        .opacity(0.3)
      Column() {
        if (this.searchText == '') {
          Row() {
            Text('热门搜索')
              .fontSize(14)
          }
          .width('90%')

          Row() {
            Text('暂无数据')
              .fontSize(12)
          }.width('90%')
          .justifyContent(FlexAlign.Center)

          Divider()
            .width('90%')
            .opacity(0.3)
            .margin({ top: 6, bottom: 10 })

          Row() {
            Text('搜索历史')
              .fontSize(14)
            Image($r('app.media.clear_his'))
              .width(20)
          }.width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          // 历史列表
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.searchHisArr, (his: string, index: number) => {
              this.buildHisTag(his)
            })
          }.width('90%')
        } else {
          List() {
            ForEach(this.data, (productDataModel: ProductDataModel) => {
              ListItem() {
                ProductListItem({productDataModel: productDataModel})
              }
            })
          }.width('100%')
        }
      }.width('100%')
      .margin({ top: 10 })
      .justifyContent(FlexAlign.Start)

    }.width('100%')
  }
}