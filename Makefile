# Variable of all source files to build
# (which is all files ending with *.asm in the folder src/impl/x86_64)
x86_64_asm_source_files := $(shell find src/impl/x86_64 -name *.asm)

# Variable of all object files (generated from building source files)
# 
# Explaining the command: $(pathsubst pattern,replacement,text)
# (Link: https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_node/make_78.html)
# - Find whitespace seperated words in 'text' that match 'pattern' and 
#   replace them with 'replacement'. Here 'pattern' can use '%' which 
#   acts like a wildcard matching any number of characters within a word.
#   If 'replacement' also contains a '%', the '%' in 'replacement' is
#   by the text that matched the '%' in 'pattern'.
x86_64_asm_object_files := $(patsubst src/impl/x86_64/%.asm, build/x86_64/%.o, $(x86_64_asm_source_files))

# 1. Make directory 
# $(dir names...) = Extracts the directory-part of each fil name in 'names'
# $@ = The file name of the target of the rule
#      * (Example explaining what a rule is: https://www.gnu.org/software/make/manual/html_node/Rule-Example.html#Rule-Example)
#      * But wait, $(x86_64_asm_object_files) are multiple targets/files.
#        How does that work?
#        ANSWER: https://www.gnu.org/software/make/manual/html_node/Multiple-Targets.html
# 2. Use the assembleer 'nasm' to assemble/build our 
#    assembly code (*.asm files) to object files (*.o files)
#    * Option '-f' = format, specifies the output file format.
#    * Option '-o' = outfile, specifies a precise name for the output file.
#    * For explanation on 'pathsubst' and '$@', look above in this file.
$(x86_64_asm_object_files): build/x86_64/%.o : src/impl/x86_64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/x86_64/%.o, src/impl/x86_64/%.asm, $@) -o $@

# By default targets are 'file targets', because a lot of times, the result
# of executing a make target is a file with the name of the target.
# So for example:
# hello: hello.c
# 	gcc hello.c -o hello
# Which builds hello.c and results in binary 'hello'. And so if a file
# named 'hello' exists before running 'make hello', nothing will happen.
#
# However, some times we just want to run some commands in our Makefil, so we
# use '.PHONY' which means the target name is not a 'file target' anymore.
# So with .PHONY we can write something like this.
# .PHONY: hello
# And by running 'make hello' we will execute whatever follows this line
# in the makefile, regardless if there is any file namned 'hello' in current directory.
.PHONY: build-x86_64
# This is what each row does running/building this target/rule:
# 1. Create folder 'dist/x86_64'
#
# 2. Call the linker to link our object files together to a output file 'kernel.bin'
#    * Linux man page for 'x86_64-elf-ld' 
#      https://linux.die.net/man/1/x86_64-linux-gnu-ld.bfd
#
#    * x86_64-elf-ld is a linker, combines a number of object and archive files
#        (a *.a file, static library, is an archive file. 
#         Perhaps not commonly referred this way in modern 
#         times, but it makes sense that a static library is 
#         an archive of multiple object files, just like a zip 
#         is an archive of multiple files.)
#    * OPTIONS:
#      -n = Turn off page alignment 
#           !!!  TODO !!!! Add more easy to understand explanation to 
#                          this. Perhaps from reading the book 
#                          "Linkers & Loaders by John R.Levine"
#                          I'll learn something useful (Have it 
#                          downloaded as pdf) Otherwise, continue 
#                          googling for a good answer on it.
#      -T = scriptfile, Point out a linker script file, 
#           replacing ld's default linker script.
#      -o = output, specify the name for the program produced 
#           by ld (the linker 'x86_64-elf-ld').
#
# 3. Copy the output file/program from linking (kernel.bin) to
#    other directory, in preperation for creating the *.iso file
#
# 4. Create a bootable GRUB rescue image
#    * More info on grub-mkrescue: 
#      https://www.gnu.org/software/grub/manual/grub/html_node/Invoking-grub_002dmkrescue.html
#    * More info on grub (which grub-mkrescue is a part of):
#      https://www.gnu.org/software/grub/manual/grub/html_node/Overview.html#Overview
#    * From wikipedia site on 'GNU Grub' (https://en.wikipedia.org/wiki/GNU_GRUB):
#      "GNU Grub is a "reference implementation" of the 
#       FSF's (Free Software Foundation) "Multiboot specification".
#      More info on Multiboot: https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html
#      * There is similar link for "Multiboot" and "Multiboot 2" 
#        respectively.But I choose to display the link to 
#        "Multiboot 2", because going by the magicnumber we provide 
#        in our file 'main.asm', I hint based on the code-comment
#        that we are using "Multiboot 2".
#      * There is perhaps a even bigger hint that we are using 
#        "Multiboot 2" when you look inside our 'grub.cfg' file.
#    * !!! TODO !!! Try to understand and explain why we 
#                   need to pass the '/usr/lib/grub/i386-pc'
#                   path. I have so far found no information on
#                   this on any man page or similar of the
#                   'grub-mkrescue' command.
#      * The best guess I have of this so far is the following
#        which can be read from man page of 'grub-mkrescue'
#        command:
#        """
#        -d, --directory=,DIR/
#                use images and modules under DIR [default=/usr/lib/grub/<platform>]
#        """
#        At the very least the path '/usr/lib/grub/<platform>'
#        matches what we pass in "/usr/lib/grub/i386-pc"
#
#    * Option '-o' = Output, File to save the output in 
#                    (in this case a *.iso file namned
#                     'kernel.iso')
#
#    * At the end we have 'targets/x86_64/iso' which is passed
#      in as something referred to as 'SOURCE...' in the man page
#      for the 'grub-mkrescue' command.
#      What we pass in here is what files to add
#      to the resulting output file. E.g. what will
#      be inside it.
build-x86_64: $(x86_64_asm_object_files)
	mkdir -p dist/x86_64 && .
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(x86_64_asm_object_files) && \
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso
