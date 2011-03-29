class GollumWikisController < ApplicationController
  menu_item :settings
  unloadable
  
  before_filter :find_project, :authorize

  def index
    redirect_to :action => :show
  end

  def update
    gollum_wiki =
      GollumWiki.first(:conditions => ["project_id = ?", @project.id]) ||
      GollumWiki.new( :project_id => @project.id )
    gollum_wiki.attributes = params[:gollum_wiki]
    if gollum_wiki.save
      flash[:notice] = t(:gollum_wiki_updated)
    else
      flash[:error] = t(:gollum_wiki_update_error)
    end
    redirect_to(:controller=>'projects', :action=>'settings', :id=>@project, :tab=>'gollum')
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
