class Api::V1::DirectUploadManagementController < ApplicationController
  before_action :authenticate_user!, only: [:before_direct_upload]

  def before_direct_upload
    fail unless params[:record_id]
    fail unless params[:checksum]

    access_key_secret = ENV['ALIOSS_KEY_SECRET']
    access_key_id = ENV['ALIOSS_KEY_ID']
    host = "https://#{ENV['ALIOSS_PREFIX']}-#{Rails.env}.#{ENV['ALIOSS_ENDPOINT']}"
    expire_syncpoint = Time.now.to_i + 1.minutes
    # expire_syncpoint = Time.now.to_i + 1.minutes
    callback_url = "https://#{ENV['HOST']}/api/v1/upload_callback"
    upload_dir = "TM"

    expire = Time.at(expire_syncpoint).utc.iso8601()
    response.headers['expire'] = expire

    policy_dict = {}
    condition_arrary = Array.new
    array_item = Array.new
    array_item.push('starts-with')
    array_item.push('$key')
    array_item.push(upload_dir)
    condition_arrary.push(array_item)
    policy_dict["conditions"] = condition_arrary
    policy_dict["expiration"] = expire
    policy = policy_dict.to_json
    policy_encode = Base64.strict_encode64(policy).chomp
    h = OpenSSL::HMAC.digest('sha1', access_key_secret, policy_encode)
    hs = Digest::MD5.hexdigest(h)
    sign_result = Base64.strict_encode64(h).strip()

    callback_dict = {}
    callback_dict['callbackBodyType'] = 'application/x-www-form-urlencoded'
    callback_dict['callbackBody'] = 'filename=${object}&size=${size}&mimeType=${mimeType}&height=${imageInfo.height}&width=${imageInfo.width}&x:record_id=' + params[:record_id].to_s + '&x:checksum=' + params[:checksum]
    callback_dict['callbackUrl'] = callback_url
    callback_param = callback_dict.to_json
    base64_callback_body = Base64.strict_encode64(callback_param)

    token_dict = {}
    token_dict['accessid'] = access_key_id
    token_dict['host'] = host
    token_dict['policy'] = policy_encode
    token_dict['signature'] = sign_result
    token_dict['expire'] = expire_syncpoint
    token_dict['dir'] = upload_dir
    token_dict['callback'] = base64_callback_body
    response.headers["Access-Control-Allow-Methods"] = "POST"
    response.headers["Access-Control-Allow-Origin"] = "*"

    render json: token_dict
  end

  def upload_callback
    render json: { mesg: 'invalid signature' }, status: 500 unless check_signature

    blob = ActiveStorage::Blob.create!(filename: params[:filename],
                                       key: params[:filename],
                                       byte_size: params[:size],
                                       checksum: params['x:checksum'.to_sym],
                                       content_type: params[:mimeType],
                                       service_name: 'aliyun')

    attatchments = ActiveStorage::Attachment.create!(
      name: 'screenshots',
      record_type: 'Website',
      record_id: params['x:record_id'.to_sym],
      blob_id: blob.id
    )

    if blob && attatchments
      render json: { mesg: 'upload success' }, status: 200
    else
      render json: { mesg: 'save failed' }, status: 500
    end
  end

  private

  def check_signature
    # pub_key_url = urlopen(Base64.decode64(request.headers['x-oss-pub-key-url']))
    pub_key = <<~DOC
      -----BEGIN PUBLIC KEY-----
      MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKs/JBGzwUB2aVht4crBx3oIPBLNsjGs
      C0fTXv+nvlmklvkcolvpvXLTjaxUHR3W9LXxQ2EHXAJfCB+6H2YF1k8CAwEAAQ==
      -----END PUBLIC KEY-----
    DOC

    rsa = OpenSSL::PKey::RSA.new(pub_key)

    signature = Base64.decode64(request.headers['authorization'])

    req_body = request.body.read
    if request.query_string.empty? then
      auth_str = CGI.unescape(request.path) + "\n" + req_body
    else
      auth_str = CGI.unescape(request.path) + '?' + request.query_string + "\n" + req_body
    end

    rsa.public_key.verify(OpenSSL::Digest::MD5.new, signature, auth_str)
  end
end