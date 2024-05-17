import MyOrderListItemDataModel from './MyOrderListItemDataModel'
export default class MyOrderListDataModel {
  records: MyOrderListItemDataModel[]
  total: number
  size: number
  current: number
  pages: number
}