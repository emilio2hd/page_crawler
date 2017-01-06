class AddStatusToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :status, :integer, null: false, default: 0
    Page.all.each { |page| page.processed! }
  end
end
