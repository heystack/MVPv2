class ColsForNewStack < ActiveRecord::Migration
  def change
    add_column :stacks, :attr_type, :string
    add_column :stacks, :attr_tooltip_prefix, :string
    add_column :stacks, :attr_tooltip_units, :string
    add_column :stacks, :attr_rounding, :string
    add_column :stacks, :attr_comparison_1, :string
    add_column :stacks, :attr_comparison_2, :string
    add_column :stacks, :madlibs_1, :string
    add_column :stacks, :madlibs_1_type, :string
    add_column :stacks, :madlibs_1_label, :string
    add_column :stacks, :madlibs_1_option_1, :string
    add_column :stacks, :madlibs_1_option_2, :string
    add_column :stacks, :madlibs_1_option_3, :string
    add_column :stacks, :madlibs_1_option_4, :string
    add_column :stacks, :madlibs_1_option_5, :string
    add_column :stacks, :madlibs_1_option_6, :string
    add_column :stacks, :madlibs_1_option_7, :string
    add_column :stacks, :madlibs_1_option_8, :string
    add_column :stacks, :madlibs_1_option_9, :string
    add_column :stacks, :madlibs_1_option_10, :string
    add_column :stacks, :madlibs_1_option_11, :string
    add_column :stacks, :madlibs_1_option_12, :string
    add_column :stacks, :madlibs_2, :string
    add_column :stacks, :madlibs_2_label, :string
    add_column :stacks, :madlibs_3, :string
  end
end
