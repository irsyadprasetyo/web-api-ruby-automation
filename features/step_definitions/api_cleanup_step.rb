Given("SEIT login backoffice {string} {string} with api") do |email, password|
  get_global_api_address
  credentials = {email: email, password: password}
  @accountinfo = login_mokapos_api(credentials)
  print "\nEmail with #{email} already logged on API!\n"
end

When("SEIT prepare for cleanup data") do
  @userinfo = Hash.new
  @userinfo[:cookiez] = @accountinfo['access_token']
  puts @userinfo[:cookiez]
  @userinfo[:profile] = get_profile_info(@userinfo)
  @userinfo[:outlet_info] = get_outlet_info(@userinfo)
end

When("SEIT do cleanup data for") do |table|
  @data = table.rows
  i = 0
  begin
    @data[i][0]
    case @data[i][0]
      when "item"
        print "\n"
        data_cleanup_library_item(@userinfo)
    end
    i += 1
  end while i <= (@data.length-1)
end
