<#
    This code is for making your life easier when you need to create Hyper-V virtual machines
    fast and easily.
    Just select the right parameters for your virtual machine and with a single press of a button,
    the script does everything magically for you.
    .NAME
    HYPERVM-GUI
#>


# First of all, initiate the form.
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

[Windows.Forms.Application]::EnableVisualStyles()


# We want the GUI to autoscale, thus we need to get the current users display resolution
$ClientSize = [Windows.Forms.SystemInformation]::PrimaryMonitorSize
$ClientWidth = [math]::FLoor($ClientSize.Width)
$ClientHeight = [math]::FLoor($ClientSize.Height)


# Check if the machine running the script is a server, a workstation or a domain controller
$OPERATING_SYSTEM = Get-WmiObject -Class Win32_OperatingSystem
$OPERATING_SYSTEM_TYPE = Switch ($OPERATING_SYSTEM.ProductType) {
  '1' {'Workstation'; break}
  '2' {'Domain-Controller'; break}
  '3' {'Server'; break}
  default {'Something went wrong'; break}
}


# Add a icon to the GUI in base64
$ICON_BASE_64 = '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'
$ICON_BYTES = [Convert]::FromBase64String($ICON_BASE_64)
$STREAM = New-Object -TypeName IO.MemoryStream -ArgumentList ($ICON_BYTES, 0, $ICON_BYTES.Length)
$STREAM.Write($ICON_BYTES, 0, $ICON_BYTES.Length)


# Get the version that PowerShell is running
$PS_CURRENT_VERSION = $PSVersionTable.PSVersion


# Get the Windows version that the current computer or server runs
$WINDOWS_CURRENT_VERSION = (Get-WmiObject -class Win32_OperatingSystem).Caption


# Get the Windows RAM amount
function Calculate-Ram
{
  param
  (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage='Data to process')]
    $InputObject
  )
  process
  {
    '{0:N0}' -F (([math]::round(($InputObject.Sum / 1GB),2)))
  }
}

$TOTAL_CLIENT_MEMORY = Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | Calculate-Ram

# Get the usable RAM amount
$TOTAL_CLIENT_USABLE_MEMORY = $($TOTAL_CLIENT_MEMORY - 1)


# Build the form
$HYPERVM_GUI_MAIN_WINDOW = New-Object -TypeName System.Windows.Forms.Form
$HYPERVM_GUI_MAIN_WINDOW.ClientSize = ('{0}, {1}' -f [math]::Floor($($ClientWidth / 1.5)), [math]::Floor($($ClientHeight / 1.5)))
$HYPERVM_GUI_MAIN_WINDOW.Text = 'HYPERVM-GUI'
$HYPERVM_GUI_MAIN_WINDOW.TopMost = $false
$HYPERVM_GUI_MAIN_WINDOW.StartPosition = 'CenterScreen'
$HYPERVM_GUI_MAIN_WINDOW.BackColor = 'White'
$HYPERVM_GUI_MAIN_WINDOW.MinimumSize = ('{0}, {1}' -f [math]::Floor($($ClientWidth / 2)), [math]::Floor($($ClientHeight / 2)))


# Add the icon to the form
$HYPERVM_GUI_MAIN_WINDOW.Icon = [Drawing.Icon]::FromHandle((New-Object -TypeName System.Drawing.Bitmap -ArgumentList $STREAM).GetHicon())
$HYPERVM_GUI_MAIN_WINDOW.BringToFront()


# Add Tab Control to support multiple tabs
$TabControl = New-Object -TypeName System.Windows.Forms.TabControl
$TabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object -TypeName System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 0
$TabControl.Location = $System_Drawing_Point
$TabControl.Name = 'TabControl'
$TabControl.SizeMode = 'Fixed'

$System_Drawing_Size = New-Object -TypeName System.Drawing.Size
$System_Drawing_Size.Width = ('{0}' -f ($ClientWidth / 1.5))
$System_Drawing_Size.Height = ('{0}' -f ($ClientHeight / 1.5))
$TabControl.Size = $System_Drawing_Size
$TabControl.Anchor = 'left, right, top, bottom'

