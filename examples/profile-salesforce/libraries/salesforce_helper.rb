class SalesforceHelper
  @@version = "v42.0"
  @@soql_path = "/services/data/#{@@version}/query"
  @@tooling_path = "/services/data/#{@@version}/tooling/query"
  @@sobject_path = "/services/data/#{@@version}/sobjects"

  attr_reader :instance_url, :access_token

  def initialize(inspec, oath_url)
    return skip_resource 'Package `curl` not avaiable on the host' unless inspec.command('curl').exist?

    # Auth
    @username = ENV["SALESFORCE_USERNAME"]
    password = ENV["SALESFORCE_PASSWORD"]
    secret = ENV["SALESFORCE_SECRET"]
    return skip_resource 'Make sure SALESFORCE_USERNAME, SALESFORCE_PASSWORD, SALESFORCE_SECRET env. vars are set.' unless @username and password and secret
    @passcombined = password+secret

    @inspec = inspec
    @oath_url = oath_url || "https://login.salesforce.com/services/Soap/u/39.0/"
  end

  def login()
    soap_login(@username, @passcombined)
  end

  def soap_login(username, password)
    data = %{<?xml version="1.0" encoding="utf-8" ?>
            <env:Envelope  
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
            <env:Body>
            <n1:login xmlns:n1="urn:partner.soap.sforce.com">
            <n1:username>#{username}</n1:username>
            <n1:password>#{password}</n1:password>
            </n1:login></env:Body>
            </env:Envelope>
    }
    headers = {'Content-Type': "text/xml; charset=utf-8", SOAPAction: "login"}
    content = http_post(@oath_url, headers, data)
    if content.match("INVALID_LOGIN")
        raise Exception.new("Error: Salesforce Login failed. Check username and password\n\n#{content}\n")
    end

    @instance_url = content.match(/\<serverUrl\>(https:\/\/[a-zA-Z0-9\-\.]+salesforce\.com)\/services.*\<\/serverUrl\>/)[1]
    @access_token = content.match(/\<sessionId\>(.*)\<\/sessionId\>/)[1]
    @auth_headers = {Authorization: "Bearer #{@access_token}"}
    #puts "----- Vars: #{@instance_url} #{@access_token} -----"
  end

  def http_get_json(url, headers)
    data = http_get(url, headers)

    begin
      content = JSON.parse(data)
    rescue JSON::ParserError => e
      return skip_resource "Couldn't parse the Salesforce response: #{e.message}"
    rescue => e
      return skip_resource e.message
    end

    content
  end

  def http_get(url, headers)
    # headers is hash of header: value
    headers_string = headers.map { |k, v| "-H '#{k}: #{v}'" } .join(" ")
    cmd_string = "curl #{headers_string} #{url}"

    cmd = @inspec.command(cmd_string)

    begin
      verify_curl_success!(cmd)
    rescue => e
      return skip_resource e.message
    end

    cmd.stdout
  end

  def http_post(url, headers, body)
    # headers is hash of header: value
    headers_string = headers.map { |k, v| "-H '#{k}: #{v}'" } .join(" ")
    cmd_string = "curl -X POST #{headers_string} -d '#{body}' #{url}"

    cmd = @inspec.command(cmd_string)

    begin
      verify_curl_success!(cmd)
    rescue => e
      return skip_resource e.message
    end

    cmd.stdout
  end

  def query_sobject(object, id)
    url = "#{@instance_url}#{@@sobject_path}/#{object}/#{id}"
    content = http_get_json(url, @auth_headers)
  end

  def query_soql(object, fields)
    query = "?q=SELECT+" + fields.join(',') + "+FROM+" + object
    url = "#{@instance_url}#{@@soql_path}#{query}"
    content = http_get_json(url, @auth_headers)
    content["records"]
  end

  def query_tooling(object, fields)
    query = "?q=SELECT+" + fields.join(',') + "+FROM+" + object
    url = "#{@instance_url}#{@@tooling_path}#{query}"
    content = http_get_json(url, @auth_headers)
    content["records"]
  end

  def query_security_settings()
    fields = ['Metadata']
    object = 'SecuritySettings'
    query_tooling(object, fields)[0]['Metadata']
  end

  def logged_in?
    return !!@access_token
  end

  def verify_curl_success!(cmd)
    # the following lines captures known possible curl command errors and provides compact skip resource messeges
    if cmd.stderr =~ /Failed to connect/
      raise "Connection refused - please check the URL #{url} for accuracy"
    end

    if cmd.stderr =~ /Peer's Certificate issuer is not recognized/
      raise 'Connection refused - peer certificate issuer is not recognized'
    end

    raise "Error fetching data from curl #{url}: #{cmd.stderr}" unless cmd.exit_status.zero?
  end
end
