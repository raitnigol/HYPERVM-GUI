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

# Get the Windows RAM amount
$TOTAL_CLIENT_MEMORY = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | ForEach {'{0:N2}' -F (([math]::round(($_.Sum / 1GB),2)))}

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
$HYPERVM_GUI_MAIN_PAGE.UseVisualStyleBackColor = $true
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


# This section is reserved for the main page
# To even create Hyper-V virtual machines at the first place, you must have RSAT-Hyper-V-Tools installed.
# So we should check if the user has installed the tool and if not, ask the user if they would like to install it.

# to be implemented later because I do not have access to a Windows Server.

# Add a label that when not installed, shows that the Hyper-V tools are not yet installed.
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Text = "Module: RSAT-Hyper-V-Tools has not yet been installed."
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.TextAlign = 'TopCenter'
$HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL.BackColor = 'Gray'

# Disable as of right now - $HYPERVM_GUI_MAIN_PAGE.Controls.Add($HYPERVM_GUI_MAIN_WINDOW_INSTALLED_HYPER_V_TOOLS_LABEL)

# Create a table layout panel so we could buil the main page for building the virtual machine.
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL = New-Object System.Windows.Forms.TableLayoutPanel
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.AutoSizeMode = 'GrowAndShrink'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Dock = 'Fill'

$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.RowCount = 5
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.ColumnCount = 4

$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.BackColor = 'White'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Anchor = 'top, left'

$HYPERVM_GUI_MAIN_PAGE.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL)

# Create a label that lets to select the name of the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL.Text = 'VM Name'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL.AutoSize = $true

#Add the label to the first row and column 
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_LABEL, 0, 0)

# Create a textbox that lets to select the name of the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX = New-Object System.Windows.Forms.TextBox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Anchor = 'left, right'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX.Autosize = $true

# Add the textbox to the first row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CREATE_VM_TEXTBOX, 1, 0)

# Create a label that lets to select the amount of ram in GB for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL.Text = 'RAM (GB)'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL.Anchor = 'left'

# Add the label to the second row and first column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_LABEL, 0, 1)

# Create a textbox that lets to select the amount of RAM in GB for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX = New-Object System.Windows.Forms.TextBox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX.Anchor = 'left, right'

# Add the textbox to the second row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX, 1, 1)

# Create a label that lets to select the amount of CPU's to be assigned for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL.Text = 'CPU Count'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL.Anchor = 'left'

# Add the textbox to the third row and first column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_LABEL, 0, 2)

# Create a textbox that lets to select the amount of CPU's to be assigned to the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX = New-Object System.Windows.Forms.Textbox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX.Anchor = 'left, right'

# Add the textbox to the third row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX, 1, 2)

# Create a label that lets to select the generation for the virtual machine (gen 1 or gen 2)
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL.Text = 'Generation'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL.Anchor = 'left'

# Add the label to the fourth row and first column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VM_GENERATION_LABEL, 0, 3)

# Add a table layout panel to already existing table layout panel to add two radio buttons inside
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL = New-Object System.Windows.Forms.TableLayoutPanel
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.AutoSizeMode = 'GrowAndShrink'

$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.RowCount = 1
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.ColumnCount = 2

$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.BackColor = 'White'
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.Anchor = 'left, top, right'

# Add the table layout panel to the fourth row and second column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL, 1, 3)

# Then create two radio buttons to put inside the table layout panel
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1 = New-Object System.Windows.Forms.RadioButton
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.Text = 'Generation 1'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

# Add the first radio button to the table layout panel
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_1)

$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2 = New-Object System.Windows.Forms.RadioButton
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2.Text = 'Generation 2'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2.AutoSize = $true
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

# Add the second radio button to the table layout panel
$HYPERVM_GUI_MAIN_PAGE_RADIO_BUTTON_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RADIO_BUTTON_GEN_2)

# Create a label that lets to select the switch for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL.Text = 'Switch Name'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL.Anchor = 'left'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL.AutoSize = $true

# Add the label to the first row and third column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_LABEL, 2, 0)

# Create a combobox to select the switch for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX = New-Object System.Windows.Forms.ComboBox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.DropDownStyle = 'DropDownList'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX.Anchor = 'left, right'

# Add the combobox to the first row and fourth column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_SWITCH_COMBOBOX, 3, 0)

# Create a label to select a VLAN ID for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL.Text = 'VLAN ID'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL.Anchor = 'left'

# Add the label to the second row and third column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_LABEL, 2, 1)

# Create a textbox to input the VLAN ID for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX = New-Object System.Windows.Forms.Textbox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX.Anchor = 'left, right'

# Add the textbox to the second row and fourth column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX, 3, 1)

# Create a label to select the Boot ISO for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL.Text = 'Boot ISO'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL.Anchor = 'left'

# Add the label to the third row and third column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_LABEL, 2, 2)

# Create a textbox to show the selected boot ISO for the virtual machine
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX = New-Object System.Windows.Forms.Textbox
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX.Multiline = $false
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX.Anchor = 'left, right'
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX.ReadOnly = $true

# Add the textbox to the third row and third column
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL.Controls.Add($HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_BOOT_ISO_TEXTBOX, 3, 2)


# This section is reserved for the second page, Virtual Machines


# This section is reserved for the third page, properties
# Add a label to the third page showing current powershell version
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Text = $("Current PowerShell version: $PS_CURRENT_VERSION")
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 8)
$HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL.Dock = 'Bottom'

$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_POWERSHELL_VERSION_LABEL)

# Add a label to the third page showing current Windows version
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Text = $("Current Windows version: $WINDOWS_CURRENT_VERSION")
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 8)
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL.Margin = 50

$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_WINDOWS_VERSION_LABEL)

# Add a label to the third page showing the RAM amount that the current client has
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL = New-Object System.Windows.Forms.Label
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL.Text = $("Physical Memory: $TOTAL_CLIENT_MEMORY GB")
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 8)
$HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL.Dock = 'Bottom'
$HYPERVM_GUI_PROPERTIES_PAGE.Controls.Add($HYPERVM_GUI_PROPERTIES_PAGE_CLIENT_RAM_AMOUNT_LABEL)

# Add logic and functions to the code
# Add logic to the textboxes, remove all characters that are not 0-9
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_RAM_AMOUNT_TEXTBOX.Add_TextChanged({REMOVE-LETTERS})
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_CPU_COUNT_TEXTBOX.Add_TextChanged({REMOVE-LETTERS})
$HYPERVM_GUI_MAIN_PAGE_TABLE_LAYOUT_PANEL_VLAN_ID_TEXTBOX.Add_TextChanged({REMOVE-LETTERS})


# The code for removing the numbers from the textboxes
function REMOVE-LETTERS {
    # finds all characters that are not 0-9 and replaces them with '' (nothing)
    if ($this.Text -match '[^0-9]') {
        $CURSOR_POS = $this.SelectionStart
        $this.Text = $This.Text -replace '[^0-9]',''
        # Move the cursor to the end of the text
        $this.SelectionStart = $this.Text.Length
    }
}

# Show the GUI
[void]$HYPERVM_GUI_MAIN_WINDOW.ShowDialog()


# After closing the GUI, dispose of it
$HYPERVM_GUI_MAIN_WINDOW.Dispose()