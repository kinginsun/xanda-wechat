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

FactoryGirl.define do
  factory :query do
    statement "MyText"
    open_id "MyString"
    rows 1
    paid_at "2015-01-26 15:28:59"
    total_fee 1
    post_raw_data "MyText"
  end

end