$HYPERVM_GUI_MAIN_WINDOW.Controls.Add($TabControl)


# Add main page to the GUI
$HYPERVM_GUI_MAIN_PAGE = New-Object -TypeName System.Windows.Forms.TabPage
$HYPERVM_GUI_MAIN_PAGE.DataBindings.DefaultDataSourceUpdateMode = 0
$HYPERVM_GUI_MAIN_PAGE.UseVisualStyleBackColor = $true
$HYPERVM_GUI_MAIN_PAGE.Text = 'Create a VM'

$TabControl.Controls.Add($HYPERVM_GUI_MAIN_PAGE)


# Add second page, a datagridview that shows all available virtual machines to the GUI
$HYPERVM_GUI_DATAGRIDVIEW_PAGE = New-Object -TypeName System.Windows.Forms.TabPage
$HYPERVM_GUI_DATAGRIDVIEW_PAGE.DataBindings.DefaultDataSourceUpdateMode = 0
$HYPERVM_GUI_DATAGRIDVIEW_PAGE.UseVisualStyleBackColor = $true
$HYPERVM_GUI_DATAGRIDVIEW_PAGE.Text = 'Virtual Machines'

$TabControl.Controls.Add($HYPERVM_GUI_DATAGRIDVIEW_PAGE)


# Add a third page, showing current PowerShell versions and available virtual machines
$HYPERVM_GUI_PROPERTIES_PAGE = New-Object -TypeName System.Windows.Forms.TabPage
$HYPERVM_GUI_PROPERTIES_PAGE.DataBindings.DefaultDataSourceUpdateMode = 0
$HYPERVM_GUI_PROPERTIES_PAGE.UseVisualStyleBackColor = $true
$HYPERVM_GUI_PROPERTIES_PAGE.Text = 'Properties'

$TabControl.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE)


# This section is reserved for the main page
# To even create Hyper-V virtual machines at the first place, you must have RSAT-Hyper-V-Tools installed.
# So we should check if the user has installed the tool and if not, ask the user if they would like to install it.

# Add a label that when not installed, shows that the Hyper-V tools are not yet installed.
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Text = 'Module: RSAT-Hyper-V-Tools has not yet been installed.'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 10)
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.TextAlign = 'middlecenter'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.BackColor = 'Gray'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.ForeColor = 'Black'

# Add a label that when not installed, shows that you are running the script on a workstation
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL.Text = 'This is a workstation, not a server. Please use a Windows Server'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 10)
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL.TextAlign = 'middlecenter'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL.BackColor = 'Gray'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL.ForeColor = 'Black'

# Check what operating system type the computer runs and according to that add a label to the bottom of the screen, or not
if ($OPERATING_SYSTEM_TYPE -eq 'Workstation') {
  $HYPERVM_GUI_MAIN_PAGE.Controls.Add($HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_WORKSTATION_LABEL)
}
elseif ($OPERATING_SYSTEM_TYPE -eq 'Server' -or $OPERATING_SYSTEM_TYPE -eq 'Domain-Controller') {
  $HYPER_V_TOOLS = Get-WindowsFeature -Name Hyper-V
  if ($HYPER_V_TOOLS.Installed -eq $true) {
    $HYPER_V_TOOLS_INSTALLED = $true
  }
  else {
    $HYPERVM_GUI_MAIN_PAGE.Controls.Add($HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL)
  }
}


# Create a table layout panel so we could buil the main page for building the virtual machine.
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL = New-Object -TypeName System.Windows.Forms.TableLayoutPanel
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.AutoSizeMode = 'GrowAndShrink'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Dock = 'Fill'

$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.RowCount = 5
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.ColumnCount = 4

$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.BackColor = 'White'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Anchor = 'top, left'

$HYPERVM_GUI_MAIN_PAGE.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL)


# Create a label that lets to select the name of the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL.Text = 'VM Name'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL.TextAlign = 'middleleft'

#Add the label to the first row and column 
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL, 0, 0)


