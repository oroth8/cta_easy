require "application_system_test_case"

class ArrivalsTest < ApplicationSystemTestCase
  setup do
    @arrival = arrivals(:one)
  end

  test "visiting the index" do
    visit arrivals_url
    assert_selector "h1", text: "Arrivals"
  end

  test "should create arrival" do
    visit arrivals_url
    click_on "New arrival"

    click_on "Create Arrival"

    assert_text "Arrival was successfully created"
    click_on "Back"
  end

  test "should update Arrival" do
    visit arrival_url(@arrival)
    click_on "Edit this arrival", match: :first

    click_on "Update Arrival"

    assert_text "Arrival was successfully updated"
    click_on "Back"
  end

  test "should destroy Arrival" do
    visit arrival_url(@arrival)
    click_on "Destroy this arrival", match: :first

    assert_text "Arrival was successfully destroyed"
  end
end
