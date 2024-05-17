import ShopCartItemDiscount from './ShopCartItemDiscountDataModel'
export default class ShopCartOrderDataModel {
  shopId: number
  shopName: string
  actualTotal: number
  total: number
  totalCount: number
  transfee: number
  discountReduce: number
  couponReduce: number
  shopReduce: number
  remarks: string
  shopCartItemDiscounts: ShopCartItemDiscount[]
  coupons: number
  orderNumber: number
}