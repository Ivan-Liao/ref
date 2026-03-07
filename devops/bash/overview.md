# Commands
Here are 20 of the most commonly used bash commands.

1. > 
   1. redirection
2. >> 
   1. append
3. `cat`
   1. `cat <filename>`
       1. `cat my_notes.txt`
4. `cd`
   1. `cd <directory_path>`
       1. `cd /var/log`
       2. `cd ..` (up one directory)
       3. `cd ~` (to home directory)
5. `chmod`
   1. `chmod <permissions> <filename>`
       1. `chmod 755 run_me.sh`
6. `chown`
   1. `chown <user>:<group> <filename>`
       1. `chown www-data:www-data config.php`
7. `cp`
   1. `cp <source_file> <destination_file>`
       1. `cp data.csv data_backup.csv`
8. `cut`
    1. extracts specific sections from each line of input
    2. `cut -d ',' -f 2 data.csv`
       1. uses comma as delimiter (-d ',') and selects the second field (-f 2)
    3. can be piped into
9. `df # Details on disk usage`
   1. `df [options]`
       1. `df -h`
10. .  `echo`
   1.  `echo "<text_to_display>"`
       1. `echo "Hello World"`
       2. `echo "Hello, world!" > hello.txt`
11. `find`
   1. `find <starting_directory> -name "<filename_pattern>"`
       1. `find . -name "*.py"`
    2. Find a type of file like human readable
       1. `find . -type f -exec sh -c 'file -b "{}" | grep -q text' \; -print`
    3. human readable, certain size in bytes, non executable
       1. `find . -size 1033c -type f ! -perm /0111 -exec sh -c 'file -b "{}" | grep -q text' \; -print`
    4. standard error file descriptor 2, users, groups
       1. `find / -size 33c -user bandit7 -group bandit6 -type f -exec sh -c 'file -b "{}" | grep -q text' \; -print 2>/dev/null`
12. `grep`
   1. `grep "<pattern>" <filename>`
       1. `grep "error" server.log`
13. `js`
    1.  jq is a powerful command-line tool used in Bash and other shells to parse, filter, and transform JSON data
```
echo '{"name": "Alice", "age": 30}' | jq '.name'
# Output: "Alice"
name=$(echo '{"name": "Alice"}' | jq -r '.name') # raw output
echo '[1, 2, 3]' | jq '.[]' # iterate over arrays
USER="Alice"
jq -n --arg name "$USER" '{user: $name}' # prevent injection issues
```
14. `kill`
    1. `kill <process_id>`
        1. `kill 12345`
15. `ls`
    1. `ls [options] [directory]`
        1. `ls -la` (l is for detailed list, a is to show hidden files)
16. `man # windows git bash equivalent is <command> --help`
    1. `man <command_name>`
        1. `man grep`
17. `mkdir`
    1. `mkdir <directory_name>`
        1. `mkdir project_files`
18. `mv`
    1. `mv <source> <destination_or_new_name>` (move or rename)
        1. `mv old_name.txt new_name.txt`
19. `ps # Details on running processes`
    1. `ps [options]`
        1. `ps aux`
20. `pwd`
    1. present working directory
21. `rm`
    1. `rm [options] <filename>`
        1. `rm temporary_file.tmp`
    2. `rm -r <directory_name>` (remove recursively)
    3. `rm -r ./mydir1/mydir2`
22. `ssh`
    1. `ssh -p 2210 username@remote_host_or_ip`
    2. `ssh -i /path/to/your/private_key username@remote_host_or_ip`
    3. `ssh -L local_port:remote_host:remote_port username@remote_host_or_ip`
        1. `ssh -L 8080:localhost:80 username@example.com`
23. `sudo`
    1. `sudo <command>`
        1. `sudo apt-get update`
24. `tail`
    1. `tail [options] <filename>`
        1. `tail -f /var/log/syslog`
25. `touch`
    1. `touch <filename_to_create>`
        1. `touch new_script.sh`