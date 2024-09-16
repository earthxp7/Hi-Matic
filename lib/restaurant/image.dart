class ImageController {
  final String image;

  const ImageController({required this.image});
}

List<ImageController> images = [
  const ImageController(image: 'assets/logo.png'),
  const ImageController(image: 'assets/click.png')
];
