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


# Add Tab Control to support multiple tabs
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 0
$TabControl.Location = $System_Drawing_Point
$TabControl.Name = 'TabControl'
$TabControl.SizeMode = 'Fixed'

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = "$($ClientWidth / 1.5)"
$System_Drawing_Size.Height = "$($ClientHeight / 1.5)"
$TabControl.Size = $System_Drawing_Size
$TabControl.Anchor = 'left, right, top, bottom'

$HYPERVM_GUI_MAIN_WINDOW.Controls.Add($TabControl)


# Add main page to the GUI
$HYPERVM_GUI_MAIN_PAGE = New-Object System.Windows.Forms.TabPage
$HYPERVM_GUI_MAIN_PAGE.DataBindings.DefaultDataSourceUpdateMode = 0
$HYPERVM_GUI_MAIN_PAGE.UseVisualStyleBackColor = $tue
$HYPERVM_GUI_MAIN_PAGE.Text = 'Create a VM'

$TabControl.Controls.Add($HYPERVM_GUI_MAIN_PAGE)


# Add second page, a datagridview that shows all available virtual machines to the GUI
$HYPERVM_GUI_DATAGRIDVIEW_PAGE = New-Object System.Windows.Forms.TabPage
$HYPERVM_GUI_DATAGRIDVIEW_PAGE.DataBindings.DefaultDataSourceUpdateMode = 0
$HYPERVM_GUI_DATAGRIDVIEW_PAGE.UseVisualStyleBackColor = $true
$HYPERVM_GUI_DATAGRIDVIEW_PAGE.Text = 'Virtual Machines'

$TabControl.Controls.Add($HYPERVM_GUI_DATAGRIDVIEW_PAGE)


# Add a third page, showing current PowerShell versions and available virtual machines
$HYPERVM_GUI_PROPERTIES_PAGE = New-Object System.Windows.Forms.TabPage
$HYPERVM_GUI_PROPERTIES_PAGE.DataBindings.DefaultDataSourceUpdateMode = 0
$HYPERVM_GUI_PROPERTIES_PAGE.UseVisualStyleBackColor = $true
$HYPERVM_GUI_PROPERTIES_PAGE.Text = 'Properties'

$TabControl.Controls.Add($HYPERVM_GUI_DATAGRIDVIEW_PAGE)


$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW = New-Object System.Windows.Forms.DataGridView
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Dock = 'Fill'

# To even create Hyper-V virtual machines at the first place, you must have RSAT-Hyper-V-Tools installed.
# So we should check if the user has installed the tool and if not, ask the user if they would like to install it.

# to be implemented later because I do not have access to a Windows Server.

# Add a label that when not installed, shows that the Hyper-V tools are not yet installed.
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Text = "Module: RSAT-Hyper-V-Tools has not yet been installed."
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Dock = 'Top'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.TextAlign = 'TopCenter'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.BackColor = 'Gray'
$HYPERVM_GUI_MAIN_PAGE.Controls.Add($HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL)


# Show the GUI
[void]$HYPERVM_GUI_MAIN_WINDOW.ShowDialog()


# After closing the GUI, dispose of it
$HYPERVM_GUI_MAIN_WINDOW.Dispose()