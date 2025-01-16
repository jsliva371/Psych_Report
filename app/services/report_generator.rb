require 'prawn'

class ReportGenerator
  def initialize(report)
    @report = report
  end

  def generate_pdf
    Prawn::Document.generate("output.pdf") do |pdf|
      # Set font
      pdf.font_families.update("Play" => {
      normal: "#{Rails.root}/app/assets/fonts/Play-Regular.ttf",
      bold: "#{Rails.root}/app/assets/fonts/Play-Bold.ttf"
      })

      pdf.font "Play", size: 9


      # Add a title
      pdf.text "WISC-V Report", size: 18, style: :bold, align: :center
      pdf.move_down 20

      # Create table data
      table_data = [
        ["Index", "Standard Score", "Percentile", "Interpretation"],
        ["Verbal Comprehension (VCI)", @report.vci_standard, @report.vci_percentile, @report.vci_analysis],
        ["  Similarities", @report.similarities_scaled_score, @report.similarities_percentile_score, @report.similarities_analysis],
        ["  Vocabulary", @report.vocabulary_scaled_score, @report.vocabulary_percentile_score, @report.vocabulary_analysis],
        ["Visual Spatial (VSI)", @report.vsi_standard, @report.vsi_percentile, @report.vsi_analysis],
        ["  Block Design", @report.block_design_scaled_score, @report.block_design_percentile_score, @report.block_design_analysis],
        ["  Visual Puzzles", @report.visual_puzzles_scaled_score, @report.visual_puzzles_percentile_score, @report.visual_puzzles_analysis],
        ["Fluid Reasoning (FRI)", @report.fri_standard, @report.fri_percentile, @report.fri_analysis],
        ["  Matrix Reasoning", @report.matrix_reasoning_scaled_score, @report.matrix_reasoning_percentile_score, @report.matrix_reasoning_analysis],
        ["  Figure Weights", @report.figure_weights_scaled_score, @report.figure_weights_percentile_score, @report.figure_weights_analysis],
        ["Working Memory (WMI)", @report.wmi_standard, @report.wmi_percentile, @report.wmi_analysis],
        ["  Digit Span", @report.digit_span_scaled_score, @report.digit_span_percentile_score, @report.digit_span_analysis],
        ["  Picture Span", @report.picture_span_scaled_score, @report.picture_span_percentile_score, @report.picture_span_analysis],
        ["Processing Speed (PSI)", @report.psi_standard, @report.psi_percentile, @report.psi_analysis],
        ["  Symbol Search", @report.symbol_search_scaled_score, @report.symbol_search_percentile_score, @report.symbol_search_analysis],
        ["  Coding", @report.coding_scaled_score, @report.coding_percentile_score, @report.coding_analysis],
        ["Full Scale IQ (FSIQ)", @report.fsiq_standard, @report.fsiq_percentile, @report.fsiq_analysis],
      ]

      # Render the table
      pdf.table(table_data, header: true, width: pdf.bounds.width) do |table|
        table.row(0).font_style = :bold
        table.row(1).font_style = :bold
        table.row(4).font_style = :bold
        table.row(7).font_style = :bold
        table.row(10).font_style = :bold
        table.row(13).font_style = :bold
        table.row(16).font_style = :bold
        table.row(0).background_color = "cccccc"
        table.row(1).background_color = "cccccc"
        table.row(4).background_color = "cccccc"
        table.row(7).background_color = "cccccc"
        table.row(10).background_color = "cccccc"
        table.row(13).background_color = "cccccc"
        table.row(16).background_color = "cccccc"
        table.column(3).align = :left
        table.column(1..2).align = :center
        table.row(0).align = :center
        table.cells.border_width = 1
        table.columns(2).width = 60
      end

      # Add summary of cognitive testing
      pdf.move_down 20
      pdf.text "SUMMARY OF COGNITIVE TESTING:", style: :bold, size: 12
      pdf.text @report.analysis, size: 10
    end
  end
end
