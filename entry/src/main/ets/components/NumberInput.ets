import formInfo from '@ohos.app.form.formInfo'

@Preview
@Component
export default struct NumberInput {
  @Prop min: number
  @Prop max: number
  defaultWidth: number
  defaultHeight: number
  @Link value: number

  aboutToAppear() {
    if (!this.value) {
      this.value = 0
    }
    if (!this.min) {
      this.min = 0
    }

    if (!this.max) {
      this.max = 9999
    }
    if (!this.defaultWidth) {
      this.defaultWidth = 80
    }
    if (!this.defaultHeight) {
      this.defaultHeight = 30
    }

  }

  build() {
    Row() {
      Text('-')
        .width(30)
        .textAlign(TextAlign.Center)
        .fontColor(Color.Grey)
        .onClick(() => {
          this.value--
          if (this.value < this.min) {
            this.value = this.min
          }
        })
      Text(this.value + '')
        .width(20)
        .textAlign(TextAlign.Center)
      Text('+')
        .width(30)
        .textAlign(TextAlign.Center)
        .fontColor(Color.Grey)
        .onClick(() => {
          this.value++
          if (this.value > this.max) {
            this.value = this.max
          }
        })
    }.width(this.defaultWidth)
    .height(this.defaultHeight)
    .backgroundColor('#f7f7f7')
  }
}