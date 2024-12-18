class GeminiService
    BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
  
    def initialize
      @api_key = ENV['GEMINI_API_KEY']
    end
  
    def generate_analysis(subtest_scores)
      prompt = build_prompt(subtest_scores)
  
      # Send the request to the Gemini API
      response = HTTP.post("#{BASE_URL}?key=#{@api_key}", json: {
        contents: [{ parts: [{ text: prompt }] }]
      })
  
      # Parse the response and extract the analysis
      parsed_response = JSON.parse(response.body.to_s)
      parsed_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
    rescue StandardError => e
      Rails.logger.error "Gemini API Error: #{e.message}"
      "There was an issue generating the report analysis."
    end
  
    private
  
    def build_prompt(subtest_scores)
      <<~PROMPT
        You are an expert psychologist tasked with analyzing WISC (Wechsler Intelligence Scale for Children) test results.
        Based on the following scaled and percentile scores for each subtest, provide a detailed analysis:
  
        #{format_scores(subtest_scores)}
  
        Write a professional, yet parent-friendly paragraph summarizing the child's overall performance, areas of strength, and areas of weakness in a concise
        manner, with brief descriptions of performance on each subtest. Replace any percentiles with descriptive terms.
      PROMPT
    end
  
    def format_scores(subtest_scores)
      # Format the scores with both scaled and percentile values
      subtest_scores.map { |test, scores| "#{test}: Scaled Score #{scores[:scaled]}, Percentile #{scores[:percentile]}" }.join("\n")
    end
  end
  