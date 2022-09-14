# Created 02/12/2019
# Irsyad Prasetyo
# API for cleanup data
require 'curb'

module ApiCleanupData
  def login_mokapos_api(param)
    @param = {session:
        {email: param[:email],
        password: param[:password]}
      }
    login = Curl.post("#{@login_addr}", @param.to_json) do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.headers['Content-Type'] = 'application/json'
      curl.headers['Authorization'] = 'undefined'
      curl.headers['User-Agent'] = 'capybara'
      curl.verbose = true
    end
    JSON.parse login.body
  end

####################################### Inventory - Ingredient #######################################
  def get_all_ingredient_library(param)
    params = {"inventory": "all"}
    item_info = Curl.get("#{@ingredient_lib_addr}", params) do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.headers['Content-Type'] = 'application/json'
      curl.headers['User-Agent'] = 'capybara'
      curl.headers['Authorization'] = "#{param[:cookiez]}"
      curl.headers['OUTLET_ID'] = "#{param[:outlet_id]}"
      curl.ssl_verify_peer = false
    end
    JSON.parse item_info.body
  end

###################################### Inventory - Ingredient ########################################

########################################## Item - Library ############################################
  def get_all_item_list(param)
    params = {"outlet_id": param[:outlet_id], "inventory": "all", "is_mobile": false}
    item_info = Curl.get("#{@item_lib_addr}", params) do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.headers['Content-Type'] = 'application/json'
      curl.headers['User-Agent'] = 'capybara'
      curl.headers['Authorization'] = "#{param[:cookiez]}"
      curl.headers['OUTLET_ID'] = "#{param[:outlet_id]}"
      curl.ssl_verify_peer = false
    end
    JSON.parse item_info.body
  end

  def api_delete_item(item_id, param)
    url = "#{@item_lib_addr}/#{item_id}"
    item_info = Curl.delete(url) do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.headers['Content-Type'] = 'application/json'
      curl.headers['User-Agent'] = 'capybara'
      curl.headers['Authorization'] = "#{param[:cookiez]}"
      curl.headers['OUTLET_ID'] = "#{param[:outlet_id]}"
      curl.ssl_verify_peer = false
    end
    JSON.parse item_info.body
  end

  def data_cleanup_library_item(param)
    outlet_num = 0
    while outlet_num < param[:outlet_info].length
      param[:outlet_id] = param[:outlet_info][outlet_num]['id']
      param[:item_info] = get_all_item_list(param)
      if param[:item_info].length > 1
        begin
          item_data = get_all_item_list(param)
          item_id = item_data['items'][0]['id']
          api_delete_item(item_id, param)
          print "Item (#{item_data['items'][0]['name']}) is successfully deleted on outlet: #{param[:outlet_info][outlet_num]['name']}\n"
          item_data = get_all_item_list(param)
        end while item_data.length > 1
      else
        print "There's no Item data on outlet_name: #{param[:outlet_info][outlet_num]['name']}, with outlet_id: #{param[:outlet_info][outlet_num]['id']}\n"
      end
      outlet_num += 1
    end
  end
########################################## Item - Library ############################################
end
