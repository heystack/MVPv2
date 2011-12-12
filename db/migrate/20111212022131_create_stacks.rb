class CreateStacks < ActiveRecord::Migration
  def change
    create_table :stacks do |t|
      t.string :attr_biggest_desc
      t.string :attr_comparison_text
      t.string :attr_email_buttons
      t.string :attr_email_units
      t.string :attr_lowest_desc
      t.string :attr_lowest_legend
      t.integer :created_by
      t.string :madlibs_intro
      t.string :madlibs_label
      t.string :madlibs_units
      t.string :name
      t.string :question
      t.integer :sotd
      t.string :stem

      t.timestamps
    end
  end
end
