require '../../wrappers/nrsr/voting'

describe NRSR::Voting do 
  it "should parse voting info" do
    voting = NRSR::Voting.parse(File.read("fixtures/voting1.html"))
    voting.subject.should == "Hlasovanie o pozmeňujúcich a doplňujúcich návrhoch k programu 48. schôdze Národnej rady Slovenskej republiky.\nPodpr. Belousovová, 1. návrh."
    voting.meeting_number.should == 48
    voting.number.should == 3
    voting.happened_at.should == DateTime.civil(2010, 2, 2, 13, 18)
  end

  it "should parse voting statistics" do
    voting = NRSR::Voting.parse(File.read("fixtures/voting1.html"))
    voting.attending_count.should == 108
    voting.voting_count.should == 96
    voting.pro_count.should == 44
    voting.against_count.should == 0
    voting.hold_count.should == 52
    voting.not_voting_count.should == 12
    voting.not_attending_count.should == 42
  end

  it "should parse all votes with parties" do
    voting = NRSR::Voting.parse(File.read("fixtures/voting1.html"))
    voting.votes["Klub KDH"].should == [
            ["N", "Abrhan, Pavol"], ["?", "Brocka, Július"], ["?", "Fronc, Martin"], ["?", "Gibalová, Monika"],
            ["?", "Hrušovský, Pavol"], ["N", "Kahanec, Stanislav"], ["0", "Lipšic, Daniel"], ["?", "Sabolová, Mária"],
            ["0", "Šimko, Jozef"],
    ]
    voting.votes["Klub ĽS – HZDS"].size.should == 15
    voting.votes["Klub SDKÚ – DS"].size.should == 28
    voting.votes["Klub SMER – SD"].size.should == 50
    voting.votes["Klub SMK – MKP"].size.should == 15
    voting.votes["Klub SNS"].size.should == 19
    voting.votes["Poslanci, ktorí nie sú členmi poslaneckých klubov"].size.should == 14
    voting.votes["Poslanci, ktorí nie sú členmi poslaneckých klubov"].last.should == ["?", "Simon, Zsolt"]
  end

  it "should parse info from secret voting" do
    voting = NRSR::Voting.parse(File.read("fixtures/voting2.html"))
    voting.meeting_number.should == 4
    voting.number.should == nil
    voting.happened_at.should == DateTime.civil(2006, 9, 5)
    voting.attending_count.should == 99
    voting.voting_count.should == 96
    voting.pro_count.should == 78
    voting.against_count.should == 13
    voting.hold_count.should == 5
    voting.not_voting_count.should == 3
    voting.not_attending_count.should == 51
    voting.votes.should == {}
  end

  it "should return nil on invalid data" do
    NRSR::Voting.parse(File.read("fixtures/voting3.html")).should == nil
  end

  it "should return url for a given id" do
    NRSR::Voting.url(123).should == "http://www.nrsr.sk/Default.aspx?sid=schodze/hlasovanie/hlasklub&ID=123&Lang=sk"
  end
end