class CarouselSliderItem {
  final String imageUrl;

  CarouselSliderItem(this.imageUrl);
}

final List<CarouselSliderItem> carouselItems = [
  CarouselSliderItem(
      "https://tse1.mm.bing.net/th?id=OIP.PuPWrQGLcGccVqXE4PHsWAHaEo&pid=Api&P=0&h=180"),
  CarouselSliderItem(
      "https://tse2.mm.bing.net/th?id=OIP.azMfOwQjMfBnRHijyoxd7gHaE8&pid=Api&P=0&h=180"),
  CarouselSliderItem(
      "https://tse4.mm.bing.net/th?id=OIP.kcV9D5d94KEY6f3cm8qxMwHaEo&pid=Api&P=0&h=180"),
  CarouselSliderItem(
      "https://tse4.mm.bing.net/th?id=OIP.iHj98dpR98Z8kLJWUzhdVgHaFi&pid=Api&P=0&h=180")
];

class TextContainerItem {
  final String text;

  TextContainerItem(this.text);
}

final List<TextContainerItem> textItems = [
  TextContainerItem("Text 1"),
  TextContainerItem("Text 2"),
  TextContainerItem("Text 3"),
  TextContainerItem("Text 4"),
];



class MainContainerItem {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String imageUrl;
  final bool showMarquee;

  MainContainerItem({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.imageUrl,
    this.showMarquee = false,
  });
}

List<MainContainerItem> mainContainerItems = [
  MainContainerItem(text1: 'Text 1', text2: 'Text 2', text3: 'Text 3', text4: 'Text 4', imageUrl: 'https://tse1.mm.bing.net/th?id=OIP.PuPWrQGLcGccVqXE4PHsWAHaEo&pid=Api&P=0&h=180', showMarquee: true),
  MainContainerItem(text1: 'Text 5', text2: 'Text 6', text3: 'Text 7', text4: 'Text 8', imageUrl: 'https://tse2.mm.bing.net/th?id=OIP.azMfOwQjMfBnRHijyoxd7gHaE8&pid=Api&P=0&h=180', showMarquee: false),
  MainContainerItem(text1: 'Text 9', text2: 'Text 10', text3: 'Text 11', text4: 'Text 12', imageUrl: 'https://tse4.mm.bing.net/th?id=OIP.kcV9D5d94KEY6f3cm8qxMwHaEo&pid=Api&P=0&h=180', showMarquee: true),
  MainContainerItem(text1: 'Text 1', text2: 'Text 2', text3: 'Text 3', text4: 'Text 4', imageUrl: 'https://tse1.mm.bing.net/th?id=OIP.PuPWrQGLcGccVqXE4PHsWAHaEo&pid=Api&P=0&h=180', showMarquee: true),
  MainContainerItem(text1: 'Text 5', text2: 'Text 6', text3: 'Text 7', text4: 'Text 8', imageUrl: 'https://tse2.mm.bing.net/th?id=OIP.azMfOwQjMfBnRHijyoxd7gHaE8&pid=Api&P=0&h=180', showMarquee: false),
  MainContainerItem(text1: 'Text 9', text2: 'Text 10', text3: 'Text 11', text4: 'Text 12', imageUrl: 'https://tse4.mm.bing.net/th?id=OIP.kcV9D5d94KEY6f3cm8qxMwHaEo&pid=Api&P=0&h=180', showMarquee: true),
  
];

class RadioModel {
  final String title;
  final String subtitle;

  RadioModel({required this.title, required this.subtitle});
}

final List<RadioModel> radioOptions = [
    RadioModel(title: 'Option 1', subtitle: 'Subtext 1'),
    RadioModel(title: 'Option 2', subtitle: 'Subtext 2'),
    RadioModel(title: 'Option 3', subtitle: 'Subtext 3'),
  ];

