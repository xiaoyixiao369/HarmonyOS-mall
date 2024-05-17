import TransfeeDataModel from './TransfeeDataModel'
export default class TransportDataModel {
  transportId: number
  transName: string
  createTime: string
  shopId: number
  chargeType: number
  isFreeFee: number
  hasFreeCondition: number
  transfeeFrees: []
  transfees: TransfeeDataModel[]
}