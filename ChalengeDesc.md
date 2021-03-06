You want to figure out how different archivers with different compiler options compress different files. For that you want to create a simple benchmarking suite that would read the commands to run from /root/devops/commands.txt and run it on files from /root/devops/files/, then output the compression statistics in the format <command>,<filename>,<compression ratio %>.

Given the commands in /root/devops/commands.txt and files to compress in /root/devops/files/ folder, write a script that would run a compressing command on each file and output the total statistics in the format given above. The output should be sorted first by the command, followed by the filename within each command group, in lexicographical order.

It's guaranteed that no command specifies a custom output filename so you may rely on a default one or specify one yourself. It's also guaranteed that there is at least 1 command in commands.txt. All commands accept the -c option that makes the output to STDOUT. All files are at least 1 byte in size. There are no spaces in the file's names.

Example

For the following /root/devops/commands.txt:

gzip -1
gzip -9
And the following files in /root/devops/files/:

/root/devops/files/a.txt:
CodeSignal Rules!
/root/devops/files/b.txt
aaaabbbdcdcdcd
The output should be as follows:

gzip -1,a.txt,253%
gzip -1,b.txt,257%
gzip -9,a.txt,253%
gzip -9,b.txt,257%
The size of a.txt is 17 bytes and the size of b.txt is 14 bytes. However, when compressed, their sizes become 43 and 36 bytes respectively for both commands, hence the 43 * 100 / 17 ~ 253% and 36 * 100 / 14 ~ 257% compression ratios (rounded to the nearest integer). The files were too small to be meaningfully compressed.