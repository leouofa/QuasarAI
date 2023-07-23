class TagsController < ApplicationController
  include RestrictedAccess

  def index
    grouped_tags = Tag.joins(:taggings).group(:name).order('count_id DESC').count(:id)
    @tags = Kaminari.paginate_array(grouped_tags.to_a).page(params[:page])
    @total_tags = Tag.all.count

    @excluded_tags = applicationcontroller.helpers.s('excluded_tags')
    return if @excluded_tags.blank?

    @excluded_tags
  end
end
