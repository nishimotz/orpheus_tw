# require 'rubygems'
require 'mechanize'

class Song < ActiveRecord::Base
  def compose
    lyric = @text
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
    @compose_id = f.fields.find{|f| f.name == "compositionid"}.value
    #puts @compose_id
  end
end
