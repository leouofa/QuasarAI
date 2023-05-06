class TagsController < ApplicationController
  include RestrictedAccess

  def index
    grouped_tags = Tag.joins(:taggings).group(:name).order('count_id DESC').count(:id)
    @tags = Kaminari.paginate_array(grouped_tags.to_a).page(params[:page])
  end
end
