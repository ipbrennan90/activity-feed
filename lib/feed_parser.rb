require 'json'
class FeedParser
  def initialize
    @data = JSON.parse(File.open("data/feed_entries.json").read)
    @objects = JSON.parse(File.open("data/objects.json").read)
  end

  def find_id(feed_object)
    @user = feed_object["creator"]["id"]
    @address = feed_object["address"]["id"]
    @patient = feed_object["patient"]["id"]
  end


  def find_creator(id)
    @objects["User"].map {|creator|
      if creator["id"]== id
        @name = creator["name"]
        @user_url = creator["url"]
    end}
  end

  def find_address(id)
    @objects["Address"].map {|address|
      if address["id"]== id
        @address_name= address["address"]
        @address_url = address["url"]
    end}
  end

  def find_patient(id)
    @objects["Patient"].map {|patient|
      if patient["id"]== id
        @patient_name= patient["name"]
        @patient_url = patient["url"]
    end}
  end

  def sentence
    md=""
    @data.each do |feed|
      find_id(feed["objects"])
      find_creator(@user)
      find_address(@address)
      find_patient(@patient)
      new_sentence = feed["sentence"].sub! '{creator}', "[#{@name}](#{@user_url})"
      new_sentence.sub! '{address}', "[#{@address_name}](#{@address_url})"
      new_sentence.sub! '{patient}', "[#{@patient_name}](#{@patient_url})"
      md<<new_sentence
    end
    File.write('test.md',md)
  end

end

feed = FeedParser.new
feed.sentence
