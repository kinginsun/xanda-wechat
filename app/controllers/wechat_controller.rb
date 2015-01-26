class WechatController < ApplicationController

  def auth_return
    code = params[:code]
  end

  def index
    @search = BaseDrugHosp.new
    open_id = 'ob56ojj3_OsMkNue9870yWX_xBfU'
    appid = 'wxcbb786241f2ef879'
    mch_id = '1228019202'
    options = {
        appid: appid,
        mch_id: mch_id,
        nonce_str: SecureRandom.uuid.gsub('-',''),
        body: 'test',
        out_trade_no: '10001',
        total_fee: 1,
        spbill_create_ip: request.remote_ip,
        notify_url: wechat_notify_url,
        trade_type: 'JSAPI',
        openid: open_id
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

    @options = {
      appId: appid,
      timeStamp: Time.now.to_i.to_s,
      nonceStr: @response['xml']['nonce_str'],
      package: "prepay_id=#{@response['xml']['prepay_id']}",
      signType: 'MD5'
    }
    @options[:paySign] = generate_sign(@options)

  end

  private
  def make_payload(options)
    "<xml>#{options.sort.map { |k, v| "<#{k}>#{v}</#{k}>" }.join}<sign>#{generate_sign(options)}</sign></xml>"
  end

  def generate_sign(options)
    query = options.sort.map do |key, value|
      "#{key}=#{value}"
    end.join('&')
    
    query += '&key=YfP5yCNVzsYffsfy64hmKGuqcl3xop3A'
    Digest::MD5.hexdigest(query).upcase
  end

end
