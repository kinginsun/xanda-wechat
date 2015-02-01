class QueryMailer < ApplicationMailer

  def result(query_id)
    query = Query.find(query_id)
    attachments['result.xlsx'] = File.read(query.to_xls)
    mail(to: query.email,
         bcc: ENV['email_guardian'],
         subject: '查询结果')
  end

end
