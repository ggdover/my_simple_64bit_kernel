/*
 * This is a linker script file.
 *
 * Here is a link for more info: 
 * https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_chapter/ld_3.html
 * 
 * In summary this is a file you can write and use to 
 * have more control over the link process, by specifying
 * the mapping between the linker's input files and its output.
 * The file uses a special language/script which you find more
 * info about, for example, in the link above.
*/

/* 
 * Defines the first executable instruction (Entry point) in the output file
 * The syntax of this command is 'ENTRY(symbol)' where 'symbol' is the name
 * of any defined symbol.
 * The following explains what a 'symbol' is a in linker script:
 *    "It is possible to define arbitrary symbols within a linker script. 
 *     These symbols are added into the program's symbol table. Each symbol 
 *     in the table has a name and an associated address. Symbols within a 
 *     linker script that have been assigned a value will be given external 
 *     linkage, and are accessible within the program's code as pointers. "
 *
 * In this case we send in a symbol called 'start'.
 * If no symbol 'start' is defined within our input files, we could
 * simply define it, assigning it an appropriate value, as such:
 * 
 * start = 0x2020;
 */
ENTRY(start)

/*
 * The SECTIONS command controls exactly where input sections are 
 * placed into output sections, their order in the output file and 
 * to which output sections they are allocated.
 * 
 * In summary it describes the memory layout of the output file.
 */
SECTIONS
{
    . = 1M;

    .boot :
    {
        KEEP(*(.multiboot_header))
    }

    .text :
    {
        *(.text)
    }
}
