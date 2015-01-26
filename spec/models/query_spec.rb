# == Schema Information
#
# Table name: queries
#
#  id            :integer          not null, primary key
#  statement     :text(65535)
#  open_id       :string(255)
#  email         :string(255)
#  rows          :integer
#  paid_at       :datetime
#  total_fee     :integer
#  post_raw_data :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Query, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
