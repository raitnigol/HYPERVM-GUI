<#
This code is for making your life easier when you need to create Hyper-V virtual machines
fast and easily.
Just select the right parameters for your virtual machine and with a single press of a button,
the script does everything magically for you.

.NAME
    HYPERVM-GUI
#>


# We want the GUI to autoscale, thus we need to get the current users display resolution
$ClientSize = [System.Windows.Forms.SystemInformation]::VirtualScreen
$ClientWidth = $ClientSize.Width
$ClientHeight = $ClientSize.Height


# Get the version that PowerShell is running
$PS_CURRENT_VERSION = $PSVersionTable.PSVersion

# Get the Windows version that the current computer or server runs
$WINDOWS_CURRENT_VERSION = (Get-WmiObject -class Win32_OperatingSystem).Caption

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

$TabControl.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE)


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


# Add a datagridview to list all currently available virtual machines
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW = New-Object System.Windows.Forms.DataGridView
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Dock = 'Fill'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Anchor = 'top, bottom, left, right'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AutoSizeColumnsMode = 'AllCells'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.TabIndex = 0
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.RowHeadersVisible = $false
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Location = $System_Drawing_Point
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Size = $System_Drawing_Size
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToAddRows = $false
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToResizeRows = $false
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToResizeRows = $false
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToDeleteRows = $false
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.ReadOnly = $true
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.BackColor = 'White'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.ColumnCount = 7

# Column 1 to show the name of the virtual machine
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Columns[0].Name = 'Virtual Machine'

# Column 2 to show the state of the virtual machine
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Columns[1].Name = 'State'

# Column 3 to show the CPU usage of the VM
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Columns[2].Name = 'CPU usage (%)'

# Column 4 to show the memory assigned to the VM
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Columns[3].Name = 'Memory Assigned'

# Column 5 to show the uptime of the VM.
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Columns[4].Name = 'Uptime'

# Column 6 to show the status of the currently running virtual machine
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Columns[5].Name = 'Status'

# Column 7 to show the version of the virtual machine
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Columns[6].Name = 'Version'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AutoSizeColumnsMode = 'Fill'

#$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AutoSizeRowsMode = 'AllCells'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToResizeColumns = $true
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToOrderColumns = $true

$HYPERVM_GUI_DATAGRIDVIEW_PAGE.Controls.Add($HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW)


# Add a label to the third page showing current powershell version
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Text = $("Current PowerShell version: $PS_CURRENT_VERSION")
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 8)
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Dock = 'Bottom'

$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL)

# Add a label to the third page howing current Windows version
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Text = $("Current Windows version: $WINDOWS_CURRENT_VERSION")
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 8)
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Margin = 50

$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL)


# Show the GUI
[void]$HYPERVM_GUI_MAIN_WINDOW.ShowDialog()


# After closing the GUI, dispose of it
$HYPERVM_GUI_MAIN_WINDOW.Dispose()