title 'Password-Based Authentication'

control 'IA-05(01)' do
  only_if { false }
  impact 1.0
  title 'Password-Based Authentication'
  desc  'Ensure password requirements meet IA-05(01) guidelines.'
  ref 'Set Password Policies', url: '1. https://developer.salesforce.com/docs/atlas.en-us.securityImplGuide.meta/securityImplGuide/admin_password.htm'
  #tag nist: 'IA-5(1)'
  tag "nist": ["IA-5(1)", "4"]
  tag "severity": "medium"
  tag "audit text": "Salesforce Setup
1. From Setup, enter Password Policies in the Quick Find box, then select Password Policies.
2. Verify policies meet or exceed CMS ARS Guidelines
 a. Require a minimum 1 day password lifetime: Enabled
 b. User passwords expire in: 60 days
 c. Minimum password length: 8
 d. Password complexity requirement: No restriction
 e. Enforce password history: 6 passwords remembered
"
  tag "fix": "Go to Salesforce Setup
1. From Setup, enter Password Policies in the Quick Find box, then select Password Policies.
2. Set the following Password Policies
 a. Require a minimum 1 day password lifetime: Enabled
 b. User passwords expire in: 60 days
 c. Minimum password length: 8
 d. Password complexity requirement: No restriction
 e. Enforce password history: 6 passwords remembered
"
  tag "Default Value": "
  Require a minimum 1 day password lifetime: (Not Stated)
  User passwords expire in: 90 days
  Minimum password length: 8 characters
  Password complexity requirement: Must mix alpha and numeric characters
  Enforce password history: 3 passwords remembered
  "
  ALL_COMPLEXITY = ["UpperLowerCaseNumericSpecialCharacters", "UpperLowerCaseNumeric", "SpecialCharacters", "AlphaNumeric", "NoRestriction"]

  describe salesforce_password_policies do
    # Require a minimum 1 day password lifetime
    it { should have_minimumpasswordlifetime_enabled }

    # User passwords expire in at most 60 days
    its('expiration_days') { should cmp <= 60 }

    # Minimum password length is at least 8
    its('MinimumPasswordLength') { should cmp >= 8}

    # Password complexity requirement does not have any restrictions
    its('Complexity') { should be_in ALL_COMPLEXITY }

    # Enforce password history must have at least 6 passwords remembered
    its('HistoryRestriction') { should cmp >= 6 }
  end
end

# Need to add:
# verification of admin password length (will have to inspec profiles or something)
# (also add to audit and fix text)
# Can we do anything about dictionary word password restrictions?
# Does workbench have defaults for the ones we are missing.

# Other
# This is AC-07 or something
#  Maximum invalid login attempts: (Not Stated)
#  Lockout effective period: 15 minutes
# It isn't displayed in the right category in the heatmap
