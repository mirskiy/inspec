require 'salesforce_helper'

class SalesforceProfile < Inspec.resource(1)
  name 'salesforce_profile'
  supports platform: 'unix'
  desc "Salesforce Profile Resource"
  example "
    describe salesforce_profile do
      #TODO should take id
      #it { should have_activateorder_permissions } ???
      its('PermissionsEmailSingle') { should eq true }
    end
  "

  permission_fields = %w{PermissionsAccessCMC PermissionsActivateContract
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

  fields = permission_fields + %w{Id Name UserType}

  fields.each do |property|
    define_method(property.to_sym) do
      @profile[property]
    end
  end

  def to_s
    'Salesforce Profile #{@profile_id}'
  end

  def initialize(opts = {})
    @profile_id = opts.fetch(:id, nil)
    oath_url = opts.fetch(:url, 'https://login.salesforce.com/services/Soap/u/39.0/')

    @helper = SalesforceHelper.new(inspec, oath_url)
    @helper.login()
    query_profile
  end

  def query_profile
    @profile = @helper.query_sobject('Profile', @profile_id)
    @profile
  end

end
