import ShopCartOrderDataModel from './ShopCartOrderDataModel'
import UserAddrDataModel from './UserAddrDataModel'
@Observed
export default class ConfirmOrderDataModel {
  actualTotal: number
  total: number
  totalCount: number
  orderReduce: number
  userAddr: UserAddrDataModel
  shopCartOrders: ShopCartOrderDataModel[]
  coupons: number
}