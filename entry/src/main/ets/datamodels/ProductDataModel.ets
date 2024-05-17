import SkuDataModel from './SkuDataModel'
import TransfeeDataModel from './TransfeeDataModel'
import TransportDataModel from './TransportDataModel'
export default class ProductDataModel {
  shopId: number
  shopName: string
  prodId: number
  prodName: string
  price: number
  content: string
  oriPrice: number
  totalStocks: number
  brief: string
  pic: string
  imgs: string
  categoryId: number
  skuList: SkuDataModel[]
  transport: TransportDataModel[]
  transfeeFrees: string[]
  transfees: TransfeeDataModel[]
}
