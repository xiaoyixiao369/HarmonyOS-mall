import router from '@ohos.router'
import Prompt from '@system.prompt'
import { myApi } from '../api/Api'
import LoginReqModel from '../datamodels/LoginReqModel'
import CryptoJSUtil from '../utils/CryptoJSUtil'
import PreferencesUtil from '../utils/PreferencesUtil'
import AppConst from '../configurations/AppConst'

@Entry
@Component
export default struct Login {
  @State userName: string = 'a'
  @State passWord: string = 'a'

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.more'))
          .width(20)
          .margin({ left: 10 })
          .rotate({
            angle: 180
          }).onClick(() => {
          router.back()
        })

        Row() {
          Text('用户登录')
            .fontSize(20)
            .fontWeight(600)
        }.layoutWeight(1)
        .justifyContent(FlexAlign.Center)

        Blank()
          .width(20)

      }
      .width('100%')
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)

      // Logo
      Row() {
        Image($r('app.media.logo'))
          .width(80)
      }.width('100%')
      .margin({ top: 40 })
      .justifyContent(FlexAlign.Center)

      // 登录框
      Column() {
        Row() {
          Text('账号')
            .fontSize(14)
          TextInput({ placeholder: '请输入用户名', text: this.userName })
            .borderRadius(5)
            .backgroundColor('#f5f5f5')
            .layoutWeight(1)
            .onChange(value => {
              this.userName = value
            })
        }.width('90%')
        .padding(3)
        .borderRadius(6)
        .backgroundColor('#f5f5f5')

        Row() {
          Text('密码')
            .fontSize(14)
          TextInput({ placeholder: '请输入密码', text: this.passWord })
            .type(InputType.Password)
            .borderRadius(5)
            .backgroundColor('#f5f5f5')
            .layoutWeight(1)
            .onChange(value => {
              this.passWord = value
            })
        }
        .width('90%')
        .padding(3)
        .borderRadius(6)
        .backgroundColor('#f5f5f5')
        .margin({ top: 10 })

        Row() {
          Text('还没有账号? 去注册>')
            .fontSize(14)
            .fontColor('#00aaff')
        }.width('90%')
        .margin({ top: 10 })

        Row() {
          Button('登录')
            .commonButton()
            .fontColor(Color.White)
            .backgroundColor('#0ab906')
            .onClick(async () => {
              if (this.userName.trim() == '') {
                Prompt.showToast({
                  message: '请输入用户名'
                })
                return false
              }

              if (this.passWord.trim() == '') {
                Prompt.showToast({
                  message: '请输入密码'
                })
                return false
              }
              console.log('username', CryptoJSUtil.encrypt(this.passWord))
              const loginDataModel = await myApi.login(new LoginReqModel(this.userName, CryptoJSUtil.encrypt(this.passWord)))
              console.log('loginDataModel', JSON.stringify(loginDataModel))
              // 保存用户的登录信息到preferences
              if (loginDataModel.accessToken) {
                try {
                  // 这里必须要用try,否则router那里无法执行,不知道为什么
                  console.log("开始保存用户登录信息到首选项")
                  await PreferencesUtil.setPreference(AppConst.PREFERENCES_LOGIN_CODE, loginDataModel.accessToken + '')
                  console.log("保存用户登录信息到首选项成功")
                } catch (e) {
                  console.error("保存用户登录信息到首选项失败:", JSON.stringify(e))
                }
                // 登录成功,返回到首页
                router.replaceUrl({
                  url: 'pages/Index'
                })
              }
            })
        }
        .width('90%')
        .margin({ top: 30 })

        Row() {
          Button('回到首页')
            .commonButton()
            .fontColor(Color.Black)
            .backgroundColor('#c9c9c9')
            .onClick(() => {
              router.replaceUrl({
                url: 'pages/Index'
              })
            })

        }
        .width('90%')
        .margin({ top: 10 })
      }.width('100%')
      .margin({ top: 20 })
    }.width('100%')
  }
}

@Extend(Button) function commonButton() {
  .width('100%')
  .height(35)
  .fontSize(14)
  .type(ButtonType.Normal)
  .borderRadius(3)
}