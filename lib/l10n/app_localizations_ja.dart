// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Whodat';

  @override
  String get heroTitle1 => '「あの人、誰だっけ？」\nをなくそう。';

  @override
  String get heroTitle2 => '大切な人との記録を\nここに残そう。';

  @override
  String get heroTitle3 => 'すべての出会いを\nあなたの資産に。';

  @override
  String get home => 'ホーム';

  @override
  String get addPerson => '追加';

  @override
  String get map => 'マップ';

  @override
  String get calendar => 'カレンダー';

  @override
  String get allRecords => 'すべての記録';

  @override
  String get myPage => 'マイページ';

  @override
  String get location => '場所';

  @override
  String get memo => 'メモ（会話内容など）';

  @override
  String get featureTags => '特徴タグ（スペース区切り）';

  @override
  String get cancel => 'キャンセル';

  @override
  String get add => '追加';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get error => 'エラー';

  @override
  String errorOccurred(Object error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get searchPlaceholder => '名前やタグで検索...';

  @override
  String get voiceSearch => '音声検索';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get noResultsFound => '結果が見つかりません';

  @override
  String get addPersonTitle => '新しい人を追加';

  @override
  String get editPersonTitle => '人物を編集';

  @override
  String get personName => '人物名';

  @override
  String get takePhoto => '写真を撮る';

  @override
  String get selectFromGallery => 'アルバムから選択';

  @override
  String get changePhoto => '写真を変更';

  @override
  String get selectLocation => '場所を選択';

  @override
  String get selectOnMap => '地図で選択';

  @override
  String get enterLocationManually => '手動で入力';

  @override
  String get locationNamePlaceholder => '場所名を入力（例: 渋谷駅）';

  @override
  String get locationExample => '例: 渋谷駅、東京オフィス、カフェ・ド・クリエ';

  @override
  String get selectOnMapDescription => '地図上で場所をタップして指定';

  @override
  String get dateAndTime => '日時';

  @override
  String get changeDate => '日付を変更';

  @override
  String get unsetDate => '未設定にする';

  @override
  String get confirmChangeDate => '日付を変更しますか？それとも未設定にしますか？';

  @override
  String get tagSettings => 'タグ設定';

  @override
  String get addTag => 'タグを追加';

  @override
  String get tagPlaceholder => '例: 先輩、同期、お客さん';

  @override
  String get deleteTag => 'タグの削除';

  @override
  String deleteTagConfirmation(Object tag) {
    return '「#$tag」を削除します。\nこのタグが設定された人物のタグも削除されます。\nよろしいですか？';
  }

  @override
  String get storyTitle => '出会いのジレンマ';

  @override
  String get storySubtitle1 => 'ビジネスの会合、勉強会、イベント…';

  @override
  String get storySubtitle2 => '新しい人と出会う機会は増えるのに、';

  @override
  String get storySubtitle3 => '名前と顔が結びつかないまま過ごしてしまう。';

  @override
  String get storySubtitle4 => '名前を忘れているのが気になって…';

  @override
  String get storySolution => 'もっと気楽に';

  @override
  String get storySolutionDesc => '忘れるのは当然。人間だもの。';

  @override
  String get storySolution2 => '完璧でなくたっていい。';

  @override
  String get storyBenefit => 'ちょっとした記録が、';

  @override
  String get storyBenefit2 => '次の出会いをより豊かにしてくれる。';

  @override
  String get whodatFeatures => 'Whodat?ができること';

  @override
  String get feature1 => '名前と顔を簡単に記録';

  @override
  String get feature2 => '出会った場所や時間を思い出す';

  @override
  String get feature3 => '特徴や会話のメモを残す';

  @override
  String get feature4 => '色分けで直感的に管理';

  @override
  String get feature5 => '覚えた人にチェックマーク';

  @override
  String get missionTitle => '私たちのミッション';

  @override
  String get missionDesc => '出会いをすべて資産に。';

  @override
  String get missionDesc2 => '誰もが人の名前を覚えやすい、';

  @override
  String get missionDesc3 => 'そんな世界を作りたい。';

  @override
  String get feedback => 'フィードバック';

  @override
  String get feedbackTitle => 'フィードバック';

  @override
  String get feedbackPlaceholder => 'ご意見、ご要望、バグ報告などをお聞かせください';

  @override
  String get submitFeedback => 'フィードバックを送信';

  @override
  String get appStory => 'アプリのストーリー';

  @override
  String versionInfo(Object version) {
    return 'バージョン $version';
  }

  @override
  String get noData => 'データなし';

  @override
  String get noPeopleAdded => 'まだ人物が追加されていません';

  @override
  String get noRecordsFound => '記録が見つかりません';

  @override
  String get startAddingPeople => '出会った人を追加しましょう！';

  @override
  String get markedAsRemembered => '覚えたことにしました';

  @override
  String get unmarkedAsRemembered => '覚えたことを取り消しました';

  @override
  String get permissionRequiredTitle => '権限が必要です';

  @override
  String get locationPermissionRequired =>
      '位置情報権限が必要です。地図上に人物の位置を表示するために使用します。';

  @override
  String get locationPermissionDenied => '位置情報へのアクセスが拒否されました。設定から有効にしてください。';

  @override
  String get locationPermissionDeniedForever =>
      '位置情報へのアクセスが永久に拒否されました。設定から有効にしてください。';

  @override
  String get settings => '設定';

  @override
  String get grantPermission => '権限を許可';

  @override
  String get enableLocationServices => '位置情報サービスを有効にしてください。';

  @override
  String get microphonePermissionRequired => '音声検索にはマイク権限が必要です。';

  @override
  String get microphonePermissionDenied => 'マイクへのアクセスが拒否されました。設定から有効にしてください。';

  @override
  String get speechRecognitionNotAvailable => 'このデバイスでは音声認識が利用できません。';

  @override
  String get listening => '聞き取り中...';

  @override
  String speechRecognitionError(Object error) {
    return '音声認識エラー: $error';
  }

  @override
  String get speechRecognitionNoResults => '音声認識の結果がありません';

  @override
  String get permissionLocationDescription =>
      'このアプリは地図上に登録された人の位置を表示するために位置情報を使用します';

  @override
  String get permissionSpeechRecognitionDescription =>
      '音声認識を使用して検索キーワードを入力するために使用します';

  @override
  String get permissionMicrophoneDescription => '音声検索のためにマイクへのアクセスを許可してください';

  @override
  String get recentlyRegistered => '最近登録した人';

  @override
  String get viewAll => 'すべて見る';

  @override
  String get noRecords => '記録がありません';

  @override
  String get addFirstPerson => '追加(+)ボタンで\n最初の人を追加してみましょう';

  @override
  String get iRememberThisPerson => 'この人を覚えた';

  @override
  String get saveMemory => '記憶を記録';

  @override
  String get name => '名前';

  @override
  String get nameOptional => 'わからなければ空欄でOK';

  @override
  String get company => '所属';

  @override
  String get companyHint => '会社、学校など';

  @override
  String get position => '肩書き';

  @override
  String get positionHint => '役職、学年など';

  @override
  String get featuresTags => '特徴・タグ';

  @override
  String get whenWhereMet => 'いつ、どこで会った？';

  @override
  String get addAnotherDay => '別の日を追加';

  @override
  String get whenDidYouMeet => 'いつ会った？（タップして設定）';

  @override
  String get locationPlaceholder => '場所';

  @override
  String get memoHint => 'メモ（会話内容など）';

  @override
  String get tagsHint => '特徴タグ（スペース区切り）';

  @override
  String get changeDateConfirmation => '日付を変更しますか？それとも未設定にしますか？';

  @override
  String get deleteAllRecords => '記録をすべて削除';

  @override
  String get deleteConfirmation => '削除の確認';

  @override
  String deletePersonConfirmation(Object name) {
    return '$nameの記録をすべて削除します。\n削除した記録は復元できません。';
  }

  @override
  String get haveYouEver => 'そんな経験ありませんか？';

  @override
  String get monday => '月';

  @override
  String get tuesday => '火';

  @override
  String get wednesday => '水';

  @override
  String get thursday => '木';

  @override
  String get friday => '金';

  @override
  String get saturday => '土';

  @override
  String get sunday => '日';

  @override
  String get nameNotRegistered => '名前未登録';

  @override
  String get notFound => '見つかりませんでした';

  @override
  String get viewPeopleList => '会った人の一覧を見る';

  @override
  String get pleaseTellUs => 'ご意見をお聞かせください';

  @override
  String get whatFeedback => 'どのようなフィードバックですか？';

  @override
  String get bugReport => 'バグ報告';

  @override
  String get bugReportDesc => 'アプリの不具合やクラッシュなどの報告';

  @override
  String get featureRequest => '機能リクエスト';

  @override
  String get featureRequestDesc => 'こんな機能があったら便利かもというアイデア';

  @override
  String get appReview => 'アプリの感想';

  @override
  String get appReviewDesc => '使い心地やデザインについての率直な意見';

  @override
  String get other => 'その他';

  @override
  String get otherDesc => 'その他、どんなことでもお聞かせください';

  @override
  String get feedbackThankYou => 'いただいたフィードバックは、\n今後のアップデートの参考にさせていただきます';

  @override
  String get openFeedbackForm => 'フィードバックフォームを開く';

  @override
  String get myPageTitle => 'マイページ';

  @override
  String get setName => '名前を設定';

  @override
  String memoryRank(Object rank) {
    return '記憶ランク: $rank';
  }

  @override
  String get rememberedPeople => '覚えた人';

  @override
  String get monthlyMeetings => '今月の出会い';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String versionLabel(Object version) {
    return 'バージョン: $version';
  }

  @override
  String get nameSettings => '名前の設定';

  @override
  String get nameLabel => '名前';

  @override
  String get mapTitle => 'マップ';

  @override
  String get confirmLocation => '地図で場所を選択';

  @override
  String get tapToSelectLocation => '地図をタップして場所を選択してください';

  @override
  String get locationEntryMethod => '場所の入力方法を選択';

  @override
  String get selectOnMapDesc => '地図上で場所をタップして指定';

  @override
  String get enterManually => '手動で入力';

  @override
  String get enterManuallyDesc => '場所の名前をテキストで入力';

  @override
  String get enterLocation => '場所を入力';

  @override
  String get locationNote => '手動で入力した場合、Mapにピンは表示されません';

  @override
  String get tagAbout => 'タグについて';

  @override
  String get tagAboutDesc =>
      '人物に付けるタグを管理できます。\nよく使うタグを登録しておくと、新しい記録を追加する時にタップで選べて便利です。';

  @override
  String get noRegisteredTags => '登録されたタグがありません';

  @override
  String get addFrequentTags => 'よく使うタグを追加してみましょう';

  @override
  String get confirm => '決定';

  @override
  String get selectLocationOnMap => '地図で場所を選択';

  @override
  String get selectedLocation => '選択された場所';

  @override
  String get developerNote =>
      'このアプリは、私自身の「人を覚えられない」という悩みから生まれました。もしこのアプリが、あなたの出会いを少しでも豊かにできたら、これほど嬉しいことはありません。';

  @override
  String get reviewMeetings => 'いつ会ったかを振り返る';

  @override
  String get tapMicToStart => '認識を開始するにはマイクボタンをタップ';

  @override
  String speechError(Object error) {
    return 'エラー: $error';
  }

  @override
  String get searchByVoice => '音声で検索';

  @override
  String get pleaseSpeak => 'お話しください…';

  @override
  String get complete => '完了';

  @override
  String get searchHint => '名前、会社、場所、タグで検索...';

  @override
  String get businessMeetings => 'ビジネスの会合、勉強会、イベント…';

  @override
  String get morePeopleBut => '新しい人と出会う機会は増えるのに、';

  @override
  String get forgetNames => '名前と顔が結びつかないまま過ごしてしまう。';

  @override
  String get worriedAboutForgetting => '名前を忘れているのが気になって…';

  @override
  String get forgettingIsNatural => '忘れるのは当然。人間だもの。';

  @override
  String get dontNeedToBePerfect => '完璧でなくたっていい。';

  @override
  String get littleRecords => 'ちょっとした記録が、';

  @override
  String get enrichNextEncounters => '次の出会いをより豊かにしてくれる。';

  @override
  String get recordNameAndFace => '• 名前と顔を簡単に記録';

  @override
  String get rememberPlaceAndTime => '• 出会った場所や時間を思い出す';

  @override
  String get saveFeaturesAndMemo => '• 特徴や会話のメモを残す';

  @override
  String get manageWithColors => '• 色分けで直感的に管理';

  @override
  String get checkRememberedPeople => '• 覚えた人にチェックマーク';

  @override
  String get turnMeetingsToAssets => '出会いをすべて資産に。';

  @override
  String get worldEasyToRemember => '誰もが人の名前を覚えやすい、';

  @override
  String get createSuchWorld => 'そんな世界を作りたい。';

  @override
  String get beginner => '初心者';

  @override
  String get bronzeMember => 'ブロンズ会員';

  @override
  String get silverMember => 'シルバー会員';

  @override
  String get goldMember => 'ゴールド会員';

  @override
  String get platinumMember => 'プラチナ会員';

  @override
  String get memoryRankBeginner => '記憶の見習い';

  @override
  String get memoryRankBronze => '名前を覚え始めた';

  @override
  String get memoryRankSilver => '顔と名前が一致';

  @override
  String get memoryRankGold => '誰とでも会話できる';

  @override
  String get memoryRankPlatinum => '人脈マスター';

  @override
  String searchResultsFor(Object query) {
    return '「$query」の検索結果';
  }

  @override
  String foundResultsCount(Object count) {
    return '$count件見つかりました';
  }

  @override
  String get whodatStory => 'Whodat?の物語';

  @override
  String get whoWasThatPerson => '「あの人、誰だっけ？」';

  @override
  String get tagManagementDescription =>
      '人物に付けるタグを管理できます。\nよく使うタグを登録しておくと、新しい記録を追加する時にタップで選べて便利です。';

  @override
  String recordsUsingTag(Object count) {
    return '$count件の記録で使用';
  }

  @override
  String dateWithWeekday(
    Object day,
    Object month,
    Object weekday,
    Object year,
  ) {
    return '$year年$month月$day日 ($weekday)';
  }

  @override
  String get metLastWeek => '先週会った';

  @override
  String get today => '今日';

  @override
  String get thisMonth => '今月';
}
