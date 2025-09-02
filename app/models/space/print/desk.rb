module Space
  module Print::Desk
    extend ActiveSupport::Concern

    included do

    end

    def print
      if organ&.receipt_printer
        organ.receipt_printer.printer.print do |pr|
          to_esc(pr)
        end
      end
    end

    def print_all
      return unless organ.receipt_printer
      organ.receipt_printer.printer.print do |pr|
        to_esc(pr)
      end
    end

    def to_esc(pr)
      total = 0

      pr.big_text "#{organ.name}"
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
      pr.render
      pr
    end

    def to_tspl(ts)
      ts.bar(height: 20)
      ts.qrcode(product_url, x: 20, y: 10, cell_width: 10)
      ts.text(name, x: 320, scale: 2)
      ts.middle_text('扫码点餐', x: 320)
      ts.render
    end

    def to_cpcl(cpcl)
      cpcl.text code
      cpcl.qrcode_right(product_url)
      cpcl.render
    end

  end
end
