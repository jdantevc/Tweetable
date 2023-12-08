class TweetsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tweet, only: %i[ show edit update destroy ]

  # GET /tweets
  def index
    @tweets = Tweet.order(created_at: :desc)
  end

  # GET /tweets/1
  def show
    @tweet = Tweet.find(params[:id])
    @reply = Tweet.new 
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  def create
    @tweet = current_user.tweets.build(tweet_params)

    if @tweet.save
      redirect_to @tweet, notice: "Tweet was successfully created."
    else
      puts @tweet.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tweets/1
  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "Tweet was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tweets/1
  def destroy
    @tweet.destroy
    redirect_to tweets_url, notice: "Tweet was successfully destroyed."
  end

  def reply
    @tweet = Tweet.find(params[:id])
    @reply = @tweet.replies.build(reply_params.merge(user: current_user))

    if @reply.save
      redirect_to @tweet, notice: 'Reply created successfully.'
    else
      render 'show'
      puts @tweet.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:body, :replies_count, :likes_count, :user_id, :replied_to).tap do |whitelisted|

        whitelisted[:replied_to] = nil if whitelisted[:replied_to].blank?
      end
    end

    def reply_params
      params.require(:tweet).permit(:body)
    end
end