# Create a textbox that lets to select the name of the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX = New-Object -TypeName System.Windows.Forms.TextBox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Anchor = 'left, right'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Autosize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Text = "New Virtual Machine"

# Add the textbox to the first row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX, 1, 0)


# Create a label that lets to select the amount of ram in GB for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL.Text = 'RAM (GB)'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL.TextAlign = 'middleleft'

# Add the label to the second row and first column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL, 0, 1)


# Create a textbox that lets to select the amount of RAM in GB for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX = New-Object -TypeName System.Windows.Forms.TextBox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX.Anchor = 'left, right'
# Add a value of 4 GB as of a default value for the RAM amount
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX.Text = 4


# Add the textbox to the second row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX, 1, 1)


# Create a label that lets to select the amount of CPU's to be assigned for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL.Text = 'CPU Count'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL.TextAlign = 'middleleft'

# Add the textbox to the third row and first column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL, 0, 2)


# Create a textbox that lets to select the amount of CPU's to be assigned to the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX = New-Object -TypeName System.Windows.Forms.Textbox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX.Anchor = 'left, right'

# Add a value of 2 CPU's as of a default value for the CPU count
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX.Text = 2


# Add the textbox to the third row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX, 1, 2)

# Create a label that lets to select the generation for the virtual machine (gen 1 or gen 2)
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL.Text = 'Generation'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL.TextAlign = 'middleleft'

# Add the label to the fourth row and first column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL, 0, 3)

# Add a table layout panel to already existing table layout panel to add two radio buttons inside
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL = New-Object -TypeName System.Windows.Forms.TableLayoutPanel
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.AutoSizeMode = 'GrowAndShrink'

$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.RowCount = 1
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.ColumnCount = 2

$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.BackColor = 'White'
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.Anchor = 'left, top, right'

# Add the table layout panel to the fourth row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL, 1, 3)

# Then create two radio buttons to put inside the table layout panel
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1 = New-Object -TypeName System.Windows.Forms.RadioButton
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.Text = 'Generation 1'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 10)

# By default, select the generation 1 radio button
if ($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.Checked -eq $False) {
  $HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.Checked = $True
}

# Add the first radio button to the table layout panel
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1)

$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2 = New-Object -TypeName System.Windows.Forms.RadioButton
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2.Text = 'Generation 2'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 10)

# Add the second radio button to the table layout panel
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2)

# Create a label that lets to select the switch for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL.Text = 'Switch Name'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL.TextAlign = 'middlecenter'

# Add the label to the first row and third column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL, 2, 0)

# Create a combobox to select the switch for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX = New-Object -TypeName System.Windows.Forms.ComboBox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.DropDownStyle = 'DropDownList'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.Anchor = 'left, right'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.Text = 'Not Connected'

# Add the combobox to the first row and fourth column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX, 3, 0)

# Create a label to select a VLAN ID for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL.Text = 'VLAN ID'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL.TextAlign = 'middlecenter'

# Add the label to the second row and third column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL, 2, 1)

# Create a textbox to input the VLAN ID for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX = New-Object -TypeName System.Windows.Forms.Textbox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX.Anchor = 'left, right'

# Add the textbox to the second row and fourth column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX, 3, 1)

# Create a table layout panel to have boot ISO textbox and browse button in the same cell
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL = New-Object -TypeName System.Windows.Forms.TableLayoutPanel
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.AutoSizeMode = 'GrowAndShrink'
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.Dock = 'Fill'

$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.RowCount = 1
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.ColumnCount = 2

$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.BackColor = 'White'
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.Anchor = 'top, left, right, bottom'

# Add the table layout panel to the third row and fourth column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL)

# Create a label to select the Boot ISO for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL.Text = 'Boot ISO'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL.Anchor = 'right'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL.TextAlign = 'middlecenter'

# Add the label to the third row and third column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL, 2, 2)

# Create a textbox to show the selected boot ISO for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX = New-Object -TypeName System.Windows.Forms.Textbox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX.Anchor = 'left, right'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX.ReadOnly = $true

# Add the textbox to the first row and first column of the boot ISO table layout panel
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX, 1, 0)

