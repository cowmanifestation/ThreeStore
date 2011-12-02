require 'spec_helper'

describe ThreeStore do
  
  before(:all) do
    @test_bucket = 'hedgeye-ent-bucket'
    @store = ThreeStore.new(ENV['S3_KEY'], ENV['S3_SECRET'], @test_bucket)
    @url = "http://www2.hedgeye.com/assets/hedgeye-ui/button-sprite.png"
    @s3_object_path = @store.store_on_s3(:url => @url, :content_type => 'image/png', :access => 'public-read')
  end

#  after(:all) do
#    AWS::S3::Bucket.find(@test_bucket).clear
#  end

  it "should establish a connection with s3" do
    AWS::S3::Base.connected?.should be_true
  end

  it "should put a given file on s3" do
    # TODO: test with this url (a quotemedia chart) - it has some issues
    # url = "http://app.quotemedia.com/quotetools/getChart.go?webmasterId=98924&symbol=COMP&chsym=Nasdaq%20Comp&chscale=5d&chtype=AreaChart&chfrmon=on&chfrm=ffffff&chbdron=on&chbdr=cccccc&chbg=ffffff&chbgch=ffffff&chln=465665&chfill=1B57AA&chfill2=c0c9d2&chgrdon=on&chgrd=cccccc&chton=on&chtcol=000000&chxyc=111111&chpcon=on&chpccol=ee0000&chmrg=2&chhig=250&chwid=380"

    open(@s3_object_path).read.should == open(@url).read
  end

  it "should add an md5 hexdigest to the key" do
    file_content = open(@url).read
    digest = Digest::MD5.hexdigest(file_content)

    @s3_object_path.should match(digest)
  end

  # Regression test because quotemedia urls have spaces and carets for some reason.
  it "should remove spaces and carets from the given url" do
    url = "http://app.quotemedia.com/quotetools/getChart.go?webmasterId=500&symbol=^DOW&chsym=^DOW Comp&chscale=5d&chtype=AreaChart&chfrmon=on&chfrm=ffffff&chbdron=on&chbdr=cccccc&chbg=ffffff&chbgch=ffffff&chln=465665&chfill=1B57AA&chfill2=c0c9d2&chgrdon=on&chgrd=cccccc&chton=on&chtcol=000000&chxyc=111111&chpcon=on&chpccol=ee0000&chmrg=2&chhig=250&chwid=380"

    s3_object_path = @store.store_on_s3(:url => url, :content_type => 'image/png', :access => 'public-read')

    s3_object_path.should_not match(/ /)
    s3_object_path.should_not match(/\^/)
  end
end
