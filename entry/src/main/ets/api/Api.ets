import axios from '@ohos/axios'
import Prompt from '@system.prompt'
import AppConst from '../configurations/AppConst'
import AddCartReqModel from '../datamodels/AddCartReqModel'
import CartDataModel from '../datamodels/CartDataModel'
import CategoryDataModel from '../datamodels/CategoryDataModel'
import LoginDataModel from '../datamodels/LoginDataModel'
import LoginReqModel from '../datamodels/LoginReqModel'
import NoticeDataModel from '../datamodels/NoticeDataModel'
import OrderCountDataModel from '../datamodels/OrderCountDataModel'
import ProductDataModel from '../datamodels/ProductDataModel'
import ResData from '../datamodels/ResData'
import SwiperDataModel from '../datamodels/SwiperDataModel'
import TotalPayDataModel from '../datamodels/TotalPayDataModel'
import PreferencesUtil from '../utils/PreferencesUtil'
import ConfirmOrderReqModel from '../datamodels/ConfirmOrderReqModel'
import ConfirmOrderDataModel from '../datamodels/ConfirmOrderDataModel'
import UserAddrDataModel from '../datamodels/UserAddrDataModel'
import AreaDataModel from '../datamodels/AreaDataModel'
import AddAddrRequestModel from '../datamodels/AddAddrRequestModel'
import SubmitOrderDataModel from '../datamodels/SubmitOrderDataModel'
import MyOrderListDataModel from '../datamodels/MyOrderListDataModel'

class Api {

  // 统一网络请求
  protected async requestNetwork<T>(options) {
    const accessToken = await PreferencesUtil.getPreference(AppConst.PREFERENCES_LOGIN_CODE)
    console.log('api获取到的accessToken:', accessToken)
    if (accessToken) {
      options.headers = {
        'Authorization': accessToken,
        'Content-Type': 'application/json'
      }
    }
    try {
      const axiosInstance = axios.create({
        baseURL: "http://1.14.108.253:8086"
      });
      axiosInstance.interceptors.request.use(
        (config) => {
          const { method, url, data, headers } = config;
          const logMessage = `Sending ${method} request to ${url}`;
          console.log('axios:', logMessage);

          // 可以选择性打印请求体和头部信息
          if (data) {
            console.debug('axios body Request body:', JSON.stringify(data));
          }
          if (headers) {
            console.debug('axios headers:', JSON.stringify(headers));
          }

          return config;
        },
        (error) => {
          console.error('axios: Request error:', JSON.stringify(error));
          return Promise.reject(error);
        },
      );
      const res = await axiosInstance.request(options)
      console.log('axios: res data,', JSON.stringify(res))
      return Promise.resolve(res["data"] as ResData<T>)
    } catch (err) {
      console.log('axios 网络请求失败', `网络请求失败: ${err.code} ${err.message}`)
      Prompt.showToast({
        message: `网络请求失败: ${err.code} ${err.message}`,
        duration: 2000
      })
      return Promise.reject(err)
    }
  }

  // get请求
  protected async get<T>(url, params = {}) {
    return this.requestNetwork<T>({
      method: 'get',
      url: url,
      params
    })
  }

  // post请求.如果服务器用的是delete接口,需要改成post接口.
  // 不知为何,axios发送delete请求会报404(只在请求参数是数组的情况下验证过)
  protected async post<T>(url, data) {
    return this.requestNetwork<T>({
      method: 'post',
      url: url,
      data
    })
  }

  // put请求
  protected async put<T>(url, data) {
    return this.requestNetwork<T>({
      method: 'put',
      url: url,
      data
    })
  }
}

// 首页的接口
class HomeApi extends Api {
  // 获取轮播图
  async getSwiperData(): Promise<SwiperDataModel[]> {
    return (await this.get<SwiperDataModel[]>('/indexImgs')).data
  }

  // 获取通知消息
  async getNoticeData(): Promise<NoticeDataModel[]> {
    return (await this.get<NoticeDataModel[]>('/shop/notice/topNoticeList')).data
  }

  // 每日上新
  async getLastedProductData(): Promise<ProductDataModel[]> {
    return (await this.get<ProductDataModel[]>('/prod/lastedProdPage?current=1&size=6')).data
  }

  // 更多商品
  async getMoreProductData(): Promise<ProductDataModel[]> {
    return (await this.get<ProductDataModel[]>('/prod/moreBuyProdList?current=1&size=10')).data
  }
}

// 用户相关的接口
class MyApi extends Api {

  // 登录
  async login(loginReqModel: LoginReqModel): Promise<LoginDataModel> {
    return (await this.post<LoginDataModel>('/login', loginReqModel)).data
  }

