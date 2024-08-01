class CreateJoinTableWebsitesTags < ActiveRecord::Migration[7.1]
  def change
    create_join_table :websites, :tags do |t|
       t.index [:website_id, :tag_id]
       t.index [:tag_id, :website_id]
    end
  end
end
