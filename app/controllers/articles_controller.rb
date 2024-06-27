class ArticlesController < ApplicationController
  include RestrictedAccess
  def index
    scope = set_scope
    sort_order = set_sortorder

    @articles = Article.send(scope).order(sort_order).page params[:page]
    @total_articles = Article.send(scope).count
  end

  def show
    @article = Article.find(params[:id])
  end

  private

  def set_scope
    if params[:scope] && params[:scope] == 'unpublished'
      return 'unpublished'
    elsif params[:scope] && params[:scope] == 'published'
      return 'published'
    end

    'unscoped'
  end

  def set_sortorder
    if params[:scope] && params[:scope] == 'unpublished'
      'id desc'
    elsif params[:scope] && params[:scope] == 'published'
      'published_at desc'
    end

    'id desc'
  end
end
