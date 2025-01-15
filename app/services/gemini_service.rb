class GeminiService
  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"

  def initialize
    @api_key = ENV['GEMINI_API_KEY']
  end

  # Handles analysis generation
  def generate_analysis(subtest_scores, mode: :summary)

    if mode == :individual
      subtest_scores.each do |test_name, test_data|
        test_data[:percentile] = test_data[:percentile].to_i
      end
    end

    prompt = build_prompt(subtest_scores, mode)

    # API Request for Summary Mode
    if mode == :summary
      response = HTTP.post("#{BASE_URL}?key=#{@api_key}", json: {
        contents: [{ parts: [{ text: prompt }] }]
      })

      parsed_response = JSON.parse(response.body.to_s)
      text = parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
      return text.strip
    end

    # Generate individual analysis using predefined descriptions for each percentile
    generate_individual_analysis(subtest_scores)
  rescue StandardError => e
    Rails.logger.error "Gemini API Error: #{e.message}"
    mode == :summary ? "Error generating summary analysis." : {}
  end

  private

  # Build Prompt for Summary Analysis
  def build_prompt(subtest_scores, mode)
    case mode
    when :summary
      <<~PROMPT
      You are an expert psychologist tasked with analyzing WISC (Wechsler Intelligence Scale for Children) test results.

      ## Core Principles of analysis 

      1. EXPLORATION OVER CONCLUSION
      - Never rush to conclusions
      - Keep exploring until a solution emerges naturally from the evidence
      - Question every assumption and inference

      2. DEPTH OF REASONING
      - Engage in extensive contemplation (minimum 10,000 characters)
      - Express thoughts in natural, conversational internal monologue 
      - Break down complex thoughts into simple, atomic steps
      - Embrace uncertainity and revision of previous thoughts

      3. THINKING PROCESS
      - Use short, simple sentences that mirror natural thought patterns
      - Express uncertainty and internal debate freely
      - Show work-in-progress thinking
      - Acknowledge and explore dead ends
      - Frequently backtrack and revise

      4. PERSISTENCE
      - Value thorough exploration over quick resolution

      ## Based on the following scaled and percentile scores for each subtest, provide a detailed analysis:

      #{format_scores(subtest_scores)}

      Write a professional, yet parent-friendly paragraph summarizing the child's overall performance, areas of strength, and areas of weakness in a concise manner. Replace any percentiles with descriptive terms.

      Using the provided WISC test results, the summary should:

      - Provide an overall cognitive profile, including the Full-Scale IQ (FSIQ) score and its interpretation (e.g., average, above average, etc.).
      - Describe performance in each index (e.g., Verbal Comprehension, Visual Spatial, Fluid Reasoning, Working Memory, Processing Speed):
      - Report the index score and interpretation (e.g., average, high average).
      - Summarize subtest scores within each index, highlighting strengths and weaknesses.
      - Highlight notable strengths and areas for support, explaining their practical implications (e.g., strong verbal reasoning aids in communication, while slower processing speed may affect timed tasks).
      - Offer general recommendations for leveraging strengths and addressing challenges.
      - Use clear, professional language and ensure the summary is organized, precise, and free of jargon.
      PROMPT
    end
  end

  # Format Scores
  def format_scores(subtest_scores)
    subtest_scores.map do |test, scores|
      "#{test}: Scaled Score #{scores[:scaled]}, Percentile #{scores[:percentile]}"
    end.join("\n")
  end

  # Generate Individual Analysis Using Predefined Sentences
  def generate_individual_analysis(subtest_scores)
    analysis = {}
    
    field_mapping = {
      "similarities" => "similarities_analysis",
      "vocabulary" => "vocabulary_analysis",
      "block_design" => "block_design_analysis",
      "visual_puzzles" => "visual_puzzles_analysis",
      "matrix_reasoning" => "matrix_reasoning_analysis",
      "figure_weights" => "figure_weights_analysis",
      "digit_span" => "digit_span_analysis",
      "picture_span" => "picture_span_analysis",
      "coding" => "coding_analysis",
      "symbol_search" => "symbol_search_analysis",
      "vci" => "vci_analysis",
      "vsi" => "vsi_analysis",
      "fri" => "fri_analysis",
      "wmi" => "wmi_analysis",
      "psi" => "psi_analysis",
      "fsiq" => "fsiq_analysis"
    }

    
    subtest_scores.each do |test, scores|
      # Find the corresponding field name in the mapping
      field_name = field_mapping[test]
      
      if field_name
        category = categorize_score(scores[:percentile])
        analysis[field_name] = "#{category[:label]} ability in #{test}, indicating #{category[:description]}"
      else
        Rails.logger.warn "No field mapping found for #{test}"
      end
    end

    analysis
  end


  # Categorize Score Based on Percentile
  def categorize_score(percentile)
    case percentile
    when 0..1
      { label: 'Exceptionally Low', description: 'severe challenges or very low ability in this area' }
    when 2..8
      { label: 'Below Average', description: 'below typical performance for this age group' }
    when 9..24
      { label: 'Low Average', description: 'some challenges but still within a lower average range' }
    when 25..74
      { label: 'Average', description: 'typical performance for this age group' }
    when 75..90
      { label: 'High Average', description: 'above typical performance but not at the highest level' }
    when 91..95
      { label: 'Above Average', description: 'strong abilities in this area, above most peers' }
    when 96..100
      { label: 'Exceptionally High', description: 'outstanding ability in this area, far above peers' }
    else
      { label: 'Unknown', description: 'unable to categorize score' }
    end
  end
end