  // 各状态的订单数量
  async orders(): Promise<OrderCountDataModel> {
    return (await this.get<OrderCountDataModel>('/p/myOrder/orderCount')).data
  }
}

// 分类相关的接口
class CategoryApi extends Api {
  async categories(parentId: number = 0): Promise<CategoryDataModel[]> {
    return (await this.get<CategoryDataModel[]>(`/category/categoryInfo?parentId=${parentId}`)).data
  }
}

// 商品相关的接口
class ProductApi extends Api {
  async getCategoryProductData(categoryId: number): Promise<ProductDataModel[]> {
    return (await this.get<ProductDataModel[]>(`/prod/pageProd?categoryId=${categoryId}&current=1&size=10&sort=0&isAllProdType=true`)).data
  }

  async getProductData(prodId: number): Promise<ProductDataModel> {
    return (await this.get<ProductDataModel>(`/prod/prodInfo?prodId=${prodId}`)).data
  }

  // 搜索商品
  async search(current: number, prodName: string, size: number): Promise<ProductDataModel[]> {
    return (await this.get<ProductDataModel[]>(`/search/searchProdPage?current=${current}&prodName=${prodName}&size=${size}&sort=0`)).data
  }

}

// 购物车
class CartApi extends Api {

  // 添加购物车
  async add(addCarReqModel: AddCartReqModel): Promise<any> {
    return (await this.post<any>('/p/shopCart/changeItem', addCarReqModel)).data
  }

  // 购物车列表
  async list(): Promise<CartDataModel[]> {
    return (await this.post<CartDataModel[]>(`/p/shopCart/info`, {})).data
  }

  // 获取购物车商品数量
  async prodCount(): Promise<number> {
    return (await this.get<number>('/p/shopCart/prodCount')).data
  }


  // 计算购物车商品的价格
  async totalPay(basketIds: number[]): Promise<TotalPayDataModel> {
    return (await this.post<TotalPayDataModel>(`/p/shopCart/totalPay`, basketIds)).data
  }

  // 删除购物车中的商品
  async deleteCartProds(basketIds: number[]): Promise<any> {
    return (await this.post<any>(`/p/shopCart/deleteItem`, basketIds)).data
  }
}

// 确认订单接口
class ConfirmOrderApi extends Api {

  // 确认订单
  async confirm(confirmOrderReqModel: ConfirmOrderReqModel): Promise<ConfirmOrderDataModel> {
    return (await this.post<ConfirmOrderDataModel>(`/p/order/confirm`, confirmOrderReqModel)).data
  }

  // 提交订单
  async submit(submitOrderDataModel: SubmitOrderDataModel): Promise<ResData<any>> {
    return (await this.post<SubmitOrderDataModel>(`/p/order/submit`, submitOrderDataModel))
  }
}

// 我的订单相关接口
class MyOrderApi extends Api {
  async list(status: number, page: number, current: number): Promise<MyOrderListDataModel> {
    return (await this.get<MyOrderListDataModel>(`/p/myOrder/myOrder?current=${current}&size=${page}&status=${status}`)).data
  }


  // 取消订单
  async cancel(orderNumber: string): Promise<any> {
    return (await this.put<any>(`/p/myOrder/cancel/${orderNumber}`, {})).data
  }

  // 模拟支付订单
  async pay(orderNumber: string): Promise<any> {
    return (await this.post<any>(`/p/order/normalPay`, {'orderNumbers': orderNumber})).data
  }


}

// 地址管理相关接口
class AddrApi extends Api {
  async list(): Promise<UserAddrDataModel[]> {
    return (await this.get<UserAddrDataModel[]>('/p/address/list')).data
  }

  // 获取地区接口
  async areas(parentId: number): Promise<AreaDataModel[]> {
    return (await this.get<AreaDataModel[]>('/p/area/listByPid?pid=' + parentId)).data
  }

  // 增加收货地址
  async addAddr(addAddrRequestModel: AddAddrRequestModel): Promise<ResData<string>> {
    return (await this.post<ResData<string>>('/p/address/addAddr', addAddrRequestModel)).data
  }

  // 设为默认收货地址
  async setDefault(addrId: number): Promise<ResData<string>> {
    return (await this.put<ResData<string>>('/p/address/defaultAddr/' + addrId, {})).data
  }
}


const homeApi = new HomeApi()
const myApi = new MyApi()
const categoryApi = new CategoryApi()
const productApi = new ProductApi()
const cartApi = new CartApi()
const confirmOrderApi = new ConfirmOrderApi()
const addrApi = new AddrApi()
const myOrderApi = new MyOrderApi()

export { homeApi, myApi, categoryApi, productApi, cartApi, confirmOrderApi, addrApi, myOrderApi }