require 'pdf-reader'

class WISCParser
  def initialize(file)
    @file = file # Now expecting a Tempfile or any IO-like object
  end

  def extract_scores
    # Open the PDF file using the Tempfile directly
    reader = PDF::Reader.new(@file.path)  # Use the .path of the Tempfile

    # Read through each page and extract text
    text = reader.pages.map(&:text).join("\n")

    # Extract subtest scores using regex
    scores = {
      similarities: extract_subtest(text, 'Similarities'),
      vocabulary: extract_subtest(text, 'Vocabulary'),
      block_design: extract_subtest(text, 'Block Design'),
      visual_puzzles: extract_subtest(text, 'Visual Puzzles'),
      matrix_reasoning: extract_subtest(text, 'Matrix Reasoning'),
      figure_weights: extract_subtest(text, 'Figure Weights'),
      digit_span: extract_subtest(text, 'Digit Span'),
      picture_span: extract_subtest(text, 'Picture Span'),
      coding: extract_subtest(text, 'Coding'),
      symbol_search: extract_subtest(text, 'Symbol Search')
    }

    # Return only the scaled and percentile scores, but raw scores will be ignored
    scores.transform_values do |score|
      {
        scaled: score[:scaled],        # Only return scaled score
        percentile: score[:percentile] # Only return percentile rank
      }
    end
  end

  private

  # Regex matcher for extracting raw, scaled, and percentile scores
  def extract_subtest(text, name)
    # Regex to extract raw, scaled, and percentile scores
    match = text.match(/#{name}.*?\s+(\d+)\s+(\d+)\s+(\d+)/)  # 3 capture groups: raw, scaled, and percentile
    if match
      {
        raw: match[1].to_i,          # Raw Score
        scaled: match[2].to_i,       # Scaled Score
        percentile: match[3].to_i    # Percentile Rank
      }
    else
      { raw: nil, scaled: nil, percentile: nil } # Return nils if not found
    end
  end
end
