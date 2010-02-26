require "nokogiri"

module NRSR
  class Voting
    attr_accessor :subject, :meeting_number, :number, :happened_at, :attending_count, :voting_count, :pro_count, :against_count, :hold_count, :not_voting_count, :not_attending_count, :votes

    def self.parse(html)
      doc = Nokogiri::HTML(html)
      voting = new
      voting.subject = doc.css("#ctl15__hlasHeader__nazovLabel").first.content
      return nil if voting.subject == "(Popis hlasovania)"
      voting.meeting_number = doc.css("#ctl15__hlasHeader__schodzaLink").first.content.match(/\d+/)[0].to_i
      number_raw = doc.css("#ctl15__hlasHeader__cisHlasovaniaLabel").first.content
      voting.number = number_raw.match(/\d+/)[0].to_i unless number_raw.empty?
      time = doc.css("#ctl15__hlasHeader__dateLabel").first.content.match(/(\d+)\. (\d+)\. (\d+) (\d+):(\d+)/)
      voting.happened_at = DateTime.civil(time[3].to_i, time[2].to_i, time[1].to_i, time[4].to_i, time[5].to_i)

      voting.attending_count = doc.css("#ctl15__hlasHeader__headerCounterPritomni").first.content.to_i
      voting.voting_count = doc.css("#ctl15__hlasHeader__headerCounterHlasujucich").first.content.to_i
      voting.pro_count = doc.css("#ctl15__hlasHeader__headerCounterZa").first.content.to_i
      voting.against_count = doc.css("#ctl15__hlasHeader__headerCounterProti").first.content.to_i
      voting.hold_count = doc.css("#ctl15__hlasHeader__headerCounterZdrzaloSa").first.content.to_i
      voting.not_voting_count = doc.css("#ctl15__hlasHeader__headerCounterNehlasovalo").first.content.to_i
      voting.not_attending_count = doc.css("#ctl15__hlasHeader__headerCounterNepritomni").first.content.to_i
      voting.votes = parse_votes(doc)
      voting
    end

    private
    def self.parse_votes(doc)
      votes = {}
      party = nil
      doc.css("#ctl15__resultsTable tr td").each do |row|
        if row["class"] == "h3"
          party = row.content
        else
          spans = row.css("span")
          unless spans.empty?
            vote = spans.first.content.tr("[] ", "")
            person = row.css("a").first.content
            votes[party] ||= []
            votes[party] << [vote, person]
          end
        end
      end
      votes
    end
  end
end