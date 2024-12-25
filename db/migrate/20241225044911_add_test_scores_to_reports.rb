class AddTestScoresToReports < ActiveRecord::Migration[7.1]
  def change
    add_column :reports, :vci_standard, :integer
    add_column :reports, :vci_percentile, :integer
    add_column :reports, :vci_analysis, :text
    add_column :reports, :vsi_standard, :integer
    add_column :reports, :vsi_percentile, :integer
    add_column :reports, :vsi_analysis, :text
    add_column :reports, :fri_standard, :integer
    add_column :reports, :fri_percentile, :integer
    add_column :reports, :fri_analysis, :text
    add_column :reports, :wmi_standard, :integer
    add_column :reports, :wmi_percentile, :integer
    add_column :reports, :wmi_analysis, :text
    add_column :reports, :psi_standard, :integer
    add_column :reports, :psi_percentile, :integer
    add_column :reports, :psi_analysis, :text
    add_column :reports, :fsiq_standard, :integer
    add_column :reports, :fsiq_percentile, :integer
    add_column :reports, :fsiq_analysis, :text
    add_column :reports, :similarties_analysis, :text
    add_column :reports, :vocabulary_analysis, :text
    add_column :reports, :block_design_analysis, :text
    add_column :reports, :visual_puzzles_analysis, :text
    add_column :reports, :matrix_reasoning_analysis, :text
    add_column :reports, :figure_weights_analysis, :text
    add_column :reports, :digit_span_analysis, :text
    add_column :reports, :picture_span_analysis, :text
    add_column :reports, :symbol_search_analysis, :text
    add_column :reports, :coding_analysis, :text
  end
end
