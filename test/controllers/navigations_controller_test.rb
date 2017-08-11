require 'test_helper'

class NavigationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @navigation = navigations(:one)
  end

  test "should get index" do
    get navigations_url
    assert_response :success
  end

  test "should get new" do
    get new_navigation_url
    assert_response :success
  end

  test "should create navigation" do
    assert_difference('Navigation.count') do
      post navigations_url, params: { navigation: { display_text: @navigation.display_text, html_class: @navigation.html_class, parent: @navigation.parent, url: @navigation.url } }
    end

    assert_redirected_to navigation_url(Navigation.last)
  end

  test "should show navigation" do
    get navigation_url(@navigation)
    assert_response :success
  end

  test "should get edit" do
    get edit_navigation_url(@navigation)
    assert_response :success
  end

  test "should update navigation" do
    patch navigation_url(@navigation), params: { navigation: { display_text: @navigation.display_text, html_class: @navigation.html_class, parent: @navigation.parent, url: @navigation.url } }
    assert_redirected_to navigation_url(@navigation)
  end

  test "should destroy navigation" do
    assert_difference('Navigation.count', -1) do
      delete navigation_url(@navigation)
    end

    assert_redirected_to navigations_url
  end
end
