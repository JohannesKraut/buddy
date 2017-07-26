require 'test_helper'

class FinanceStatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @finance_state = finance_states(:one)
  end

  test "should get index" do
    get finance_states_url
    assert_response :success
  end

  test "should get new" do
    get new_finance_state_url
    assert_response :success
  end

  test "should create finance_state" do
    assert_difference('FinanceState.count') do
      post finance_states_url, params: { finance_state: { account_id: @finance_state.account_id, balance: @finance_state.balance, hibiscus_sync_id: @finance_state.hibiscus_sync_id, period: @finance_state.period } }
    end

    assert_redirected_to finance_state_url(FinanceState.last)
  end

  test "should show finance_state" do
    get finance_state_url(@finance_state)
    assert_response :success
  end

  test "should get edit" do
    get edit_finance_state_url(@finance_state)
    assert_response :success
  end

  test "should update finance_state" do
    patch finance_state_url(@finance_state), params: { finance_state: { account_id: @finance_state.account_id, balance: @finance_state.balance, hibiscus_sync_id: @finance_state.hibiscus_sync_id, period: @finance_state.period } }
    assert_redirected_to finance_state_url(@finance_state)
  end

  test "should destroy finance_state" do
    assert_difference('FinanceState.count', -1) do
      delete finance_state_url(@finance_state)
    end

    assert_redirected_to finance_states_url
  end
end
