require "parser/current"
require "proc_party"
require "set"

require "who_am_i/refinement/yield_self"
require "who_am_i/refinement/hash_dig"

require "who_am_i/extracted_class"
require "who_am_i/comment"
require "who_am_i/table_info"
require "who_am_i/table_column_info"
require "who_am_i/version"
require "who_am_i/find_classes"
require "who_am_i/text_table"
require "who_am_i/error"
require "who_am_i/config"

require "who_am_i/function/remove_annotation"
require "who_am_i/function/main"
require "who_am_i/function/load_config"
require "who_am_i/function/setup_environment"
require "who_am_i/function/connect_to_database"
require "who_am_i/function/load_initializers"
require "who_am_i/function/get_tables"
require "who_am_i/function/annotate_models"
require "who_am_i/function/ls"
require "who_am_i/function/parse_model"
require "who_am_i/function/extract_model_data"
require "who_am_i/function/resolve_class_relationships"
require "who_am_i/function/resolve_active_record"
require "who_am_i/function/resolve_table"
require "who_am_i/function/compute_comment"
require "who_am_i/function/compute_content"
require "who_am_i/function/write_model"

if defined?(Rails)
  require "who_am_i/railtie"
end
