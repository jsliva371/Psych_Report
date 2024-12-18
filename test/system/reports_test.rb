require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)
  end

  test "visiting the index" do
    visit reports_url
    assert_selector "h1", text: "Reports"
  end

  test "should create report" do
    visit reports_url
    click_on "New report"

    fill_in "Analysis", with: @report.analysis
    fill_in "Block design percentile score", with: @report.block_design_percentile_score
    fill_in "Block design scaled score", with: @report.block_design_scaled_score
    fill_in "Coding percentile score", with: @report.coding_percentile_score
    fill_in "Coding scaled score", with: @report.coding_scaled_score
    fill_in "Digit span percentile score", with: @report.digit_span_percentile_score
    fill_in "Digit span scaled score", with: @report.digit_span_scaled_score
    fill_in "Figure weights percentile score", with: @report.figure_weights_percentile_score
    fill_in "Figure weights scaled score", with: @report.figure_weights_scaled_score
    fill_in "Matrix reasoning percentile score", with: @report.matrix_reasoning_percentile_score
    fill_in "Matrix reasoning scaled score", with: @report.matrix_reasoning_scaled_score
    fill_in "Picture span percentile score", with: @report.picture_span_percentile_score
    fill_in "Picture span scaled score", with: @report.picture_span_scaled_score
    fill_in "Similarities percentile score", with: @report.similarities_percentile_score
    fill_in "Similarities scaled score", with: @report.similarities_scaled_score
    fill_in "Symbol search percentile score", with: @report.symbol_search_percentile_score
    fill_in "Symbol search scaled score", with: @report.symbol_search_scaled_score
    fill_in "User", with: @report.user_id
    fill_in "Visual puzzles percentile score", with: @report.visual_puzzles_percentile_score
    fill_in "Visual puzzles scaled score", with: @report.visual_puzzles_scaled_score
    fill_in "Vocabulary percentile score", with: @report.vocabulary_percentile_score
    fill_in "Vocabulary scaled score", with: @report.vocabulary_scaled_score
    click_on "Create Report"

    assert_text "Report was successfully created"
    click_on "Back"
  end

  test "should update Report" do
    visit report_url(@report)
    click_on "Edit this report", match: :first

    fill_in "Analysis", with: @report.analysis
    fill_in "Block design percentile score", with: @report.block_design_percentile_score
    fill_in "Block design scaled score", with: @report.block_design_scaled_score
    fill_in "Coding percentile score", with: @report.coding_percentile_score
    fill_in "Coding scaled score", with: @report.coding_scaled_score
    fill_in "Digit span percentile score", with: @report.digit_span_percentile_score
    fill_in "Digit span scaled score", with: @report.digit_span_scaled_score
    fill_in "Figure weights percentile score", with: @report.figure_weights_percentile_score
    fill_in "Figure weights scaled score", with: @report.figure_weights_scaled_score
    fill_in "Matrix reasoning percentile score", with: @report.matrix_reasoning_percentile_score
    fill_in "Matrix reasoning scaled score", with: @report.matrix_reasoning_scaled_score
    fill_in "Picture span percentile score", with: @report.picture_span_percentile_score
    fill_in "Picture span scaled score", with: @report.picture_span_scaled_score
    fill_in "Similarities percentile score", with: @report.similarities_percentile_score
    fill_in "Similarities scaled score", with: @report.similarities_scaled_score
    fill_in "Symbol search percentile score", with: @report.symbol_search_percentile_score
    fill_in "Symbol search scaled score", with: @report.symbol_search_scaled_score
    fill_in "User", with: @report.user_id
    fill_in "Visual puzzles percentile score", with: @report.visual_puzzles_percentile_score
    fill_in "Visual puzzles scaled score", with: @report.visual_puzzles_scaled_score
    fill_in "Vocabulary percentile score", with: @report.vocabulary_percentile_score
    fill_in "Vocabulary scaled score", with: @report.vocabulary_scaled_score
    click_on "Update Report"

    assert_text "Report was successfully updated"
    click_on "Back"
  end

  test "should destroy Report" do
    visit report_url(@report)
    click_on "Destroy this report", match: :first

    assert_text "Report was successfully destroyed"
  end
end
