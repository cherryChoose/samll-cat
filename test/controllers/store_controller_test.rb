require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "#column #slid a",mininum: 4
    assert_select "h3",'Iphone4'
    assert_select ".price",/\$[,\d]]+|.\d\d/
  end

end
