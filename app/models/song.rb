require 'rubygems'
require 'mechanize'
gem 'twitter4r', '>=0.3.1'
require 'twitter'
#require 'twitter/console'
require 'time'
#require 'yaml'

#USERNAME = 'orpheus_tw'
#PASSWORD = 'c7CYqDyx'

class Song < ActiveRecord::Base
  def perform
    lyric = self.text
    agent = WWW::Mechanize.new
    page = agent.get('http://orpheus.hil.t.u-tokyo.ac.jp/automatic-composition/index.cgi')
    form = page.forms.find{|f| f.name == 'orpheus_form'}
    # form.fields.each{|f| puts f.name + " " + f.value.to_s}
    form.fields.find{|f| f.name == 'lyric'}.value = lyric
    form.fields.find{|f| f.name == 'lyric1'}.value = lyric
    form.fields.find{|f| f.name == 'compose'}.value = 'yes'
    form.fields.find{|f| f.name == 'genre'}.value = '1'
    form.fields.find{|f| f.name == 'voice'}.value = '1'
    form.fields.find{|f| f.name == 'tempo'}.value = '0'
    result1_page = agent.submit(form)
    result1_form = result1_page.form_with(:name => 'go')
    result2_page = agent.submit(result1_form)
    #puts result2_page.body
    #result2_page.fields.each{ |f| puts f.name + " " + f.value.to_s }
    f = result2_page.forms.find{|f| f.action == "../automatic-composition/enquete.cgi"}
    self.composition = f.fields.find{|f| f.name == "compositionid"}.value
    save!
    
    twitter = Twitter::Client.from_config( "#{RAILS_ROOT}/config/tw_conf.yml",'orpheus_tw')
    status = twitter.status(:post, self.tweet)
  end
  
  def tweet
    self.text + " " + self.comment + " http://orpheus-tw.heroku.com/songs/#{self.id.to_s}"
  end
end

