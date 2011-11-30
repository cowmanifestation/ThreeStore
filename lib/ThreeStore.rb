require 'open-uri'
require 'aws/s3'
autoload :VERSION, "ThreeStore/version"

# maybe a class:
# def initalize(key, secret, bucket)
class ThreeStore
  def initialize(key, secret, bucket)
    AWS::S3::Base.establish_connection!(:access_key_id => key, :secret_access_key => secret)
    @bucket = bucket
  end

  def store_on_s3(url)
    url.gsub!(/ /, '%20')
    file = open(url)
    AWS::S3::S3Object.store(url, file.read, @bucket)
  end
    

  # store method should return location of thing being stored
  # maybe also add a hexdigest to the name
  # def store(url)
end
