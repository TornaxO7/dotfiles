command! Cp let @+=expand('%:p')
command! CmpStop lua require('cmp').setup.buffer { enabled = false }
command! CmpStart lua require('cmp').setup.buffer { enabled = true }

command! DapStop lua require("dap").terminate()
command! NotificantionDismiss lua require("notify").dismiss()
