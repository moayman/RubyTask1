class Numeric

@@currencies = {egp:1.00,usd:7.15,eur:9.26,jpy: 0.068}
@@memo = {}


def convert_currency(options)
options[:from] = options[:from][/(?<curr>.+)(s)\Z/,"curr"].to_sym if options[:from] =~ /(.+)s\Z/
options[:to] = options[:to][/(?<curr>.+)(s)\Z/,"curr"].to_sym if options[:to] =~ /(.+)s\Z/
if options[:from] == :egp
memo_currency(options[:to])
return self * @@currencies[options[:to]]
else
temp = self / @@currencies[options[:to]]
return temp * @@currencies[options[:from]]
end
end

def self.add_currency(options)
options.each do |curr,rate|
@@currencies[curr] = rate;
end
end

def self.update_currencies()
@@currencies.each do |currency, rate|
update_currency(currency)
end
puts @@currencies
end

def self.update_currency(curr)
require "date"
require "net/http"
require "uri"
require "json"
uri = URI.parse("http://devel.farebookings.com/api/curconversor/"+curr.to_s+"/EGP/1/json")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
json = JSON.parse(response.body)
@@currencies[curr] = json["EGP"];
@@memo[curr] = Date.today
end

def memo_currency(curr)
require "date"
update_currency(curr) if @@memo[curr] == nil || @@memo[curr] < Date.today
end

end
