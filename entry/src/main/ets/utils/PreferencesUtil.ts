import dataPreferences from '@ohos.data.preferences'

class PreferencesUtil {
  private static preferenceName: string = 'mall4j'
  private preferencesInstance = null

  private getPreferencesInstance() {
    return this.preferencesInstance
  }

  // 设置首选项要用到的上下文
  async setInstanceContext(context) {
    try {
      this.preferencesInstance = await dataPreferences.getPreferences(context, PreferencesUtil.preferenceName);
      console.log('初始化首选项成功')
    } catch (e) {
      console.error('初始化首选项失败:', e.code, e.message)
    }
  }

  // 获取首选项
  async getPreference(key: string, defaultVal = '') {
    try {
      return await this.getPreferencesInstance().get(key, defaultVal)
    } catch (e) {
      console.error('获取用户首选项失败:', e.code, e.message)
      return defaultVal
    }
  }

  // 设置首选项
  async setPreference(key: string, value: any) {
    try {
      console.log('开始保存首选项')
      if (await this.getPreferencesInstance().has(key)) {
        await this.deletePreference(key)
      }
      await this.getPreferencesInstance().put(key, value)
      // 持久化
      await this.getPreferencesInstance().flush()
      console.log(`保存到首选项的${key}的值:`, await this.getPreference(key))
    }
    catch (e) {
      console.error('保存首选项失败:', e.code, e.message)
    }
  }


  // 删除首选项
  async deletePreference(key: string) {
    await this.getPreferencesInstance().delete(key)
    // 持久化
    await this.getPreferencesInstance().flush()

  }
}

export default new PreferencesUtil()