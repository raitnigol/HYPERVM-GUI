<#
This code is for making your life easier when you need to create Hyper-V virtual machines
fast and easily.
Just select the right parameters for your virtual machine and with a single press of a button,
the script does everything magically for you.
#>


# We want the GUI to autoscale, thus we need to get the current users display resolution
$ClientSize = [System.Windows.Forms.SystemInformation]::VirtualScreen
$ClientWidth = $ClientSize.Width
$ClientHeight = $ClientSize.Height

# First, initiate the form.
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Build the form
$HYPERVM_GUI_MAIN_WINDOW = New-Object System.Windows.Forms.Form
$HYPERVM_GUI_MAIN_WINDOW.ClientSize = "$($ClientWidth / 1.5), $($ClientHeight / 1.5)"
$HYPERVM_GUI_MAIN_WINDOW.Text = 'HYPERVM-GUI'
$HYPERVM_GUI_MAIN_WINDOW.TopMost = $false
$HYPERVM_GUI_MAIN_WINDOW.StartPosition = 'CenterScreen'
$HYPERVM_GUI_MAIN_WINDOW.BackColor = 'White'
$HYPERVM_GUI_MAIN_WINDOW.MinimumSize = "$($ClientWidth / 2), $($ClientHeight / 2)"

$HYPERVM_GUI_MAIN_WINDOW.BringToFront()


# Show the GUI
[void]$HYPERVM_GUI_MAIN_WINDOW.ShowDialog()


# After closing the GUI, dispose of it
$HYPERVM_GUI_MAIN_WINDOW.Dispose()