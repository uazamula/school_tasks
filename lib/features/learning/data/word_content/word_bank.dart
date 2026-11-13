import 'package:school_tasks/features/learning/domain/word_content/content_tag.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_bank.dart';
import 'package:school_tasks/features/learning/domain/word_content/word_builder.dart';

typedef t = ContentTag;

final ukWordBank = WordBank([...ukWords]);

final ukWords = [
  wordUk('accordion', 'accordion', 'uk_bajan', 'баян', 'ба-ян'),
  wordUk('anchor', 'anchor', 'uk_yakir', 'якір', 'я-кір'),
  wordUk('ants', 'ants', 'uk_murakhy', 'мурахи', 'му-ра-хи', {t.animal}),
  wordUk('apron', 'apron', 'uk_fartukh', 'фартух', 'фар-тух'),
  wordUk('arc', 'arc', 'uk_arka', 'арка', 'ар-ка'),
  wordUk('arm', 'arm', 'uk_ruka', 'рука', 'ру-ка'),
  wordUk('awl', 'awl', 'uk_shylo', 'шило', 'ши-ло'),
  wordUk('axe', 'axe', 'uk_sokyra', 'сокира', 'со-ки-ра'),
  wordUk('bark', 'bark.jpg', 'uk_kora', 'кора', 'ко-ра'),
  wordUk('birch', 'birch', 'uk_bereza', 'береза', 'бе-ре-за'),
  wordUk('buddy', null, null, 'чоловіче', null),
  wordUk('calf', 'calf', 'uk_telja', 'теля', 'те-ля'),
  wordUk('cheese', 'cheese', 'uk_syr', 'сир', 'сир'),
  wordUk('cheetah', 'cheetah', 'uk_hepard', 'гепард', 'ге-пард'),
  wordUk('coat', 'coat', 'uk_shuba', 'шуба', 'шу-ба'),
  wordUk('cow', 'cow', 'uk_korova', 'корова', 'ко-ро-ва', {t.domesticAnimal}),
  wordUk('crown', 'crown', 'uk_korona', 'корона', 'ко-ро-на'),
  wordUk('cuckoo', 'cuckoo', 'uk_zozulja', 'зозуля', 'зо-зу-ля'),
  wordUk('cupboard', 'cupboard', 'uk_shafa', 'шафа', 'ша-фа'),
  wordUk('dew', 'dew', 'uk_rosa', 'роса', 'ро-са'),
  wordUk('duckling', 'duckling', 'uk_kachenia', 'каченя', 'ка-че-ня'),
  wordUk('ear', 'ear', 'uk_vukho', 'вухо', 'ву-хо'),
  wordUk('egg', 'egg', 'uk_yaitse', 'яйце', 'яй-це'),
  wordUk('emu', 'emu', 'uk_emu', 'ему', 'е-му'),
  wordUk('eye', 'eye', 'uk_oko', 'око', 'о-ко'),
  wordUk('eyes', 'eyes', 'uk_ochi', 'очі', 'о-чі'),
  wordUk('fairy', 'fairy', 'uk_feja', 'фея', 'фе-я'),
  wordUk('feather', 'feather', 'uk_pero', 'перо', 'пе-ро'),
  wordUk('fieldmark', 'fieldmark.jpg', 'uk_pole', 'поле', 'по-ле'),
  wordUk('fish', 'fish', 'uk_ryba', 'риба', 'ри-ба'),
  wordUk('fly', 'fly', 'uk_mukha', 'муха', 'му-ха'),
  wordUk('foal', 'foal', 'uk_losha', 'лоша', 'ло-ша'),
  wordUk('foam', 'foam', 'uk_pina', 'піна', 'пі-на'),
  wordUk('food', 'food', 'uk_yizha', 'їжа', 'ї-жа'),
  wordUk('fox', 'fox', 'uk_lysytsja', 'лисиця', 'ли-си-ця'),
  wordUk('frame', 'frame.jpg', 'uk_rama', 'рама', 'ра-ма'),
  wordUk('frog', 'frog', 'uk_zhaba', 'жаба', 'жа-ба'),
  wordUk('gate', 'gate', 'uk_vorota', 'ворота', 'во-ро-та'),
  wordUk('geese', 'geese', 'uk_husy', 'гуси', 'гу-си'),
  wordUk('giraffe', 'giraffe', 'uk_zhyrafa', 'жирафа', 'жи-ра-фа'),
  wordUk('goat', 'goat', 'uk_koza', 'коза', 'ко-за'),
  wordUk('guitar', 'guitar', 'uk_hitara', 'гітара', 'гі-та-ра'),
  wordUk('horns', 'horns', null, 'роги', 'ро-ги'),
  wordUk('icecream', 'icecream', 'uk_morozyvo', 'морозиво', 'мо-ро-зи-во'),
  wordUk('jelly', 'jelly', 'uk_zhele', 'желе', 'же-ле'),
  wordUk('kettlebell', 'kettlebell', 'uk_hyrja', 'гиря', 'ги-ря'),
  wordUk('kitten', 'kitten', 'uk_koshenia', 'кошеня', 'ко-ше-ня'),
  wordUk('kiwi', 'kiwi', 'uk_kivi', 'ківі', 'кі-ві'),
  wordUk('knife', 'knife', 'uk_nizh', 'ніж', 'ніж'),
  wordUk('leg', 'leg', 'uk_noha', 'нога', 'но-га'),
  wordUk('lemon', 'lemon', 'uk_lymon', 'лимон', 'ли-мон'),
  wordUk('marten', 'marten', 'uk_kunytsja', 'куниця', 'ку-ни-ця'),
  // wordUk('marlin', 'marlin', null, 'риба-меч', 'ри-ба-меч'),
  wordUk('mouth', 'mouth', 'uk_rot', 'рот', 'рот'),
  wordUk('owl', ':🦉', 'uk_sova', 'сова', 'сова'),
  wordUk('peregrine', 'peregrine', null, 'сапсан', 'сап-сан'),
  wordUk('river', 'river', 'uk_richka', 'ріка', 'рі-ка'),
  wordUk('wheel', ':🎡', 'uk_koleso', 'колесо', 'колесо'),
  wordUk('yoga', 'yoga', 'uk_yoha', 'йога', 'йо-га'),
];

final ukEnWordBank = WordBank([
  // дві мови (або три): один концепт, кілька форм
  words(
    'dog',
    'dog',
    [uk('uk_pes', 'пес', null), en('en_dog', 'dog')],
    {t.animal, t.domesticAnimal},
  ),
]);
