export default class LoginReqModel {
  userName: string
  passWord: string

  constructor(userName: string, passWord: string) {
    this.userName = userName
    this.passWord = passWord
  }
}
