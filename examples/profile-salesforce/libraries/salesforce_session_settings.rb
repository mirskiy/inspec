require 'salesforce_helper'

class SalesforceSessionSettings < Inspec.resource(1)
  name 'salesforce_session_settings'
  supports platform: 'unix'
  desc "
    Salesforce Session Settings Resource
  "
  attr_reader :session_timeout_minutes

  example "
    describe salesforce_session_settings do
      it { should have_requirehttponly_enabled }
      its('RequireHttpOnly') { should eq true }
      its('session_timeout_minutes') { should cmp > 5 }
    end
  "

  %w{enforceIpRangesEveryRequest lockSessionsToIp requireHttps enableUpgradeInsecureRequests requireHttpOnly enablePostForSessions enableCacheAndAutocomplete enableClickjackNonsetupSFDC enableClickjackNonsetupUser enableClickjackNonsetupUserHeaderless enableClickjackSetup enableCSRFOnGet enableCSRFOnPost enableXssProtection enableContentSniffingProtection referrerPolicy redirectionWarning}.each do |setting_name|
    setting_name_capitalized = setting_name[0].upcase + setting_name[1..-1]
    define_method(setting_name_capitalized.to_sym) do
      @session_settings[setting_name]
    end

    define_method("has_" + setting_name.downcase.sub(/^enable/, "") + "_enabled?") do
      @session_settings[setting_name]
    end
  end

  def to_s
    'Salesforce Session Settings'
  end

  def initialize(opts = {})
    oath_url = opts.fetch(:url, 'https://login.salesforce.com/services/Soap/u/39.0/')

    @helper = SalesforceHelper.new(inspec, oath_url)
    @helper.login()
    query_session_settings
    @session_timeout_minutes = convert_session_timeout(@session_settings["sessionTimeout"])
  end

  def query_session_settings
    @session_settings = @helper.query_security_settings()['sessionSettings']
    @session_settings.default_proc = proc do |hash, key|
      raise("Key #{key} not found")
    end
    @session_settings
  end

  def convert_session_timeout(session_timeout_string)
    # Convert string to integer minutes to support Inspec comparisons
    options = {
        TwentyFourHours: 576,
        TwelveHours: 288,
        EightHours: 192,
        FourHours: 96,
        TwoHours: 48,
        OneHour: 24,
        ThirtyMinutes: 30,
        FifteenMinutes: 15,
    }
    options.default_proc = proc do |hash, key|
      raise("SessionTimeout value #{key} not recognized!")
    end
    options[session_timeout_string.to_sym]
  end

end
