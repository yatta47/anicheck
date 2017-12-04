require 'json'
require 'uri'
require 'net/http'
require 'date'
require 'fileutils'

class Main
    def initialize
        @itunes_url = "https://itunes.apple.com/jp/rss/topsongs/limit=100/genre=29/json"
        @heroku_url = "https://top-anime-watcher.herokuapp.com/musics.json"
        @data_dir = "../_data"
        
        @new_items = ""
        @all_items = []
    end
    
    def main
        setup
        read_itunes_feed
        # day_test
        read_heroku_feed
        diff_data
    end
    
    def setup
        #
        # New Items Data Get
        # 
        uri = URI.parse(@heroku_url)
        json = Net::HTTP.get(uri)
        result = JSON.load(json)

        # today's insert data filtering
        @new_items = get_today_new_items_from_json(result)
        
        #
        # All Items Data Get
        #
        @all_items = get_today_all_items_from_json()
    end
    
    def get_today_all_items_from_json()
        uri = URI.parse(@itunes_url)
        json = Net::HTTP.get(uri)

        result = JSON.load(json)
        
        items = []
        num = 1
        entries = result["feed"]["entry"]
        
        # File.open("rank_entry.json", "w") do |file|
        #     JSON.dump(entries, file)
        # end
        
        entries.each do |entry|
            item ={}
            # pp entry
            item.store("song", entry["im:name"]["label"])
            item.store("artist", entry["im:artist"]["label"])
            item.store("image", entry["im:image"][2]["label"])
            # rights は無い場合があるからnilチェック
            if entry["rights"].nil?
                item.store("rights", "")
            else
                item.store("rights", entry["rights"]["label"])
            end
            item.store("title", entry["title"]["label"])
            item.store("link", entry["id"]["label"])
            item.store("preview", entry["link"][1]["attributes"]["href"])
            item.store("id_key",entry["id"]["attributes"]["im:id"])
            item.store("release_date", entry["im:releaseDate"]["label"])
            item.store("price", entry["im:price"]["attributes"]["amount"])
            item.store("rank", num)

            num += 1
            
            items.push(item)
        end
        
        items
    end
    
    
    def read_heroku_feed
        # # Json Data get
        # uri = URI.parse(@heroku_url)
        # json = Net::HTTP.get(uri)
        # result = JSON.load(json)

        # # today's insert data filtering
        # items = get_today_items_from_json(result)        

        d = DateTime.now
        # str = d.strftime("%Y%m%d%H%M%S")
        str = d.strftime("%Y%m%d")
        file_name = "rank_new_" + str + ".json"

        File.open(file_name, 'w') do |file|
            file.puts(@new_items.to_json)
        end
        
        FileUtils.mv(file_name, @data_dir)
    end
    
    def read_itunes_feed
        # uri = URI.parse(@itunes_url)
        # json = Net::HTTP.get(uri)

        # result = JSON.load(json)
        
        # items = []
        # num = 1
        # entries = result["feed"]["entry"]
        
        # # File.open("rank_entry.json", "w") do |file|
        # #     JSON.dump(entries, file)
        # # end
        
        # entries.each do |entry|
        #     item ={}
        #     # pp entry
        #     item.store("song", entry["im:name"]["label"])
        #     item.store("artist", entry["im:artist"]["label"])
        #     item.store("image", entry["im:image"][2]["label"])
        #     # rights は無い場合があるからnilチェック
        #     if entry["rights"].nil?
        #         item.store("rights", "")
        #     else
        #         item.store("rights", entry["rights"]["label"])
        #     end
        #     item.store("title", entry["title"]["label"])
        #     item.store("link", entry["id"]["label"])
        #     item.store("preview", entry["link"][1]["attributes"]["href"])
        #     item.store("id_key",entry["id"]["attributes"]["im:id"])
        #     item.store("release_date", entry["im:releaseDate"]["label"])
        #     item.store("price", entry["im:price"]["attributes"]["amount"])
        #     item.store("rank", num)

        #     num += 1
            
        #     items.push(item)
        # end
        
        d = DateTime.now
        # str = d.strftime("%Y%m%d%H%M%S")
        str = d.strftime("%Y%m%d")
        file_name = "rank_all_" + str + ".json"
        File.open(file_name, 'w') do |file|
            file.puts(@all_items.to_json)
        end

        FileUtils.mv(file_name, @data_dir)
    end
    
    def diff_data
        all = []
        @all_items.each do |item|
            @new_items.each do |new|
                if item["id_key"] == new["id_key"]
                    item.store("css", "blue")
                    break
                end
                item.store("css", "orange")
            end
            all.push(item)
        end
        
        d = DateTime.now
        str = d.strftime("%Y%m%d")
        file_name = "change_rank_all_" + str + ".json"
        File.open(file_name, 'w') do |file|
            file.puts(all.to_json)
        end
    end

    def day_test
        today = DateTime.now.new_offset('+09:00')
        puts today
        puts today.to_date - 1

        # today2 = Time.now.in_time_zone('Tokyo').to_date
        # p today2
        
        # today3 = Date.today_in_zone('Melbourne')
        # p today3
    end

    private
        # Description:
        #   もらったJSONデータから、今日の日付で追加されたものだけを返す
        #   今日以外のものを取得したければ日付を減算する
        #    ex) today = DateTime.now.new_offset('+09:00').to_date - 2
        def get_today_new_items_from_json(json)
            today = DateTime.now.new_offset('+09:00').to_date - 5
            items = []
            
            json.each do |entry|
                update_day = Date.parse(entry["updated_at"])
                if today == update_day
                    items.push(entry)
                end
            end
        
            items
        end
        
        def json_to_file(file_name, data)
            File.open(file_name, 'w') do |file|
                JSON.dump(data, file)
            end
        end
        
        def hash_to_file(file_name, data)
            File.open(file_name, 'w') do |file|
                file.puts(data.to_json)
            end
        end

end

Main.new.main