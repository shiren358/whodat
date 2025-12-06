import 'dart:math';
import 'package:flutter/foundation.dart';

import '../models/person.dart';
import '../models/meeting_record.dart';
import '../services/person_storage.dart';
import '../services/meeting_record_storage.dart';

class DummyDataGenerator {
  static const List<String> _avatarColors = [
    '#4D6FFF',
    '#9B72FF',
    '#FF6B9D',
    '#FF6F00',
    '#00D4AA',
    '#607D8B',
  ];

  // Realistic Japanese names
  static const List<String> _surnames = [
    '佐藤',
    '鈴木',
    '高橋',
    '田中',
    '伊藤',
    '渡辺',
    '山本',
    '中村',
    '小林',
    '加藤',
    '吉田',
    '山田',
    '佐々木',
    '山口',
    '松本',
    '井上',
    '木村',
    '林',
    '斎藤',
    '清水',
    '岡田',
    '森',
    '橋本',
    '池田',
    '阿部',
    '石川',
    '山下',
    '中島',
    '前田',
    '藤井',
    '小川',
    '後藤',
    '長谷川',
    '近藤',
    '村上',
    '遠藤',
    '坂本',
    '石井',
    '青木',
    '藤田',
    '西村',
    '福田',
    '太田',
    '三浦',
    '岡本',
    '中川',
    '藤原',
    '松田',
    '斎藤',
    '金子',
  ];

  static const List<String> _givenNames = [
    '誠',
    '大輝',
    '翔太',
    '拓也',
    '雄大',
    '健太',
    '涼介',
    '海斗',
    '裕樹',
    '大介',
    '智也',
    '陽一',
    '拓実',
    '航平',
    '亮',
    '駿',
    '結衣',
    '美咲',
    '陽子',
    '恵子',
    '由美',
    '香織',
    'あかり',
    'さくら',
    '葵',
    '美月',
    '凛',
    '愛子',
    '久美子',
    '雅子',
    '浩',
    '勉',
    '稔',
    '剛',
    '健一',
    '正樹',
    '和也',
    '悠',
    '和彦',
    '修一',
    '久美',
    '智子',
    '裕子',
    '和子',
    '洋子',
    '明子',
    '道子',
    '昌子',
    '恵美',
    '千春',
  ];

  // Real Japanese companies and fictional ones
  static const List<String> _companies = [
    'トヨタ自動車',
    '本田技研工業',
    '日産自動車',
    'ソニー',
    'パナソニック',
    '日立製作所',
    '東芝',
    '三菱電機',
    'NTTドコモ',
    'KDDI',
    'ソフトバンク',
    '楽天グループ',
    '三菱UFJ銀行',
    '三井住友銀行',
    'みずほ銀行',
    '東京海上日動',
    '第一生命保険',
    '日本郵便',
    'JR東日本',
    'JR東海',
    'ANA',
    'JAL',
    '伊藤忠商事',
    '三菱商事',
    '三井物産',
    '住友商事',
    '丸紅',
    '武田薬品',
    'アステラス製薬',
    '第一三共',
    '資生堂',
    '花王',
    'ユニリーバ・ジャパン',
    'P&Gジャパン',
    'キリン',
    'アサヒビール',
    'サントリー',
    '日本烟草産業',
    'ゼンショー',
    'すき家',
    'ワタミ',
    'サイバーエージェント',
    'メルカリ',
    'LINE',
    'Yahoo! JAPAN',
    'Google',
    'Amazon Japan',
    'Microsoft Japan',
    '富士通',
    'NEC',
    'シャープ',
    '京セラ',
    '村田製作所',
    '日本電気',
    '日清食品',
    '明治',
    '雪印メグミルク',
    'ヤクルト',
    '東京電力',
    '関西電力',
    '中部電力',
    '東北電力',
    '九州電力',
    '北海道電力',
    '四国電力',
    '任天堂',
    'バンダイナムコ',
    'スクウェア・エニックス',
    'カプコン',
    'コーエーテクモ',
    'セガ',
    '日本通信',
    'テクノロジ・イノベーション・コンサルティング',
    'グローバル・ビジネス・ソリューションズ',
    '未来創造エンジニアリング',
    'デジタル・トランスフォーメーション・パートナーズ',
  ];

  static const List<String> _positions = [
    '代表取締役',
    '専務取締役',
    '常務取締役',
    '取締役',
    '事業部長',
    '部長',
    '室長',
    '課長',
    'グループリーダー',
    'シニアマネージャー',
    'マネージャー',
    'シニアエンジニア',
    'リードエンジニア',
    'エンジニア',
    'シニアコンサルタント',
    'コンサルタント',
    'アソシエイト',
    'アナリスト',
    'シニアデザイナー',
    'リードデザイナー',
    'デザイナー',
    'プロジェクトマネージャー',
    'プロダクトマネージャー',
    'プロデューサー',
    'ディレクター',
    'シニアディレクター',
    'アーキテクト',
    'シニアアーキテクト',
    '営業部長',
    '営業課長',
    'シニア営業',
    '営業担当',
    'マーケティング部長',
    'マーケティングマネージャー',
    'プロダクトマーケティングマネージャー',
    '人事部長',
    '人事課長',
    '採用担当',
    '教育担当',
    '財務部長',
    '経理課長',
    '事業企画部長',
    '事業企画課長',
    '新規事業担当',
    'イノベーション担当',
    '研究所長',
    '研究員',
    '開発責任者',
    '技術顧問',
    '顧問',
    'シニアアドバイザー',
  ];