# Create a browse button to select the boot ISO for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_BROWSE_BUTTON = New-Object -TypeName System.Windows.Forms.Button
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_BROWSE_BUTTON.Text = 'Browse'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_BROWSE_BUTTON.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_BROWSE_BUTTON.TextAlign = 'middlecenter'

# Add the button to the first row and second column of the boot ISO table layout panel
$HYPERVM_GUI_MAIN_PAGE_BOOT_ISO_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_BROWSE_BUTTON, 0, 0)

# Create a table layout panel to have VHD root textbox and browse button in the same cell
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL = New-Object -TypeName System.Windows.Forms.TableLayoutPanel
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.AutoSizeMode = 'GrowAndShrink'
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.Dock = 'Fill'

$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.RowCount = 1
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.ColumnCount = 2

$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.BackColor = 'White'
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.Anchor = 'top, left, right, bottom'

# Add the table layout panel to the fourth row and fourth column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL, 3, 3)

# Add a label for selecting the VHD Root
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_LABEL = New-oBject -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_LABEL.Text = 'VHD Root'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_LABEL.TextAlign = 'middlecenter'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_LABEL.Anchor = 'left'

$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_LABEL, 2, 3)

# Create a browse button for the VHD root table layout panel
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_BROWSE_BUTTON = New-Object -TypeName System.Windows.Forms.Button
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_BROWSE_BUTTON.Text = 'Browse'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_BROWSE_BUTTON.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_BROWSE_BUTTON.TextAlign = 'middlecenter'

# Add the browse button to the first row and first column of the VHD root table layout panel
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_BROWSE_BUTTON, 0, 0)

# Create a textbox to display the VHD root path
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_TEXTBOX = New-Object -TypeName System.Windows.Forms.TextBox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_TEXTBOX.Anchor = 'left, right'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_TEXTBOX.ReadOnly = $true

# Add the textbox to the first row and second column of the VHD root table layout panel
$HYPERVM_GUI_MAIN_PAGE_VHD_ROOT_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_TEXTBOX, 1, 0)

# This section is reserved for the second page, Virtual Machines
# Add a datagridview to list all currently available virtual machines
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW = New-Object -TypeName System.Windows.Forms.DataGridView
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AutoSize = 'true'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AutoSizeRowsMode = 'allcells'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Dock = 'Fill'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Anchor = 'top, left'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AutoSizeColumnsMode = 'Fill'
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
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 10)
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.ColumnCount = 7
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.ColumnHeadersDefaultCellStyle.Alignment = 'MiddleCenter'

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

#$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AutoSizeRowsMode = 'AllCells'
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToResizeColumns = $true
$HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.AllowUserToOrderColumns = $true

$HYPERVM_GUI_DATAGRIDVIEW_PAGE.Controls.Add($HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW)


# This section is reserved for the third page, properties

# Add a label to the third page showing current powershell version
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Text = $(('Current PowerShell version: {0}' -f $PS_CURRENT_VERSION))
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 8)
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Dock = 'Bottom'

$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL)

# Add a label to the third page showing current Windows version
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Text = $(('Current Windows version: {0}' -f $WINDOWS_CURRENT_VERSION))
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 8)
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Margin = 50

$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL)

# Add a label to the third page showing the RAM amount that the current client has
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL = New-Object -TypeName System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL.Text = $(('Physical Memory: {0} GB | Usable: {1} GB' -f $TOTAL_CLIENT_MEMORY, $TOTAL_CLIENT_USABLE_MEMORY))
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL.Font = New-Object -TypeName System.Drawing.Font -ArgumentList ('Microsoft Sans Serif', 8)
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL)

# Add logic and functions to the code
# The code for removing unwanted characters from the textboxes
<#
function Remove-Unwanted-Characters {
  # finds all characters that are not [~!@#$%^&*_+{}:"<>()?/.,`;+ ] and replaces them with '' (nothing)
  if ($this.Text -match '[~!@#$%^&*_+{}:"<>()?/.,`;+ ]') {
    $this.Text = $This.Text -replace '[~!@#$%^&*_+{}:"<>()?/.,`;+ ]',''
    # Move the cursor to the end of the text
    $this.SelectionStart = $this.Text.Length
  }
}
#>

