require 'open-uri'
require 'nokogiri'
require 'date'
require 'awesome_print'

URL = 'https://www.spies.dk/afbudsrejser?filter=false&search=false' +
                                     '&tripTypes=FLIGHTONLY' +
                                     '&destinationCode=EG' +
                                     '&departure=CPH' +
                                     '&orderBy=DATE' +
                                     '&durationFrom=7' +
                                     '&durationTo=10'

doc = Nokogiri::HTML(open(URL))
puts ' +-----------------+'
puts ' | Trips to: Egypt |'
puts '+------------+-----+-----------+-------------+------------+'
puts '| Date       | Duration (days) | Price (kr.) | Seats Left |'
puts '+------------+-----------------+-------------+------------+'
doc.css('.tcne-lms-hit').take(5).each do |hit|
  price = hit.at_css('.webui-price-formatter').text.scan(/\d/).join.chars.reverse.each_slice(3).map(&:join).join('.').reverse.rjust(5) << ',00'
  date  = Date.strptime(CGI.parse(URI.parse(hit.at_css('.tcne-lms-hit__content a')[:href]).query)['QueryDepDate'].first, '%d%m%Y').strftime('%Y-%m-%d')
  seats = ((t = hit.at_css('.webui-tags__tag--few-seats')) && t.text.scan(/\d/).join).to_s.rjust(3)

  puts "| #{date} |               8 |    #{price} |        #{seats} |"
end
puts '+------------+-----------------+-------------+------------+'
