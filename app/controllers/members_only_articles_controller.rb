class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    unless session.include? :user_id
      return render json: { error: 'Not authorized' }, status: :unauthorized
    end
    articles =
      Article
        .where(is_member_only: true)
        .includes(:user)
        .order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    unless session.include? :user_id
      return render json: { error: 'Not authorized' }, status: :unauthorized
    end
    article = Article.find(params[:id])
    render json: article
  end

  private

  def record_not_found
    render json: { error: 'Article not found' }, status: :not_found
  end
end
