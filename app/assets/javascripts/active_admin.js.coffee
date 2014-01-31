#= require active_admin/base

# ADDED BY TOM SMYTH
# need to turn off the confirm dialog on batch actions because there is a JS error
$(document).ready ->
  $('div.batch_actions_selector a.batch_action').removeAttr('data-confirm');