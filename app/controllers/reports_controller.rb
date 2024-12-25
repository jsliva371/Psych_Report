class ReportsController < ApplicationController
  before_action :authenticate_user!  # Ensure the user is signed in
  before_action :set_user  # Fetch the user for the nested route
  before_action :set_report, only: [:show, :edit, :update, :destroy]  # Fetch report for specific actions

  # GET /users/:user_id/reports
  def index
    @reports = @user.reports
  end

  # GET /users/:user_id/reports/new
  def new
    @report = @user.reports.new
  end

  # POST /users/:user_id/reports
  def create
    # Handle PDF file upload
    if params[:pdf_file].present?
      # Read the uploaded file directly
      uploaded_file = params[:pdf_file]
  
      # Pass the uploaded file directly to the parser (IO object)
      parser = WISCParser.new(uploaded_file)
      scores = parser.extract_scores
  
      # Debugging output
      puts "Extracted Scores: #{scores.inspect}"
  
      # Create the report with extracted scores
      @report = current_user.reports.new(
        similarities_scaled_score: scores[:similarities][:scaled],
        similarities_percentile_score: scores[:similarities][:percentile],
        vocabulary_scaled_score: scores[:vocabulary][:scaled],
        vocabulary_percentile_score: scores[:vocabulary][:percentile],
        block_design_scaled_score: scores[:block_design][:scaled],
        block_design_percentile_score: scores[:block_design][:percentile],
        visual_puzzles_scaled_score: scores[:visual_puzzles][:scaled],
        visual_puzzles_percentile_score: scores[:visual_puzzles][:percentile],
        matrix_reasoning_scaled_score: scores[:matrix_reasoning][:scaled],
        matrix_reasoning_percentile_score: scores[:matrix_reasoning][:percentile],
        figure_weights_scaled_score: scores[:figure_weights][:scaled],
        figure_weights_percentile_score: scores[:figure_weights][:percentile],
        digit_span_scaled_score: scores[:digit_span][:scaled],
        digit_span_percentile_score: scores[:digit_span][:percentile],
        picture_span_scaled_score: scores[:picture_span][:scaled],
        picture_span_percentile_score: scores[:picture_span][:percentile],
        coding_scaled_score: scores[:coding][:scaled],
        coding_percentile_score: scores[:coding][:percentile],
        symbol_search_scaled_score: scores[:symbol_search][:scaled],
        symbol_search_percentile_score: scores[:symbol_search][:percentile]
      )
  
      if @report.save
        redirect_to user_report_path(current_user, @report), notice: "Report successfully created!"
      else
        flash[:alert] = "Failed to save the report."
        render :new
      end
    else
      # No file uploaded—handle regular manual input
      @report = current_user.reports.new(report_params)
      if @report.save
        redirect_to user_report_path(current_user, @report), notice: "Report successfully created!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end
  

  # GET /users/:user_id/reports/:id
  def show
  end

  # GET /users/:user_id/reports/:id/edit
  def edit
  end

  # PATCH/PUT /users/:user_id/reports/:id
  def update
    if @report.update(report_params)
      redirect_to user_report_path(@user, @report), notice: 'Report was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/:user_id/reports/:id
  def destroy
    @report.destroy
    redirect_to user_reports_path(@user), notice: 'Report was successfully deleted.'
  end

  def generate_analysis
    # Permit the nested 'scores' parameter with subtests containing 'scaled' and 'percentile'
    subtest_scores = params.require(:scores).permit(
      similarities: [:scaled, :percentile],
      vocabulary: [:scaled, :percentile],
      block_design: [:scaled, :percentile],
      visual_puzzles: [:scaled, :percentile],
      matrix_reasoning: [:scaled, :percentile],
      figure_weights: [:scaled, :percentile],
      digit_span: [:scaled, :percentile],
      picture_span: [:scaled, :percentile],
      coding: [:scaled, :percentile],
      symbol_search: [:scaled, :percentile]
    ).to_h # Convert to plain Ruby hash
  
    # Log scores to verify that they are being sent correctly
    Rails.logger.debug "Received scores: #{subtest_scores.inspect}"
  
    # Ensure subtest_scores is present
    if subtest_scores.blank?
      render json: { error: 'Scores cannot be empty' }, status: :unprocessable_entity
      return
    end
  
    # Call GeminiService to generate analysis
    gemini_service = GeminiService.new
    analysis_result = gemini_service.generate_analysis(subtest_scores)
  
    # Log the result for debugging purposes
    Rails.logger.debug "Generated analysis: #{analysis_result}"
  
    # Return the analysis in the response
    if analysis_result.present?
      render json: { analysis: analysis_result }
    else
      render json: { error: 'Analysis generation failed' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error "Generate analysis error: #{e.message}"
    render json: { error: 'Error generating analysis' }, status: :unprocessable_entity
  end  

  def extract_scores
    if params[:pdf_file].present?
      uploaded_file = params[:pdf_file]
      
      # Ensure the uploaded file is a PDF
      if uploaded_file.content_type != 'application/pdf'
        render json: { error: "Only PDF files are allowed." }, status: :unprocessable_entity
        return
      end
      
      Rails.logger.debug("Uploaded file: #{uploaded_file.inspect}")
  
      # Use the tempfile directly rather than the file path
      temp_file = uploaded_file.tempfile
  
      # Log the tempfile path for debugging
      Rails.logger.debug("Temp file path: #{temp_file.path}")
  
      # Parse the PDF file
      begin
        parser = WISCParser.new(temp_file)  # Pass the file object
        scores = parser.extract_scores
  
        if scores.present?
          # Return the extracted scores in a JSON response
          render json: { scores: scores }, status: :ok
        else
          render json: { error: "No scores found in the PDF." }, status: :unprocessable_entity
        end
  
      rescue => e
        Rails.logger.error("Error parsing file: #{e.message}")
        render json: { error: "Error processing PDF file: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: "No PDF file uploaded." }, status: :unprocessable_entity
    end
  end  
  
  private

  def set_user
    @user = User.find(params[:user_id])  # Fetch the parent user
  end

  def set_report
    @report = @user.reports.find(params[:id])  # Fetch the report for the user
  end

  def report_params
    params.require(:report).permit(
      :similarities_scaled_score, :similarities_percentile_score,
      :vocabulary_scaled_score, :vocabulary_percentile_score,
      :block_design_scaled_score, :block_design_percentile_score,
      :visual_puzzles_scaled_score, :visual_puzzles_percentile_score,
      :matrix_reasoning_scaled_score, :matrix_reasoning_percentile_score,
      :figure_weights_scaled_score, :figure_weights_percentile_score,
      :digit_span_scaled_score, :digit_span_percentile_score,
      :picture_span_scaled_score, :picture_span_percentile_score,
      :coding_scaled_score, :coding_percentile_score,
      :symbol_search_scaled_score, :symbol_search_percentile_score,
      :analysis
    )
  end
end
