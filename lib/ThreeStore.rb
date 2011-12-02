require 'open-uri'
require 'aws/s3'
require 'digest/md5'
autoload :VERSION, "ThreeStore/version"

class ThreeStore
  def initialize(key, secret, bucket)
    AWS::S3::Base.establish_connection!(:access_key_id => key, :secret_access_key => secret)
    @bucket = bucket
  end

  # Options: url (required),
  #          content_type,
  #          access_level
  def store_on_s3(options)
    # Deleting :url from options because we don't want it in the options that we pass to s3
    # and removing some characters that aren't allowed in urls
    url = options.delete(:url).gsub(/ /, '%20').gsub(/\^/, '%5E')
    file = open(url)

    key = create_key(url, file)

    AWS::S3::S3Object.store(key, file, @bucket, :access => options[:access], :content_type => options[:content_type])

    # Return location on s3
    "http://s3.amazonaws.com/" + @bucket + "/" + key
  end

  def create_key(url, file)
    key = CGI.escape(url.gsub(/http:\/\//, ''))
    file_content = file.read

    digest = Digest::MD5.hexdigest(file_content)
    extname = File.extname(url)

    key.gsub(extname, "-#{digest}#{extname}")
  end
end
