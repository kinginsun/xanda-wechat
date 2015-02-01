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

class Query < ActiveRecord::Base

  def result
    BaseDrugHosp.find_by_sql(statement)
  end

  def to_xls
    path = Rails.root.join('data', 'queries', "#{id}.xlsx")
    Spreadsheet.client_encoding = 'UTF-8'

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = 'Result'

    sheet1.row(0).concat BaseDrugHosp.attribute_names
    result.each_with_index do |row, index|
      sheet1.row(index+1).concat row.attributes.values
    end

    book.write(path)
    path
  end

  def to_csv
    require 'csv'

    path = Rails.root.join('data', 'queries', "#{id}.csv")
    CSV.open(path, 'wb') do |csv|
      csv << BaseDrugHosp.attribute_names
      result.each do |item|
        csv << item.attributes.values
      end
    end

    path
  end

end
