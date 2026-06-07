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
        orders.where(state: 'init').each do |order|
          total += order.amount
          order.items.each do |item|
            pr.text(" #{item.good_name} #{item.number.to_human} x #{item.single_price.to_money.to_s}") if item.good
          end
        end
        pr.break_line
        pr.text "合计：#{total.to_money.to_s}"
        pr.break_line
        organ.print_note.to_s.split("\n").each do |note|
          pr.text note
        end
        pr.text "#{Time.current.to_fs(:wechat)}"
      when 'dinner'
        pr.dash(height: 20)
        pr.qrcode_right(product_url)
        pr.text(name)
        pr.text('扫码点餐')
      when 'xxx'
        pr.text code
        pr.qrcode_right(product_url)
      end
    end

  end
end
