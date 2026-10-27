enum AppPage {
  welcome('/welcome', 'Моя будущая профессия'),
  overview('/overview', 'Привет!\nЭто мой путь во\nFlutter.'),
  profile('/profile', 'Профиль'),
  why('/path/why', 'Выбор, который\nзадаёт направление'),
  stack('/path/stack', 'Один стек.\nМного платформ.'),
  profession('/profession', 'Моя профессия —\nFlutter-разработчик'),
  duties('/profession/duties', 'Что делает\nFlutter-разработчик'),
  tradeoffs('/profession/tradeoffs', 'Профессия\nбез розовых очков'),
  skills('/skills', 'Навыки, на которых\nстроится успех'),
  learning('/path', 'Как я буду\nучиться'),
  growth('/path/growth', 'Рост — это путь,\nа не одна ступень');

  const AppPage(this.path, this.title);
  final String path;
  final String title;
}

enum CardTone { neutral, accent, dark }

class ContentBlock {
  const ContentBlock(this.title, this.body, [this.tone = CardTone.neutral]);
  final String title;
  final String body;
  final CardTone tone;
}

const whyBlocks = [
  ContentBlock(
    '01 Интерес каждый день',
    'Мне важно заниматься тем, что интересно лично мне.',
    CardTone.accent,
  ),
  ContentBlock(
    '02 Своё направление',
    'В техникуме изучают веб, а меня привлекла мобильная разработка.',
  ),
  ContentBlock(
    '03 Интересен весь процесс',
    'От анализа проблемы и поиска решения — до готового приложения.',
  ),
  ContentBlock(
    'Мой ориентир',
    'Соединить личный интерес, способности и реальные задачи пользователей.',
    CardTone.dark,
  ),
];
const dutyBlocks = [
  ContentBlock(
    '01 Понять задачу',
    'Уточнить сценарии, требования и результат.',
  ),
  ContentBlock(
    '02 Собрать интерфейс',
    'Создать экраны, навигацию и адаптивную вёрстку.',
  ),
  ContentBlock(
    '03 Подключить данные',
    'Реализовать логику, API и хранение данных.',
  ),
  ContentBlock(
    '04 Проверить качество',
    'Написать тесты, исправить ошибки и ускорить работу.',
  ),
  ContentBlock(
    '05 Подготовить релиз',
    'Собрать приложение и поддерживать его после выпуска.',
  ),
];
const skillBlocks = [
  ContentBlock(
    'Dart и Flutter',
    'ООП, асинхронность, виджеты и управление состоянием.',
    CardTone.accent,
  ),
  ContentBlock(
    'Данные и качество',
    'HTTP / REST, локальное хранение, Git, отладка и автоматические тесты.',
  ),
  ContentBlock(
    'Не только код',
    'Быстро учиться и искать решения\nОбщаться и работать в команде\nРасставлять приоритеты\nУчитывать различия платформ',
    CardTone.dark,
  ),
  ContentBlock(
    'Мой принцип',
    'Понять проблему, отладить код и использовать готовые инструменты с умом.',
  ),
];
const learningBlocks = [
  ContentBlock(
    '01 Образование — плюс',
    'Вуз даёт фундамент, но начать изучать Flutter можно самостоятельно.',
  ),
  ContentBlock(
    '02 Изучить Dart и Flutter',
    'Официальные руководства: dart.dev и docs.flutter.dev/learn/pathway.',
    CardTone.accent,
  ),
  ContentBlock(
    '03 Видео, статьи и ИИ',
    'Видео и нейросети помогают учиться; ответы важно проверять и понимать код.',
  ),
  ContentBlock(
    '04 Практика и проекты',
    'Свои приложения, Flutter Codelabs, наставники и разбор чужого кода.',
    CardTone.dark,
  ),
];
const growthBlocks = [
  ContentBlock(
    '01 Старт / Junior',
    'Освоить базу, создавать экраны и решать задачи с поддержкой команды.',
  ),
  ContentBlock(
    '02 Middle',
    'Самостоятельно разрабатывать функции и отвечать за качество решений.',
  ),
  ContentBlock(
    '03 Senior',
    'Проектировать архитектуру, решать сложные задачи и помогать коллегам.',
  ),
  ContentBlock(
    '04 Tech Lead / свой продукт',
    'Развивать команду и техническое направление или запустить приложение.',
    CardTone.dark,
  ),
];
const tradeoffBlocks = [
  ContentBlock(
    '+  Что привлекает',
    'Создание собственных продуктов\nОдна кодовая база для нескольких платформ.\nВидимый результат работы.\nРазные проекты и постоянное развитие.',
    CardTone.accent,
  ),
  ContentBlock(
    '−  Что требует усилий',
    'Нужно постоянно учиться.\nЕсть дедлайны и сложные ошибки.\nИногда нужен нативный код под платформу.\nБольшая часть дня за компом',
    CardTone.dark,
  ),
  ContentBlock(
    'Как я к этому отношусь',
    'Готов учиться, искать причины ошибок и улучшать результат шаг за шагом.',
  ),
];
const stackBlocks = [
  ContentBlock(
    'Не ограничиваться платформой',
    'Я хочу создавать универсальные решения, а не выбирать только Android или только iOS.',
    CardTone.accent,
  ),
  ContentBlock(
    'Как я открыл Flutter',
    'Искал альтернативу веб-разработке и нашёл Flutter от Google.',
  ),
  ContentBlock(
    'Объединить мои интересы',
    'Мне близки логика разработки, устройство технологий и возможность создавать что-то своими руками.',
  ),
  ContentBlock(
    'Моя цель',
    'Превращать идеи в полезные мобильные приложения, доступные разным пользователям.',
    CardTone.dark,
  ),
];

