import router from '@ohos.router'
import { addrApi } from '../api/Api'
import UserAddrDataModel from '../datamodels/UserAddrDataModel'

@Entry
@Component
struct Addr {
  @State addrs: UserAddrDataModel[] = []

  private backUrl: string = ''

  private selectedAddrId: number = 0
  private selectedAddr: UserAddrDataModel

  async aboutToAppear() {
    this.backUrl = router.getParams()['backUrl']
  }

  async onPageShow() {
    this.addrs = await addrApi.list()
    for (let index = 0; index < this.addrs.length; index++) {
      const element = this.addrs[index];
      if (element.commonAddr == 1) {
        this.selectedAddrId = element.addrId
        this.selectedAddr = element
      }
    }
    console.log('addr:', JSON.stringify(this.addrs))
  }

  @Builder
  buildAddrItem(addr: UserAddrDataModel, index: number) {
    Column() {
      Row() {
        Column() {
          Text(addr.receiver + ' ' + addr.mobile)
            .fontSize(14)
          Text(addr.addr)
            .fontSize(14)
            .fontColor('#c3c3c3')
            .margin({ top: 4 })
        }.layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 10, top: 10, bottom: 10 })

        Image($r('app.media.revise'))
          .width(20)
          .margin({ right: 10 })

      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .margin({ top: 4, bottom: 4 })
        .opacity(0.6)

      Row() {
        Radio({
          group: 'group',
          value: addr.addrId + ''
        })
          .colorBlend(Color.Red)
          .checked(addr.commonAddr == 1)
          .onChange(async (isChecked: boolean) => {
            if (isChecked) {
              await addrApi.setDefault(addr.addrId)
              this.selectedAddrId = addr.addrId
              this.selectedAddr = addr
            }
          })

        Text(' 设为默认地址')
          .fontSize(14)

      }.width('100%')

    }.width('100%')
  }

  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Scroll() {
        Column() {
          Row() {
            Image($r('app.media.more'))
              .width(16)
              .rotate({
                angle: 180
              })
              .margin({ left: 10 })
              .onClick(() => {
                router.back({
                  url: this.backUrl,
                  params: {
                    selectedAddrId: this.selectedAddrId,
                    selectedAddr: this.selectedAddr
                  }
                })
              })

            Row() {
              Text('收货地址')
                .fontSize(16)
                .fontWeight(600)
            }.layoutWeight(1)
            .justifyContent(FlexAlign.Center)
            .offset({
              x: -10
            })

            Blank()
              .width(20)
          }.width('100%')
          .height(50)
          .justifyContent(FlexAlign.SpaceAround)
          .backgroundColor(Color.White)


          Column() {
            List() {
              ForEach(this.addrs, (addr: UserAddrDataModel, index: number) => {
                ListItem() {
                  this.buildAddrItem(addr, index)
                }.width('100%')
              })
            }.width('98%')

          }.width('100%')
          .backgroundColor(Color.White)
          .margin({ top: 10 })

        }.width('100%')
        .height('100%')
        .backgroundColor('#f4f4f4')

      }.width('100%')

      Row() {
        Button('新增收货地址')
          .type(ButtonType.Normal)
          .borderRadius(0)
          .width('100%')
          .fontSize(16)
          .fontColor(Color.Red)
          .backgroundColor(Color.White)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/EditAddr'
            })
          })
      }.width('100%')
      .height(50)
    }.width('100%')
    .height('100%')
  }
}