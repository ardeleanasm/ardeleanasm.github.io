{
 :title "Keep processes running after SSH session ended"
 :layout :post
 :tags [ "scripts" ]
 :toc true}


Ssh into remote OS, type `screen` and start the process you want. Use **CTRL-A** then **CTRL-D** to detach the screen session and log out. Use `screen -r` to resume the detached screen session.

