import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @aaHandle.
  ///
  /// In en, this message translates to:
  /// **'AA Handle'**
  String get aaHandle;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @acceptedOn.
  ///
  /// In en, this message translates to:
  /// **'Accepted On'**
  String get acceptedOn;

  /// No description provided for @accessAllFeaturesOnFinvu.
  ///
  /// In en, this message translates to:
  /// **'Access all features on Finvu'**
  String get accessAllFeaturesOnFinvu;

  /// No description provided for @accessDetails.
  ///
  /// In en, this message translates to:
  /// **'Access Details'**
  String get accessDetails;

  /// No description provided for @accountActivity.
  ///
  /// In en, this message translates to:
  /// **'Account Activity'**
  String get accountActivity;

  /// No description provided for @accountConsents.
  ///
  /// In en, this message translates to:
  /// **'Consents for this account'**
  String get accountConsents;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @accountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account Linked'**
  String get accountLinked;

  /// No description provided for @accountRegisteredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account registered successfully'**
  String get accountRegisteredSuccessfully;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @accountsDiscoveredWithMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'We have discovered below accounts associated with mobile number'**
  String get accountsDiscoveredWithMobileNumber;

  /// No description provided for @accountsFound.
  ///
  /// In en, this message translates to:
  /// **'Accounts Found'**
  String get accountsFound;

  /// No description provided for @accountsWillBeDelinked.
  ///
  /// In en, this message translates to:
  /// **'• Accounts will be delinked.'**
  String get accountsWillBeDelinked;

  /// No description provided for @accountTypesRequested.
  ///
  /// In en, this message translates to:
  /// **'Account Types Requested'**
  String get accountTypesRequested;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeConsents.
  ///
  /// In en, this message translates to:
  /// **'Active Consents'**
  String get activeConsents;

  /// No description provided for @activeSelfConsents.
  ///
  /// In en, this message translates to:
  /// **'Active Self Consents'**
  String get activeSelfConsents;

  /// No description provided for @addInsuranceEquityAndDeposits.
  ///
  /// In en, this message translates to:
  /// **'Add insurance, equity, deposits, mutual funds & more for hassle free experience'**
  String get addInsuranceEquityAndDeposits;

  /// No description provided for @addMoreAccounts.
  ///
  /// In en, this message translates to:
  /// **'Add More Accounts'**
  String get addMoreAccounts;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @addNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Add New Account'**
  String get addNewAccount;

  /// No description provided for @addNewMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'ADD NEW MOBILE NUMBER'**
  String get addNewMobileNumber;

  /// No description provided for @addNow.
  ///
  /// In en, this message translates to:
  /// **'Add Now'**
  String get addNow;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @alreadyAUserSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already a user? Sign In'**
  String get alreadyAUserSignIn;

  /// No description provided for @approachingYourBank.
  ///
  /// In en, this message translates to:
  /// **'Approaching your bank!'**
  String get approachingYourBank;

  /// No description provided for @approveConsent.
  ///
  /// In en, this message translates to:
  /// **'Approve Consent'**
  String get approveConsent;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @bankAccounts.
  ///
  /// In en, this message translates to:
  /// **'Bank Accounts'**
  String get bankAccounts;

  /// No description provided for @bankAccountsLinkedConsent.
  ///
  /// In en, this message translates to:
  /// **'You have successfully linked the below bank accounts. Please provide self consent in order to proceed.'**
  String get bankAccountsLinkedConsent;

  /// No description provided for @bankAccountsLinkedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bank accounts linked successfully!'**
  String get bankAccountsLinkedSuccess;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @changeMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Mobile Number'**
  String get changeMobileNumber;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @chooseAccounts.
  ///
  /// In en, this message translates to:
  /// **'Choose Accounts'**
  String get chooseAccounts;

  /// No description provided for @closeAAAccount.
  ///
  /// In en, this message translates to:
  /// **'Close AA account'**
  String get closeAAAccount;

  /// No description provided for @closeAccount.
  ///
  /// In en, this message translates to:
  /// **'Close Account'**
  String get closeAccount;

  /// No description provided for @closeFinvuAccount.
  ///
  /// In en, this message translates to:
  /// **'Finvu account has been closed successfully'**
  String get closeFinvuAccount;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @confirmYourApproval.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Approval'**
  String get confirmYourApproval;

  /// No description provided for @consentApproved.
  ///
  /// In en, this message translates to:
  /// **'Consent Approved'**
  String get consentApproved;

  /// No description provided for @consentDetails.
  ///
  /// In en, this message translates to:
  /// **'Consents Details'**
  String get consentDetails;

  /// No description provided for @consentExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Consent Expires On'**
  String get consentExpiresOn;

  /// No description provided for @consentForAccounts.
  ///
  /// In en, this message translates to:
  /// **'Consent For Accounts'**
  String get consentForAccounts;

  /// No description provided for @consentFromDate.
  ///
  /// In en, this message translates to:
  /// **'Consent From Date'**
  String get consentFromDate;

  /// No description provided for @consentId.
  ///
  /// In en, this message translates to:
  /// **'Consent Id'**
  String get consentId;

  /// No description provided for @consentPurpose.
  ///
  /// In en, this message translates to:
  /// **'Consent Purpose'**
  String get consentPurpose;

  /// No description provided for @consentRejected.
  ///
  /// In en, this message translates to:
  /// **'Consent Rejected'**
  String get consentRejected;

  /// No description provided for @consentRequested.
  ///
  /// In en, this message translates to:
  /// **'Consent Requested'**
  String get consentRequested;

  /// No description provided for @consentRequestedOn.
  ///
  /// In en, this message translates to:
  /// **'Consent Requested On'**
  String get consentRequestedOn;

  /// No description provided for @consentRevoked.
  ///
  /// In en, this message translates to:
  /// **'Consent Revoked'**
  String get consentRevoked;

  /// No description provided for @consents.
  ///
  /// In en, this message translates to:
  /// **'Consents'**
  String get consents;

  /// No description provided for @consentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Consent provided successfully'**
  String get consentSuccessMessage;

  /// No description provided for @consentsWillBeRevoked.
  ///
  /// In en, this message translates to:
  /// **'• Your consents will be revoked.'**
  String get consentsWillBeRevoked;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @continueSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue Sign In'**
  String get continueSignIn;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @customerSpendingPatternsBudgetOrOtherReportings.
  ///
  /// In en, this message translates to:
  /// **'Customer spending patterns, budget or other reportings'**
  String get customerSpendingPatternsBudgetOrOtherReportings;

  /// No description provided for @dataFetchFrequency.
  ///
  /// In en, this message translates to:
  /// **'Data Fetch Frequency'**
  String get dataFetchFrequency;

  /// No description provided for @dataFetchFrom.
  ///
  /// In en, this message translates to:
  /// **'Data Fetch From'**
  String get dataFetchFrom;

  /// No description provided for @dataFetchUntil.
  ///
  /// In en, this message translates to:
  /// **'Data Fetch Until'**
  String get dataFetchUntil;

  /// No description provided for @dataFromDate.
  ///
  /// In en, this message translates to:
  /// **'Data From Date'**
  String get dataFromDate;

  /// No description provided for @dataRetrievalTimestamps.
  ///
  /// In en, this message translates to:
  /// **'Data Retrieval Timestamps'**
  String get dataRetrievalTimestamps;

  /// No description provided for @dataStoredUntil.
  ///
  /// In en, this message translates to:
  /// **'Data Stored Until'**
  String get dataStoredUntil;

  /// No description provided for @dataToDate.
  ///
  /// In en, this message translates to:
  /// **'Data To Date'**
  String get dataToDate;

  /// No description provided for @dataUse.
  ///
  /// In en, this message translates to:
  /// **'Data Use'**
  String get dataUse;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @deleteAAAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete AA Account'**
  String get deleteAAAccount;

  /// No description provided for @delink.
  ///
  /// In en, this message translates to:
  /// **'De-link'**
  String get delink;

  /// No description provided for @delinkAccount.
  ///
  /// In en, this message translates to:
  /// **'De-link Account'**
  String get delinkAccount;

  /// No description provided for @delinkAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delink this account? All consents approved for this account will be revoked.'**
  String get delinkAccountConfirmation;

  /// No description provided for @delinkingSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Delinking Successful'**
  String get delinkingSuccessful;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'De-Select All'**
  String get deselectAll;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @doNotHaveFinvuAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don’t have a Finvu Account yet?  Register'**
  String get doNotHaveFinvuAccountRegister;

  /// No description provided for @downloadConsentReport.
  ///
  /// In en, this message translates to:
  /// **'Download Consent Report'**
  String get downloadConsentReport;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download Failed'**
  String get downloadFailed;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @enterMobileNumberLinkedToFinvuAAHandle.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number linked to Finvu AA Handle'**
  String get enterMobileNumberLinkedToFinvuAAHandle;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @equities.
  ///
  /// In en, this message translates to:
  /// **'Equities'**
  String get equities;

  /// No description provided for @equityHoldings.
  ///
  /// In en, this message translates to:
  /// **'Equity Holdings'**
  String get equityHoldings;

  /// No description provided for @expiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired On'**
  String get expiredOn;

  /// Expires on date
  ///
  /// In en, this message translates to:
  /// **'Expires on {date}'**
  String expiresOn(String date);

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @expiryOn.
  ///
  /// In en, this message translates to:
  /// **'Expiry On'**
  String get expiryOn;

  /// No description provided for @failedToFetchData.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch data'**
  String get failedToFetchData;

  /// No description provided for @facingIssues.
  ///
  /// In en, this message translates to:
  /// **'Facing issues? please contact '**
  String get facingIssues;

  /// No description provided for @fiTypes.
  ///
  /// In en, this message translates to:
  /// **'FI Types'**
  String get fiTypes;

  /// No description provided for @finvuHasSentOtp.
  ///
  /// In en, this message translates to:
  /// **'A one-time password has been sent on your registered mobile number {mobileNumber} via {method}.'**
  String finvuHasSentOtp(Object method, Object mobileNumber);

  /// No description provided for @folioNo.
  ///
  /// In en, this message translates to:
  /// **'Folio No'**
  String get folioNo;

  /// No description provided for @followingBanksRequestedConsent.
  ///
  /// In en, this message translates to:
  /// **'Following institution has requested your consent to access information from your accounts.'**
  String get followingBanksRequestedConsent;

  /// No description provided for @forceUpdateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please update your Finvu app to ensure the best and safest experience.'**
  String get forceUpdateSubtitle;

  /// No description provided for @forceUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Important Update Available'**
  String get forceUpdateTitle;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get forgot;

  /// No description provided for @forgotPinOrAAHandle.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN | AA Handle?'**
  String get forgotPinOrAAHandle;

  /// No description provided for @foundAaHandle.
  ///
  /// In en, this message translates to:
  /// **'Found AA Handle(s)'**
  String get foundAaHandle;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// No description provided for @goToConsents.
  ///
  /// In en, this message translates to:
  /// **'Go to Consents'**
  String get goToConsents;

  /// No description provided for @goTOSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goTOSettings;

  /// No description provided for @gstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get gstin;

  /// No description provided for @hasYourConsentAccess.
  ///
  /// In en, this message translates to:
  /// **'has your consent to access information from accounts'**
  String get hasYourConsentAccess;

  /// No description provided for @holdings.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get holdings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hr;

  /// No description provided for @hrs.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get hrs;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @inactiveConsents.
  ///
  /// In en, this message translates to:
  /// **'Inactive Consents'**
  String get inactiveConsents;

  /// Information fetched count
  ///
  /// In en, this message translates to:
  /// **'Information fetched {count} times / {unit}'**
  String informationFetchedTimes(int count, String unit);

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @insurancePolicies.
  ///
  /// In en, this message translates to:
  /// **'Insurance Policies'**
  String get insurancePolicies;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid Otp'**
  String get invalidOtp;

  /// No description provided for @invalidUsernameOrPin.
  ///
  /// In en, this message translates to:
  /// **'Invalid Username or PIN'**
  String get invalidUsernameOrPin;

  /// No description provided for @isin.
  ///
  /// In en, this message translates to:
  /// **'ISIN'**
  String get isin;

  /// No description provided for @justAMonentDeviceBinding.
  ///
  /// In en, this message translates to:
  /// **'Just a moment, we are ensuring your Finvu AA account can be accessed only through this device'**
  String get justAMonentDeviceBinding;

  /// No description provided for @knowMoreAboutFinvu.
  ///
  /// In en, this message translates to:
  /// **'KNOW MORE ABOUT FINVU'**
  String get knowMoreAboutFinvu;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @linkAccounts.
  ///
  /// In en, this message translates to:
  /// **'Link Accounts'**
  String get linkAccounts;

  /// No description provided for @linked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get linked;

  /// No description provided for @linkingSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Linking Successful'**
  String get linkingSuccessful;

  /// No description provided for @loginDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Cookiejar Technologies Pvt Ltd. is a registered and licensed NBFC Account Aggregator (NBFC-AA) from the Reserve Bank of India (RBI) and has the operational license for the business of account aggregation. Finvu AA is a brand of Cookiejar Technologies Pvt Ltd.'**
  String get loginDisclaimer;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @managingConsentPoint1.
  ///
  /// In en, this message translates to:
  /// **'Finvu is a brand name of Cookiejar Technologies that is a licensed and operational NBFC Account Aggregator from Reserve Bank of India (RBI)'**
  String get managingConsentPoint1;

  /// No description provided for @managingConsentPoint2.
  ///
  /// In en, this message translates to:
  /// **'Account Aggregator are entities that do not store or read your financial information but only facilitate instant and real-time secure sharing of financial information'**
  String get managingConsentPoint2;

  /// No description provided for @managingConsentPoint3.
  ///
  /// In en, this message translates to:
  /// **'Individuals now have a trusted platform to take control of finances and the financial information you share with an explicit Consent'**
  String get managingConsentPoint3;

  /// No description provided for @managingConsentPoint4.
  ///
  /// In en, this message translates to:
  /// **'Register to get your virtual AA handle and link your Bank accounts, Insurance Policies, Equity demat accounts, Mutual Funds and other assets held with financial institutions and share information safely'**
  String get managingConsentPoint4;

  /// No description provided for @managingConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Introducing Finvu, Account Aggregator'**
  String get managingConsentTitle;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mins;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @mutualFunds.
  ///
  /// In en, this message translates to:
  /// **'Mutual Funds'**
  String get mutualFunds;

  /// No description provided for @networkInsecure.
  ///
  /// In en, this message translates to:
  /// **'Your network is insecure'**
  String get networkInsecure;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @newPinAndOldPinCannotBeTheSame.
  ///
  /// In en, this message translates to:
  /// **'New and current PIN cannot be the same'**
  String get newPinAndOldPinCannotBeTheSame;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noAccountFound.
  ///
  /// In en, this message translates to:
  /// **'No Account Found'**
  String get noAccountFound;

  /// No description provided for @noAccountsDiscoveredReason1.
  ///
  /// In en, this message translates to:
  /// **'This could be due to either:'**
  String get noAccountsDiscoveredReason1;

  /// No description provided for @noAccountsDiscoveredReason2.
  ///
  /// In en, this message translates to:
  /// **'• The institution may be experiencing some technical difficulties - please try again later'**
  String get noAccountsDiscoveredReason2;

  /// No description provided for @noAccountsDiscoveredReason3.
  ///
  /// In en, this message translates to:
  /// **'• Your account with the bank is a joint account - Banks only support this functionality on Individual accounts'**
  String get noAccountsDiscoveredReason3;

  /// No description provided for @noAccountsFoundAssociatedWith.
  ///
  /// In en, this message translates to:
  /// **'Could not find accounts for below institutions with mobile number'**
  String get noAccountsFoundAssociatedWith;

  /// No description provided for @noConsentActivityFound.
  ///
  /// In en, this message translates to:
  /// **'No Consent Activity found'**
  String get noConsentActivityFound;

  /// No description provided for @noConsentFound.
  ///
  /// In en, this message translates to:
  /// **'No consent found for this Account'**
  String get noConsentFound;

  /// No description provided for @noOtherNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Other Notifications'**
  String get noOtherNotifications;

  /// No description provided for @noPriorityNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Priority Notifications'**
  String get noPriorityNotifications;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noUnlinkedAccounts.
  ///
  /// In en, this message translates to:
  /// **'No Unlinked Accounts'**
  String get noUnlinkedAccounts;

  /// No description provided for @nps.
  ///
  /// In en, this message translates to:
  /// **'NPS'**
  String get nps;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @oopsDeviceRegistrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Oops, Device Registration Failed'**
  String get oopsDeviceRegistrationFailed;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @otherNotifications.
  ///
  /// In en, this message translates to:
  /// **'Other Notifications'**
  String get otherNotifications;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @pausedConsents.
  ///
  /// In en, this message translates to:
  /// **'Paused Consents'**
  String get pausedConsents;

  /// No description provided for @pendingConsentDetails.
  ///
  /// In en, this message translates to:
  /// **'Pending Consent Details'**
  String get pendingConsentDetails;

  /// No description provided for @pendingConsents.
  ///
  /// In en, this message translates to:
  /// **'Pending Consents'**
  String get pendingConsents;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @pinChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PIN Changed Successfully'**
  String get pinChangedSuccessfully;

  /// No description provided for @pinChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'PIN Change Failed'**
  String get pinChangeFailed;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsDoNotMatch;

  /// No description provided for @pleaseAcceptTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Please accept terms and conditions to proceed.'**
  String get pleaseAcceptTermsAndConditions;

  /// No description provided for @pleaseCheckYourConnectionOrSim.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and ensure the SIM card is active in this device. Then, log in again to continue.'**
  String get pleaseCheckYourConnectionOrSim;

  /// Subtitle for the dialog where user is asked to enter identifier
  ///
  /// In en, this message translates to:
  /// **'Please enter the {identifierType} in order to get your details'**
  String pleaseEnterIdentifierToGetDetails(String identifierType);

  /// No description provided for @pleaseEnterLinkedMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter the mobile number linked to your account'**
  String get pleaseEnterLinkedMobileNumber;

  /// No description provided for @pleaseEnterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number for account linking'**
  String get pleaseEnterMobileNumber;

  /// No description provided for @pleaseEnterValidPanCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid pancard number'**
  String get pleaseEnterValidPanCardNumber;

  /// No description provided for @pleaseVerifyYourMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please verify your mobile number'**
  String get pleaseVerifyYourMobileNumber;

  /// No description provided for @welcomeYourAAHandleIs.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Your AA Handle is {handleID}'**
  String welcomeYourAAHandleIs(Object handleID);

  /// No description provided for @pleaseEnterAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please enter all fields'**
  String get pleaseEnterAllFields;

  /// Plus more count
  ///
  /// In en, this message translates to:
  /// **'+ {count} more'**
  String plusMore(int count);

  /// No description provided for @policies.
  ///
  /// In en, this message translates to:
  /// **'Policies'**
  String get policies;

  /// No description provided for @policyName.
  ///
  /// In en, this message translates to:
  /// **'Policy Name'**
  String get policyName;

  /// No description provided for @policyNumber.
  ///
  /// In en, this message translates to:
  /// **'Policy Number'**
  String get policyNumber;

  /// No description provided for @sixDigitOtp.
  ///
  /// In en, this message translates to:
  /// **'6 Digit OTP'**
  String get sixDigitOtp;

  /// No description provided for @sumAssured.
  ///
  /// In en, this message translates to:
  /// **'Sum Assured'**
  String get sumAssured;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'support'**
  String get support;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @policyType.
  ///
  /// In en, this message translates to:
  /// **'Policy Type'**
  String get policyType;

  /// No description provided for @premiumAmount.
  ///
  /// In en, this message translates to:
  /// **'Premium amount'**
  String get premiumAmount;

  /// No description provided for @premiumFrequency.
  ///
  /// In en, this message translates to:
  /// **'Premium frequency'**
  String get premiumFrequency;

  /// No description provided for @premiumPaymentYears.
  ///
  /// In en, this message translates to:
  /// **'Premium payment years'**
  String get premiumPaymentYears;

  /// No description provided for @nextPremium.
  ///
  /// In en, this message translates to:
  /// **'Next premium'**
  String get nextPremium;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @provideConsent.
  ///
  /// In en, this message translates to:
  /// **'Provide Consent'**
  String get provideConsent;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerAccount.
  ///
  /// In en, this message translates to:
  /// **'Register Account'**
  String get registerAccount;

  /// No description provided for @registerDevice.
  ///
  /// In en, this message translates to:
  /// **'Register Device'**
  String get registerDevice;

  /// No description provided for @registeringYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Registering your device'**
  String get registeringYourDevice;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registrationFailed;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Requested on date
  ///
  /// In en, this message translates to:
  /// **'Requested on {date}'**
  String requestedOn(String date);

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in'**
  String get resendOtpIn;

  /// No description provided for @retryLogin.
  ///
  /// In en, this message translates to:
  /// **'Retry Login'**
  String get retryLogin;

  /// No description provided for @revoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// No description provided for @revokeConsentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure that you want to revoke this consent?'**
  String get revokeConsentConfirmation;

  /// No description provided for @searchInstitution.
  ///
  /// In en, this message translates to:
  /// **'Search Institution'**
  String get searchInstitution;

  /// No description provided for @sec.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get sec;

  /// No description provided for @secs.
  ///
  /// In en, this message translates to:
  /// **'secs'**
  String get secs;

  /// No description provided for @securityCompromisedErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Your device\'\'s security has been compromised. For the safety of your financial information, access to the Finvu app is restricted on this device.'**
  String get securityCompromisedErrorDescription;

  /// No description provided for @securityError.
  ///
  /// In en, this message translates to:
  /// **'Security Error'**
  String get securityError;

  /// No description provided for @securityPasscodeLockErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'The device is not protected by a passcode or lock. To ensure the security of your Finvu application, please set up a passcode or lock on your device.'**
  String get securityPasscodeLockErrorDescription;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @selectMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Select Mobile Number'**
  String get selectMobileNumber;

  /// No description provided for @selfConsent.
  ///
  /// In en, this message translates to:
  /// **'Self Consent'**
  String get selfConsent;

  /// No description provided for @selfConsentRequest.
  ///
  /// In en, this message translates to:
  /// **'Provide self consent'**
  String get selfConsentRequest;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredLoginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired, please login again to continue'**
  String get sessionExpiredLoginToContinue;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInUsingPin.
  ///
  /// In en, this message translates to:
  /// **'Sign In Using PIN'**
  String get signInUsingPin;

  /// No description provided for @sitBackAndRelax.
  ///
  /// In en, this message translates to:
  /// **'Sit back and relax while we discover your accounts'**
  String get sitBackAndRelax;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @somethingWentWrongPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again in sometime.'**
  String get somethingWentWrongPleaseTryAgain;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @termAndRecurringDeposits.
  ///
  /// In en, this message translates to:
  /// **'Term & Recurring Deposits'**
  String get termAndRecurringDeposits;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Time ago text
  ///
  /// In en, this message translates to:
  /// **'{value} {unit} ago'**
  String timeAgo(int value, String unit);

  /// Times per unit
  ///
  /// In en, this message translates to:
  /// **'{value} times per {unit}'**
  String timesPerUnit(int value, String unit);

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transactionTime.
  ///
  /// In en, this message translates to:
  /// **'Transaction Time'**
  String get transactionTime;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @usePinToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Use PIN to Sign In'**
  String get usePinToSignIn;

  /// No description provided for @verifyDeviceViaOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify device via OTP'**
  String get verifyDeviceViaOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @verifyOtpAndSetPin.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP and Set PIN'**
  String get verifyOtpAndSetPin;

  /// No description provided for @verifyYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Details'**
  String get verifyYourDetails;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewConsentActivity.
  ///
  /// In en, this message translates to:
  /// **'VIEW CONSENT ACTIVITY'**
  String get viewConsentActivity;

  /// No description provided for @viewTransactions.
  ///
  /// In en, this message translates to:
  /// **'View Transactions'**
  String get viewTransactions;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @viewData.
  ///
  /// In en, this message translates to:
  /// **'View Data'**
  String get viewData;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks;

  /// No description provided for @weHaveFoundFollowingAaHandles.
  ///
  /// In en, this message translates to:
  /// **'We have found the following AA Handle(s) associated with your mobile number: '**
  String get weHaveFoundFollowingAaHandles;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hey, Good to see you again!'**
  String get welcomeMessage;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// AA Handle shown to the user
  ///
  /// In en, this message translates to:
  /// **'Your AA Handle is {aaHandle}'**
  String yourAAHandleIs(String aaHandle);

  /// No description provided for @yourAccountIsNowRegistered.
  ///
  /// In en, this message translates to:
  /// **'Your account is now registered, please continue with login'**
  String get yourAccountIsNowRegistered;

  /// No description provided for @yourConsents.
  ///
  /// In en, this message translates to:
  /// **'Your Consents'**
  String get yourConsents;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en', 'gu', 'hi', 'kn', 'ml', 'mr', 'or', 'pa', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
    case 'gu': return AppLocalizationsGu();
    case 'hi': return AppLocalizationsHi();
    case 'kn': return AppLocalizationsKn();
    case 'ml': return AppLocalizationsMl();
    case 'mr': return AppLocalizationsMr();
    case 'or': return AppLocalizationsOr();
    case 'pa': return AppLocalizationsPa();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
