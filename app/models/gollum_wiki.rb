# A model used to store project-wide gollum settings.
class GollumWiki < ActiveRecord::Base
  unloadable
  belongs_to :project
end
