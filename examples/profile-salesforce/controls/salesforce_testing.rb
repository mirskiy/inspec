# encoding: utf-8

control 'Salesforce Testing' do
  only_if { true }
  title 'Salesforce basic test'

  #describe salesforce_user(id: '0051I000001cQDDQA2') do
  #  its('UserType') { should eq 'Standard'}
  #end

  #ALL_COMPLEXITY = ["UpperLowerCaseNumericSpecialCharacters", "UpperLowerCaseNumeric", "SpecialCharacters", "AlphaNumeric", "NoRestriction"]
  #ALLOWED_COMPLEXITY = ALL_COMPLEXITY[0..-3]
  #describe salesforce_password_policies do
    #its('expiration_days') { should cmp <= 90 }
    #its('Complexity') { should be_in ALLOWED_COMPLEXITY }
  #end

  #describe salesforce_profile(id: '00e1I000000RxL0QAK') do
  #  its('PermissionsEmailSingle') { should eq false }
  #  its('UserType') { should eq 'Standard' }
  #end

  salesforce_profiles.where({'PermissionsCustomizeApplication' => true}).ids.each do |profile_id|
    puts(profile_id)
    # Verify ProfilePasswordPolicy password length >= 15
  end

  #describe salesforce_profiles.where({'PermissionsCustomizeApplication' => true}) do
  #  it { should exist }
  #  its ('UserTypes') { should_not include 'Guest' }
  #  its('ids') { should include 'test' }
  #end

  #describe salesforce_profiles.where({'UserType' => 'Guest'}) do
  #  it { should_not exist }
  #end

  #describe salesforce_session_settings do
  #  #it { should be_logged_in }
  #  it { should have_requirehttponly_enabled }
  #  its('RequireHttpOnly') { should eq true }
  #  its('session_timeout_minutes') { should cmp > 5 }
  #  #its('session_timeout_minutes') { should cmp < 48 }
  #end

  #describe salesforce_user do
    #its('user_count') { should cmp > 3 }
    #its('Id') { should cmp > 0 }
  #end
end
