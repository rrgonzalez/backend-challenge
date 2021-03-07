require 'test_helper'

class MemberControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get member_create_url
    assert_response :success
  end

  test "should get index" do
    get member_index_url
    assert_response :success
  end

  test "should get add_friend" do
    get member_add_friend_url
    assert_response :success
  end

  test "should get show" do
    get member_show_url
    assert_response :success
  end

end
