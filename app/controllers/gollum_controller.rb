require "gollum"

class GollumController < ApplicationController
  unloadable

  before_filter :find_project, :authorize

  def index
    show_page_or_file("Home")
  end

  private

  def show_page_or_file(name)
    wiki = Gollum::Wiki.new("/tmp/fnord.wiki.git", {})
    if page = wiki.page(name)
      @page = page
      @name = name
      @content = page.formatted_data
    elsif file = wiki.file(name)
      content_type file.mime_type
      file.raw_data
    else
      @name = name
    end
  end

  def find_project
    if params[:project_id].present?
      @project = Project.find(params[:project_id])
    elsif params[:id].present?
    elsif User.current.admin?
    end
  end
end