  static const List<String> _tags = [
    'マーケティング',
    '営業',
    'コンサルティング',
    '企画',
    '経営戦略',
    '新規事業',
    'イノベーション',
    'DX',
    'AI',
    '機械学習',
    'データサイエンス',
    'IoT',
    'ブロックチェーン',
    'FinTech',
    'HealthTech',
    'EdTech',
    'Web3',
    'メタバース',
    'SaaS',
    'クラウド',
    'インフラ',
    'セキュリティ',
    'UI/UX',
    'プロダクトデザイン',
    'アプリ開発',
    'Web開発',
    'モバイル',
    'フロントエンド',
    'バックエンド',
    'フルスタック',
    'Java',
    'Python',
    'JavaScript',
    'TypeScript',
    'React',
    'Vue.js',
    'Angular',
    'Node.js',
    'Django',
    'Ruby on Rails',
    'Go',
    'Kotlin',
    'Swift',
    'AWS',
    'GCP',
    'Azure',
    'Docker',
    'Kubernetes',
    'CI/CD',
    'Agile',
    'Scrum',
    'プロジェクトマネジメント',
    'リーダーシップ',
    'チームビルディング',
    'コミュニケーション',
    'プレゼンテーション',
    'ファシリテーション',
    'コーチング',
    'メンタリング',
    '人事',
    '採用',
    '組織開発',
    '研修',
    '労務',
    '財務',
    '経理',
    '法務',
    '知的財産',
    '特許',
    '事業開発',
    'アライアンス',
    'パートナーシップ',
    'グローバル',
    '英語',
    '中国語',
    '韓国語',
    '貿易',
    'サプライチェーン',
    '物流',
    '小売',
    'EC',
    '店舗開発',
    'ブランディング',
    '広告',
    'PR',
    'SNS',
    'コンテンツマーケティング',
    'SEO',
    '動画制作',
    'ライティング',
    '編集',
    'カメラ',
    'デザイン',
    'イラスト',
    'DTP',
    '医療',
    '製薬',
    'バイオ',
    '化学',
    '材料',
    '電子',
    '機械',
    '自動車',
    '航空',
    'エネルギー',
    '環境',
    'サステナビリティ',
    '農業',
    '食品',
    '不動産',
    '建築',
    '建設',
  ];

