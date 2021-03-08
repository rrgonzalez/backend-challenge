require 'test_helper'

class SearchExpertControllerTest < ActionDispatch::IntegrationTest
  test "should get search_closest_expert" do
    get search_expert_search_closest_expert_url
    assert_response :success
  end

end
