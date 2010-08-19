require '../../wrappers/statistics.sk/regis'

describe StatisticsSK::Regis do
  it "should parse all info" do
    doc = StatisticsSK::Regis.parse(File.read('fixtures/ibmm.html'))
    doc.ico.should == 31606717
    doc.name.should == "IBMM, s.r.o."
    doc.address.should == "Okružná 292/15, 018 41 Dubnica nad Váhom"
    doc.district.should == "Ilava"
    doc.valid_from.should == Date.civil(1994, 5, 17)
    doc.valid_to.should == Date.civil(2008, 11, 29)
    doc.legal_form_code.should == 112
    doc.sk_nace_category_code.should == 32400
    doc.okec_category_code.should == 36500
    doc.sector_account_code.should == 11002
    doc.holder_code.should == 8
  end

  it "should parse undefined valid_to as nil" do
    doc = StatisticsSK::Regis.parse(File.read('fixtures/hecom.html'))
    doc.valid_to.should == nil
  end

  it "should return url for given id" do
    StatisticsSK::Regis.url(164483).should == "http://www.statistics.sk/pls/wregis/detail?wxidorg=164483"
  end
end