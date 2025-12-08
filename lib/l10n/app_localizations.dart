import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Whodat'**
  String get appTitle;

  /// No description provided for @heroTitle1.
  ///
  /// In en, this message translates to:
  /// **'\"Who was that person?\"\nLet\'s eliminate that feeling.'**
  String get heroTitle1;

  /// No description provided for @heroTitle2.
  ///
  /// In en, this message translates to:
  /// **'Let\'s save your records\nwith important people here.'**
  String get heroTitle2;

  /// No description provided for @heroTitle3.
  ///
  /// In en, this message translates to:
  /// **'Turn every encounter\ninto your asset.'**
  String get heroTitle3;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add Person'**
  String get addPerson;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @allRecords.
  ///
  /// In en, this message translates to:
  /// **'All Records'**
  String get allRecords;

  /// No description provided for @myPage.
  ///
  /// In en, this message translates to:
  /// **'My Page'**
  String get myPage;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo (conversation content, etc.)'**
  String get memo;

  /// No description provided for @featureTags.
  ///
  /// In en, this message translates to:
  /// **'Feature Tags (space separated)'**
  String get featureTags;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name or tag...'**
  String get searchPlaceholder;

  /// No description provided for @voiceSearch.
  ///
  /// In en, this message translates to:
  /// **'Voice Search'**
  String get voiceSearch;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @addPersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Person'**
  String get addPersonTitle;

  /// No description provided for @editPersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Person'**
  String get editPersonTitle;

  /// No description provided for @personName.
  ///
  /// In en, this message translates to:
  /// **'Person\'s Name'**
  String get personName;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @selectOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select on Map'**
  String get selectOnMap;

  /// No description provided for @enterLocationManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Location Manually'**
  String get enterLocationManually;

  /// No description provided for @locationNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter location name (e.g., Shibuya Station)'**
  String get locationNamePlaceholder;

  /// No description provided for @locationExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., Shibuya Station, Tokyo Office, Café du Créé'**
  String get locationExample;

  /// No description provided for @selectOnMapDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to specify location'**
  String get selectOnMapDescription;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @changeDate.
  ///
  /// In en, this message translates to:
  /// **'Change Date'**
  String get changeDate;

  /// No description provided for @unsetDate.
  ///
  /// In en, this message translates to:
  /// **'Set to Unset'**
  String get unsetDate;

  /// No description provided for @confirmChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change the date or unset it?'**
  String get confirmChangeDate;

  /// No description provided for @tagSettings.
  ///
  /// In en, this message translates to:
  /// **'Tag Settings'**
  String get tagSettings;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add Tag'**
  String get addTag;

  /// No description provided for @tagPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., senior, colleague, client'**
  String get tagPlaceholder;

  /// No description provided for @deleteTag.
  ///
  /// In en, this message translates to:
  /// **'Delete Tag'**
  String get deleteTag;

  /// No description provided for @deleteTagConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete \"#{tag}\".\nThis tag will also be removed from people who have it set.\nAre you sure?'**
  String deleteTagConfirmation(Object tag);

  /// No description provided for @storyTitle.
  ///
  /// In en, this message translates to:
  /// **'The Encounter Dilemma'**
  String get storyTitle;

  /// No description provided for @storySubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Business meetings, study groups, events...'**
  String get storySubtitle1;

  /// No description provided for @storySubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Opportunities to meet new people increase, yet'**
  String get storySubtitle2;

  /// No description provided for @storySubtitle3.
  ///
  /// In en, this message translates to:
  /// **'we end up passing time without connecting names and faces.'**
  String get storySubtitle3;

  /// No description provided for @storySubtitle4.
  ///
  /// In en, this message translates to:
  /// **'Worried about having forgotten their name...'**
  String get storySubtitle4;

  /// No description provided for @storySolution.
  ///
  /// In en, this message translates to:
  /// **'More casually'**
  String get storySolution;

  /// No description provided for @storySolutionDesc.
  ///
  /// In en, this message translates to:
  /// **'Forgetting is natural. We\'re only human.'**
  String get storySolutionDesc;

  /// No description provided for @storySolution2.
  ///
  /// In en, this message translates to:
  /// **'It\'s okay not to be perfect.'**
  String get storySolution2;

  /// No description provided for @storyBenefit.
  ///
  /// In en, this message translates to:
  /// **'A small record can'**
  String get storyBenefit;

  /// No description provided for @storyBenefit2.
  ///
  /// In en, this message translates to:
  /// **'make your next encounter even richer.'**
  String get storyBenefit2;

  /// No description provided for @whodatFeatures.
  ///
  /// In en, this message translates to:
  /// **'What Whodat? Can Do'**
  String get whodatFeatures;

  /// No description provided for @feature1.
  ///
  /// In en, this message translates to:
  /// **'Easily record names and faces'**
  String get feature1;

  /// No description provided for @feature2.
  ///
  /// In en, this message translates to:
  /// **'Remember where and when you met'**
  String get feature2;

  /// No description provided for @feature3.
  ///
  /// In en, this message translates to:
  /// **'Save features and conversation memos'**
  String get feature3;

  /// No description provided for @feature4.
  ///
  /// In en, this message translates to:
  /// **'Intuitive management with color coding'**
  String get feature4;

  /// No description provided for @feature5.
  ///
  /// In en, this message translates to:
  /// **'Check off people you\'ve remembered'**
  String get feature5;

  /// No description provided for @missionTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get missionTitle;

  /// No description provided for @missionDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn every encounter into an asset.'**
  String get missionDesc;

  /// No description provided for @missionDesc2.
  ///
  /// In en, this message translates to:
  /// **'Create a world where'**
  String get missionDesc2;

  /// No description provided for @missionDesc3.
  ///
  /// In en, this message translates to:
  /// **'anyone can easily remember people\'s names.'**
  String get missionDesc3;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Please share your opinions, requests, bug reports, etc.'**
  String get feedbackPlaceholder;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @appStory.
  ///
  /// In en, this message translates to:
  /// **'App Story'**
  String get appStory;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionInfo(Object version);

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @noPeopleAdded.
  ///
  /// In en, this message translates to:
  /// **'No people added yet'**
  String get noPeopleAdded;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFound;

  /// No description provided for @startAddingPeople.
  ///
  /// In en, this message translates to:
  /// **'Start adding people you meet!'**
  String get startAddingPeople;

  /// No description provided for @markedAsRemembered.
  ///
  /// In en, this message translates to:
  /// **'Marked as remembered'**
  String get markedAsRemembered;

  /// No description provided for @unmarkedAsRemembered.
  ///
  /// In en, this message translates to:
  /// **'Unmarked as remembered'**
  String get unmarkedAsRemembered;

  /// No description provided for @permissionRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequiredTitle;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to display people\'s locations on the map.'**
  String get locationPermissionRequired;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is denied. Please enable it in settings to use location features.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it in settings to use location features.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @enableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to use this feature.'**
  String get enableLocationServices;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required for voice search.'**
  String get microphonePermissionRequired;

  /// No description provided for @microphonePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is denied. Please enable it in settings to use voice search.'**
  String get microphonePermissionDenied;

  /// No description provided for @speechRecognitionNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device.'**
  String get speechRecognitionNotAvailable;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @speechRecognitionError.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition error: {error}'**
  String speechRecognitionError(Object error);

  /// No description provided for @speechRecognitionNoResults.
  ///
  /// In en, this message translates to:
  /// **'No speech recognition results'**
  String get speechRecognitionNoResults;

  /// No description provided for @permissionLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'This app uses location information to display registered people\'s locations on the map'**
  String get permissionLocationDescription;

  /// No description provided for @permissionSpeechRecognitionDescription.
  ///
  /// In en, this message translates to:
  /// **'Used for inputting search keywords using speech recognition'**
  String get permissionSpeechRecognitionDescription;

  /// No description provided for @permissionMicrophoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Please allow microphone access for voice search'**
  String get permissionMicrophoneDescription;

  /// No description provided for @recentlyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Recently Registered'**
  String get recentlyRegistered;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// No description provided for @addFirstPerson.
  ///
  /// In en, this message translates to:
  /// **'Add your first person using the + button'**
  String get addFirstPerson;

  /// No description provided for @iRememberThisPerson.
  ///
  /// In en, this message translates to:
  /// **'I remember this person'**
  String get iRememberThisPerson;

  /// No description provided for @saveMemory.
  ///
  /// In en, this message translates to:
  /// **'Save Memory'**
  String get saveMemory;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional if unknown'**
  String get nameOptional;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @companyHint.
  ///
  /// In en, this message translates to:
  /// **'Company, school, etc.'**
  String get companyHint;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @positionHint.
  ///
  /// In en, this message translates to:
  /// **'Position, school year, etc.'**
  String get positionHint;

  /// No description provided for @featuresTags.
  ///
  /// In en, this message translates to:
  /// **'Features/Tags'**
  String get featuresTags;

  /// No description provided for @whenWhereMet.
  ///
  /// In en, this message translates to:
  /// **'When & Where Did You Meet?'**
  String get whenWhereMet;

  /// No description provided for @addAnotherDay.
  ///
  /// In en, this message translates to:
  /// **'Add Another Day'**
  String get addAnotherDay;

  /// No description provided for @whenDidYouMeet.
  ///
  /// In en, this message translates to:
  /// **'When did you meet? (Tap to set)'**
  String get whenDidYouMeet;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationPlaceholder;

  /// No description provided for @memoHint.
  ///
  /// In en, this message translates to:
  /// **'Memo (conversation content, etc.)'**
  String get memoHint;

  /// No description provided for @tagsHint.
  ///
  /// In en, this message translates to:
  /// **'Feature tags (space separated)'**
  String get tagsHint;

  /// No description provided for @changeDateConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change the date or unset it?'**
  String get changeDateConfirmation;

  /// No description provided for @deleteAllRecords.
  ///
  /// In en, this message translates to:
  /// **'Delete All Records'**
  String get deleteAllRecords;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// No description provided for @deletePersonConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete all records for {name}.\nDeleted records cannot be restored.'**
  String deletePersonConfirmation(Object name);

  /// No description provided for @haveYouEver.
  ///
  /// In en, this message translates to:
  /// **'Have you ever had this experience?'**
  String get haveYouEver;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @nameNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Name not registered'**
  String get nameNotRegistered;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @viewPeopleList.
  ///
  /// In en, this message translates to:
  /// **'View People List'**
  String get viewPeopleList;

  /// No description provided for @pleaseTellUs.
  ///
  /// In en, this message translates to:
  /// **'Please tell us your thoughts'**
  String get pleaseTellUs;

  /// No description provided for @whatFeedback.
  ///
  /// In en, this message translates to:
  /// **'What kind of feedback is this?'**
  String get whatFeedback;

  /// No description provided for @bugReport.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get bugReport;

  /// No description provided for @bugReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Report app issues or crashes'**
  String get bugReportDesc;

  /// No description provided for @featureRequest.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get featureRequest;

  /// No description provided for @featureRequestDesc.
  ///
  /// In en, this message translates to:
  /// **'Ideas for features that would be useful'**
  String get featureRequestDesc;

  /// No description provided for @appReview.
  ///
  /// In en, this message translates to:
  /// **'App Review'**
  String get appReview;

  /// No description provided for @appReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Honest opinions about usability and design'**
  String get appReviewDesc;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @otherDesc.
  ///
  /// In en, this message translates to:
  /// **'Anything else you\'d like to tell us'**
  String get otherDesc;

  /// No description provided for @feedbackThankYou.
  ///
  /// In en, this message translates to:
  /// **'Your feedback will be used as reference for future updates'**
  String get feedbackThankYou;

  /// No description provided for @openFeedbackForm.
  ///
  /// In en, this message translates to:
  /// **'Open Feedback Form'**
  String get openFeedbackForm;

  /// No description provided for @myPageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Page'**
  String get myPageTitle;

  /// No description provided for @setName.
  ///
  /// In en, this message translates to:
  /// **'Set Name'**
  String get setName;

  /// No description provided for @memoryRank.
  ///
  /// In en, this message translates to:
  /// **'Memory Rank: {rank}'**
  String memoryRank(Object rank);

  /// No description provided for @rememberedPeople.
  ///
  /// In en, this message translates to:
  /// **'Remembered People'**
  String get rememberedPeople;

  /// No description provided for @monthlyMeetings.
  ///
  /// In en, this message translates to:
  /// **'This Month\'s Meetings'**
  String get monthlyMeetings;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String versionLabel(Object version);

  /// No description provided for @nameSettings.
  ///
  /// In en, this message translates to:
  /// **'Name Settings'**
  String get nameSettings;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm location on map'**
  String get confirmLocation;

  /// No description provided for @tapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to select a location'**
  String get tapToSelectLocation;

  /// No description provided for @locationEntryMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose location entry method'**
  String get locationEntryMethod;

  /// No description provided for @selectOnMapDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to specify location'**
  String get selectOnMapDesc;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Manually'**
  String get enterManually;

  /// No description provided for @enterManuallyDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter location name as text'**
  String get enterManuallyDesc;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter Location'**
  String get enterLocation;

  /// No description provided for @locationNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Manual entry won\'t show pins on the Map'**
  String get locationNote;

  /// No description provided for @tagAbout.
  ///
  /// In en, this message translates to:
  /// **'About Tags'**
  String get tagAbout;

  /// No description provided for @tagAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'You can manage tags for people.\nRegistering frequently used tags makes it convenient to select them with a tap when adding new records.'**
  String get tagAboutDesc;

  /// No description provided for @noRegisteredTags.
  ///
  /// In en, this message translates to:
  /// **'No registered tags'**
  String get noRegisteredTags;

  /// No description provided for @addFrequentTags.
  ///
  /// In en, this message translates to:
  /// **'Add frequently used tags'**
  String get addFrequentTags;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selectLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select location on map'**
  String get selectLocationOnMap;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @developerNote.
  ///
  /// In en, this message translates to:
  /// **'This app was born from my own struggle with \"not being able to remember people\". If this app can enrich your encounters even a little, there would be no greater joy.'**
  String get developerNote;

  /// No description provided for @reviewMeetings.
  ///
  /// In en, this message translates to:
  /// **'Review when you met'**
  String get reviewMeetings;

  /// No description provided for @tapMicToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap microphone button to start recognition'**
  String get tapMicToStart;

  /// No description provided for @speechError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String speechError(Object error);

  /// No description provided for @searchByVoice.
  ///
  /// In en, this message translates to:
  /// **'Search by voice'**
  String get searchByVoice;

  /// No description provided for @pleaseSpeak.
  ///
  /// In en, this message translates to:
  /// **'Please speak...'**
  String get pleaseSpeak;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, company, location, tags...'**
  String get searchHint;

  /// No description provided for @businessMeetings.
  ///
  /// In en, this message translates to:
  /// **'Business meetings, study groups, events...'**
  String get businessMeetings;

  /// No description provided for @morePeopleBut.
  ///
  /// In en, this message translates to:
  /// **'Opportunities to meet new people increase, but'**
  String get morePeopleBut;

  /// No description provided for @forgetNames.
  ///
  /// In en, this message translates to:
  /// **'we go on without connecting names and faces.'**
  String get forgetNames;

  /// No description provided for @worriedAboutForgetting.
  ///
  /// In en, this message translates to:
  /// **'Worried about forgetting names...'**
  String get worriedAboutForgetting;

  /// No description provided for @forgettingIsNatural.
  ///
  /// In en, this message translates to:
  /// **'Forgetting is natural. We\'re only human.'**
  String get forgettingIsNatural;

  /// No description provided for @dontNeedToBePerfect.
  ///
  /// In en, this message translates to:
  /// **'You don\'t need to be perfect.'**
  String get dontNeedToBePerfect;

  /// No description provided for @littleRecords.
  ///
  /// In en, this message translates to:
  /// **'Little records'**
  String get littleRecords;

  /// No description provided for @enrichNextEncounters.
  ///
  /// In en, this message translates to:
  /// **'enrich your next encounters.'**
  String get enrichNextEncounters;

  /// No description provided for @recordNameAndFace.
  ///
  /// In en, this message translates to:
  /// **'• Easily record names and faces'**
  String get recordNameAndFace;

  /// No description provided for @rememberPlaceAndTime.
  ///
  /// In en, this message translates to:
  /// **'• Remember where and when you met'**
  String get rememberPlaceAndTime;

  /// No description provided for @saveFeaturesAndMemo.
  ///
  /// In en, this message translates to:
  /// **'• Save features and conversation memos'**
  String get saveFeaturesAndMemo;

  /// No description provided for @manageWithColors.
  ///
  /// In en, this message translates to:
  /// **'• Manage intuitively with colors'**
  String get manageWithColors;

  /// No description provided for @checkRememberedPeople.
  ///
  /// In en, this message translates to:
  /// **'• Check off people you\'ve remembered'**
  String get checkRememberedPeople;

  /// No description provided for @turnMeetingsToAssets.
  ///
  /// In en, this message translates to:
  /// **'Turn all encounters into assets.'**
  String get turnMeetingsToAssets;

  /// No description provided for @worldEasyToRemember.
  ///
  /// In en, this message translates to:
  /// **'A world where everyone can easily remember people\'s names,'**
  String get worldEasyToRemember;

  /// No description provided for @createSuchWorld.
  ///
  /// In en, this message translates to:
  /// **'let\'s create such a world.'**
  String get createSuchWorld;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @bronzeMember.
  ///
  /// In en, this message translates to:
  /// **'Bronze Member'**
  String get bronzeMember;

  /// No description provided for @silverMember.
  ///
  /// In en, this message translates to:
  /// **'Silver Member'**
  String get silverMember;

  /// No description provided for @goldMember.
  ///
  /// In en, this message translates to:
  /// **'Gold Member'**
  String get goldMember;

  /// No description provided for @platinumMember.
  ///
  /// In en, this message translates to:
  /// **'Platinum Member'**
  String get platinumMember;

  /// No description provided for @memoryRankBeginner.
  ///
  /// In en, this message translates to:
  /// **'Memory Apprentice'**
  String get memoryRankBeginner;

  /// No description provided for @memoryRankBronze.
  ///
  /// In en, this message translates to:
  /// **'Starting to Remember'**
  String get memoryRankBronze;

  /// No description provided for @memoryRankSilver.
  ///
  /// In en, this message translates to:
  /// **'Faces Match Names'**
  String get memoryRankSilver;

  /// No description provided for @memoryRankGold.
  ///
  /// In en, this message translates to:
  /// **'Can Talk to Anyone'**
  String get memoryRankGold;

  /// No description provided for @memoryRankPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Network Master'**
  String get memoryRankPlatinum;

  /// No description provided for @searchResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Search results for \"{query}\"'**
  String searchResultsFor(Object query);

  /// No description provided for @foundResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Found {count} results'**
  String foundResultsCount(Object count);

  /// No description provided for @whodatStory.
  ///
  /// In en, this message translates to:
  /// **'The Whodat? Story'**
  String get whodatStory;

  /// No description provided for @whoWasThatPerson.
  ///
  /// In en, this message translates to:
  /// **'Who was that person?'**
  String get whoWasThatPerson;

  /// No description provided for @tagManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'You can manage tags for people.\nIf you register frequently used tags, you can easily select them when adding new records.'**
  String get tagManagementDescription;

  /// No description provided for @recordsUsingTag.
  ///
  /// In en, this message translates to:
  /// **'Used in {count} records'**
  String recordsUsingTag(Object count);

  /// No description provided for @dateWithWeekday.
  ///
  /// In en, this message translates to:
  /// **'{weekday}, {month}/{day}/{year}'**
  String dateWithWeekday(Object day, Object month, Object weekday, Object year);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
