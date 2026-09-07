module Space
  module Print::Desk
    extend ActiveSupport::Concern

    def to_esc(pr, aim: 'order')
      case aim
      when 'order'
        pr.text_big_center "#{organ.name}"
        pr.dash
        pr.text "#{self.class.human_attribute_name(:name)}：#{name}"
        pr.dash

        pr.text '已下单（已支付）：'
        pr.dash
        paid = 0
        paids = []
        orders.where(state: 'init', payment_status: 'paid').each do |order|
          paid += order.amount
          order.items.each do |item|
            paids << [item.good_name, item.single_price.to_money.to_s, item.number.to_human, item.amount.to_money.to_s]
          end
        end
        pr.table_3(cols: paids)
        pr.dash
        pr.text "合计（已支付）：#{paid.to_money.to_s}"
        pr.dash

        pr.text '已下单（未支付）：'
        pr.dash
        total = 0
        cols = []
        orders.where(state: 'init', payment_status: 'unpaid').each do |order|
          total += order.amount
          order.items.each do |item|
            cols << [item.good_name, item.single_price.to_money.to_s, item.number.to_human, item.amount.to_money.to_s]
          end
        end
        pr.table_3(cols: cols)
        pr.break_line
        pr.dash
        pr.text "合计（未支付）：#{total.to_money.to_s}"
        pr.break_line
        pr.dash

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
