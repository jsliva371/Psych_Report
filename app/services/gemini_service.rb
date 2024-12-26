class GeminiService
  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"

  def initialize
    @api_key = ENV['GEMINI_API_KEY']
  end

  # Handles single or multi-analysis modes
  def generate_analysis(subtest_scores, mode: :summary)
    prompt = build_prompt(subtest_scores, mode)

    # API Request
    response = HTTP.post("#{BASE_URL}?key=#{@api_key}", json: {
      contents: [{ parts: [{ text: prompt }] }]
    })

    # Parse Response
    parsed_response = JSON.parse(response.body.to_s)
    text = parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')

    # Force valid JSON parsing
    text = text.strip.gsub(/```json|```/, '') # Remove formatting if present

    mode == :summary ? text : parse_individual_analyses(text)
  rescue StandardError => e
    Rails.logger.error "Gemini API Error: #{e.message}"
    mode == :summary ? "Error generating summary analysis." : {}
  end

  private

  # Build Prompt
  def build_prompt(subtest_scores, mode)
    case mode
    when :summary
      <<~PROMPT
        You are an expert psychologist tasked with analyzing WISC (Wechsler Intelligence Scale for Children) test results.
        Based on the following scaled and percentile scores for each subtest, provide a detailed analysis:

        #{format_scores(subtest_scores)}

        Write a professional, yet parent-friendly paragraph summarizing the child's overall performance, areas of strength, and areas of weakness in a concise manner. Replace any percentiles with descriptive terms.
      PROMPT
    when :individual
      <<~PROMPT
        You are an expert psychologist analyzing WISC (Wechsler Intelligence Scale for Children) test results.
        Based on the following scores, provide **one-sentence descriptions** of each subtest and composite score performance. Highlight whether it is **below average, average, or above average** and mention areas of **strength or weakness**.

        #{format_scores(subtest_scores)}

        Provide responses in **valid JSON format** with keys matching the test names, and values as the analysis sentences.

        Important Notes:
        - Return **only** the JSON object as output.  
        - Do **not** include Markdown formatting, code blocks, or explanations.  
        - Do **not** include comments in the JSON.  
        - Ensure the output is **valid JSON** and can be parsed directly.  

        Example Output:
        {
          "similarities_analysis": "Short analysis here",
          "vocabulary_analysis": "Short analysis here",
          "block_design_analysis": "Short analysis here",
          "visual_puzzles_analysis": "Short analysis here",
          "matrix_reasoning_analysis": "Short analysis here",
          "figure_weights_analysis": "Short analysis here",
          "digit_span_analysis": "Short analysis here",
          "picture_span_analysis": "Short analysis here",
          "coding_analysis": "Short analysis here",
          "symbol_search_analysis": "Short analysis here",
          "vci_analysis": "Short analysis here",
          "vsi_analysis": "Short analysis here",
          "fri_analysis": "Short analysis here",
          "wmi_analysis": "Short analysis here",
          "psi_analysis": "Short analysis here",
          "fsiq_analysis": "Short analysis here"
        }
      PROMPT
    end
  end

  # Format Scores
  def format_scores(subtest_scores)
    subtest_scores.map do |test, scores|
      "#{test}: Scaled Score #{scores[:scaled]}, Percentile #{scores[:percentile]}"
    end.join("\n")
  end

  # Parse Individual Analyses (JSON)
  def parse_individual_analyses(response_text)
    begin
      # Attempt to parse response as valid JSON
      JSON.parse(response_text)
    rescue JSON::ParserError => e
      Rails.logger.error "JSON Parsing Error: #{e.message} | Response: #{response_text}"
      {}
    end
  end
end
