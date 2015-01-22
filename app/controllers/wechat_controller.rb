class WechatController < ApplicationController

  def auth_return
    code = params[:code]
  end

  def index
    @search = BaseDrugHosp.new

    options = {
        appid: 'wxcbb786241f2ef879',
        mch_id: '1228019202',
        # key: '0312da9137d5e5bdc71a14eed8816ffc',

        nonce_str: '6da569638aec4855b3d3b44ec1103e2c',
        body: 'test',
        out_trade_no: '10001',
        total_fee: 1,
        spbill_create_ip: request.remote_ip,
        notify_url: wechat_notify_url,
        trade_type: 'JSAPI',
        openid: '99999'
    }
    @payload = make_payload(options)
    response = RestClient::Request.execute(
        {
            method: :post,
            url: 'https://api.mch.weixin.qq.com/pay/unifiedorder',
            payload: @payload,
            headers: {content_type: 'application/xml'}
        }
    )
    @response = Hash.from_xml(response)
  end

  private

  def make_payload(options)
    "<xml>#{options.sort.map { |k, v| "<#{k}>#{v}</#{k}>" }.join}<sign>#{generate_sign(options)}</sign></xml>"
  end

  def generate_sign(options)
    query = options.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')
    query += '&key=0312da9137d5e5bdc71a14eed8816ffc'
    Digest::MD5.hexdigest(query).upcase
  end

end
