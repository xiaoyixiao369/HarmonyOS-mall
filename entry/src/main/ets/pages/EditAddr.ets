import router from '@ohos.router'
import Prompt from '@system.prompt'
import { addrApi } from '../api/Api'
import { AreaPicker } from '../components/AreaPicker'
import AddAddrRequestModel from '../datamodels/AddAddrRequestModel'
@Entry
@Component
struct EditAddr {
  @State receiver: string = ''
  @State mobile: string = ''
  @State addr: string = ''

  @State selectProvinceId: number = 0
  @State selectProvinceName: string = ''
  @State selectCityId: number = 110000000000
  @State selectCityName: string = ''

  @State selectZoneId: number = 120100000000
  @State selectZoneName: string = ''

  customDialogController: CustomDialogController = new CustomDialogController({
      builder: AreaPicker({
        selectProvinceId: $selectProvinceId,
        selectProvinceName: $selectProvinceName,
        selectCityId: $selectCityId,
        selectCityName: $selectCityName,
        selectZoneId: $selectZoneId,
        selectZoneName: $selectZoneName
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })


  build() {
    Column() {
      Row() {
        Image($r('app.media.more'))
          .width(16)
          .rotate({
            angle: 180
          })
          .margin({ left: 10 })
          .onClick(() => {
            router.back()
          })

        Row() {
          Text('编辑收货地址')
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

      Row() {
        Text('收 货 人')
          .fontSize(14)
          .width(70)
        TextInput({placeholder: '姓名', text: this.receiver})
          .fontSize(14)
          .margin({left: 10})
          .borderRadius(0)
          .backgroundColor(Color.White)
          .onChange(value => {
            this.receiver = value
          })
      }.width('100%')
      .padding(10)
      Divider()
        .opacity(0.6)
        .margin({left: 10, right: 10})

      Row() {
        Text('手机号码')
          .fontSize(14)
          .width(70)
        TextInput({placeholder: '11位手机号码', text: this.mobile})
          .type(InputType.Number)
          .fontSize(14)
          .margin({left: 10})
          .borderRadius(0)
          .backgroundColor(Color.White)
          .onChange((value: string) => {
            this.mobile = value
          })
      }.width('100%')
      .padding(10)
      Divider()
        .opacity(0.6)
        .margin({left: 10, right: 10})

      Row() {
        Text('所在地区')
          .fontSize(14)
        .width(70)
        Row() {
          Text(`${this.selectProvinceName} ${this.selectCityName} ${this.selectZoneName}`)
            .fontSize(14)
          Image($r('app.media.more'))
            .width(16)
            .onClick(() => {
              // 打开地区选择器
              this.customDialogController.open()
            })
        }.layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)

      }.width('100%')
      .padding(10)
      .justifyContent(FlexAlign.SpaceBetween)

      .padding(10)
      Divider()
        .opacity(0.6)
        .margin({left: 10, right: 10})

      Row() {
        Text('详细地址')
          .fontSize(14)
          .width(70)
        TextInput({placeholder: '如楼号/单元/门牌号', text: this.addr})
          .fontSize(14)
          .margin({left: 10})
          .borderRadius(0)
          .backgroundColor(Color.White)
          .onChange(value => {
            this.addr = value
          })
      }.width('100%')
      .padding(10)
      Divider()
        .opacity(0.6)
        .margin({left: 10, right: 10})

      Button('保存收货地址')
        .backgroundColor(Color.Red)
        .width(200)
        .margin({top: 20})
        .onClick(async () => {
          console.log('receiver:', this.receiver)
          if (this.receiver == '') {
            Prompt.showToast({
              message: '请填写收货人'
            })
            return
          }
          if (this.mobile == '') {
            Prompt.showToast({
              message: '请填写手机号码'
            })
            return
          }
          if (this.selectProvinceName == '') {
            Prompt.showToast({
              message: '请选择省份'
            })
            return
          }

          if (this.selectCityName == '') {
            Prompt.showToast({
              message: '请选择城市'
            })
            return
          }

          if (this.selectZoneName == '') {
            Prompt.showToast({
              message: '请选择区县'
            })
            return
          }

          if (this.addr == '') {
            Prompt.showToast({
              message: '请填写详细地址'
            })
            return
          }

          const addAddrRequestModel: AddAddrRequestModel = new AddAddrRequestModel()
          addAddrRequestModel.receiver = this.receiver
          addAddrRequestModel.mobile = this.mobile
          addAddrRequestModel.provinceId = this.selectProvinceId
          addAddrRequestModel.province = this.selectProvinceName
          addAddrRequestModel.cityId = this.selectCityId
          addAddrRequestModel.city = this.selectCityName
          addAddrRequestModel.areaId = this.selectZoneId
          addAddrRequestModel.area = this.selectZoneName
          addAddrRequestModel.addr = this.addr
          addAddrRequestModel.userType = 0

          await addrApi.addAddr(addAddrRequestModel)
          router.back()

        })
    }
    .width('100%')
  }
}