require 'salesforce_helper'

# Custom resource based on the InSpec resource DSL
class Salesforce < Inspec.resource(1)
  name 'salesforce'

  supports platform: 'unix'

  desc "
    Salesforce Resource
  "

  example "
    describe salesforce do
      it { should logged_in }
    end
  "

  def initialize(opts = {})
    oath_url = opts.fetch(:url, 'https://login.salesforce.com/services/Soap/u/39.0/')

    @helper = SalesforceHelper.new(inspec, oath_url)
    @helper.login()
  end

  # Example method to make sure log in succeeded
  def logged_in?
    return @helper.logged_in?
  end

end
