require 'open-uri'
require 'nokogiri'
require 'date'
require 'terminal-table/import'
require 'awesome_print'

URL = 'https://www.spies.dk/afbudsrejser?filter=false&search=false' +
                                     '&tripTypes=FLIGHTONLY' +
                                     '&destinationCode=EG' +
                                     '&departure=CPH' +
                                     '&orderBy=DATE' +
                                     '&durationFrom=7' +
                                     '&durationTo=10'

table do
  self.title    = 'Trips to: Egypt'
  self.headings = ['Date', 'Duration (days)', 'Price (kr.)', 'Seats Left']
  self.rows     = Nokogiri::HTML(open(URL)).css('.tcne-lms-hit').take(5).map do |hit|
    [
      # date =
      Date.strptime(CGI.parse(URI.parse(hit.at_css('.tcne-lms-hit__content a')[:href]).query)['QueryDepDate'].first, '%d%m%Y').strftime('%Y-%m-%d'),
      # days =
      8,
      # price =
      hit.at_css('.webui-price-formatter').text.scan(/\d/).join.chars.reverse.each_slice(3).map(&:join).join('.').reverse.rjust(5) << ',00',
      # seats =
      ((t = hit.at_css('.webui-tags__tag--few-seats')) && t.text.scan(/\d/).join).to_s.rjust(3),
    ]
  end.map { |r| r.map { |c| { value: c, alignment: :right } } }
  def title_cell_options ; super.merge(alignment: :left) ; end
end.tap(&method(:puts))
