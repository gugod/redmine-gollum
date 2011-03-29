class GollumController < ApplicationController
  unloadable

  before_filter :find_project, :authorize

  def index
    redirect_to :action => :show, :id => "Home"
  end

  def show
    @editable = true

    show_page(params[:id])
  end

  def edit
    @name = params[:id]
    @page = @wiki.page(@name)
    @content = @page ? @page.raw_data : ""
  end

  def update
    @name = params[:id]
    @page = @wiki.page(@name)
    @user = User.current

    commit = { :message => params[:page][:message], :name => @user.name, :email => @user.mail }

    if @page
      @wiki.update_page(@page, @page.name, @page.format, params[:page][:raw_data], commit)
    else
      @wiki.write_page(@name, :markdown, params[:page][:raw_data], commit)
    end

    redirect_to :action => :show, :id => @name
  end

  private

  def project_repository_path
    gollum_wiki = GollumWiki.first(:conditions => ["project_id = ?", @project.id])
    unless gollum_wiki.nil?
      git_path = gollum_wiki.git_path
    end
    return git_path ||
      (Pathname.new(
      Redmine::Configuration["gollum"]["repository_root"] ||
      Rails.root + "gollum") + "#{@project.identifier}.wiki.git").to_s
  end

  def show_page(name)
    @name = name

    if page = @wiki.page(name)
      @page = page
      @content = page.formatted_data
    end
  end

  def find_project
    unless params[:project_id].present?
      render :status => 404
      return
    end

    @project = Project.find(params[:project_id])

    git_path = project_repository_path

    unless File.directory? git_path
      Grit::Repo.init_bare(git_path)
    end

    @wiki = Gollum::Wiki.new(git_path, :base_path => gollum_index_path(:project_id => @project.identifier))
  end
end