class Hobby {
  const Hobby(this.title, this.image, this.description);
  final String title;
  final String image;
  final String description;
}

const hobbies = {
  'Робототехника\nи дроны': Hobby(
    'Робототехника\nи дроны',
    'robotics',
    'Робототехника и дроны научили меня разбираться, как устроена система и как её части связаны между собой.\nВ приложении похожая история: мало сделать отдельные экраны, нужно ещё продумать, как всё будет работать вместе.',
  ),
  'Мототехника': Hobby(
    'Мототехника',
    'motorcycle',
    'Мототехника приучила искать решения, даже когда сначала вообще непонятно, что делать. Разбираешь, проверяешь, ищешь информацию, пробуешь снова.\nС программированием у меня часто получается так же.',
  ),
  'Садоводство': Hobby(
    'Садоводство',
    'gardening',
    'А садоводство научило терпению. Результат появляется не сразу, и иногда нужно просто спокойно продолжать заниматься своим делом.\nКогда долго ищешь ошибку в коде, это очень помогает.',
  ),
};
const hobbyLabels = [
  'Программирование',
  'Дизайн',
  'Робототехника\nи дроны',
  'Радиоэлектроника',
  'Ардуино',
  'Английский',
  'Баян',
  'Мототехника',
  'Укулеле',
  'Танцы',
  'Садоводство',
  'Сноуборды',
  'Велосипед',
  'Путешествия',
  'ОФП',
  'Китайский язык',
  'Рыбалка',
  'Квадроциклы',
];
const techStack = [
  'Flutter',
  'Dart',
  'Bloc',
  'Dio',
  'Riverpod',
  'Firebase',
  'GitHub',
  'MVVM',
  'HTTP',
  'HTTPS',
  'Local Notifications',
  'Firebase Messaging',
  'SOLID',
];

class Achievement {
  const Achievement(
    this.title,
    this.description,
    this.result,
    this.year,
    this.symbol,
  );
  final String title, description, result, year, symbol;
}

const achievements = [
  Achievement(
    'Стипендия Правительства Российской Федерации',
    'Стипендиант Правительства РФ',
    'Стипендиант',
    '2025/2026 уч. год',
    'award',
  ),
  Achievement(
    'Именная стипендия\nмэра Томска',
    'Номинация «Лучший по профессии»',
    'Лауреат',
    '',
    'award',
  ),
  Achievement(
    'Премия Томской области',
    'За значительные результаты\nв научно-исследовательской\nи инновационной деятельности',
    'Лауреат',
    '',
    'star',
  ),
  Achievement(
    'Студент года — 2025',
    'Региональный этап премии\nНоминация «Профессионал года»',
    'Победитель',
    '2025',
    'cup',
  ),
  Achievement(
    'Архипелаг 2025',
    'Инженерные соревнования\n«Аддитивная фабрика БАС»',
    'II место',
    '2025',
    'drone',
  ),
  Achievement(
    'Национальный рекорд НТИ',
    'Наименьшее время создания и запуска функционального прототипа\nбеспилотного воздушного судна',
    'Участие в установлении рекорда',
    '',
    'drone',
  ),
  Achievement(
    'Международный фестиваль\nнаучно-технического творчества',
    'Финал · направление «Решения\nв сфере инженерного проектирования»',
    'I место',
    '',
    'cup',
  ),
  Achievement(
    'Летай в ТГУ',
    'Чемпионат дронов\n«Автоматическая посадка дрона\nна движущуюся платформу»',
    'III место',
    '',
    'drone',
  ),
  Achievement(
    'АГРОБАС',
    'Региональные соревнования\nпо пилотированию беспилотников\nСтаршая лига',
    'I место',
    '',
    'drone',
  ),
  Achievement(
    'VI Региональный конкурс\nстуденческих работ',
    'Обучающиеся СПО Томской области\nПрактико-ориентированные проекты\nпо физике · «Творческая лаборатория\n(Экспериментальная и прикладная физика)»',
    '',
    '2025',
    'book',
  ),
  Achievement(
    'Основы предпринимательства',
    'Обучающая программа\nАНО «Агентство инвестиционного\nразвития Томской области»',
    'Участие',
    '2026',
    'book',
  ),
];

const platformIds = ['android', 'ios', 'web', 'windows', 'macos', 'linux'];
const platformLabels = ['Android', 'iOS', 'Web', 'Windows', 'macOS', 'Linux'];

class CatalogProgress {
  const CatalogProgress({this.selected = const {}});
  static const totalSteps = 6;
  final Set<String> selected;
  int get completedSteps => selected.length;
  bool get isComplete => completedSteps == totalSteps;
  CatalogProgress add(String id) =>
      !platformIds.contains(id) || selected.contains(id)
      ? this
      : CatalogProgress(selected: Set.unmodifiable({...selected, id}));
}
