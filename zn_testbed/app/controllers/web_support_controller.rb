class WebSupportController < ApplicationController
  def echo
    respond_to do |format|
      format.html # 
      format.xml { render :xml => { :headers => request.headers,
                                    :method => request.method,
                                    :body => request.body.string } }
    end
  end
end
