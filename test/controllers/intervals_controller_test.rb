require 'test_helper'

class IntervalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interval = intervals(:one)
  end

  test "should get index" do
    get intervals_url
    assert_response :success
  end

  test "should get new" do
    get new_interval_url
    assert_response :success
  end

  test "should create interval" do
    assert_difference('Interval.count') do
      post intervals_url, params: { interval: { denominator: @interval.denominator, description: @interval.description, numerator: @interval.numerator } }
    end

    assert_redirected_to interval_url(Interval.last)
  end

  test "should show interval" do
    get interval_url(@interval)
    assert_response :success
  end

  test "should get edit" do
    get edit_interval_url(@interval)
    assert_response :success
  end

  test "should update interval" do
    patch interval_url(@interval), params: { interval: { denominator: @interval.denominator, description: @interval.description, numerator: @interval.numerator } }
    assert_redirected_to interval_url(@interval)
  end

  test "should destroy interval" do
    assert_difference('Interval.count', -1) do
      delete interval_url(@interval)
    end

    assert_redirected_to intervals_url
  end
end
