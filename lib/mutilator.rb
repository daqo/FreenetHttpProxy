require 'nokogiri'
require 'open-uri'
require_relative 'utility'

class Mutilator
  def initialize(url,prefix=nil)
    url = "http://#{url}" unless url?(url)
    @url = URI.parse(url)
    @prefix = prefix
    @doc = Nokogiri(open(url, "User-Agent" => "Mongler Ruby/#{RUBY_VERSION}"))
  end

  def rewrite(tag, attribute, prefix = false)
    @doc.css(tag).each do |element|
      unless url?(element[attribute])
        element[attribute] = "#{@prefix if prefix}http://#{@url.host}/#{element[attribute]}"
      end
    end
  end

  def to_html
    @doc.to_s
  end

  def url?(url=nil)
    url.nil? ? !@url.scheme.nil? : !(URI.parse(url).scheme.nil?)
  end

  def rewrite_page
    self.rewrite('img', 'src')
    self.rewrite('link', 'href')
    self.rewrite('a', 'href', true)
    self.rewrite('form', 'action', true)
    self.to_html
  end
end