function Remove-Letters {
  # finds all characters that are not 0-9 and replaces them with '' (nothing)
  if ($this.Text -match '[^0-9]') {
    $this.Text = $This.Text -replace '[^0-9]',''
    # Move the cursor to the end of the text
    $this.SelectionStart = $this.Text.Length
  }
}

function Update-Switch-Combobox-List {
  $SWITCH_LIST = Get-VMSwitch | Select-Object -ExpandProperty Name
  $HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.Items.Add('No Connection')
  ForEach ($SWITCH in $SWITCH_LIST) {
    $null = $HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.Items.Add($SWITCH)
  }
  $HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.SelectedIndex = 0
}


# The code for browsing when pressing the browse button
function Browse-Iso-Files {
  $FileBrowser = New-Object -TypeName System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
    Filter = '.iso files (*iso)|*.iso|All files(*.*)|*.*'
  }
    
  $OpenDialog = $FileBrowser.ShowDialog()
    
  if ($OpenDialog -eq 'OK')
  {
    $BOOT_ISO = $FileBrowser.FileName

    $Extension = [IO.Path]::GetExtension($BOOT_ISO)
    if ($Extension -eq '.iso') {
      $HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX.Text = $BOOT_ISO
    }
    else {
      [Windows.MessageBox]::Show('File extension is not .iso', 'File extension must be .iso', 'Ok', 'Warning')
    }
  }
}


# The code for browsing when pressing the browse button
function Browse-Vhdx-Files { 
  $FileBrowser = New-Object -TypeName System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
    Filter = '.vhdx files (*vhdx)|*.vhdx|All files(*.*)|**'
  }

  $OpenDialog = $FileBrowser.ShowDialog()

  if ($OpenDialog -eq 'OK')
  {
    $VHDX_FILE = $FileBrowser.FileName

    $Extension = [IO.Path]::GetExtension($VHDX_FILE)
    if ($Extension -eq '.vhdx') {
      $HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_TEXTBOX.Text = $VHDX_FILE
    }
    else {
      [Windows.MessageBox]::Show('File extension is not .vhdx', 'File extension must be .vhdx', 'Ok', 'Warning')
    }
  }
}


function Update-VirtualMachines-List {
  function Get-VirtualMachinesData {
    param (
      [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Data to process")]
      $InputObject
    )

    process {
      $TotalVirtualMachines += 1
      $MemoryAssignedRam = [math]::round($InputObject.MemoryStartup / 1GB)
      $null = $HYPERVM_GUI_DATAGRIDVIEW_PAGE_DATAGRIDVIEW.Rows.Add($InputObject.Name, $InputObject.State, $InputObject.CPUUsage, $MemoryAssignedRam, $InputObject.Uptime, $InputObject.Status, $InputObject.Version)                                
    }
  }
  Get-VM | Get-VirtualMachinesData
}


# Run the scripts only if the server has HYPER-V tools installed.
if ($HYPER_V_TOOLS_INSTALLED -eq $true) {
  Update-VirtualMachines-List
  Update-Switch-Combobox-List
}


# Add logic to the textboxes, remove all unwanted characters
#$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Add_TextChanged{Remove-Unwanted-Characters}
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX.Add_TextChanged{Remove-Letters}
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX.Add_TextChanged{Remove-Letters}
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX.Add_TextChanged{Remove-Letters}


# Add logic to the boot iso browse button
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_BROWSE_BUTTON.Add_Click{Browse-Iso-Files}


# Add logic to the vhd root browse button
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VHD_ROOT_BROWSE_BUTTON.Add_Click{Browse-Vhdx-Files}

#Add logic to the virtual machine name textbox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Add_Click{
    if ($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Text -eq "New Virtual Machine") {
        $HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Text = ""
    }
}

# Show the GUI
$null = $HYPERVM_GUI_MAIN_WINDOW.ShowDialog()


# After closing the GUI, dispose of it
$HYPERVM_GUI_MAIN_WINDOW.Dispose()
