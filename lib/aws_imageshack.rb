module AwsImageshack
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module PublicControllerMethods
    def responds_to_parent(&block)
      yield 
      if performed?
        script = if location = erase_redirect_results
                    "document.location.href = '#{self.class.helpers.escape_javascript location.to_s}'"
                  else
                    response.body || ''
                  end

        erase_results
        response.headers['Content-Type'] = 'text/html; charset=UTF-8'
        render :text => "<html><body><script type='text/javascript' charset='utf-8'>
var loc = document.location;
with(window.parent) { setTimeout(function() { window.eval('#{self.class.helpers.escape_javascript script}'); window.loc && loc.replace('about:blank'); }, 1) }
</script></body></html>"
      end
    end
  
    # options
    #   - size : Size of the file input
    #   - style_css : Style apply to the file input (replace the default css)
    #   - class_css : Class apply to the file input
    #   - width     : Witdh of image in the preview
    #   - height    : Height of image in the preview
    #   - position  : Position for the preview ( left, right, top, left)
    def aws_imageshack(*args)
      options = args.extract_options!

      @aws_params = options[:params]
      @aws_api_key = options[:api_key]  
      @aws_options = options[:options]  
      if @aws_params[:aws] and @aws_params[:aws][:fileupload]
        image_link = aws_imageshack_save(@aws_params, @aws_api_key)
        if image_link and @aws_params[:aws] and @aws_params[:aws][:fileupload_only]=='+'
          responds_to_parent do
            render :update do |page|
              page.replace 'aws_upload_form', :inline => aws_image_shack_form(image_link)
            end
          end
        end
        return image_link
      end
    end 
    
    def aws_imageshack_save(params, api_key)
      require "net/http"
      require "net/http/post/multipart"      
      if params[:aws][:fileupload] == ''
        return nil
      end    
      name = params[:aws][:fileupload].original_filename
      directory = 'tmp/uploads'
      `mkdir "#{directory}"` if !File.exists?(directory)
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:aws][:fileupload].read)}
      extension = File.extname( path ).sub( /^\./, '' ).downcase
      mime_type = params[:aws][:fileupload].content_type

      url = URI.parse('http://www.imageshack.us/upload_api.php')
      File.open(path) do |filedata|
        req = Net::HTTP::Post::Multipart.new url.path,
          "fileupload" => UploadIO.new(filedata, mime_type, path),
          "key" => api_key
        res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
        image_link = res.body.scan(/<image_link>(.*)<\/image_link>/)
        return image_link[0].to_s
      end
    end
  end
  
  module ViewHelpersMethods
    include ActionView::Helpers::FormTagHelper
    def aws_image_shack_form(image = nil)
      style_css = (@aws_options[:style_css] ? @aws_options[:style_css] : "height: 22px; border: 1px solid rgb(199, 199, 199); margin-bottom: 1px;") if !@aws_options[:class_css]
      class_css = @aws_options[:class_css] ? @aws_options[:class_css] : ""
      size = @aws_options[:size] ? @aws_options[:size] : 58
      
      image_html = ''      
      image_html = image_tag(image, :style => "float: #{@aws_options[:position]};width: #{@aws_options[:width]}px; height: #{@aws_options[:height]}px") if image
    
      content = ''
      content += form_tag({:controller=> params[:controller], :action => params[:action]} , :id => 'aws_upload_form', :multipart => true, :target => 'aws_hidden_iframe', :style => 'text-align:center')+"\n"
      content += hidden_field('aws', 'fileupload_only', :value => '-')+"\n"
      content += hidden_field(@aws_options[:field_object], @aws_options[:field_name], :value => image)+"\n" if image
      content += image_html+'</br>' if @aws_options[:position].downcase=='top'+"\n"
      content += file_field('aws', 'fileupload', :size => size, :class => class_css, :style => 'style_css', :onchange => "document.getElementById('aws_fileupload_only').value='+';document.getElementById('aws_upload_form').form.submit();")+"\n"
      content += '</br>'+image_html if @aws_options[:position].downcase!='top'+"\n"
      content += "<iframe id=\"aws_hidden_iframe\" name=\"aws_hidden_iframe\" style=\"display: none\"></iframe>"+"\n"
      content += "</form>"+"\n"
      return content
    end
  end
end
ActionController::Base.helper AwsImageshack::ViewHelpersMethods
ActionController::Base.send :include, AwsImageshack::PublicControllerMethods

