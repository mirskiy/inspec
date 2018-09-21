require 'salesforce_helper'

class SalesforceUser < Inspec.resource(1)
  name 'salesforce_user'
  supports platform: 'unix'
  desc "Salesforce User Resource"
  example "
    describe salesforce_user do
      its('UserType') { should eq 'Standard' }
    end
  "

  fields = %w{
    AboutMe AccountId Address Alias BadgeText BannerPhotoUrl CallCenterId City
    CommunityNickname CompanyName ContactId Country CreatedById CreatedDate
    DefaultGroupNotificationFrequency DelegatedApproverId Department
    DigestFrequency Division Email EmailEncodingKey EmailPreferencesAutoBcc
    EmailPreferencesAutoBccStayInTouch EmailPreferencesStayInTouchReminder
    EmployeeNumber Extension Fax FederationIdentifier FirstName ForecastEnabled
    FullPhotoUrl GeocodeAccuracy Id IsActive IsExtIndicatorVisible
    IsProfilePhotoActive JigsawImportLimitOverride LanguageLocaleKey
    LastLoginDate LastModifiedById LastModifiedDate LastName
    LastPasswordChangeDate LastReferencedDate LastViewedDate Latitude
    LocaleSidKey Longitude ManagerId MediumBannerPhotoUrl MediumPhotoUrl
    MobilePhone Name OfflinePdaTrialExpirationDate OfflineTrialExpirationDate
    OutOfOfficeMessage Phone PostalCode ProfileId ReceivesAdminInfoEmails
    ReceivesInfoEmails SenderEmail SenderName Signature SmallBannerPhotoUrl
    SmallPhotoUrl State StayInTouchNote StayInTouchSignature StayInTouchSubject
    Street SystemModstamp TimeZoneSidKey Title Username
    UserPermissionsCallCenterAutoLogin UserPermissionsInteractionUser
    UserPermissionsJigsawProspectingUser UserPermissionsKnowledgeUser
    UserPermissionsMarketingUser UserPermissionsMobileUser
    UserPermissionsOfflineUser UserPermissionsSFContentUser
    UserPermissionsSiteforceContributorUser UserPermissionsSiteforcePublisherUser
    UserPermissionsSupportUser UserPermissionsWorkDotComUserFeature
    UserPreferencesActivityRemindersPopup UserPreferencesApexPagesDeveloperMode
    UserPreferencesCacheDiagnostics UserPreferencesContentEmailAsAndWhen
    UserPreferencesContentNoEmail UserPreferencesCreateLEXAppsWTShown
    UserPreferencesDisableAllFeedsEmail UserPreferencesDisableBookmarkEmail
    UserPreferencesDisableChangeCommentEmail
    UserPreferencesDisableEndorsementEmail UserPreferencesDisableFeedbackEmail
    UserPreferencesDisableFileShareNotificationsForApi
    UserPreferencesDisableFollowersEmail UserPreferencesDisableLaterCommentEmail
    UserPreferencesDisableLikeEmail UserPreferencesDisableMentionsPostEmail
    UserPreferencesDisableMessageEmail UserPreferencesDisableProfilePostEmail
    UserPreferencesDisableSharePostEmail UserPreferencesDisableWorkEmail
    UserPreferencesDisCommentAfterLikeEmail
    UserPreferencesDisMentionsCommentEmail UserPreferencesDisProfPostCommentEmail
    UserPreferencesEnableAutoSubForFeeds
    UserPreferencesEventRemindersCheckboxDefault
    UserPreferencesExcludeMailAppAttachments
    UserPreferencesFavoritesShowTopFavorites UserPreferencesFavoritesWTShown
    UserPreferencesGlobalNavBarWTShown UserPreferencesGlobalNavGridMenuWTShown
    UserPreferencesHasCelebrationBadge UserPreferencesHideBiggerPhotoCallout
    UserPreferencesHideChatterOnboardingSplash UserPreferencesHideCSNDesktopTask
    UserPreferencesHideCSNGetChatterMobileTask
    UserPreferencesHideEndUserOnboardingAssistantModal
    UserPreferencesHideLightningMigrationModal UserPreferencesHideS1BrowserUI
    UserPreferencesHideSecondChatterOnboardingSplash
    UserPreferencesHideSfxWelcomeMat UserPreferencesJigsawListUser
    UserPreferencesLightningExperiencePreferred
    UserPreferencesPathAssistantCollapsed UserPreferencesPreviewCustomTheme
    UserPreferencesPreviewLightning UserPreferencesRecordHomeReservedWTShown
    UserPreferencesRecordHomeSectionCollapseWTShown
    UserPreferencesReminderSoundOff UserPreferencesShowCityToExternalUsers
    UserPreferencesShowCityToGuestUsers UserPreferencesShowCountryToExternalUsers
    UserPreferencesShowCountryToGuestUsers
    UserPreferencesShowEmailToExternalUsers UserPreferencesShowEmailToGuestUsers
    UserPreferencesShowFaxToExternalUsers UserPreferencesShowFaxToGuestUsers
    UserPreferencesShowManagerToExternalUsers
    UserPreferencesShowManagerToGuestUsers
    UserPreferencesShowMobilePhoneToExternalUsers
    UserPreferencesShowMobilePhoneToGuestUsers
    UserPreferencesShowPostalCodeToExternalUsers
    UserPreferencesShowPostalCodeToGuestUsers
    UserPreferencesShowProfilePicToGuestUsers
    UserPreferencesShowStateToExternalUsers UserPreferencesShowStateToGuestUsers
    UserPreferencesShowStreetAddressToExternalUsers
    UserPreferencesShowStreetAddressToGuestUsers
    UserPreferencesShowTitleToExternalUsers UserPreferencesShowTitleToGuestUsers
    UserPreferencesShowWorkPhoneToExternalUsers
    UserPreferencesShowWorkPhoneToGuestUsers UserPreferencesSortFeedByComment
    UserPreferencesSuppressEventSFXReminders
    UserPreferencesSuppressTaskSFXReminders
    UserPreferencesTaskRemindersCheckboxDefault UserPreferencesUserDebugModePref
    UserRoleId UserType
  }

  fields.each do |property|
    define_method(property.to_sym) do
      @user[property]
    end
  end

  def to_s
    'Salesforce User #{@user_id}'
  end

  def initialize(opts = {})
    @user_id = opts.fetch(:id, nil)
    oath_url = opts.fetch(:url, nil)

    @helper = SalesforceHelper.new(inspec, oath_url)
    @helper.login()
    query_user
  end

  def query_user
    @user = @helper.query_sobject('User', @user_id)
    @user
  end

end
