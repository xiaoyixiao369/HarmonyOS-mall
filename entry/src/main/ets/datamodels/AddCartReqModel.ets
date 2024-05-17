export default class AddCartReqModel {
  basketId: number
  count: number
  prodId: number
  shopId: number
  skuId: number

  constructor(basketId: number,count: number,prodId: number,shopId: number,skuId: number) {
    this.basketId = basketId
    this.count = count
    this.prodId = prodId
    this.shopId = shopId
    this.skuId = skuId
  }
}