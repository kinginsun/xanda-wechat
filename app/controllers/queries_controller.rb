class QueriesController < ApplicationController

  def show

  end

  def update_email
    @query = Query.find(params[:id])
    @query.email = params[:query][:email]

    respond_to do |format|
      if @query.save
        QueryMailer.result(@query.id).deliver_now
        format.html { redirect_to wechat_url, notice: "数据已经发送到 #{@query.email}" }
      else
        format.html { redirect_to wechat_url, alert: '更新失败，请联系管理员' }
      end
    end
  end

end