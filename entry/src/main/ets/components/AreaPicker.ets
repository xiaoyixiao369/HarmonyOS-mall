import { addrApi } from '../api/Api'
import AreaDataModel from '../datamodels/AreaDataModel'

@CustomDialog
export struct AreaPicker {
  @Link selectProvinceId: number
  @Link selectProvinceName: string
  @State provinces: AreaDataModel[] = []
  @State provincesStr: string[] = []
  @Link selectCityId: number
  @Link selectCityName: string
  @State cities: AreaDataModel[] = []
  @State citiesStr: string[] = []
  @Link selectZoneId: number
  @Link selectZoneName: string
  @State zones: AreaDataModel[] = []
  @State zonesStr: string[] = []
  customDialogController: CustomDialogController

  async aboutToAppear() {
    // 加在所有的省份
    this.provinces = await addrApi.areas(0)
    // 处理所有省份的名称
    this.provincesStr = this.provinces.map(province => province.areaName)

    // 默认加载北京的城市
    this.cities = await addrApi.areas(this.selectCityId)
    this.citiesStr = this.cities.map(city => city.areaName)
    // 默认加载北京市辖区的区县
    this.zones = await addrApi.areas(this.selectZoneId)
    this.zonesStr = this.zones.map(zone => zone.areaName)
  }

  build() {
    Column() {
      Row() {
        Text('确定')
          .fontSize(14)
          .margin({top: 10, right: 10, bottom: 10})
          .onClick(() => {
            this.customDialogController.close()
          })
      }.width('100%')
      .justifyContent(FlexAlign.End)

      Row() {
        TextPicker({
          range: this.provincesStr, selected: 0
        })
          .onChange(async (provinceName: string, index: number) => {
            this.selectProvinceId = this.provinces.filter(province => province.areaName == provinceName)[0].areaId
            this.selectProvinceName = provinceName

            this.cities = await addrApi.areas(this.selectProvinceId)
            this.citiesStr = this.cities.map(city => city.areaName)

          })
        TextPicker({
          range: this.citiesStr, selected: 0
        }).onChange(async (cityName: string, index: number) => {
          this.selectCityId = this.cities.filter(city => city.areaName == cityName)[0].areaId
          this.selectCityName = cityName

          this.zones = await addrApi.areas(this.selectCityId)
          this.zonesStr = this.zones.map(zone => zone.areaName)
        })

        TextPicker({
          range: this.zonesStr, selected: 0
        }).onChange((zoneName: string, index: number) => {
          this.selectZoneId = this.zones.filter(zone => zone.areaName == zoneName)[0].areaId
          this.selectZoneName = zoneName
        })
      }
    }.width('100%')
  }
}