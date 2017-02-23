class RestController < ApplicationController
  #explara oauth login page
  def login

  end
#method to get access_token from code we got
  def verifyLogin 
    @code     = params[:code]
    
    if @code != ''
    url = URI("https://www.explara.com/a/account/oauth/token")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'multipart/form-data; boundary='
    request.body = "--\r\nContent-Disposition: form-data;"+
                    "name=\"client_id\"\r\n\r\n<YOUR_CLIENT_ID>\r\n--\r\n"+
                    "Content-Disposition: form-data;"+
                    "name=\"client_secret\"\r\n\r\n<YOUR_CLIENT_SECRET>\r\n--\r\n"+
                    "Content-Disposition: form-data;"+
                    "name=\"grant_type\"\r\n\r\nauthorization_code\r\n--\r\n"+
                    "Content-Disposition: form-data;"+
                    "name=\"code\"\r\n\r\n"+@code+"\r\n----"

    response = http.request(request)
    processed_response = JSON.parse(response.read_body)

    $accessToken = processed_response['access_token']
    @accessToken = $accessToken
    @returnUrl   ='/events?access_token='+@accessToken
    else
      @returnUrl = "/"
    end

  end
#fetch the event list with the access_token obtained
  def eventlist
    @accesstoken = params[:access_token]
    url = URI("https://www.explara.com/api/e/get-all-events")


    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["authorization"] = "Bearer #{@accesstoken}"

    response = http.request(request)
    res = JSON.parse(response.read_body)
    $event_id = res['events']

    @events = $event_id


  end
#fetch the attendee list for a particular event with the access_token obtained
  def attendeelist
    @eventid = params[:eventId]

    @accesstoken = params[:accessToken]
    url = URI("https://www.explara.com/api/e/attendee-list")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'multipart/form-data; boundary='
    request["authorization"] = "Bearer #{@accesstoken}"
    request.body = "--\r\nContent-Disposition: form-data; name=\"eventId\"\r\n\r\n#{@eventid}\r\n--\r\nContent-Disposition: form-data; name=\"fromRecord\"\r\n\r\n0\r\n--\r\nContent-Disposition: form-data; name=\"toRecord\"\r\n\r\n50\r\n----"

    response = http.request(request)
    attendees = JSON.parse(response.read_body)
    @attendee = attendees["attendee"]


  end
end
