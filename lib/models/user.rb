class User < ActiveRecord::Base
  scope :active, -> { where(active: true) }
  scope :by_tags, ->(t) { where('ARRAY [?] && tags', t) }
end
