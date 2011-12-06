require 'spec_helper'
require 'yaml'

describe ThreeStore do
  # TODO: UPdate README
  
  before(:all) do
    @yaml = YAML.load_file('ThreeStore.yml')
    @test_bucket = @yaml[:test_bucket]
    @store = ThreeStore.new(@yaml[:access_key_id], @yaml[:secret_access_key], @test_bucket)
  end

  after(:all) do
    AWS::S3::Bucket.find(@test_bucket).clear
  end

  it "should establish a connection with s3" do
    AWS::S3::Base.connected?.should be_true
  end

  it "should put a given file on s3" do
    url = @yaml[:test_image]
    s3_object_path = @store.store_on_s3(:url => url, :key => "hedgeye-button-sprite.png", :access => 'public-read')

    open(s3_object_path).read.should == open(url).read
  end

  # Regression test because quotemedia urls have spaces and carets for some reason.
  it "should be able to prcess urls with spaces and carets" do
    url = "http://app.quotemedia.com/quotetools/getChart.go?webmasterId=500&symbol=^DOW&chsym=^DOW Comp" +
          "&chscale=5d&chtype=AreaChart&chfrmon=on&chfrm=ffffff&chbdron=on&chbdr=cccccc&chbg=ffffff" +
          "&chbgch=ffffff&chln=465665&chfill=1B57AA&chfill2=c0c9d2&chgrdon=on&chgrd=cccccc&chton=on" +
          "&chtcol=000000&chxyc=111111&chpcon=on&chpccol=ee0000&chmrg=2&chhig=250&chwid=380"

    s3_object_path = @store.store_on_s3(:url => url, :key => "quotemedia_chart.png", :content_type => 'image/png', :access => 'public-read')

    open(s3_object_path).should be_true
  end
end
