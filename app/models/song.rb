require 'rubygems'
require 'mechanize'
gem 'twitter4r', '>=0.3.1'
require 'twitter'
#require 'twitter/console'
require 'time'
#require 'yaml'
require 'timeout'

class Song < ActiveRecord::Base
  def perform
    begin
      timeout(60) do
        lyric = self.text
        agent = WWW::Mechanize.new
        page = agent.get('http://orpheus.hil.t.u-tokyo.ac.jp/automatic-composition/index.cgi')
        form = page.forms.find{|f| f.name == 'orpheus_form'}
        # form.fields.each{|f| puts f.name + " " + f.value.to_s}
        form.fields.find{|f| f.name == 'lyric'}.value = lyric
        form.fields.find{|f| f.name == 'lyric1'}.value = lyric
        form.fields.find{|f| f.name == 'compose'}.value = 'yes'
        form.fields.find{|f| f.name == 'genre'}.value = (rand(6)+1).to_s # '1'..'6'
        form.fields.find{|f| f.name == 'voice'}.value = (rand(3)+1).to_s # '1'..'3'
        form.fields.find{|f| f.name == 'tempo'}.value = '0' # omakase
        result1_page = agent.submit(form)
        result1_form = result1_page.form_with(:name => 'go')
        result2_page = agent.submit(result1_form)
        #puts result2_page.body
        #result2_page.fields.each{ |f| puts f.name + " " + f.value.to_s }
        f = result2_page.forms.find{|f| f.action == "../automatic-composition/enquete.cgi"}
        self.composition = f.fields.find{|f| f.name == "compositionid"}.value
        save!
        
        twitter = Twitter::Client.from_config( "#{RAILS_ROOT}/config/tw_conf.yml",'orpheus_tw')
        twitter.status(:post, self.tweet)
        
      end
    rescue TimeoutError
      self.composition = '0'
      save!
    end
  end
  
  def tweet
    msg = self.text + " " + self.comment
    msg = msg.gsub(/\#/,' ').gsub(/\@/,' ')
    url = " http://orpheus-tw.heroku.com/songs/#{self.id.to_s}"
    s = msg + url
    #len = s.chars.count
    #if len > 140
    #  n = len - 138
    #  s1 = msg
    #  s2 = ''
    #  s1.each_char { |c| if n > 0 then n -= 1 else s2 += c end }
    #  s2 += '..'
    #  s = s2 + url
    #end
    s
  end
end

