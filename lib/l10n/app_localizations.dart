import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_tr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('tr')
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get languagecode;

  /// sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin;

  /// E-mail
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// Password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password?
  ///
  /// In en, this message translates to:
  /// **'Forgot password? '**
  String get forgotpass;

  /// Click here.
  ///
  /// In en, this message translates to:
  /// **'Click here.'**
  String get clickhere;

  /// User is not found.
  ///
  /// In en, this message translates to:
  /// **'User is not found.'**
  String get usernotfound;

  /// Please fill all fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get fillallfields;

  /// Register with email & password.
  ///
  /// In en, this message translates to:
  /// **'Register with email & password'**
  String get registertitle;

  /// Name & surname.
  ///
  /// In en, this message translates to:
  /// **'Name & surname'**
  String get namesurname;

  /// Confirm password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmpassword;

  /// Register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerbutton;

  /// Cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelbutton;

  /// Password must be longer than 6 characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be longer than 6 characters'**
  String get passwordwarningone;

  /// Password and confirm password does not match.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password does not match.'**
  String get passwordwarningtwo;

  /// Identify a plant or plant problem.
  ///
  /// In en, this message translates to:
  /// **'Discover Everything About Plants!'**
  String get splashtitle;

  /// Flow
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get flowtitle;

  /// Please wait...
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get plswait;

  /// Author
  ///
  /// In en, this message translates to:
  /// **'Author: '**
  String get author;

  /// Date
  ///
  /// In en, this message translates to:
  /// **'Date: '**
  String get date;

  /// time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchtitle;

  /// Diagnose
  ///
  /// In en, this message translates to:
  /// **'Diagnose'**
  String get diagnosetitle;

  /// Reminder
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get remindertitle;

  /// mygardentitle
  ///
  /// In en, this message translates to:
  /// **'My Garden'**
  String get mygardentitle;

  /// Add Picture
  ///
  /// In en, this message translates to:
  /// **'Add Picture'**
  String get addpicture;

  /// Please select 5 or less photos.
  ///
  /// In en, this message translates to:
  /// **'Please select 5 or less photos.'**
  String get addpictureerror;

  /// diagnosesubtitle
  ///
  /// In en, this message translates to:
  /// **'Identify a Plant Problem.'**
  String get diagnosesubtitle;

  /// diagnosesubtitle2
  ///
  /// In en, this message translates to:
  /// **'You can diagnose all the diseases that you have observed in your plants but do not know the cause and solution by using your camera or photo gallery.'**
  String get diagnosesubtitle2;

  /// Take a photo.
  ///
  /// In en, this message translates to:
  /// **'Take a photo.'**
  String get takeaphotobutton;

  /// Recent Snaps.
  ///
  /// In en, this message translates to:
  /// **'Recent Snaps.'**
  String get recentsnaps;

  /// Your plant is not healthy
  ///
  /// In en, this message translates to:
  /// **'Your plant is not healthy'**
  String get nothealthy;

  /// Common problems
  ///
  /// In en, this message translates to:
  /// **'Common problems'**
  String get commonprolems;

  /// See All
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeall;

  /// Similarity
  ///
  /// In en, this message translates to:
  /// **'Similarity'**
  String get similarity;

  /// clear
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Reasons
  ///
  /// In en, this message translates to:
  /// **'Reasons'**
  String get reasons;

  /// Healthy
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// Uploads
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get uploads;

  /// searchpagesubtitle
  ///
  /// In en, this message translates to:
  /// **'Find!'**
  String get searchpagesubtitle;

  /// searchpagesubtitle2
  ///
  /// In en, this message translates to:
  /// **'Discover the perfect herbs and vegetables using the camera or adding photos from the gallery.'**
  String get searchpagesubtitle2;

  /// typeaplantname
  ///
  /// In en, this message translates to:
  /// **'Type a plant name'**
  String get typeaplantname;

  /// typeaplantname
  ///
  /// In en, this message translates to:
  /// **'Scientific Names'**
  String get scientificnames;

  /// descrip
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descrip;

  /// taxonomy
  ///
  /// In en, this message translates to:
  /// **'Taxonomy'**
  String get taxonomy;

  /// phylum
  ///
  /// In en, this message translates to:
  /// **'Phylum'**
  String get phylum;

  /// phylum
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classs;

  /// family
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// genus
  ///
  /// In en, this message translates to:
  /// **'Genus'**
  String get genus;

  /// plantname
  ///
  /// In en, this message translates to:
  /// **'Plant Name'**
  String get plantname;

  /// day
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// schduletype
  ///
  /// In en, this message translates to:
  /// **'Schedule Type'**
  String get schduletype;

  /// scanyourplant
  ///
  /// In en, this message translates to:
  /// **'Scan your plant'**
  String get scanyourplant;

  /// addyourgarden
  ///
  /// In en, this message translates to:
  /// **'Add your garden'**
  String get addyourgarden;

  /// roomname
  ///
  /// In en, this message translates to:
  /// **'Room Name'**
  String get roomname;

  /// wateringtime
  ///
  /// In en, this message translates to:
  /// **'Watering Time'**
  String get wateringtime;

  /// plant
  ///
  /// In en, this message translates to:
  /// **'Plant'**
  String get plant;

  /// wateringalarmisset
  ///
  /// In en, this message translates to:
  /// **'watering alarms is set.'**
  String get wateringalarmisset;

  /// selectday
  ///
  /// In en, this message translates to:
  /// **'Select Day'**
  String get selectday;

  /// monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// tuesday
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// wednesday
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// thursday
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// friday
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// saturday
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// sunday
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// adddailyreminderbutton
  ///
  /// In en, this message translates to:
  /// **'Add daily reminder'**
  String get adddailyreminderbutton;

  /// addweeklyreminder
  ///
  /// In en, this message translates to:
  /// **'Add weekly reminder'**
  String get addweeklyreminder;

  /// noreminder
  ///
  /// In en, this message translates to:
  /// **'No reminder. Add your first.'**
  String get noreminder;

  /// areyousurewanttodeletereminder
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this reminder?'**
  String get areyousurewanttodeletereminder;

  /// reminderisdeleted
  ///
  /// In en, this message translates to:
  /// **'Reminder is deleted.'**
  String get reminderisdeleted;

  /// yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// no
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// allresponse
  ///
  /// In en, this message translates to:
  /// **'All Response'**
  String get allresponse;

  /// daysago
  ///
  /// In en, this message translates to:
  /// **'Days ago'**
  String get daysago;

  /// category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// addyourfirstgardenbutton
  ///
  /// In en, this message translates to:
  /// **'Add your first garden'**
  String get addyourfirstgardenbutton;

  /// addyourgardentitle
  ///
  /// In en, this message translates to:
  /// **'Add your garden/room etc.'**
  String get addyourgardentitle;

  /// addedisokey
  ///
  /// In en, this message translates to:
  /// **'Your garden is added.'**
  String get addedisokey;

  /// save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// addplantmessage
  ///
  /// In en, this message translates to:
  /// **'Your plant is added.'**
  String get addplantmessage;

  /// areyousuredoyouwanttodelete
  ///
  /// In en, this message translates to:
  /// **'Are you sure? Do you want to delete '**
  String get areyousuredoyouwanttodelete;

  /// isdeleted
  ///
  /// In en, this message translates to:
  /// **'is deleted.'**
  String get isdeleted;

  /// noplant
  ///
  /// In en, this message translates to:
  /// **'No plant.'**
  String get noplant;

  /// youdonthaveanyroomyet
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any rooms yet.'**
  String get youdonthaveanyroomyet;

  /// theplantspreferredmoisturelevel
  ///
  /// In en, this message translates to:
  /// **'The plant\'s preferred moisture level'**
  String get theplantspreferredmoisturelevel;

  /// plsselectaphoto
  ///
  /// In en, this message translates to:
  /// **'Please select a profile photo.'**
  String get plsselectaphoto;

  /// yourplantisadded
  ///
  /// In en, this message translates to:
  /// **'Your plant is being added.'**
  String get yourplantisadded;

  /// plsselectthearearoomyourplant
  ///
  /// In en, this message translates to:
  /// **'Please select the area/room where your plant is located'**
  String get plsselectthearearoomyourplant;

  /// plsenterthenameofyourplant
  ///
  /// In en, this message translates to:
  /// **'Please enter the name of your plant'**
  String get plsenterthenameofyourplant;

  /// camera
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// discover
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// approved
  ///
  /// In en, this message translates to:
  /// **'people approved.'**
  String get approved;

  /// solution
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get solution;

  /// prevention
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get prevention;

  /// locationservicesaredisable
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationservicesaredisable;

  /// locationpermissionaredenied
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get locationpermissionaredenied;

  /// locationpermissionpermanetly
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String get locationpermissionpermanetly;

  /// feelslike
  ///
  /// In en, this message translates to:
  /// **'Feels Like:'**
  String get feelslike;

  /// noselection
  ///
  /// In en, this message translates to:
  /// **'No selection.'**
  String get noselection;

  /// nodata
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any search data yet.'**
  String get nodata;

  /// connectiontimeout
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout\nYour internet connection may be bad,\nThe photo you uploaded may be of poor quality,\nSomething may have gone wrong or,\nAdd more photos.'**
  String get connectiontimeout;

  /// yourplantishealty
  ///
  /// In en, this message translates to:
  /// **'Your plant is healthy'**
  String get yourplantishealty;

  /// selectcountry
  ///
  /// In en, this message translates to:
  /// **'Select country and contact center for weather and sharing data'**
  String get selectcountry;

  /// continuee
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// logoutt
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutt;

  /// beingshare
  ///
  /// In en, this message translates to:
  /// **'Being shared...'**
  String get beingshare;

  /// shareisokey
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shareisokey;

  /// whatdoyouthinkis
  ///
  /// In en, this message translates to:
  /// **'What Do You Think Is?'**
  String get whatdoyouthinkis;

  /// defination
  ///
  /// In en, this message translates to:
  /// **'Defination'**
  String get defination;

  /// location
  ///
  /// In en, this message translates to:
  /// **'Add Location Information'**
  String get location;

  /// share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// locatinInfoAdding
  ///
  /// In en, this message translates to:
  /// **'Adding location information...'**
  String get locatinInfoAdding;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
