class RenameSimilartiesAnalysisToSimilaritiesAnalysis < ActiveRecord::Migration[7.1]
  def change
    rename_column :reports, :similarties_analysis, :similarities_analysis
  end
end
