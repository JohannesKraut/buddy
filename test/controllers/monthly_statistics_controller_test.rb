require 'test_helper'

class MonthlyStatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monthly_statistic = monthly_statistics(:one)
  end

  test "should get index" do
    get monthly_statistics_url
    assert_response :success
  end

  test "should get new" do
    get new_monthly_statistic_url
    assert_response :success
  end

  test "should create monthly_statistic" do
    assert_difference('MonthlyStatistic.count') do
      post monthly_statistics_url, params: { monthly_statistic: { actual_value: @monthly_statistic.actual_value, item_id: @monthly_statistic.item_id, period: @monthly_statistic.period, planned_value: @monthly_statistic.planned_value } }
    end

    assert_redirected_to monthly_statistic_url(MonthlyStatistic.last)
  end

  test "should show monthly_statistic" do
    get monthly_statistic_url(@monthly_statistic)
    assert_response :success
  end

  test "should get edit" do
    get edit_monthly_statistic_url(@monthly_statistic)
    assert_response :success
  end

  test "should update monthly_statistic" do
    patch monthly_statistic_url(@monthly_statistic), params: { monthly_statistic: { actual_value: @monthly_statistic.actual_value, item_id: @monthly_statistic.item_id, period: @monthly_statistic.period, planned_value: @monthly_statistic.planned_value } }
    assert_redirected_to monthly_statistic_url(@monthly_statistic)
  end

  test "should destroy monthly_statistic" do
    assert_difference('MonthlyStatistic.count', -1) do
      delete monthly_statistic_url(@monthly_statistic)
    end

    assert_redirected_to monthly_statistics_url
  end
end
