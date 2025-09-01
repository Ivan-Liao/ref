# Commands
Here are 20 of the most commonly used bash commands.

1.  `ls`
    1.  `ls [options] [directory]`
        1.  `ls -la`
2.  `cd`
    1.  `cd <directory_path>`
        1.  `cd /var/log`
3.  `pwd`
    1.  `pwd`
        1.  `pwd`
4.  `cat`
    1.  `cat <filename>`
        1.  `cat my_notes.txt`
5.  `echo`
    1.  `echo "<text_to_display>"`
        1.  `echo "Hello World"`
6.  `touch`
    1.  `touch <filename_to_create>`
        1.  `touch new_script.sh`
7.  `mkdir`
    1.  `mkdir <directory_name>`
        1.  `mkdir project_files`
8.  `cp`
    1.  `cp <source_file> <destination_file>`
        1.  `cp data.csv data_backup.csv`
9.  `mv`
    1.  `mv <source> <destination_or_new_name>`
        1.  `mv old_name.txt new_name.txt`
10. `rm`
    1.  `rm [options] <filename>`
        1.  `rm temporary_file.tmp`
    2. `rm -r <directory_name>`
       1. `rm -r ./mydir1/mydir2`
11. `grep`
    1.  `grep "<pattern>" <filename>`
        1.  `grep "error" server.log`
12. `find`
    1.  `find <starting_directory> -name "<filename_pattern>"`
        1.  `find . -name "*.py"`
13. `sudo`
    1.  `sudo <command>`
        1.  `sudo apt-get update`
14. `man # windows git bash equivalent is <command> --help`
    1.  `man <command_name>`
        1.  `man grep`
15. `chmod`
    1.  `chmod <permissions> <filename>`
        1.  `chmod 755 run_me.sh`
16. `chown`
    1.  `chown <user>:<group> <filename>`
        1.  `chown www-data:www-data config.php`
17. `ps # Details on running processes`
    1.  `ps [options]`
        1.  `ps aux`
18. `kill`
    1.  `kill <process_id>`
        1.  `kill 12345`
19. `df # Details on disk usage`
    1.  `df [options]`
        1.  `df -h`
20. `tail`
    1.  `tail [options] <filename>`
        1.  `tail -f /var/log/syslog`