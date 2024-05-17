export default class TabBarViewModel {
  title: string
  image: Resource
  selectedImage: Resource
  index: number

  constructor(title: string, image: Resource, selectedImage: Resource, index: number) {
    this.title = title
    this.image = image
    this.selectedImage = selectedImage
    this.index = index
  }

}