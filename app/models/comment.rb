class Comment < ActiveRecord::Base
  belongs_to :confirmation

  serialize :payload, Hash
end
