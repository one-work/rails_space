module Space
  module Print::Desk
    extend ActiveSupport::Concern

    def to_esc(pr, aim: 'order')
      total = 0

      case aim
      when 'order'
        pr.text_big "#{organ.name}"
        pr.break_line
        pr.text "#{self.class.human_attribute_name(:name)}：#{name}"
        pr.text '已下单：'
        trade_items.where(status: 'ordered').each do |item|
          total += item.amount
          pr.text(" #{item.good_name} #{item.number.to_human} x #{item.single_price.to_money.to_s}") if item.good
        end
        pr.break_line
        pr.text "合计：#{total.to_money.to_s}"
        pr.break_line
        pr.text "感谢您的惠顾！"
        pr.text "订餐电话：#{'0717-6788808'}"
        pr.text "#{Time.current.to_fs(:wechat)}"
      when 'dinner'
        pr.bar(height: 20)
        pr.qrcode(product_url, x: 20, y: 10, cell_width: 10)
        pr.text(name, x: 320, scale: 2)
        pr.middle_text('扫码点餐', x: 320)
      when 'xxx'
        pr.text code
        pr.qrcode_right(product_url)
      end
    end

  end
end
