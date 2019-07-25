require 'test_helper'

class YoutubeAccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get youtube_accounts_index_url
    assert_response :success
  end

  test "should get new" do
    get youtube_accounts_new_url
    assert_response :success
  end

  test "should get show" do
    get youtube_accounts_show_url
    assert_response :success
  end

end
