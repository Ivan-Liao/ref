# Commands
Here are 20 of the most commonly used bash commands.

1. `cat`
   1. `cat <filename>`
       1. `cat my_notes.txt`
2. `cd`
   1. `cd <directory_path>`
       1. `cd /var/log`
3. `chmod`
   1. `chmod <permissions> <filename>`
       1. `chmod 755 run_me.sh`
4. `chown`
   1. `chown <user>:<group> <filename>`
       1. `chown www-data:www-data config.php`
5. `cp`
   1. `cp <source_file> <destination_file>`
       1. `cp data.csv data_backup.csv`
6. `df # Details on disk usage`
   1. `df [options]`
       1. `df -h`
7. `echo`
   1. `echo "<text_to_display>"`
       1. `echo "Hello World"`
8. `find`
   1. `find <starting_directory> -name "<filename_pattern>"`
       1. `find . -name "*.py"`
9. `grep`
   1. `grep "<pattern>" <filename>`
       1. `grep "error" server.log`
10. `kill`
    1. `kill <process_id>`
        1. `kill 12345`
11. `ls`
    1. `ls [options] [directory]`
        1. `ls -la`
12. `man # windows git bash equivalent is <command> --help`
    1. `man <command_name>`
        1. `man grep`
13. `mkdir`
    1. `mkdir <directory_name>`
        1. `mkdir project_files`
14. `mv`
    1. `mv <source> <destination_or_new_name>`
        1. `mv old_name.txt new_name.txt`
15. `ps # Details on running processes`
    1. `ps [options]`
        1. `ps aux`
16. `pwd`
    1. `pwd`
        1. `pwd`
17. `rm`
    1. `rm [options] <filename>`
        1. `rm temporary_file.tmp`
    2. `rm -r <directory_name>`
        1. `rm -r ./mydir1/mydir2`
18. `ssh`
    1. `ssh -p 2210 username@remote_host_or_ip`
    2. `ssh -i /path/to/your/private_key username@remote_host_or_ip`
    3. `ssh -L local_port:remote_host:remote_port username@remote_host_or_ip`
        1. `ssh -L 8080:localhost:80 username@example.com`
19. `sudo`
    1. `sudo <command>`
        1. `sudo apt-get update`
20. `tail`
    1. `tail [options] <filename>`
        1. `tail -f /var/log/syslog`
21. `touch`
    1. `touch <filename_to_create>`
        1. `touch new_script.sh`