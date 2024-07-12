; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "PCSX2"
#define MyAppVersion "2.0"
#define MyAppPublisher "PCSX2 Team"
#define MyAppURL "http:/pcsx2.net/"
#define MyAppExeName "pcsx2-qt.exe"

#define MyAppSourceDir "main"
#define MySetupResourceDir "res"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{13CEE6E5-8EB3-47D3-882E-E9DBB6A3251C}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
Compression=lzma/max
SolidCompression=yes
ArchitecturesInstallIn64BitMode=win64
MinVersion=10.0.17134
;10.0.22000 ; Windows 11 code just for testing failure on Windows 10

DefaultGroupName={#MyAppName}

DefaultDirName={commonpf64}\{#MyAppName}

OutputDir=PCSX2
OutputBaseFilename={#MyAppName}-{#MyAppVersion}-setup

; InfoAfterFile=README.txt
UninstallDisplayIcon={app}\{#MyAppExeName},0
SetupIconFile={#MySetupResourceDir}\AppIconLarge.ico
;WizardImageFile={#MySetupResourceDir}\banner.bmp
WizardSmallImageFile={#MySetupResourceDir}/AppIconLarge.bmp

[Messages]
WindowsVersionNotSupported=PCSX2 requires Windows 10 (1809) or later. To use this app, please update your operating system.

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
;Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce

[Files]
Source: "{#MySetupResourceDir}\Redist\VC_redist.x64.exe"; DestDir: {tmp}
Source: "{#MyAppSourceDir}\*"; Excludes: "PUT PCSX2 BUILD HERE.txt"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MySetupResourceDir}\portable.txt"; DestDir: {app} ; Check: IsPortableInstallation;
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Code]    
const
  StandardDescText =
    'All PCSX2 Data will be stored in Documents, separate from the program.';
  PortableDescText =
    'All PCSX2 Data will be stored in the same folder as PCSX2 itself by default.';

var
  StandardRadioButton: TNewRadioButton;
  PortableRadioButton: TNewRadioButton;

procedure InitializeWizard();
var
  CustomPage: TWizardPage;
  FullDescLabel: TLabel;
  PartDescLabel: TLabel;
begin
  CustomPage := CreateCustomPage(wpWelcome, 'Installation type', '');
  StandardRadioButton := TNewRadioButton.Create(WizardForm);
  StandardRadioButton.Parent := CustomPage.Surface;
  StandardRadioButton.Checked := True;
  StandardRadioButton.Top := 16;
  StandardRadioButton.Width := CustomPage.SurfaceWidth;
  StandardRadioButton.Font.Style := [fsBold];
  StandardRadioButton.Font.Size := 9;
  StandardRadioButton.Caption := 'Standard Installation'
  FullDescLabel := TLabel.Create(WizardForm);
  FullDescLabel.Parent := CustomPage.Surface;
  FullDescLabel.Left := 8;
  FullDescLabel.Top := StandardRadioButton.Top + StandardRadioButton.Height + 8;
  FullDescLabel.Width := CustomPage.SurfaceWidth; 
  FullDescLabel.Height := 40;
  FullDescLabel.AutoSize := False;
  FullDescLabel.Wordwrap := True;
  FullDescLabel.Caption := StandardDescText;
  PortableRadioButton := TNewRadioButton.Create(WizardForm);
  PortableRadioButton.Parent := CustomPage.Surface;
  PortableRadioButton.Top := FullDescLabel.Top + FullDescLabel.Height + 16;
  PortableRadioButton.Width := CustomPage.SurfaceWidth;
  PortableRadioButton.Font.Style := [fsBold];
  PortableRadioButton.Font.Size := 9;
  PortableRadioButton.Caption := 'Portable Installation'
  PartDescLabel := TLabel.Create(WizardForm);
  PartDescLabel.Parent := CustomPage.Surface;
  PartDescLabel.Left := 8;
  PartDescLabel.Top := PortableRadioButton.Top + PortableRadioButton.Height + 8;
  PartDescLabel.Width := CustomPage.SurfaceWidth;
  PartDescLabel.Height := 40;
  PartDescLabel.AutoSize := False;
  PartDescLabel.Wordwrap := True;
  PartDescLabel.Caption := PortableDescText;
end;

{TODO: Need to find a way to determine how to dynamically adjust "WizardForm.DirEdit.Text := ''" at runtime, how to if else on pascal?;}

function isPortableInstallation: Boolean;
begin
  Result := PortableRadioButton.Checked;
end;

procedure SetDefaultDirName();
begin
  if isPortableInstallation = true then
    WizardForm.DirEdit.Text := 'C:\{#MyAppName}'
  else
    WizardForm.DirEdit.Text := ExpandConstant('{commonpf64}') + '\{#MyAppName}';
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  Page: TWizardPage;
begin
  Page := PageFromID(CurPageID);
  if Page.Caption = 'Installation type' then
    SetDefaultDirName();
    
  if Page.Caption = 'Select Destination Location' then
  begin
    if Pos('C:\Windows\', WizardForm.DirEdit.Text) <> 0 then
    begin
      MsgBox('Installing PCSX2 in the Windows folder is not advised. Please choose another folder.', mbError, MB_OK);
      Result := false;
      Exit;
    end;
    
    if (isPortableInstallation = true) and (Pos('Program Files', WizardForm.DirEdit.Text) <> 0) then
    begin
      MsgBox('Portable install cannot be inside Program Files, please choose another folder.', mbError, MB_OK);
      Result := false;
      Exit;
    end;
  end;
    
  Result := true;
end;

procedure SetMarqueeProgress(Marquee: Boolean);
begin
  if Marquee then
  begin
    WizardForm.ProgressGauge.Style := npbstMarquee;
  end
    else
  begin
    WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;

[Icons]
; StartMenu (Directly)
Name: "{commonprograms}\{#MyAppName}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{commonprograms}\{#MyAppName}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}";
; or
; StartMenu Group
;Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
;Name: "{group}\{#MyAppName} README"; Filename: "{app}\readme.txt"
;Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"

; Desktop
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
; Local Machine
Root: HKLM; Subkey: "Software\{#MyAppPublisher}"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\{#MyAppPublisher}\{#MyAppName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\{#MyAppPublisher}\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: {app}

[Run]
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/q /norestart"; \
    Flags: waituntilterminated; \
    StatusMsg: "Installing VC++ 2019-2022 Redistributables... Please Wait."; \
    BeforeInstall: SetMarqueeProgress(True); \
    AfterInstall: SetMarqueeProgress(False)
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent