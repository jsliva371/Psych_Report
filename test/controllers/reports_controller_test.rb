require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report = reports(:one)
  end

  test "should get index" do
    get reports_url
    assert_response :success
  end

  test "should get new" do
    get new_report_url
    assert_response :success
  end

  test "should create report" do
    assert_difference("Report.count") do
      post reports_url, params: { report: { analysis: @report.analysis, block_design_percentile_score: @report.block_design_percentile_score, block_design_scaled_score: @report.block_design_scaled_score, coding_percentile_score: @report.coding_percentile_score, coding_scaled_score: @report.coding_scaled_score, digit_span_percentile_score: @report.digit_span_percentile_score, digit_span_scaled_score: @report.digit_span_scaled_score, figure_weights_percentile_score: @report.figure_weights_percentile_score, figure_weights_scaled_score: @report.figure_weights_scaled_score, matrix_reasoning_percentile_score: @report.matrix_reasoning_percentile_score, matrix_reasoning_scaled_score: @report.matrix_reasoning_scaled_score, picture_span_percentile_score: @report.picture_span_percentile_score, picture_span_scaled_score: @report.picture_span_scaled_score, similarities_percentile_score: @report.similarities_percentile_score, similarities_scaled_score: @report.similarities_scaled_score, symbol_search_percentile_score: @report.symbol_search_percentile_score, symbol_search_scaled_score: @report.symbol_search_scaled_score, user_id: @report.user_id, visual_puzzles_percentile_score: @report.visual_puzzles_percentile_score, visual_puzzles_scaled_score: @report.visual_puzzles_scaled_score, vocabulary_percentile_score: @report.vocabulary_percentile_score, vocabulary_scaled_score: @report.vocabulary_scaled_score } }
    end

    assert_redirected_to report_url(Report.last)
  end

  test "should show report" do
    get report_url(@report)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_url(@report)
    assert_response :success
  end

  test "should update report" do
    patch report_url(@report), params: { report: { analysis: @report.analysis, block_design_percentile_score: @report.block_design_percentile_score, block_design_scaled_score: @report.block_design_scaled_score, coding_percentile_score: @report.coding_percentile_score, coding_scaled_score: @report.coding_scaled_score, digit_span_percentile_score: @report.digit_span_percentile_score, digit_span_scaled_score: @report.digit_span_scaled_score, figure_weights_percentile_score: @report.figure_weights_percentile_score, figure_weights_scaled_score: @report.figure_weights_scaled_score, matrix_reasoning_percentile_score: @report.matrix_reasoning_percentile_score, matrix_reasoning_scaled_score: @report.matrix_reasoning_scaled_score, picture_span_percentile_score: @report.picture_span_percentile_score, picture_span_scaled_score: @report.picture_span_scaled_score, similarities_percentile_score: @report.similarities_percentile_score, similarities_scaled_score: @report.similarities_scaled_score, symbol_search_percentile_score: @report.symbol_search_percentile_score, symbol_search_scaled_score: @report.symbol_search_scaled_score, user_id: @report.user_id, visual_puzzles_percentile_score: @report.visual_puzzles_percentile_score, visual_puzzles_scaled_score: @report.visual_puzzles_scaled_score, vocabulary_percentile_score: @report.vocabulary_percentile_score, vocabulary_scaled_score: @report.vocabulary_scaled_score } }
    assert_redirected_to report_url(@report)
  end

  test "should destroy report" do
    assert_difference("Report.count", -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end
end
