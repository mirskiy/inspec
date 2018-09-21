require 'salesforce_helper'

class SalesforceProfiles < Inspec.resource(1)
  name 'salesforce_profiles'
  desc 'Verifies settings for Salesforce profiles in bulk'
  example '
    describe salesforce_profiles do
      it { should exist }
    end
  '

  # This is defined in salesforce_profile, combine?
  @@permission_fields = %w{PermissionsAccessCMC PermissionsActivateContract
    PermissionsActivateOrder PermissionsAddDirectMessageMembers
    PermissionsAllowEmailIC PermissionsAllowLightningLogin
    PermissionsAllowUniversalSearch PermissionsAllowViewEditConvertedLeads
    PermissionsAllowViewKnowledge PermissionsApexRestServices
    PermissionsApiEnabled PermissionsAssignPermissionSets
    PermissionsAssignTopics PermissionsAuthorApex
    PermissionsBulkApiHardDelete PermissionsBulkMacrosAllowed
    PermissionsCampaignInfluence2 PermissionsCanApproveFeedPost
    PermissionsCanInsertFeedSystemFields PermissionsCanUseNewDashboardBuilder
    PermissionsCanVerifyComment PermissionsChangeDashboardColors
    PermissionsChatterComposeUiCodesnippet PermissionsChatterEditOwnPost
    PermissionsChatterEditOwnRecordPost PermissionsChatterFileLink
    PermissionsChatterInternalUser PermissionsChatterInviteExternalUsers
    PermissionsChatterOwnGroups PermissionsCloseConversations
    PermissionsConfigCustomRecs PermissionsConnectOrgToEnvironmentHub
    PermissionsContentAdministrator PermissionsContentWorkspaces
    PermissionsConvertLeads PermissionsCreateCustomizeDashboards
    PermissionsCreateCustomizeFilters PermissionsCreateCustomizeReports
    PermissionsCreateDashboardFolders PermissionsCreateMultiforce
    PermissionsCreateReportFolders PermissionsCreateReportInLightning
    PermissionsCreateTopics PermissionsCreateWorkspaces
    PermissionsCustomMobileAppsAccess PermissionsCustomSidebarOnAllPages
    PermissionsCustomizeApplication PermissionsDataExport
    PermissionsDelegatedTwoFactor PermissionsDeleteActivatedContract
    PermissionsDeleteTopics PermissionsDistributeFromPersWksp
    PermissionsEditActivatedOrders PermissionsEditBrandTemplates
    PermissionsEditCaseComments PermissionsEditEvent PermissionsEditHtmlTemplates
    PermissionsEditKnowledge PermissionsEditMyDashboards PermissionsEditMyReports
    PermissionsEditOppLineItemUnitPrice PermissionsEditPublicDocuments
    PermissionsEditPublicFilters PermissionsEditPublicTemplates
    PermissionsEditReadonlyFields PermissionsEditTask PermissionsEditTopics
    PermissionsEmailAdministration PermissionsEmailMass PermissionsEmailSingle
    PermissionsEmailTemplateManagement PermissionsEnableCommunityAppLauncher
    PermissionsEnableNotifications PermissionsExportReport PermissionsFeedPinning
    PermissionsFlowUFLRequired PermissionsForceTwoFactor
    PermissionsGovernNetworks PermissionsHideReadByList
    PermissionsIdentityConnect PermissionsIdentityEnabled
    PermissionsImportCustomObjects PermissionsImportLeads
    PermissionsImportPersonal PermissionsInstallMultiforce PermissionsIotUser
    PermissionsLightningConsoleAllowedForUser PermissionsLightningExperienceUser
    PermissionsListEmailSend PermissionsLtngPromoReserved01UserPerm
    PermissionsManageAnalyticSnapshots PermissionsManageAuthProviders
    PermissionsManageBusinessHourHolidays PermissionsManageCallCenters
    PermissionsManageCases PermissionsManageCategories
    PermissionsManageCertificates PermissionsManageChatterMessages
    PermissionsManageContentPermissions PermissionsManageContentProperties
    PermissionsManageContentTypes PermissionsManageCustomPermissions
    PermissionsManageCustomReportTypes PermissionsManageDashbdsInPubFolders
    PermissionsManageDataCategories PermissionsManageDataIntegrations
    PermissionsManageDynamicDashboards PermissionsManageEmailClientConfig
    PermissionsManageEncryptionKeys PermissionsManageExchangeConfig
    PermissionsManageHealthCheck PermissionsManageInteraction
    PermissionsManageInternalUsers PermissionsManageIpAddresses
    PermissionsManageKnowledge PermissionsManageKnowledgeImportExport
    PermissionsManageLeads PermissionsManageLoginAccessPolicies
    PermissionsManageMobile PermissionsManageNetworks
    PermissionsManagePasswordPolicies PermissionsManageProfilesPermissionsets
    PermissionsManagePvtRptsAndDashbds PermissionsManageRemoteAccess
    PermissionsManageReportsInPubFolders PermissionsManageRoles
    PermissionsManageSearchPromotionRules PermissionsManageSessionPermissionSets
    PermissionsManageSharing PermissionsManageSolutions PermissionsManageSurveys
    PermissionsManageSynonyms PermissionsManageTwoFactor
    PermissionsManageUnlistedGroups PermissionsManageUsers
    PermissionsMassInlineEdit PermissionsMergeTopics PermissionsModerateChatter
    PermissionsModerateNetworkUsers PermissionsModifyAllData
    PermissionsModifyMetadata PermissionsModifySecureAgents
    PermissionsNewReportBuilder PermissionsPackaging2
    PermissionsPasswordNeverExpires PermissionsPreventClassicExperience
    PermissionsPublishMultiforce PermissionsRemoveDirectMessageMembers
    PermissionsResetPasswords PermissionsRunFlow PermissionsRunReports
    PermissionsSalesConsole PermissionsScheduleReports
    PermissionsSelectFilesFromSalesforce PermissionsSendAnnouncementEmails
    PermissionsSendSitRequests PermissionsShareInternalArticles
    PermissionsShowCompanyNameAsUserBadge PermissionsSolutionImport
    PermissionsSubmitMacrosAllowed PermissionsSubscribeDashboardToOtherUsers
    PermissionsSubscribeReportToOtherUsers PermissionsSubscribeReportsRunAsUser
    PermissionsSubscribeToLightningDashboards
    PermissionsSubscribeToLightningReports PermissionsTransferAnyCase
    PermissionsTransferAnyEntity PermissionsTransferAnyLead
    PermissionsTwoFactorApi PermissionsUseTeamReassignWizards
    PermissionsUseWebLink PermissionsViewAllActivities PermissionsViewAllData
    PermissionsViewAllUsers PermissionsViewContent PermissionsViewDataAssessment
    PermissionsViewDataCategories PermissionsViewEncryptedData
    PermissionsViewEventLogFiles PermissionsViewHealthCheck
    PermissionsViewHelpLink PermissionsViewMyTeamsDashboards
    PermissionsViewPlatformEvents PermissionsViewPublicDashboards
    PermissionsViewPublicReports PermissionsViewRoles PermissionsViewSetup
    PermissionsWorkCalibrationUser PermissionsWorkDotComUserPerm
  }

  # Underlying FilterTable implementation.
  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:exists?) { |x| !x.entries.empty? }
        .register_column(:ids,  field: 'Id')
        .add(:UserTypes,  field: 'UserType')
  filter.connect(self, :table)

  attr_reader :table

  def to_s
    'Salesforce Profiles'
  end

  def initialize(opts = {})
    oath_url = opts.fetch(:url, 'https://login.salesforce.com/services/Soap/u/39.0/')

    @helper = SalesforceHelper.new(inspec, oath_url)
    @helper.login()
    query_profiles
  end

  def query_profiles
    fields = ['Id', 'UserType', 'Name'] + @@permission_fields
    @table = @helper.query_soql('Profile', fields)
  end

end
