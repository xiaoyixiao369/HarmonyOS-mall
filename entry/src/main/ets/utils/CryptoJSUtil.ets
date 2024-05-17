import CryptoJS from '@ohos/crypto-js'

class CryptoJSUtil {
  // 加密
  private keyStr = '-mall4j-password' // 解密用的key
  encrypt(word: string) {
    const time = Date.now()

    const key = CryptoJS.enc.Utf8.parse(this.keyStr)
    const srcs = CryptoJS.enc.Utf8.parse(time + word) // 加密方式: 时间戳 + 密文
    const encrypted = CryptoJS.AES.encrypt(srcs, key, { mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.Pkcs7 })
    return encrypted.toString()
  }
}

export default new CryptoJSUtil()