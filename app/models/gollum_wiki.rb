class GollumWiki < ActiveRecord::Base
  unloadable
  belongs_to :project
end
