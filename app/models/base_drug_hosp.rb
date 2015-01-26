# == Schema Information
#
# Table name: base_drug_hosp
#
#  id                   :integer          not null, primary key
#  drug_name            :string(255)      not null
#  company              :string(255)
#  years                :integer
#  sales_sum            :integer
#  sales_amount         :integer
#  specification        :string(500)
#  dosage_form          :string(100)
#  quarter              :integer
#  per_package          :integer
#  administration_route :string(100)
#  small_class          :string(100)
#  big_class            :string(100)
#  package_material     :string(100)
#  city                 :string(100)
#  WHOID                :string(20)
#  std_dosage_form      :string(100)
#  std_specification    :string(500)
#  update_time          :datetime
#

class BaseDrugHosp < ActiveRecord::Base
  self.table_name= 'base_drug_hosp'

  def self.search(options={})

  end

end
