class QueryMailer < ApplicationMailer

  def result(email)
   mail(to: email, subject: '查询结果') 
  end

end
