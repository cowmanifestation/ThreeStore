require 'spec_helper'

describe ThreeStore do
  
  before(:all) do
    @test_bucket = 'hedgeye-test-bucket-3'
    @store = ThreeStore.new(ENV['S3_KEY'], ENV['S3_SECRET'], @test_bucket)
  end

  it "should establish a connection with s3" do
    AWS::S3::Base.connected?.should be_true
  end

  it "should put a given file on s3" do
    url = "http://app.quotemedia.com/quotetools/getChart.go?webmasterId=98924&symbol=COMP&chsym=Nasdaq%20Comp&chscale=5d&chtype=AreaChart&chfrmon=on&chfrm=ffffff&chbdron=on&chbdr=cccccc&chbg=ffffff&chbgch=ffffff&chln=465665&chfill=1B57AA&chfill2=c0c9d2&chgrdon=on&chgrd=cccccc&chton=on&chtcol=000000&chxyc=111111&chpcon=on&chpccol=ee0000&chmrg=2&chhig=250&chwid=380"

    @store.store_on_s3(url)
    AWS::S3::S3Object.exists?(url, @test_bucket).should be_true
  end

  it "should function with a url containing spaces" do
    url = "http://app.quotemedia.com/quotetools/getChart.go?webmasterId=98924&symbol=COMP&chsym=Nasdaq Comp&chscale=5d&chtype=AreaChart&chfrmon=on&chfrm=ffffff&chbdron=on&chbdr=cccccc&chbg=ffffff&chbgch=ffffff&chln=465665&chfill=1B57AA&chfill2=c0c9d2&chgrdon=on&chgrd=cccccc&chton=on&chtcol=000000&chxyc=111111&chpcon=on&chpccol=ee0000&chmrg=2&chhig=250&chwid=380"

    @store.store_on_s3(url)
    AWS::S3::S3Object.exists?(url, @test_bucket).should be_true
  end
end
