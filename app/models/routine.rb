class Routine < ActiveRecord::Base
  belongs_to :user
  acts_as_taggable
  acts_as_taggable_on :tags
  DAYS = %w(SU MO TU WE TH FR SA)
end
