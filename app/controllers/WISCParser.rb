class WISCParser
    def initialize(file)
      @file = file # Expecting a Tempfile or similar IO object
    end
  
    def extract_scores
        reader = PDF::Reader.new(@file.path)
        text = reader.pages.map(&:text).join("\n")
      
        scores = {
          similarities: extract_total_score(text, 'Similarities'),
          vocabulary: extract_total_score(text, 'Vocabulary'),
          block_design: extract_total_score(text, 'Block Design'),
          visual_puzzles: extract_total_score(text, 'Visual Puzzles'),
          matrix_reasoning: extract_total_score(text, 'Matrix Reasoning'),
          figure_weights: extract_total_score(text, 'Figure Weights'),
          digit_span: extract_total_score(text, 'Digit Span'),
          picture_span: extract_total_score(text, 'Picture Span'),
          coding: extract_total_score(text, 'Coding'),
          symbol_search: extract_total_score(text, 'Symbol Search'),
      
          vci: extract_composite_and_percentile(text, 'VCI'),
          vsi: extract_composite_and_percentile(text, 'VSI'),
          fri: extract_composite_and_percentile(text, 'FRI'),
          wmi: extract_composite_and_percentile(text, 'WMI'),
          psi: extract_composite_and_percentile(text, 'PSI'),
          fsiq: extract_composite_and_percentile(text, 'FSIQ')
        }
      
        # Debugging: Print extracted scores
        puts "Extracted Scores: #{scores.inspect}"
      
        # Return everything (scaled, composite, percentile) for debugging
        scores
      end
      
  
    private
  
    # Regex matcher for extracting total raw score, scaled score, and percentile rank for a subtest
    def extract_total_score(text, name)
      match = text.match(/#{name}.*?\s+(\d+)\s+(\d+)\s+(\d+)/)  # Raw, Scaled, Percentile (3 groups)
      if match
        puts "Found raw score, scaled score, and percentile for #{name}: #{match[1]}, #{match[2]}, #{match[3]}"  # Debugging line
        {
          raw: match[1].to_i,       # Total Raw Score
          scaled: match[2].to_i,    # Scaled Score
          percentile: match[3].to_i # Percentile Rank
        }
      else
        puts "Raw score, scaled score, and percentile for #{name} not found"  # Debugging line
        { raw: nil, scaled: nil, percentile: nil } # Return nils if not found
      end
    end
  
    # Regex matcher for extracting the first three numbers after the test type
    def extract_composite_and_percentile(text, test_type)
        # Adjust regex to capture all three groups
        match = text.match(/#{test_type}\s+(\d+)\s+(\d+)\s+(\d+)/)
      
        if match
          puts "Found composite score and percentile for #{test_type}: #{match[1]}, #{match[2]}, #{match[3]}"
          {
            sum_of_scaled_scores: match[1].to_i,  # Fix: Extract from group 1
            composite_score: match[2].to_i,      # Fix: Extract from group 2
            percentile: match[3].to_i            # Fix: Extract from group 3
          }
        else
          puts "#{test_type} composite score and percentile not found"
          { sum_of_scaled_scores: nil, composite_score: nil, percentile: nil }
        end
      end          
  end