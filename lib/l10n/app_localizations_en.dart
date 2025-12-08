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
  String get feedbackTitle => 'Send Feedback';

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
  String get noData => 'No data yet';

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
}
