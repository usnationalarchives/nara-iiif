class DocumentsController < ApplicationController

  def download
    @document = Document.find_by_id(params[:id]) or return redirect_or_http404

    # Create url paramaters that overriding the response headers to be `inline` vs `attachment`
    # AWS docs: http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectGET.html#RESTObjectGET-requests
    @params = URI.encode(%{inline; filename="#{@document.content_disposition_filename}"})
    return redirect_to "#{@document.attachment.url}&#{@params}", status:302
  end

end

