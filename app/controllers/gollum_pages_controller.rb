require_dependency 'user'

# A controller used to view and edit wiki pages.
class GollumPagesController < ApplicationController
  unloadable

  before_filter :find_project, :find_wiki, :authorize

  def index
    redirect_to :action => :show, :id => "Home"
  end

  def show
    @editable = true

    show_page(params[:id])
  end

  def edit
    @page_name = params[:id]
    @page = @wiki.page(@page_name)
    @content = @page ? @page.text_data : ""
  end

  def update
    @page_name = params[:id]
    @page = @wiki.page(@page_name)
    @user = User.current

    commit = { :message => params[:page][:message], :name => @user.name, :email => @user.mail }

    if @page
      @wiki.update_page(@page, @page.name, @page.format, params[:page][:raw_data], commit)
    else
      @wiki.write_page(@page_name, @project.gollum_wiki.markup_language.to_sym, params[:page][:raw_data], commit)
    end

    redirect_to :action => :show, :id => @page_name
  end

  private

  def project_repository_path
    return @project.gollum_wiki.git_path
  end

  def show_page(name)
    if page = @wiki.page(name)
      @page_name = page.name
      @page_title = page.title
      @page_content = page.formatted_data.html_safe
    else
      redirect_to :action => :edit, :id => name
    end
  end

  def find_project
    unless params[:project_id].present?
      render :status => 404
      return
    end

    @project = Project.find(params[:project_id])
  end

  def find_wiki
    git_path = project_repository_path

    unless File.directory? git_path
      Grit::Repo.init_bare(git_path)
    end

    wiki_dir = @project.gollum_wiki.directory
    if wiki_dir.empty?
      wiki_dir = nil
    end

    gollum_base_path = project_gollum_pages_path
    @wiki = Gollum::Wiki.new(git_path,
                            :base_path => gollum_base_path,
                            :page_file_dir => wiki_dir)

  end
end
