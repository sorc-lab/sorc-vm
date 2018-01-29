apt-get install c3270

# unzip tk4- OS package
mkdir mvs38 && cd mvs38
cp ../remote/mainframe/tk4-*.zip .
unzip tk4-*.zip

# set console mode
cd unattended
./set_console_mode # prompts for key press

# run MVS
cd .. && ./mvs

# start c3270 session
/usr/bin/c3270 localhost:3270

# login
# usr: herc01
# psw: CUL8TR
# Use RFE, not RPF for programming
# RFE->3.4 view SYS2.JCLLIB
# 'E' to view, 'F7' & 'F8' to scroll
# PRIMASM, ASM prog. for Sieve of Eratosthenes

# shutdown
# F3 to ready prompt, enter 'shutdown', then 'logoff'
