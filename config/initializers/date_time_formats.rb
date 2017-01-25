# Default format for displaying dates and times
Date::DATE_FORMATS[:default] = "%m/%d/%Y"

# # MONKEY_PATCH
# module ActionView
#   module Helpers
#     module Tags
#       class DateField < DatetimeField
#         private
#
#           def format_date(value)
#             # value.try(:strftime, "%Y-%m-%d")
#             value.try(:to_date)
#           end
#       end
#     end
#   end
# end
