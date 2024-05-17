import router from '@ohos.router'
import { cartApi } from '../api/Api'
import Cart from '../components/Cart'
import Category from '../components/Category'
import Home from '../components/Home'
import My from '../components/My'
import TabBarViewModel from '../viewmodels/TabBarViewModel'

@Entry
@Component
struct Index {
  private tabBarViewModels: TabBarViewModel[] = [
    new TabBarViewModel('首页', $r('app.media.homepage'), $r('app.media.homepage_sel'), 0),
    new TabBarViewModel('分类', $r('app.media.category'), $r('app.media.category_sel'), 1),
    new TabBarViewModel('购物车', $r('app.media.basket'), $r('app.media.basket_sel'), 2),
    new TabBarViewModel('我的', $r('app.media.user'), $r('app.media.user_sel'), 3)
  ]
  @State selectedIndex: number = 0
  @State prodCount: number = 0
  private tabsController: TabsController = new TabsController()

  async aboutToAppear() {
    // 获取从其它页面跳转过来的参数
    const selectedIndex = router.getParams()?.["selectedIndex"]
    this.selectedIndex = selectedIndex
    // 获取购物车数量
    this.prodCount = await cartApi.prodCount()
  }

  onPageShow() {
    if (this.selectedIndex) {
      this.tabsController.changeIndex(this.selectedIndex)
    }
  }

  @Builder
  buildTabBar(tabBarViewModel: TabBarViewModel) {

    Badge({
      count: tabBarViewModel.title == '购物车' ? this.prodCount : 0,
      position: BadgePosition.RightTop,
      style: { badgeSize: 13, badgeColor: '#FA2A2D' }
    }) {
      Column() {
        Image(this.selectedIndex == tabBarViewModel.index ? tabBarViewModel.selectedImage : tabBarViewModel.image)
          .width(20)
          .height(20)
          .margin({ top: 3 })
        Text(tabBarViewModel.title)
          .fontSize(12)
          .fontWeight(500)
          .margin({ top: 5 })
          .fontColor(this.selectedIndex == tabBarViewModel.index ? '#00aaff' : Color.Black)

      }.height(50)
    }

  }

  build() {
    Tabs({controller: this.tabsController}) {
      TabContent() {
        Home()
      }
      .tabBar(this.buildTabBar(this.tabBarViewModels[0]))

      TabContent() {
        Category()
      }
      .tabBar(this.buildTabBar(this.tabBarViewModels[1]))

      TabContent() {
        if (this.selectedIndex == 2) {
          Cart()
        }
      }
      .tabBar(this.buildTabBar(this.tabBarViewModels[2]))

      TabContent() {
        My()
      }
      .tabBar(this.buildTabBar(this.tabBarViewModels[3]))

    }.barPosition(BarPosition.End)
    .width('100%')
    .onChange((index: number) => {
      this.selectedIndex = index
    })
  }
}