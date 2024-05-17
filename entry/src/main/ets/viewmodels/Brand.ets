export default class Brand {
  image: Resource
  title: string

  constructor(image: Resource, title: string) {
    this.image = image
    this.title = title
  }
}