  // Realistic meeting locations in Japan
  static const List<Map<String, dynamic>> _meetingLocations = [
    // Tokyo Central - Major stations with GPS
    {'name': '東京駅丸の内', 'lat': 35.6812362, 'lng': 139.7671248, 'type': 'gps'},
    {'name': '渋谷駅周辺', 'lat': 35.6580339, 'lng': 139.7016358, 'type': 'gps'},
    {'name': '新宿駅周辺', 'lat': 35.690921, 'lng': 139.700258, 'type': 'gps'},
    {'name': '品川駅周辺', 'lat': 35.628669, 'lng': 139.73344, 'type': 'gps'},
    {'name': '池袋駅周辺', 'lat': 35.729402, 'lng': 139.710264, 'type': 'gps'},
    {'name': '上野駅周辺', 'lat': 35.714765, 'lng': 139.777439, 'type': 'gps'},
    {'name': '秋葉原電気街', 'lat': 35.702222, 'lng': 139.774444, 'type': 'gps'},
    {'name': '銀座中央通り', 'lat': 35.671733, 'lng': 139.765095, 'type': 'gps'},
    {'name': '六本木ヒルズ', 'lat': 35.660378, 'lng': 139.729246, 'type': 'gps'},
    {'name': '赤坂', 'lat': 35.68506, 'lng': 139.735716, 'type': 'gps'},
    {'name': '霞が関', 'lat': 35.685197, 'lng': 139.751651, 'type': 'gps'},
    {'name': '丸の内', 'lat': 35.674828, 'lng': 139.763057, 'type': 'gps'},
    {'name': '大手町', 'lat': 35.677553, 'lng': 139.764306, 'type': 'gps'},
    {'name': '日本橋', 'lat': 35.678211, 'lng': 139.775483, 'type': 'gps'},
    {'name': '神田', 'lat': 35.703596, 'lng': 139.763219, 'type': 'gps'},
    {'name': '水道橋', 'lat': 35.691529, 'lng': 139.770889, 'type': 'gps'},
    {'name': '飯田橋', 'lat': 35.6984, 'lng': 139.6944, 'type': 'gps'},
    {'name': '高田馬場', 'lat': 35.703732, 'lng': 139.706142, 'type': 'gps'},
    {'name': '目黒', 'lat': 35.643989, 'lng': 139.700611, 'type': 'gps'},
    {'name': '五反田', 'lat': 35.626834, 'lng': 139.728463, 'type': 'gps'},
    {'name': '恵比寿', 'lat': 35.645397, 'lng': 139.725483, 'type': 'gps'},
    {'name': '大崎', 'lat': 35.62877, 'lng': 139.69967, 'type': 'gps'},
    {'name': '蒲田', 'lat': 35.56566, 'lng': 139.648887, 'type': 'gps'},
    {'name': '羽田空港第1ターミナル', 'lat': 35.549355, 'lng': 139.783706, 'type': 'gps'},
    {'name': '羽田空港第2ターミナル', 'lat': 35.549558, 'lng': 139.796762, 'type': 'gps'},
    {'name': '羽田空港第3ターミナル', 'lat': 35.549751, 'lng': 139.796855, 'type': 'gps'},
    {'name': 'お台場', 'lat': 35.658952, 'lng': 139.745789, 'type': 'gps'},
    {'name': '有楽町', 'lat': 35.674222, 'lng': 139.762916, 'type': 'gps'},
    {'name': '東京ミッドタウン', 'lat': 35.665444, 'lng': 139.730697, 'type': 'gps'},
    {'name': '表参道', 'lat': 35.665441, 'lng': 139.712796, 'type': 'gps'},
    {'name': '六本木アートセンター', 'lat': 35.662919, 'lng': 139.728947, 'type': 'gps'},
    {'name': '国立新美術館', 'lat': 35.714729, 'lng': 139.775617, 'type': 'gps'},
    {'name': '森美術館', 'lat': 35.66043, 'lng': 139.694656, 'type': 'gps'},
    {'name': '東京タワー', 'lat': 35.658581, 'lng': 139.745433, 'type': 'gps'},
    {'name': 'スカイツリー', 'lat': 35.658404, 'lng': 139.691708, 'type': 'gps'},
    {'name': '東京ドーム', 'lat': 35.705652, 'lng': 139.7516, 'type': 'gps'},
    {'name': '日本武道館', 'lat': 35.703716, 'lng': 139.727221, 'type': 'gps'},
    {'name': '両国国技館', 'lat': 35.716638, 'lng': 139.698682, 'type': 'gps'},
    {'name': '後楽園ホール', 'lat': 35.712264, 'lng': 139.7784279, 'type': 'gps'},
    {'name': '東京国際フォーラム', 'lat': 35.632111, 'lng': 139.803056, 'type': 'gps'},
    {'name': '幕張メッセ国際展示場', 'lat': 35.642986, 'lng': 140.004677, 'type': 'gps'},
    {'name': 'パシフィコ横浜', 'lat': 35.463822, 'lng': 139.629033, 'type': 'gps'},
    {'name': '横浜アリーナ', 'lat': 35.463821, 'lng': 139.629034, 'type': 'gps'},
    {'name': '横浜ランドマークタワー', 'lat': 35.455657, 'lng': 139.629601, 'type': 'gps'},
    {'name': '横浜クイーンズスクエア', 'lat': 35.455653, 'lng': 139.629597, 'type': 'gps'},
    {'name': '横浜駅', 'lat': 35.465758, 'lng': 139.622762, 'type': 'gps'},
    {'name': '川崎駅', 'lat': 35.532, 'lng': 139.699478, 'type': 'gps'},
    {'name': '菊名駅', 'lat': 35.4648, 'lng': 139.6272, 'type': 'gps'},
    {'name': '武蔵小杉駅', 'lat': 35.5674, 'lng': 139.6511, 'type': 'gps'},
    {'name': '溝の口駅', 'lat': 35.6017, 'lng': 139.5289, 'type': 'gps'},
    {'name': '自由が丘駅', 'lat': 35.6036, 'lng': 139.5274, 'type': 'gps'},
    {'name': '中野駅', 'lat': 35.7082, 'lng': 139.6656, 'type': 'gps'},
    {'name': '高円寺駅', 'lat': 35.6622, 'lng': 139.6487, 'type': 'gps'},
    {'name': '吉祥寺駅', 'lat': 35.6745, 'lng': 139.6401, 'type': 'gps'},
    {'name': '明大前駅', 'lat': 35.6973, 'lng': 139.6573, 'type': 'gps'},
    {'name': '下北沢駅', 'lat': 35.6438, 'lng': 139.6583, 'type': 'gps'},
    {'name': '成城学園前駅', 'lat': 35.681, 'lng': 139.6767, 'type': 'gps'},
    {'name': '調布駅', 'lat': 35.6445, 'lng': 139.6506, 'type': 'gps'},
    {'name': '八王子駅', 'lat': 35.6565, 'lng': 139.3486, 'type': 'gps'},
    {'name': '立川駅', 'lat': 35.6970, 'lng': 139.4186, 'type': 'gps'},
    {'name': '府中駅', 'lat': 35.6975, 'lng': 139.4811, 'type': 'gps'},
    {'name': '東京都庁', 'lat': 35.6851, 'lng': 139.6917, 'type': 'gps'},
    {'name': '国会議事堂', 'lat': 35.6755, 'lng': 139.7465, 'type': 'gps'},
    {'name': '最高裁判所', 'lat': 35.7143, 'lng': 139.7498, 'type': 'gps'},
    {'name': '検察庁', 'lat': 35.6768, 'lng': 139.7514, 'type': 'gps'},
    {'name': '日本銀行本店', 'lat': 35.6894, 'lng': 139.6917, 'type': 'gps'},
    {'name': '三菱UFJ銀行本店', 'lat': 35.6778, 'lng': 139.7618, 'type': 'gps'},
    {'name': '三井住友銀行本店', 'lat': 35.6820, 'lng': 139.7264, 'type': 'gps'},
    {'name': 'みずほ銀行本店', 'lat': 35.6805, 'lng': 139.7693, 'type': 'gps'},

    // Osaka area
    {'name': '梅田駅', 'lat': 34.702485, 'lng': 135.495951, 'type': 'gps'},
    {'name': '大阪駅', 'lat': 34.702485, 'lng': 135.495951, 'type': 'gps'},
    {'name': 'なんば駅', 'lat': 34.66684, 'lng': 135.72639, 'type': 'gps'},
    {'name': '難波駅', 'lat': 34.66684, 'lng': 135.72639, 'type': 'gps'},
    {'name': '心斎橋駅', 'lat': 34.67674, 'lng': 135.49981, 'type': 'gps'},
    {'name': '淀屋橋駅', 'lat': 34.67674, 'lng': 135.76496, 'type': 'gps'},
    {'name': '京橋駅', 'lat': 34.67674, 'lng': 135.76496, 'type': 'gps'},
    {'name': '北新地駅', 'lat': 34.6956, 'lng': 135.50966, 'type': 'gps'},
    {'name': '天満橋駅', 'lat': 34.6956, 'lng': 135.50966, 'type': 'gps'},
    {'name': '淡路駅', 'lat': 34.7366, 'lng': 135.4182, 'type': 'gps'},
    {'name': '尼崎駅', 'lat': 34.7366, 'lng': 135.4182, 'type': 'gps'},
    {'name': '堺駅', 'lat': 34.5819, 'lng': 135.4812, 'type': 'gps'},
    {'name': '天王寺駅', 'lat': 34.6535, 'lng': 135.5146, 'type': 'gps'},
    {'name': '住吉大社', 'lat': 34.6535, 'lng': 135.5146, 'type': 'gps'},
    {'name': '四天王寺', 'lat': 34.6535, 'lng': 135.5146, 'type': 'gps'},
    {'name': '大阪城公園', 'lat': 34.6872, 'lng': 135.5252, 'type': 'gps'},
    {'name': '梅田スカイビル', 'lat': 34.6982, 'lng': 135.4957, 'type': 'gps'},
    {'name': 'あべのハルカ', 'lat': 34.6982, 'lng': 135.4957, 'type': 'gps'},
    {'name': 'グランフロント大阪', 'lat': 34.6913, 'lng': 135.4961, 'type': 'gps'},
    {'name': '大阪駅前ビル', 'lat': 34.702485, 'lng': 135.495951, 'type': 'gps'},
    {'name': '淀屋橋オークタワー', 'lat': 34.6947, 'lng': 135.7642, 'type': 'gps'},
    {'name': '中之島公会堂', 'lat': 34.6916, 'lng': 135.5262, 'type': 'gps'},
    {'name': '大阪国際会議場', 'lat': 34.6939, 'lng': 135.5254, 'type': 'gps'},
    {'name': 'インテックス大阪', 'lat': 34.6939, 'lng': 135.5254, 'type': 'gps'},
    {'name': 'USJコーポー', 'lat': null, 'lng': null, 'type': 'manual'},

    // Nagoya area
    {'name': '名古屋駅', 'lat': 35.170915, 'lng': 136.881537, 'type': 'gps'},
    {'name': '名古屋城', 'lat': 35.185, 'lng': 136.898, 'type': 'gps'},
    {'name': '栄駅', 'lat': 35.170987, 'lng': 136.875972, 'type': 'gps'},
    {'name': '金山駅', 'lat': 35.169993, 'lng': 136.881909, 'type': 'gps'},
    {'name': '新名古屋駅', 'lat': 35.170915, 'lng': 136.881537, 'type': 'gps'},
    {'name': '熱田駅', 'lat': 35.1675, 'lng': 136.8926, 'type': 'gps'},
    {'name': '名古屋港', 'lat': 35.1162, 'lng': 136.8745, 'type': 'gps'},
    {'name': '鶴舞公園', 'lat': 35.181, 'lng': 136.9, 'type': 'gps'},
    {'name': '大須観音寺', 'lat': 35.1944, 'lng': 136.9026, 'type': 'gps'},
    {'name': '名古屋市役所', 'lat': 35.1803, 'lng': 136.9066, 'type': 'gps'},
    {'name': '愛知県庁', 'lat': 35.1803, 'lng': 136.9066, 'type': 'gps'},
    {'name': '名古屋国際会議場', 'lat': 35.155, 'lng': 136.923, 'type': 'gps'},
    {'name': '名古屋ドーム', 'lat': 35.186, 'lng': 136.909, 'type': 'gps'},

    // Kyoto area
    {'name': '京都駅', 'lat': 34.985837, 'lng': 135.758653, 'type': 'gps'},
    {'name': '京都御所', 'lat': 35.025431, 'lng': 135.775219, 'type': 'gps'},
    {'name': '四条烏丸', 'lat': 35.003997, 'lng': 135.767756, 'type': 'gps'},
    {'name': '三条京阪', 'lat': 35.003997, 'lng': 135.767756, 'type': 'gps'},
    {'name': '烏丸', 'lat': 35.0053, 'lng': 135.7687, 'type': 'gps'},
    {'name': '河原町', 'lat': 35.0051, 'lng': 135.7756, 'type': 'gps'},
    {'name': '祇園', 'lat': 35.0039, 'lng': 135.7778, 'type': 'gps'},
    {'name': '清水坂', 'lat': 35.0078, 'lng': 135.784, 'type': 'gps'},
    {'name': '金閣寺', 'lat': 35.0394, 'lng': 135.7292, 'type': 'gps'},
    {'name': '銀閣寺', 'lat': 35.0278, 'lng': 135.7702, 'type': 'gps'},
    {'name': '嵐山', 'lat': 35.0249, 'lng': 135.6746, 'type': 'gps'},
    {'name': '嵯峨野', 'lat': 35.0205, 'lng': 135.6726, 'type': 'gps'},
    {'name': '伏見稲荷大社', 'lat': 34.9671, 'lng': 135.7725, 'type': 'gps'},
    {'name': '平安神宮', 'lat': 35.0166, 'lng': 135.7646, 'type': 'gps'},
    {'name': '東寺', 'lat': 35.0276, 'lng': 135.7745, 'type': 'gps'},
    {'name': '二条城', 'lat': 35.0142, 'lng': 135.7515, 'type': 'gps'},
    {'name': '錦市場', 'lat': 35.0142, 'lng': 135.7515, 'type': 'gps'},

    // Other major cities
    {'name': '福岡駅', 'lat': 33.590247, 'lng': 130.401716, 'type': 'gps'},
    {'name': '博多駅', 'lat': 33.590247, 'lng': 130.401716, 'type': 'gps'},
    {'name': '天神駅', 'lat': 33.590247, 'lng': 130.401716, 'type': 'gps'},
    {'name': 'キャナルシティ博多', 'lat': 33.59065, 'lng': 130.4205, 'type': 'gps'},
    {'name': '福岡ドーム', 'lat': 33.5905, 'lng': 130.4114, 'type': 'gps'},
    {'name': '福岡市役所', 'lat': 33.6065, 'lng': 130.4181, 'type': 'gps'},

    {'name': '札幌駅', 'lat': 43.06417, 'lng': 141.34694, 'type': 'gps'},
    {'name': 'すすきの', 'lat': 43.06417, 'lng': 141.34694, 'type': 'gps'},
    {'name': 'サッポロタワー', 'lat': 43.0678, 'lng': 141.3514, 'type': 'gps'},
    {'name': '札幌ドーム', 'lat': 43.06417, 'lng': 141.34694, 'type': 'gps'},
    {'name': '中島公園', 'lat': 43.0641, 'lng': 141.3511, 'type': 'gps'},
    {'name': '大通公園', 'lat': 43.0582, 'lng': 141.3504, 'type': 'gps'},
    {'name': '北海道道庁', 'lat': 43.0642, 'lng': 141.3524, 'type': 'gps'},

    {'name': '仙台駅', 'lat': 38.260297, 'lng': 140.882584, 'type': 'gps'},
    {'name': '勾当台公園', 'lat': 38.2406, 'lng': 140.8721, 'type': 'gps'},
    {'name': '瑞鳳殿', 'lat': 38.2625, 'lng': 140.8734, 'type': 'gps'},
    {'name': '松島', 'lat': 38.2616, 'lng': 140.4051, 'type': 'gps'},
    {'name': '仙台市役所', 'lat': 38.2687, 'lng': 140.4426, 'type': 'gps'},
    {'name': '広島駅', 'lat': 34.3969, 'lng': 132.475324, 'type': 'gps'},
    {'name': '広島城', 'lat': 34.396524, 'lng': 132.475324, 'type': 'gps'},
    {'name': '基町', 'lat': 34.396524, 'lng': 132.475324, 'type': 'gps'},
    {'name': '紙屋町', 'lat': 34.396524, 'lng': 132.475324, 'type': 'gps'},
    {'name': '広島市役所', 'lat': 34.3965, 'lng': 132.475324, 'type': 'gps'},

    {'name': '新潟駅', 'lat': 37.9134, 'lng': 138.556, 'type': 'gps'},
    {'name': '万代橋', 'lat': 37.9099, 'lng': 138.5981, 'type': 'gps'},
    {'name': '古町', 'lat': 37.9019, 'lng': 138.5787, 'type': 'gps'},
    {'name': '白山公園', 'lat': 37.9136, 'lng': 138.624, 'type': 'gps'},

    {'name': '金沢駅', 'lat': 36.5785, 'lng': 136.6455, 'type': 'gps'},
    {'name': '兼六園', 'lat': 36.5785, 'lng': 136.6455, 'type': 'gps'},
    {'name': '香林坊', 'lat': 36.5785, 'lng': 136.6455, 'type': 'gps'},
    {'name': '金沢城公園', 'lat': 36.5785, 'lng': 136.6455, 'type': 'gps'},

    // Airports
    {'name': '成田空港第1ターミナル', 'lat': 35.763811, 'lng': 140.066553, 'type': 'gps'},
    {'name': '成田空港第2ターミナル', 'lat': 35.765063, 'lng': 140.386494, 'type': 'gps'},
    {'name': '成田空港第3ターミナル', 'lat': 35.764334, 'lng': 140.386698, 'type': 'gps'},
    {'name': '伊丹空港', 'lat': 34.7855, 'lng': 135.4424, 'type': 'gps'},
    {'name': '関西国際空港', 'lat': 34.4273, 'lng': 135.2440, 'type': 'gps'},
    {'name': '中部国際空港', 'lat': 34.8584, 'lng': 136.8055, 'type': 'gps'},
    {'name': '福岡空港', 'lat': 33.5768, 'lng': 130.4549, 'type': 'gps'},
    {'name': '新千歳空港', 'lat': 42.7752, 'lng': 141.692, 'type': 'gps'},
    {'name': '仙台空港', 'lat': 38.7964, 'lng': 140.9465, 'type': 'gps'},
    {'name': '広島空港', 'lat': 34.4336, 'lng': 132.9214, 'type': 'gps'},
    {'name': '北九州空港', 'lat': 33.8584, 'lng': 130.4515, 'type': 'gps'},
    {'name': '鹿児島空港', 'lat': 31.8036, 'lng': 130.5562, 'type': 'gps'},
    {'name': '那覇空港', 'lat': 26.2281, 'lng': 127.6761, 'type': 'gps'},

    // Major hotels and conference centers
    {'name': '帝国ホテル', 'lat': 35.68506, 'lng': 139.75606, 'type': 'manual'},
    {'name': 'ホテルオークラ', 'lat': 35.68145, 'lng': 139.764405, 'type': 'manual'},
    {'name': 'ホテルニューオータニ', 'lat': 35.67326, 'lng': 139.76986, 'type': 'manual'},
    {'name': 'コンラッド東京', 'lat': 35.68161, 'lng': 139.69840, 'type': 'manual'},
    {'name': 'ヒルトン東京', 'lat': 35.67333, 'lng': 139.6912, 'type': 'manual'},
    {'name': 'ホテル日航東京', 'lat': 35.67616, 'lng': 139.69022, 'type': 'manual'},
    {'name': 'ザ・ペニンシュラ東京', 'lat': 35.67705, 'lng': 139.76788, 'type': 'manual'},
    {'name': 'シャングリ・ラ東京', 'lat': 35.68598, 'lng': 139.76405, 'type': 'manual'},
    {
      'name': 'ザ・リッツ・カールトン東京',
      'lat': 35.6738,
      'lng': 139.7300,
      'type': 'manual',
    },
    {'name': '安藤・ヒューム美術館', 'lat': 35.6582, 'lng': 139.7106, 'type': 'manual'},
    {'name': 'サントリー美術館', 'lat': 35.6584, 'lng': 139.7108, 'type': 'manual'},
    {'name': 'サンリオプリンス', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': '品川プリンスホテル', 'lat': 35.62849, 'lng': 139.73425, 'type': 'manual'},
    {'name': '新高輪プリンスホテル', 'lat': 35.5839, 'lng': 139.6542, 'type': 'manual'},
    {'name': '横浜ベイホテル', 'lat': 35.4446, 'lng': 139.6387, 'type': 'manual'},
    {'name': '横浜ロイヤルパークホテル', 'lat': 35.4557, 'lng': 139.6210, 'type': 'manual'},
    {'name': '京都ステーションホテル', 'lat': 35.69834, 'lng': 135.7611, 'type': 'manual'},
    {'name': '京都ヒルトン', 'lat': 35.7622, 'lng': 135.7681, 'type': 'manual'},
    {'name': '大阪リッカーロテル', 'lat': 34.6934, 'lng': 135.5014, 'type': 'manual'},
    {'name': 'ニューオータニ大阪', 'lat': 34.6947, 'lng': 135.5018, 'type': 'manual'},
    {'name': '名古屋ヒルトン', 'lat': 35.1742, 'lng': 136.8855, 'type': 'manual'},
    {
      'name': '名古屋ロイヤルパークホテル',
      'lat': 35.1744,
      'lng': 136.8855,
      'type': 'manual',
    },

    // Universities
    {'name': '東京大学', 'lat': 35.7129, 'lng': 139.7611, 'type': 'manual'},
    {'name': '早稲田大学', 'lat': 35.7125, 'lng': 139.7916, 'type': 'manual'},
    {'name': '慶應義塾大学', 'lat': 35.6859, 'lng': 139.703, 'type': 'manual'},
    {'name': '明治大学', 'lat': 35.7022, 'lng': 139.7146, 'type': 'manual'},
    {'name': '立教大学', 'lat': 35.7141, 'lng': 139.7197, 'type': 'manual'},
    {'name': '青山学院大学', 'lat': 35.6849, 'lng': 139.7216, 'type': 'manual'},
    {'name': '学習院大学', 'lat': 35.6814, 'lng': 139.7314, 'type': 'manual'},
    {'name': '日本女子大学', 'lat': 35.3308, 'lng': 139.6766, 'type': 'manual'},
    {'name': 'お茶の水女子大学', 'lat': 35.7179, 'lng': 139.7162, 'type': 'manual'},
    {'name': '一橋大学', 'lat': 35.6818, 'lng': 139.7627, 'type': 'manual'},
    {'name': '東京工業大学', 'lat': 35.6818, 'lng': 139.6862, 'type': 'manual'},
    {'name': '東京外国語大学', 'lat': 35.6983, 'lng': 139.7314, 'type': 'manual'},
    {'name': '京都大学', 'lat': 35.0252, 'lng': 135.783, 'type': 'manual'},
    {'name': '大阪大学', 'lat': 34.6913, 'lng': 135.5146, 'type': 'manual'},
    {'name': '東北大学', 'lat': 41.0, 'lng': 140.8263, 'type': 'manual'},
    {'name': '北海道大学', 'lat': 43.0708, 'lng': 141.349, 'type': 'manual'},
    {'name': '九州大学', 'lat': 33.5805, 'lng': 130.2152, 'type': 'manual'},
    {'name': '広島大学', 'lat': 34.3941, 'lng': 132.4751, 'type': 'manual'},
    {'name': '神戸大学', 'lat': 34.6913, 'lng': 135.191, 'type': 'manual'},
    {'name': '筑波大学', 'lat': 36.111, 'lng': 140.0933, 'type': 'manual'},
    {'name': '千葉大学', 'lat': 35.605, 'lng': 140.1233, 'type': 'manual'},
    {'name': '横浜国立大学', 'lat': 35.461, 'lng': 139.6222, 'type': 'manual'},
    {'name': '名古屋工業大学', 'lat': 35.1508, 'lng': 136.8855, 'type': 'manual'},
    {'name': '京都工芸繊維大学', 'lat': 35.0142, 'lng': 135.7687, 'type': 'manual'},
    {'name': '大阪市立大学', 'lat': 34.6949, 'lng': 135.5187, 'type': 'manual'},
    {'name': '青山学院大学', 'lat': 35.6849, 'lng': 139.7216, 'type': 'manual'},
    {
      'name': '慶應義塾大学三田キャンパス',
      'lat': 35.1822,
      'lng': 139.7144,
      'type': 'manual',
    },
    {'name': '早稲田大学', 'lat': 35.6914, 'lng': 139.7005, 'type': 'manual'},
    {'name': '東京大学大学院', 'lat': 35.7141, 'lng': 139.7217, 'type': 'manual'},

    // Medical facilities
    {'name': '東京大学医学部付属病院', 'lat': 35.6997, 'lng': 139.7616, 'type': 'manual'},
    {'name': '慶應義塾大学病院', 'lat': 35.6838, 'lng': 139.7046, 'type': 'manual'},
    {'name': '東京医科大学病院', 'lat': 35.6997, 'lng': 139.7616, 'type': 'manual'},
    {'name': '順天堂大学医学部付属病院', 'lat': 35.7143, 'lng': 139.7295, 'type': 'manual'},
    {'name': '日本医科大学付属病院', 'lat': 35.6997, 'lng': 139.7616, 'type': 'manual'},
    {'name': '虎の門病院', 'lat': 35.7269, 'lng': 139.7245, 'type': 'manual'},
    {'name': '聖路加国際病院', 'lat': 35.6765, 'lng': 139.7189, 'type': 'manual'},
    {'name': '癌研究会病院', 'lat': 35.6818, 'lng': 139.7355, 'type': 'manual'},
    {'name': '国立がん研究センター', 'lat': 35.6819, 'lng': 139.7355, 'type': 'manual'},
    {'name': '大阪大学医学部付属病院', 'lat': 34.6861, 'lng': 135.5224, 'type': 'manual'},
    {'name': '京都大学医学部付属病院', 'lat': 34.9986, 'lng': 135.7631, 'type': 'manual'},
    {'name': '名古屋大学医学部付属病院', 'lat': 35.1813, 'lng': 136.9251, 'type': 'manual'},

    // Business districts
    {'name': '虎ノ門ヒルズ駅', 'lat': 35.6774, 'lng': 139.7657, 'type': 'manual'},
    {'name': '溜池山王', 'lat': 35.6815, 'lng': 139.6422, 'type': 'manual'},
    {'name': '神谷町駅', 'lat': 35.6838, 'lng': 139.7358, 'type': 'manual'},
    {'name': '霞が関駅', 'lat': 35.6852, 'lng': 139.7516, 'type': 'manual'},
    {'name': '大手町駅', 'lat': 35.6817, 'lng': 139.7663, 'type': 'manual'},
    {'name': '九段下駅', 'lat': 35.6934, 'lng': 139.7571, 'type': 'manual'},
    {'name': '飯田橋駅', 'lat': 35.6984, 'lng': 139.6944, 'type': 'manual'},
    {'name': '西新宿', 'lat': 35.6894, 'lng': 139.6916, 'type': 'manual'},
    {'name': '四ツ谷', 'lat': 35.6823, 'lng': 139.7314, 'type': 'manual'},
    {'name': '永田町', 'lat': 35.6819, 'lng': 139.7264, 'type': 'manual'},
    {'name': '半蔵門', 'lat': 35.6869, 'lng': 139.7311, 'type': 'manual'},
    {'name': '神保町', 'lat': 35.6922, 'lng': 139.7649, 'type': 'manual'},
    {'name': '霞が関ビルディング', 'lat': 35.6815, 'lng': 139.7516, 'type': 'manual'},
    {'name': '霞が関3丁目ビル', 'lat': 35.6852, 'lng': 139.7516, 'type': 'manual'},
    {'name': '霞が関ビル', 'lat': 35.6852, 'lng': 139.7516, 'type': 'manual'},
    {'name': '毎日新聞社', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': '読売新聞社', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': '朝日新聞社', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': '日本経済新聞社', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': '産経新聞社', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': '日本放送協会', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': 'テレビ東京', 'lat': 35.6585, 'lng': 139.9151, 'type': 'manual'},
    {'name': 'フジテレビ', 'lat': 35.6585, 'lng': 139.9151, 'type': 'manual'},
    {'name': 'TBSテレビ', 'lat': 35.6425, 'lng': 139.7151, 'type': 'manual'},
    {'name': 'テレビ朝日', 'lat': 35.6425, 'lng': 139.7151, 'type': 'manual'},
    {'name': '日本テレビ', 'lat': 35.6585, 'lng': 139.9151, 'type': 'manual'},

    // Shopping centers and commercial areas
    {'name': '表参道ヒルズA', 'lat': 35.66544, 'lng': 139.7128, 'type': 'manual'},
    {'name': '表参道ヒルズB', 'lat': 35.6654, 'lng': 139.7128, 'type': 'manual'},
    {'name': 'シャンゼリゼ表参道', 'lat': 35.66544, 'lng': 139.7128, 'type': 'manual'},
    {'name': 'しまむら', 'lat': 35.6719, 'lng': 139.7625, 'type': 'manual'},
    {'name': 'ラフォーレ原宿', 'lat': 35.6914, 'lng': 139.7006, 'type': 'manual'},
    {'name': '西武新宿', 'lat': 35.6901, 'lng': 139.6989, 'type': 'manual'},
    {'name': '小田急百貨店新宿店', 'lat': 35.6901, 'lng': 139.6989, 'type': 'manual'},
    {'name': '京王百貨店新宿店', 'lat': 35.6914, 'lng': 139.7006, 'type': 'manual'},
    {'name': '伊勢丹新宿店', 'lat': 35.6901, 'lng': 139.7006, 'type': 'manual'},
    {'name': '髙島屋', 'lat': 35.6762, 'lng': 139.7313, 'type': 'manual'},
    {'name': '丸井', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': '松坂屋', 'lat': 35.6762, 'lng': 139.7633, 'type': 'manual'},
    {'name': 'ルミネエストカードン', 'lat': 35.6742, 'lng': 139.7633, 'type': 'manual'},
    {'name': 'アクアパーク品川', 'lat': 35.6544, 'lng': 139.8134, 'type': 'manual'},
    {'name': 'ららぽーと', 'lat': 35.6544, 'lng': 139.8134, 'type': 'manual'},
    {'name': 'イオンモール', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'Aeon Mall', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'イオンレイクス', 'lat': null, 'lng': null, 'type': 'manual'},

    // Regional business locations
    {'name': '横浜みなとみらい', 'lat': 35.4446, 'lng': 139.6373, 'type': 'manual'},
    {'name': '川崎ラゾーナ', 'lat': 35.532, 'lng': 139.6995, 'type': 'manual'},
    {'name': '品川インターシティ', 'lat': 35.62849, 'lng': 139.7342, 'type': 'manual'},
    {'name': '新宿サブナード', 'lat': 35.6914, 'lng': 139.7006, 'type': 'manual'},
    {'name': '秋葉原クロスフィールド', 'lat': 35.7022, 'lng': 139.7744, 'type': 'manual'},
    {'name': '秋葉原UDX', 'lat': 35.7018, 'lng': 139.7710, 'type': 'manual'},
    {'name': '秋葉原ダイビル', 'lat': 35.7021, 'lng': 139.7741, 'type': 'manual'},
    {'name': '台場フィリア', 'lat': 35.6589, 'lng': 139.7458, 'type': 'manual'},
    {'name': 'お台場地区開発センター', 'lat': 35.6589, 'lng': 139.7458, 'type': 'manual'},
    {'name': '葛西臨海公園', 'lat': 35.6872, 'lng': 139.7653, 'type': 'gps'},
    {'name': 'お台場海浜公園', 'lat': 35.6589, 'lng': 139.7458, 'type': 'gps'},
    {'name': '横須賀リゾート', 'lat': 35.6589, 'lng': 139.7458, 'type': 'manual'},
    {'name': '横須賀マリーナーズ', 'lat': 35.6589, 'lng': 139.7458, 'type': 'manual'},

    // Coffee chains and casual meeting spots
    {'name': 'スターバックスコーヒー', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'タリーズコーヒー', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'プロント', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'ドトールコーヒー', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'エクセルシオールカフェ', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'コメダ珈琲', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'プロント珈琲', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'ベローチェ珈琲', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'タリーズ', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': '星野リゾート', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': '西洋フード', 'lat': null, 'lng': null, 'type': 'manual'},
    {'name': 'USJコーヒー', 'lat': null, 'lng': null, 'type': 'manual'},
  ];

  static const List<String> _meetingNotes = [
    '新規事業の協力について協議',
    'プロダクトの詳細についてデモ',
    '戦略的パートナーシップの可能性を検討',
    '業界動向と今後の展望について意見交換',
    '投資案件のプレゼンテーション',
    '技術協力の具体的な方法について協議',
    'マーケティング戦略の共有',
    '人材紹介の依頼',
    '業務提携の基本合意',
    '次世代技術についての意見交換',
    '製品ロードマップの共有',
    '顧客紹介の依頼と紹介',
    '市場調査結果の共有',
    '新製品のフィードバック収集',
    'コンサルティング契約の締結',
    '共同研究開発の打ち合わせ',
    'グローバル展開について協議',
    '企業文化と組織開発について意見交換',
    '資金調達について相談',
    'M&Aの可能性について検討',
    'DX推進に関するコンサルティング',
    'サプライチェーン最適化の提案',
    '新サービスの共同開発',
    'リクルートイベントでの協力',
    '業界カンファレンスの共催',
    '新技術導入のコンサルティング',
    'ビジネスモデルの革新について議論',
    '持続可能な開発目標への取り組み',
    'データ活用戦略の立案',
  ];

  static final Random _random = Random();
  static final Set<String> _usedNameCompanyCombinations = {};
  static final Set<String> _usedLocationCombinations = {};

  static String _generateRandomId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        _random.nextInt(10000).toString();
  }

  static String _generateRandomName() {
    final surname = _surnames[_random.nextInt(_surnames.length)];
    final givenName = _givenNames[_random.nextInt(_givenNames.length)];
    return '$surname $givenName';
  }

  static String _generateUniquePersonAndCompany() {
    String? company;
    String name;
    String combination;

    do {
      name = _generateRandomName();
      company = _companies[_random.nextInt(_companies.length)];
      combination = '$name@$company';
    } while (_usedNameCompanyCombinations.contains(combination));

    _usedNameCompanyCombinations.add(combination);
    return company;
  }

  static List<String> _generateRandomTags() {
    final int tagCount = _random.nextInt(4) + 1; // 1-4 tags
    final List<String> selectedTags = [];
    final List<String> availableTags = List.from(_tags);

    for (int i = 0; i < tagCount && availableTags.isNotEmpty; i++) {
      final index = _random.nextInt(availableTags.length);
      selectedTags.add(availableTags[index]);
      availableTags.removeAt(index);
    }

    return selectedTags;
  }

  static DateTime _generateRandomDate() {
    final now = DateTime.now();
    final twoYearsAgo = DateTime(now.year - 2, now.month, now.day);

    // 日数ベースでランダムな日付を生成（より安全なアプローチ）
    final totalDays = now.difference(twoYearsAgo).inDays;
    final randomDaysBack = _random.nextInt(totalDays);

    return now.subtract(Duration(days: randomDaysBack));
  }

  static Map<String, dynamic> _generateRandomLocation() {
    Map<String, dynamic>? location;
    String locationKey;

    // Find an unused location combination
    do {
      location = _meetingLocations[_random.nextInt(_meetingLocations.length)];
      locationKey = '${location['name']}_${location['lat']}_${location['lng']}';
    } while (_usedLocationCombinations.contains(locationKey));

    _usedLocationCombinations.add(locationKey);
    return {
      'name': location['name'],
      'lat': location['lat'],
      'lng': location['lng'],
      'type': location['type'],
    };
  }

  static String? _generateRandomNote() {
    if (_random.nextDouble() < 0.7) {
      // 70% chance of having notes
      return _meetingNotes[_random.nextInt(_meetingNotes.length)];
    }
    return null;
  }

  static Person _generatePerson() {
    final id = _generateRandomId();
    final name = _generateRandomName();
    final company = _generateUniquePersonAndCompany();
    final position = _positions[_random.nextInt(_positions.length)];
    final tags = _generateRandomTags();
    final avatarColor = _avatarColors[_random.nextInt(_avatarColors.length)];

    return Person(
      id: id,
      name: name,
      company: company,
      position: position,
      tags: tags,
      avatarColor: avatarColor,
      additionalInfoCount: _random.nextInt(3),
    );
  }

  static MeetingRecord _generateMeetingRecord(
    String personId,
    DateTime meetingDate,
  ) {
    final id = _generateRandomId();
    final location = _generateRandomLocation();
    final notes = _generateRandomNote();

    return MeetingRecord(
      id: id,
      personId: personId,
      meetingDate: meetingDate,
      location: location['name'],
      notes: notes,
      latitude: location['lat'],
      longitude: location['lng'],
    );
  }

  static Future<void> generateDummyData() async {
    debugPrint('Generating 100 dummy records...');

    final List<Person> persons = [];
    final List<MeetingRecord> meetingRecords = [];

    // Generate 100 persons
    for (int i = 0; i < 100; i++) {
      final person = _generatePerson();
      persons.add(person);

      // Generate 1-3 meeting records per person
      final int meetingCount = _random.nextInt(3) + 1;
      final List<DateTime> meetingDates = [];

      for (int j = 0; j < meetingCount; j++) {
        DateTime meetingDate;
        do {
          meetingDate = _generateRandomDate();
        } while (meetingDates.contains(meetingDate));

        meetingDates.add(meetingDate);
        final meetingRecord = _generateMeetingRecord(person.id, meetingDate);
        meetingRecords.add(meetingRecord);
      }

      debugPrint(
        'Generated person ${i + 1}/100: ${person.name} @ ${person.company}',
      );
    }

    // Save all persons to storage
    debugPrint('\nSaving persons to storage...');
    for (final person in persons) {
      await PersonStorage.savePerson(person);
    }

    // Save all meeting records to storage
    debugPrint('Saving meeting records to storage...');
    for (final record in meetingRecords) {
      await MeetingRecordStorage.saveMeetingRecord(record);
    }

    debugPrint('\n✅ Successfully generated and saved:');
    debugPrint('  • ${persons.length} persons');
    debugPrint('  • ${meetingRecords.length} meeting records');
    debugPrint('\nData generation completed!');

    // Clear used combinations for next generation
    _usedNameCompanyCombinations.clear();
    _usedLocationCombinations.clear();
  }

  // Method to clear all existing data (for testing purposes)
  static Future<void> clearAllData() async {
    debugPrint('Clearing all existing data...');

    final persons = await PersonStorage.getAllPersons();
    final meetingRecords = await MeetingRecordStorage.getAllMeetingRecords();

    for (final person in persons) {
      await PersonStorage.deletePerson(person.id);
    }

    for (final record in meetingRecords) {
      await MeetingRecordStorage.deleteMeetingRecord(record.id);
    }

    debugPrint(
      'Cleared ${persons.length} persons and ${meetingRecords.length} meeting records',
    );
  }
}
