// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Whodat';

  @override
  String get heroTitle1 =>
      '\"Who was that person?\"\nLet\'s eliminate that feeling.';

  @override
  String get heroTitle2 =>
      'Let\'s save your records\nwith important people here.';

  @override
  String get heroTitle3 => 'Turn every encounter\ninto your asset.';

  @override
  String get home => 'Home';

  @override
  String get addPerson => 'Add Person';

  @override
  String get map => 'Map';

  @override
  String get calendar => 'Calendar';

  @override
  String get allRecords => 'All Records';

  @override
  String get myPage => 'My Page';

  @override
  String get location => 'Location';

  @override
  String get memo => 'Memo (conversation content, etc.)';

  @override
  String get featureTags => 'Feature Tags (space separated)';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get error => 'Error';

  @override
  String errorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get searchPlaceholder => 'Search by name or tag...';

  @override
  String get voiceSearch => 'Voice Search';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get addPersonTitle => 'Add New Person';

  @override
  String get editPersonTitle => 'Edit Person';

  @override
  String get personName => 'Person\'s Name';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get selectOnMap => 'Select on Map';

  @override
  String get enterLocationManually => 'Enter Location Manually';

  @override
  String get locationNamePlaceholder =>
      'Enter location name (e.g., Shibuya Station)';

  @override
  String get locationExample =>
      'e.g., Shibuya Station, Tokyo Office, Café du Créé';

  @override
  String get selectOnMapDescription => 'Tap on the map to specify location';

  @override
  String get dateAndTime => 'Date & Time';

  @override
  String get changeDate => 'Change Date';

  @override
  String get unsetDate => 'Set to Unset';

  @override
  String get confirmChangeDate => 'Do you want to change the date or unset it?';

  @override
  String get tagSettings => 'Tag Settings';

  @override
  String get addTag => 'Add Tag';

  @override
  String get tagPlaceholder => 'e.g., senior, colleague, client';

  @override
  String get deleteTag => 'Delete Tag';

  @override
  String deleteTagConfirmation(Object tag) {
    return 'Delete \"#$tag\".\nThis tag will also be removed from people who have it set.\nAre you sure?';
  }

  @override
  String get storyTitle => 'The Encounter Dilemma';

  @override
  String get storySubtitle1 => 'Business meetings, study groups, events...';

  @override
  String get storySubtitle2 => 'Opportunities to meet new people increase, yet';

  @override
  String get storySubtitle3 =>
      'we end up passing time without connecting names and faces.';

  @override
  String get storySubtitle4 => 'Worried about having forgotten their name...';

  @override
  String get storySolution => 'More casually';

  @override
  String get storySolutionDesc => 'Forgetting is natural. We\'re only human.';

  @override
  String get storySolution2 => 'It\'s okay not to be perfect.';

  @override
  String get storyBenefit => 'A small record can';

  @override
  String get storyBenefit2 => 'make your next encounter even richer.';

  @override
  String get whodatFeatures => 'What Whodat? Can Do';

  @override
  String get feature1 => 'Easily record names and faces';

  @override
  String get feature2 => 'Remember where and when you met';

  @override
  String get feature3 => 'Save features and conversation memos';

  @override
  String get feature4 => 'Intuitive management with color coding';

  @override
  String get feature5 => 'Check off people you\'ve remembered';

  @override
  String get missionTitle => 'Our Mission';

  @override
  String get missionDesc => 'Turn every encounter into an asset.';

  @override
  String get missionDesc2 => 'Create a world where';

  @override
  String get missionDesc3 => 'anyone can easily remember people\'s names.';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackPlaceholder =>
      'Please share your opinions, requests, bug reports, etc.';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get appStory => 'App Story';

  @override
  String versionInfo(Object version) {
    return 'Version $version';
  }

  @override
  String get noData => 'No Data';

  @override
  String get noPeopleAdded => 'No people added yet';

  @override
  String get noRecordsFound => 'No records found';

  @override
  String get startAddingPeople => 'Start adding people you meet!';

  @override
  String get markedAsRemembered => 'Marked as remembered';

  @override
  String get unmarkedAsRemembered => 'Unmarked as remembered';

  @override
  String get permissionRequiredTitle => 'Permission Required';

  @override
  String get locationPermissionRequired =>
      'Location permission is required to display people\'s locations on the map.';

  @override
  String get locationPermissionDenied =>
      'Location permission is denied. Please enable it in settings to use location features.';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission is permanently denied. Please enable it in settings to use location features.';

  @override
  String get settings => 'Settings';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get enableLocationServices =>
      'Please enable location services to use this feature.';

  @override
  String get microphonePermissionRequired =>
      'Microphone permission is required for voice search.';

  @override
  String get microphonePermissionDenied =>
      'Microphone permission is denied. Please enable it in settings to use voice search.';

  @override
  String get speechRecognitionNotAvailable =>
      'Speech recognition is not available on this device.';

  @override
  String get listening => 'Listening...';

  @override
  String speechRecognitionError(Object error) {
    return 'Speech recognition error: $error';
  }

  @override
  String get speechRecognitionNoResults => 'No speech recognition results';

  @override
  String get permissionLocationDescription =>
      'This app uses location information to display registered people\'s locations on the map';

  @override
  String get permissionSpeechRecognitionDescription =>
      'Used for inputting search keywords using speech recognition';

  @override
  String get permissionMicrophoneDescription =>
      'Please allow microphone access for voice search';

  @override
  String get recentlyRegistered => 'Recently Registered';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecords => 'No records';

  @override
  String get addFirstPerson => 'Add your first person using the + button';

  @override
  String get iRememberThisPerson => 'I remember this person';

  @override
  String get saveMemory => 'Save Memory';

  @override
  String get name => 'Name';

  @override
  String get nameOptional => 'Optional if unknown';

  @override
  String get company => 'Company';

  @override
  String get companyHint => 'Company, school, etc.';

  @override
  String get position => 'Position';

  @override
  String get positionHint => 'Position, school year, etc.';

  @override
  String get featuresTags => 'Features/Tags';

  @override
  String get whenWhereMet => 'When & Where Did You Meet?';

  @override
  String get addAnotherDay => 'Add Another Day';

  @override
  String get whenDidYouMeet => 'When did you meet? (Tap to set)';

  @override
  String get locationPlaceholder => 'Location';

  @override
  String get memoHint => 'Memo (conversation content, etc.)';

  @override
  String get tagsHint => 'Feature tags (space separated)';

  @override
  String get changeDateConfirmation =>
      'Do you want to change the date or unset it?';

  @override
  String get deleteAllRecords => 'Delete All Records';

  @override
  String get deleteConfirmation => 'Delete Confirmation';

  @override
  String deletePersonConfirmation(Object name) {
    return 'Delete all records for $name.\nDeleted records cannot be restored.';
  }

  @override
  String get haveYouEver => 'Have you ever had this experience?';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get nameNotRegistered => 'Name not registered';

  @override
  String get notFound => 'Not found';

  @override
  String get viewPeopleList => 'View People List';

  @override
  String get pleaseTellUs => 'Please tell us your thoughts';

  @override
  String get whatFeedback => 'What kind of feedback is this?';

  @override
  String get bugReport => 'Bug Report';

  @override
  String get bugReportDesc => 'Report app issues or crashes';

  @override
  String get featureRequest => 'Feature Request';

  @override
  String get featureRequestDesc => 'Ideas for features that would be useful';

  @override
  String get appReview => 'App Review';

  @override
  String get appReviewDesc => 'Honest opinions about usability and design';

  @override
  String get other => 'Other';

  @override
  String get otherDesc => 'Anything else you\'d like to tell us';

  @override
  String get feedbackThankYou =>
      'Your feedback will be used as reference for future updates';

  @override
  String get openFeedbackForm => 'Open Feedback Form';

  @override
  String get myPageTitle => 'My Page';

  @override
  String get setName => 'Set Name';

  @override
  String memoryRank(Object rank) {
    return 'Memory Rank: $rank';
  }

  @override
  String get rememberedPeople => 'Remembered People';

  @override
  String get monthlyMeetings => 'This Month\'s Meetings';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String versionLabel(Object version) {
    return 'Version: $version';
  }

  @override
  String get nameSettings => 'Name Settings';

  @override
  String get nameLabel => 'Name';

  @override
  String get mapTitle => 'Map';

  @override
  String get confirmLocation => 'Confirm location on map';

  @override
  String get tapToSelectLocation => 'Tap on the map to select a location';

  @override
  String get locationEntryMethod => 'Choose location entry method';

  @override
  String get selectOnMapDesc => 'Tap on the map to specify location';

  @override
  String get enterManually => 'Enter Manually';

  @override
  String get enterManuallyDesc => 'Enter location name as text';

  @override
  String get enterLocation => 'Enter Location';

  @override
  String get locationNote => 'Note: Manual entry won\'t show pins on the Map';

  @override
  String get tagAbout => 'About Tags';

  @override
  String get tagAboutDesc =>
      'You can manage tags for people.\nRegistering frequently used tags makes it convenient to select them with a tap when adding new records.';

  @override
  String get noRegisteredTags => 'No registered tags';

  @override
  String get addFrequentTags => 'Add frequently used tags';

  @override
  String get confirm => 'Confirm';

  @override
  String get selectLocationOnMap => 'Select location on map';

  @override
  String get selectedLocation => 'Selected Location';

  @override
  String get developerNote =>
      'This app was born from my own struggle with \"not being able to remember people\". If this app can enrich your encounters even a little, there would be no greater joy.';

  @override
  String get reviewMeetings => 'Review when you met';

  @override
  String get tapMicToStart => 'Tap microphone button to start recognition';

  @override
  String speechError(Object error) {
    return 'Error: $error';
  }

  @override
  String get searchByVoice => 'Search by voice';

  @override
  String get pleaseSpeak => 'Please speak...';

  @override
  String get complete => 'Complete';

  @override
  String get searchHint => 'Search by name, company, location, tags...';

  @override
  String get businessMeetings => 'Business meetings, study groups, events...';

  @override
  String get morePeopleBut => 'Opportunities to meet new people increase, but';

  @override
  String get forgetNames => 'we go on without connecting names and faces.';

  @override
  String get worriedAboutForgetting => 'Worried about forgetting names...';

  @override
  String get forgettingIsNatural => 'Forgetting is natural. We\'re only human.';

  @override
  String get dontNeedToBePerfect => 'You don\'t need to be perfect.';

  @override
  String get littleRecords => 'Little records';

  @override
  String get enrichNextEncounters => 'enrich your next encounters.';

  @override
  String get recordNameAndFace => '• Easily record names and faces';

  @override
  String get rememberPlaceAndTime => '• Remember where and when you met';

  @override
  String get saveFeaturesAndMemo => '• Save features and conversation memos';

  @override
  String get manageWithColors => '• Manage intuitively with colors';

  @override
  String get checkRememberedPeople => '• Check off people you\'ve remembered';

  @override
  String get turnMeetingsToAssets => 'Turn all encounters into assets.';

  @override
  String get worldEasyToRemember =>
      'A world where everyone can easily remember people\'s names,';

  @override
  String get createSuchWorld => 'let\'s create such a world.';

  @override
  String get beginner => 'Beginner';

  @override
  String get bronzeMember => 'Bronze Member';

  @override
  String get silverMember => 'Silver Member';

  @override
  String get goldMember => 'Gold Member';

  @override
  String get platinumMember => 'Platinum Member';

  @override
  String get memoryRankBeginner => 'Memory Apprentice';

  @override
  String get memoryRankBronze => 'Starting to Remember';

  @override
  String get memoryRankSilver => 'Faces Match Names';

  @override
  String get memoryRankGold => 'Can Talk to Anyone';

  @override
  String get memoryRankPlatinum => 'Network Master';

  @override
  String searchResultsFor(Object query) {
    return 'Search results for \"$query\"';
  }

  @override
  String foundResultsCount(Object count) {
    return 'Found $count results';
  }

  @override
  String get whodatStory => 'The Whodat? Story';

  @override
  String get whoWasThatPerson => 'Who was that person?';

  @override
  String get tagManagementDescription =>
      'You can manage tags for people.\nIf you register frequently used tags, you can easily select them when adding new records.';

  @override
  String recordsUsingTag(Object count) {
    return 'Used in $count records';
  }

  @override
  String get metLastWeek => 'Met last week';

  @override
  String get today => 'Today';

  @override
  String get photoAccessDenied => 'Photo library access is not permitted';

  @override
  String get thisMonth => 'This month';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get selectThemeColor => 'Choose your favorite theme color';

  @override
  String get themePreview => 'Preview';

  @override
  String get onboardingTitle => 'Never Forget a Face Again';

  @override
  String get onboardingSubtitle =>
      'Record the people you meet, and confidently greet them next time.';

  @override
  String get onboardingFeature1 => 'Save names and faces with photos';

  @override
  String get onboardingFeature2 => 'Remember when and where you met';

  @override
  String get onboardingFeature3 => 'Check off people you\'ve memorized';

  @override
  String get onboardingButton => 'Get Started';
}
