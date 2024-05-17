class ResData<T> {
  code: string
  msg: string
  data: T
  timestamp: string
  version: string
  sign:string
  success: boolean
  fail: boolean
}
export default ResData