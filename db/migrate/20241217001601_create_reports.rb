class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :similarities_scaled_score
      t.integer :similarities_percentile_score
      t.integer :vocabulary_scaled_score
      t.integer :vocabulary_percentile_score
      t.integer :block_design_scaled_score
      t.integer :block_design_percentile_score
      t.integer :visual_puzzles_scaled_score
      t.integer :visual_puzzles_percentile_score
      t.integer :matrix_reasoning_scaled_score
      t.integer :matrix_reasoning_percentile_score
      t.integer :figure_weights_scaled_score
      t.integer :figure_weights_percentile_score
      t.integer :digit_span_scaled_score
      t.integer :digit_span_percentile_score
      t.integer :picture_span_scaled_score
      t.integer :picture_span_percentile_score
      t.integer :coding_scaled_score
      t.integer :coding_percentile_score
      t.integer :symbol_search_scaled_score
      t.integer :symbol_search_percentile_score
      t.text :analysis

      t.timestamps
    end
  end
end
