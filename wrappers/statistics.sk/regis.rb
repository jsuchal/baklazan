require "nokogiri"

module StatisticsSK
  class Regis
    attr_accessor :ico, :name, :address, :district, :valid_from, :valid_to, :legal_form_code, :sk_nace_category_code, :okec_category_code, :sector_account_code, :holder_code

    def self.parse(html)
      doc = Nokogiri::HTML(html, nil, "windows-1250")
      company = new
      company.ico = doc.css(".tabid td:nth-child(3)")[0].content.to_i
      company.name = doc.css(".tabid td:nth-child(3)")[1].content
      company.address = doc.css(".tabid td:nth-child(3)")[5].content.gsub(/\302\240/, '')
      company.district = doc.css(".tabid td:nth-child(3)")[6].content.strip
      company.valid_from = Date.parse(doc.css(".tabid td:nth-child(3)")[3].content)
      valid_to = doc.css(".tabid td:nth-child(3)")[4].content
      company.valid_to = Date.parse(valid_to) if valid_to =~ /\d+\.\d+\.\d+/
      company.legal_form_code = doc.css(".tablist td:nth-child(2)")[0].content.to_i
      company.sk_nace_category_code = doc.css(".tablist td:nth-child(2)")[1].content.to_i
      company.okec_category_code = doc.css(".tablist td:nth-child(2)")[2].content.to_i
      company.sector_account_code = doc.css(".tablist td:nth-child(2)")[3].content.to_i
      company.holder_code = doc.css(".tablist td:nth-child(2)")[4].content.to_i
      company
    end

    def self.url(id)
      "http://www.statistics.sk/pls/wregis/detail?wxidorg=#{id}"
    end
  end
end