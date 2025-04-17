enum AnalyticsEvent {
  userInfoFetchInitiated,
  userInfoFetchSuccess,
  userInfoFetchFailed,
  deviceBindingComplete,
  deviceBindingInitSNA,
  deviceBindingInitNonSNA,
  deviceBindingError,
}

class FinvuScreens {
  static const String accountDataPage = "accountDataPage";
  static const String equityDetailPage = "equityDetailPage";
  static const String mutualFundDetailPage = "mutualFundDetailPage";
  static const String insuranceDetailPage = "insuranceDetailPage";
  static const String consentHistoryPage = "consentHistoryPage";
  static const String accountLinkingPage = 'account_linking_page';
  static const String discoveredAccountsPage = 'discovered_accounts_page';
  static const String accountsPage = 'accounts_page';
  static const String linkedAccountsDetailsPage =
      'linked_accounts_details_page';

  static const String changePasswordPage = 'change_password_page';
  static const String loginPage = 'login_page';
  static const String recoveryPage = 'recovery_page';
  static const String registrationPage = 'registration_page';
  static const String deviceBindingPage = 'device_binding_page';

  static const String consentApprovalPage = 'consent_approval_page';
  static const String consentDetailsPage = 'consent_details_page';
  static const String consentsHomePage = 'consents_home_page';
  static const String consentsListPage = 'consents_list_page';
  static const String selfConsentPage = 'self_consent_page';

  static const String accountsListPage = 'accounts_list_page';
  static const String homePage = 'home_page';

  static const String changeLanguageDialog = 'change_language_dialog';

  static const String mainPage = 'main_page';

  static const String notificationsPage = 'notifications_page';

  static const String profilePage = 'profile_page';

  static const String splashPage = 'splash_page';
}
