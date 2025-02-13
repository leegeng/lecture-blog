class ArticlesController < ApplicationController
  include Secured

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])

    # openai integration
    content = "#{@article.body}\n위 글을 요약해주세요."
    client = OpenAI::Client.new
    response = client.chat(
    parameters: {
        model: "gpt-4o", # Required.
        messages: [{ role: "user", content:}], # Required.
        temperature: 0.7,
    })
    @openai_response = response.dig("choices", 0, "message", "content")

    @user = session[:userinfo]
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :status)
  end
end
