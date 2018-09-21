require 'salesforce_helper'

class SalesforcePasswordPolicies < Inspec.resource(1)
  name 'salesforce_password_policies'
  supports platform: 'unix'
  desc "
    Salesforce Password Policies Resource
  "
  example "
    describe salesforce_password_policies do
      it { should have_obscuresecretanswer_enabled }
      its('ObscureSecretAnswer') { should eq true }
      its('expiration_days') { should cmp <= 90 }
    end
  "

  # Numerics
  attr_reader :expiration_days, :lockout_interval_minutes, :max_login_attempts
  # TODO should historyRestriction and minimumPasswordLength be methods?

  # Booleans
  %w{minimumPasswordLifetime obscureSecretAnswer}.each do |setting_name|
    setting_name_capitalized = setting_name[0].upcase + setting_name[1..-1]
    define_method(setting_name_capitalized.to_sym) do
      @policies[setting_name]
    end

    define_method("has_" + setting_name.downcase.sub(/^enable/, "") + "_enabled?") do
      @policies[setting_name]
    end
  end

  # Strings and unmodified numerics
  %w{apiOnlyUserHomePageURL complexity historyRestriction minimumPasswordLength passwordAssistanceMessage passwordAssistanceURL questionRestriction}.each do |setting_name|
    setting_name_capitalized = setting_name[0].upcase + setting_name[1..-1]
    define_method(setting_name_capitalized.to_sym) do
      @policies[setting_name]
    end
  end

  def to_s
    'Salesforce Password Policies'
  end

  def initialize(opts = {})
    oath_url = opts.fetch(:url, 'https://login.salesforce.com/services/Soap/u/39.0/')

    @helper = SalesforceHelper.new(inspec, oath_url)
    @helper.login()
    query_password_policies
  end

  def query_password_policies
    @policies = @helper.query_security_settings()['passwordPolicies']
    @policies.default_proc = proc do |hash, key|
      raise("Key #{key} not found")
    end
    @policies
  end

  # Note: Acceptable values are available at https://help.salesforce.com/articleView?id=security_custom_baseline_file_requirements.htm&type=5
  def expiration_days()
    # Convert expiration policy string to numeric to support Inspec comparisons
    options = {
      ThirtyDays: 30,
      SixtyDays: 60,
      NinetyDays: 90,
      SixMonths: 180,
      OneYear: 365,
      Never: Float::INFINITY,
    }
    options.default_proc = proc do |hash, key|
      raise("Expiration value #{key} not recognized!")
    end
    options[@policies["expiration"].to_sym]
  end

  def lockout_interval_minutes()
    # Convert lockout interval policy string to numeric to support Inspec comparisons
    options = {
      Forever: Float::INFINITY,
      SixtyMinutes: 60,
      ThirtyMinutes: 30,
      FifteenMinutes: 15,
    }
    options.default_proc = proc do |hash, key|
      raise("Lockout Interval value #{key} not recognized!")
    end
    options[@policies["lockoutInterval"].to_sym]
  end

  def max_login_attempts()
    # Convert max login attempts policy string to numeric type to support Inspec comparisons
    options = {
      ThreeAttempts: 3,
      FiveAttempts: 5,
      TenAttempts: 10,
      NoLimit: Float::INFINITY,
    }
    options.default_proc = proc do |hash, key|
      raise("Max Login Attempts value #{key} not recognized!")
    end
    options[@policies["maxLoginAttempts"].to_sym]
  end

end
