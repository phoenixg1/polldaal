class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    if current_user == @question.user
      
      # The user who made this question!
      
      @total_votes = 0

      @question.choices.each do |choice|
      #logger.info("votes = " + choice.votes.length + "\n\n")
        @total_votes += choice.votes.length
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @question }
      end
    else # Not the user who made this question
      respond_to do |format|
        format.html { redirect_to root_url, :notice => "You don't have permission to view the stats, sorry!" }
        format.json { render :json => @question }
      end

    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    @question.choices.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])
    
    @question.user_id = current_user.id if current_user

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, :notice => 'Question was successfully created.' }
        format.json { render :json => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])
    
    @question.user_id = current_user.id if current_user

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, :notice => 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
