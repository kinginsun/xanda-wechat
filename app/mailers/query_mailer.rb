class QueryMailer < ApplicationMailer

  def result(query_id)
    query = Query.find(query_id)
    attachments['result.csv'] = File.read(query.to_csv)
    mail(to: query.email,
         bcc: ENV['email_guardian'],
         subject: '查询结果')
  end

end
