require "test_helper"

class ArrivalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @arrival = arrivals(:one)
  end

  test "should get index" do
    get arrivals_url
    assert_response :success
  end

  test "should get new" do
    get new_arrival_url
    assert_response :success
  end

  test "should create arrival" do
    assert_difference("Arrival.count") do
      post arrivals_url, params: { arrival: {  } }
    end

    assert_redirected_to arrival_url(Arrival.last)
  end

  test "should show arrival" do
    get arrival_url(@arrival)
    assert_response :success
  end

  test "should get edit" do
    get edit_arrival_url(@arrival)
    assert_response :success
  end

  test "should update arrival" do
    patch arrival_url(@arrival), params: { arrival: {  } }
    assert_redirected_to arrival_url(@arrival)
  end

  test "should destroy arrival" do
    assert_difference("Arrival.count", -1) do
      delete arrival_url(@arrival)
    end

    assert_redirected_to arrivals_url
  end
end
