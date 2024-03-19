
# Start the GDB Server on the Windows host 
$port_num=61234

# Expecting the server to be installed under C:\ST\
# try and find the executable
$st_gdb_serv_path='C:\ST\STM32CubeCLT\STLink-gdb-server\bin'
$st_prog_path='C:\ST\STM32CubeCLT\STM32CubeProgrammer\bin'

if (-not (Test-Path -Path $st_gdb_serv_path)){
    Write-Error -Message "$st_gdb_serv_path does not exist!"
    exit 1
}

if (-not (Test-Path -Path $st_prog_path)){
    Write-Error -Message "$st_prog_path does not exist!"
    exit 1
}

# make sure the path for the log file exists
$logfile='C:/opt/st-debug.log'
$destpath='C:\opt'
if (-not (Test-Path -Path $destpath)){
    New-Item -Path $destpath -ItemType Directory
}

# start the GDB server
cd $st_gdb_serv_path

# Start the GDB server 
# startup arguments
# -e enable persisten mode
# -f <log file>
# -p TCP port
# -r <max delay> in status refresh in seconds
# -d enable SWD mode
# -cp <path> to the CLI programmer

& ".\ST-LINK_gdbserver.exe" -e -f $logfile -p $port_num -r 15 -d -cp $st_prog_path


