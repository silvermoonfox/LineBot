require 'line/bot'
class KamigoController < ApplicationController
    protect_from_forgery with: :null_session
    def eat
        render plain: "吃土啦"
    end
   

    def line
        # Line Bot API 物件初始化
        @line ||= Line::Bot::Client.new { |config|
        config.channel_secret = ''
        config.channel_token = ''
      }
    end

    def webhook

        # 學說話
        reply_text = learn(received_text)
    
        # 關鍵字回覆
        reply_text = keyword_reply(received_text) if reply_text.include? 'imgur'

        reply_image = get_image(reply_text) else reply_text.nil?
        # 傳送訊息到 line (image)
        response = reply_image_to_line(reply_image)
    
        # 傳送訊息到 line
        response = reply_to_line(reply_text)
        
        # 回應 200
        head :ok
      end 


      def get_image(reply_text)
        return nil unless reply_text.include? 'imgur'
        reply_image_to_line(reply_image)
      end
    
      # 取得對方說的話
      def received_text
        message = params['events'][0]['message']
        message['text'] unless message.nil?
      end

      # 學說話
    def learn(received_text)
        #如果開頭不是 卡米狗學說話; 就跳出
        return nil unless received_text[0..6] == '剛大椒學說話;'
    
        received_text = received_text[7..-1]
        semicolon_index = received_text.index(';')

        # 找不到分號就跳出
        return nil if semicolon_index.nil?

        keyword = received_text[0..semicolon_index-1]
        message = received_text[semicolon_index+1..-1]

        KeywordMapping.create(keyword: keyword, message: message)
        '棍棍棍～好哦～好哦～'
  end
    
    # 關鍵字回覆
        def keyword_reply(received_text)
        KeywordMapping.where(keyword: received_text).last&.message
        end

    # 傳送訊息到 line
        def reply_to_line(reply_text)
        return nil if reply_text.nil?
     
    
    # 取得 reply token
        reply_token = params['events'][0]['replyToken']
    
    # 設定回覆訊息
        message = {
        type: 'text',
        text: reply_text
        } 
       

    # 傳送訊息
        line.reply_message(reply_token, message)
        end
    
    # 傳送圖片到 line
        def reply_image_to_line(reply_image)
        return nil if reply_image.nil?
    
    # 取得 reply token
        reply_token = params['events'][0]['replyToken']
    
    # 設定回覆訊息
        message = {
        type: "image",
            originalContentUrl: reply_image,
            previewImageUrl: reply_image
        }

    # 傳送訊息
        line.reply_message(reply_token, message)
        end


end
